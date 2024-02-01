#!/usr/bin/env python3.7

import iterm2
from typing import List, Union
import signal

def handler(signum, frame):
    raise Exception("Operation timed out")

class Tab:
    def __init__(self, name: str, cwd: str, command: Union[str, None] = None):
        self.name = name
        self.cwd = cwd
        self.command = command

async def find_existing_window(connection, profile_name: str) -> Union[iterm2.Window, None]:
    app = await iterm2.async_get_app(connection)
    candidate_windows = []
    for window in app.windows:
        candidate_tabs = []
        for tab in window.tabs:
            tab_profile_name = await tab.async_get_variable("user.profile_name")
            if tab_profile_name == profile_name:
                candidate_tabs.append(tab)
                break
        if len(candidate_tabs) > 0:
            candidate_windows.append([window, len(candidate_tabs)])

    if len(candidate_windows) > 0:
        # return window with most tabs
        return max(candidate_windows, key=lambda w: w[1])[0]

    return None

async def run_command(connection, session: iterm2.Session, command):
    prompt = await iterm2.async_get_last_prompt(connection, session.session_id)
    # Wait for prompt to show up
    if prompt is None or prompt.state != iterm2.PromptState.EDITING:
        modes = [iterm2.PromptMonitor.Mode.PROMPT, iterm2.PromptMonitor.Mode.COMMAND_END]

        async with iterm2.PromptMonitor(
            connection, session_id=session.session_id, modes=modes) as mon:
            await mon.async_get()

    if command:
        await session.async_send_text(f"{command}\n")

async def open_windows(connection, profile_name: str, tabs: List[Tab]):
    signal.signal(signal.SIGALRM, handler)
    signal.alarm(10)

    window = await find_existing_window(connection, profile_name)
    existing_tabs = window.tabs if window is not None else None
    # loop through each tab
    for i, tab in enumerate(tabs):
        # check if tab exists
        existing_tab = None
        if existing_tabs is not None:
            for t in existing_tabs:
                tabName = await t.async_get_variable("user.tab_name")
                print(tabName)
                if tabName is not None and tabName == tab.name:
                    existing_tab = t
                    break

        if existing_tab is None:
            # create tab
            profile = iterm2.LocalWriteOnlyProfile()
            profile.set_custom_directory(tab.cwd)
            profile.set_initial_directory_mode(iterm2.InitialWorkingDirectory.INITIAL_WORKING_DIRECTORY_CUSTOM)
            profile.set_name(profile_name)
            profile.set_custom_window_title(f"{profile_name} \(currentSession.name)")
            profile.set_use_custom_window_title(True)
            profile.set_allow_title_setting(False)
            if window is None:
                window = await iterm2.Window.async_create(connection, None, None, profile)
                existing_tab = window.current_tab
            else:
                existing_tab = await window.async_create_tab(
                    None,
                    None,
                    i,
                    profile
                )
            await existing_tab.current_session.async_set_profile_properties(profile)
            await existing_tab.async_set_title(f"{tab.name}: \(currentSession.name)")
            await existing_tab.async_set_variable("user.tab_name", tab.name)
            await existing_tab.async_set_variable("user.profile_name", profile_name)
            # wait for prompt to show up
            await run_command(connection, existing_tab.current_session, tab.command)
        else:
            # run command if no command running
            current_session = existing_tab.current_session
            current_command = await current_session.async_get_variable("jobName")
            if current_command is None or current_command == "zsh":
                # send ctrl-c
                await current_session.async_send_text("\x03")
                # cd into directory
                current_path = await current_session.async_get_variable("path")
                if current_path != tab.cwd:
                    await run_command(connection, current_session, f"cd {tab.cwd}")
                await run_command(connection, current_session, "clear")
                # send command to start command
                if tab.command:
                    await run_command(connection, current_session, tab.command)

    await window.async_set_title(f"{profile_name} - \(currentTab.titleOverride)")
    await window.async_activate()
