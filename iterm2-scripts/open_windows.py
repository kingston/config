#!/usr/bin/env python3.7

"""
This module provides a function for iTerm2 to upsert tabs with specific properties in a window
to allow you to quickly switch development environments for a specific project.

### Usage of the Library:
1. **Import the required functions and classes:**
   - `open_windows`: This function is responsible for opening or finding windows and creating tabs with specific properties.
   - `Tab`: The class that represents a tab's configuration, which includes:
     - `name`: The name of the tab (used for easy identification).
     - `cwd`: The directory the tab should open in.
     - `command`: (Optional) A command to be run when the tab is opened.

2. **Define a list of `Tab` objects:**
   - Each `Tab` object specifies the tab's name, the working directory (`cwd`), and an optional command.
   - If no command is provided, the tab simply opens in the specified directory.

3. **Call the `open_windows` function:**
   - Pass your iTerm2 connection, a profile name (e.g., 'Development'), and the list of tabs to the function.
   - This will either find an existing window with that profile or create a new one, then open or reuse tabs according to the provided configuration.

### Example:

In this example, we create two tabs:
1. The first tab (`dev`) opens in the `~/projects/my-app` directory and runs the development command `npm run dev`.
2. The second tab (`docs`) opens in the `~/projects/docs` directory, with no command executed.

```python
import iterm2
from lib.open_windows import open_windows, Tab

TABS = [
  Tab('dev', '~/projects/my-app', 'npm run dev'),  # Open 'my-app' folder and run 'npm run dev'.
  Tab('docs', '~/projects/docs')  # Open 'docs' folder without running a command.
]

async def main(connection):
  await open_windows(connection, 'Development', TABS)

iterm2.run_until_complete(main)
```
"""

import iterm2
from typing import List, Union
import signal

# Signal handler for timing out operations (10 seconds alarm is set later in the code)
def handler(signum, frame):
    raise Exception("Operation timed out")

# Class representing a tab with a name, working directory (cwd), and an optional command to execute
class Tab:
    def __init__(self, name: str, cwd: str, command: Union[str, None] = None):
        self.name = name
        self.cwd = cwd
        self.command = command

# Function to find an existing iTerm2 window by a specific profile name
# It looks through all open windows and returns the one that contains the most tabs with the given profile
async def find_existing_window(connection, profile_name: str) -> Union[iterm2.Window, None]:
    app = await iterm2.async_get_app(connection)
    candidate_windows = []

    # Loop through each window and check the profile name of each tab
    for window in app.windows:
        candidate_tabs = []
        for tab in window.tabs:
            tab_profile_name = await tab.async_get_variable("user.profile_name")  # Check tab profile name
            if tab_profile_name == profile_name:
                candidate_tabs.append(tab)  # If profile matches, add the tab to candidate list
                break
        if len(candidate_tabs) > 0:
            candidate_windows.append([window, len(candidate_tabs)])  # Track window and number of matching tabs

    # Return the window with the most matching tabs if found, otherwise None
    if len(candidate_windows) > 0:
        return max(candidate_windows, key=lambda w: w[1])[0]

    return None

# Function to execute a command in the specified session once the terminal prompt is ready
async def run_command(connection, session: iterm2.Session, command):
    prompt = await iterm2.async_get_last_prompt(connection, session.session_id)

    # Wait for the prompt to be in an editable state before sending the command
    if prompt is None or prompt.state != iterm2.PromptState.EDITING:
        modes = [iterm2.PromptMonitor.Mode.PROMPT, iterm2.PromptMonitor.Mode.COMMAND_END]

        async with iterm2.PromptMonitor(
            connection, session_id=session.session_id, modes=modes) as mon:
            await mon.async_get()  # Wait for the prompt to become available

    # If a command is provided, send the command to the session
    if command:
        await session.async_send_text(f"{command}\n")

# Function to open windows/tabs with a specific profile and execute commands in them
async def open_windows(connection, profile_name: str, tabs: List[Tab]):
    signal.signal(signal.SIGALRM, handler)  # Set up a signal handler for timeouts
    signal.alarm(10)  # Set a 10-second alarm for timeouts

    window = await find_existing_window(connection, profile_name)  # Find existing window with profile name
    existing_tabs = window.tabs if window is not None else None

    # Loop through the provided tabs
    for i, tab in enumerate(tabs):
        existing_tab = None

        # Check if the tab already exists by comparing its name
        if existing_tabs is not None:
            for t in existing_tabs:
                tabName = await t.async_get_variable("user.tab_name")
                print(tabName)
                if tabName is not None and tabName == tab.name:
                    existing_tab = t
                    break

        # If the tab doesn't exist, create a new one
        if existing_tab is None:
            profile = iterm2.LocalWriteOnlyProfile()  # Create a new profile for the tab
            profile.set_custom_directory(tab.cwd)  # Set the working directory for the tab
            profile.set_initial_directory_mode(iterm2.InitialWorkingDirectory.INITIAL_WORKING_DIRECTORY_CUSTOM)
            profile.set_name(profile_name)  # Set the profile name
            profile.set_custom_window_title(f"{profile_name} \(currentSession.name)")  # Custom window title
            profile.set_use_custom_window_title(True)
            profile.set_allow_title_setting(False)

            # If no window exists, create one, else create a new tab in the existing window
            if window is None:
                window = await iterm2.Window.async_create(connection, None, None, profile)
                existing_tab = window.current_tab
            else:
                existing_tab = await window.async_create_tab(None, None, i, profile)

            # Set tab properties and variables
            await existing_tab.current_session.async_set_profile_properties(profile)
            await existing_tab.async_set_title(f"{tab.name}: \(currentSession.name)")
            await existing_tab.async_set_variable("user.tab_name", tab.name)
            await existing_tab.async_set_variable("user.profile_name", profile_name)

            # Run the command in the new tab
            await run_command(connection, existing_tab.current_session, tab.command)
        else:
            # If the tab exists, check if it's idle (not running a command), then send the command
            current_session = existing_tab.current_session
            current_command = await current_session.async_get_variable("jobName")
            if current_command is None or current_command == "zsh":
                await current_session.async_send_text("\x03")  # Send Ctrl+C to stop any running command
                current_path = await current_session.async_get_variable("path")
                if current_path != tab.cwd:  # Change directory if needed
                    await run_command(connection, current_session, f"cd {tab.cwd}")
                await run_command(connection, current_session, "clear")  # Clear the screen
                if tab.command:
                    await run_command(connection, current_session, tab.command)  # Run the command in the tab

    # Set the window title and activate it
    await window.async_set_title(f"{profile_name} - \(currentTab.titleOverride)")
    await window.async_activate()
