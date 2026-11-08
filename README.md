# Configuration Setup

This is a highly opinionated configuration setup that I’ve built over the years. It contains handy settings and tools that streamline my development environment. Feel free to use or modify it, but of course it's very customized to my preferences so might need tweaking to suit whatever you want.

## Getting Started

To set everything up, follow these steps:

1. Install [Homebrew](https://brew.sh).
2. Clone this repo (e.g. to `~/repos/config`).
3. Copy `setup.cfg.template` to `setup.cfg` and edit it with your personal configurations (e.g., Git name, email, etc.).
4. Read the `Brewfile` (it runs as Ruby), then install the packages:
   ```bash
   brew bundle --file=Brewfile
   ```
5. Run the setup script:
   ```bash
   ./setup.sh
   ```
6. Install the tools pinned in the mise config:
   ```bash
   mise install
   ```

This will create symbolic links for various configuration files and ensure that everything is in place. It’s safe to rerun the setup script, as it won’t overwrite existing settings without making backups.

## After Updates

If you update or modify any files, simply run the setup script again:
```bash
./setup.sh
```

This will ensure that your configurations stay up to date.

## Tools: Homebrew and mise

Tools are split between two files:

- **`Brewfile`**: system tools, GUI apps (casks), and editor extensions installed with Homebrew, e.g. Starship, `gh`, and Eternal Terminal.
- **`mise-global/config.toml`**: language runtimes (Node, Python, Ruby, Go, Deno) and version-pinned CLIs managed by [mise](https://mise.jdx.dev). `init.zsh` runs `mise activate`.

`setup.sh` copies `mise-global/config.toml` to `~/.config/mise/config.toml` only if that file doesn't exist yet. It copies rather than symlinks, so changes pulled into the repo never take effect without review. The machine copy is the source of truth, and syncing goes one way at a time.

The sync tasks live in the repo's `mise.toml`, which holds tasks only (no tools or settings). Trust it once with `mise trust`, then run the tasks from the repo root:

- `mise run dotfiles:export` copies the machine's mise config into the repo and refreshes the `Brewfile` with `brew bundle dump`. Review and commit the result.
- `mise run dotfiles:import` shows the diff between the repo and machine configs and what the `Brewfile` would install, then asks before copying the config and running `brew bundle install` and `mise install`.

## Vim Configuration

The `.vimrc` file is included and customized with plugins and settings, including:

- [NERDCommenter](https://github.com/preservim/nerdcommenter) for easy commenting
- [Solarized Color Scheme](https://github.com/altercation/vim-colors-solarized) for enhanced readability
- [CtrlP](https://github.com/ctrlpvim/ctrlp.vim) for fuzzy file search

The setup script will automatically install [vim-plug](https://github.com/junegunn/vim-plug) and the necessary plugins.

You may want to modify the Vim bundles to suit your own preferences.

## Manual Steps

There are a few files and configurations that need to be linked manually:

- **iTerm2**: Use `./link-iterm2.sh` to link the library for opening new windows.
- **VSCode Settings**: The `vscode-settings.json` file contains user settings for VSCode.

## Additional Configurations

- **ZSH**: The setup script configures ZSH, including installing [ZPlug](https://github.com/zplug/zplug) and sourcing additional ZSH settings from `init.zsh`.
- **Bash**: Bash configuration is handled similarly, sourcing additional settings from `.bashrcadditions`.
- **Starship Prompt**: Starship is installed via Homebrew (see `Brewfile`). The setup script links its configuration.

## Notes

- Enable `xterm-256color` in your terminal settings if you are SSH’ing into remote machines.
- For Solarized terminal support, install [dircolors-solarized](https://github.com/seebi/dircolors-solarized).
- `.tmux.conf` is kept for remote machines (e.g. a devbox reached with `etc`); it isn't linked locally.
