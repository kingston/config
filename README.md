# Configuration Setup

This is a highly opinionated configuration setup that I’ve built over the years. It contains handy settings and tools that streamline my development environment. Feel free to use or modify it, but of course it's very customized to my preferences so might need tweaking to suit whatever you want.

## Getting Started

To set everything up, follow these steps:

1. Copy `setup.cfg.template` to `setup.cfg`.
2. Edit `setup.cfg` with your personal configurations (e.g., Git name, email, etc.).
3. Run the setup script:  
   ```bash
   ./setup.sh
   ```

This will create symbolic links for various configuration files and ensure that everything is in place. It’s safe to rerun the setup script, as it won’t overwrite existing settings without making backups.

## After Updates

If you update or modify any files, simply run the setup script again:
```bash
./setup.sh
```

This will ensure that your configurations stay up to date.

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
- **Git Hooks**:  
  - The Git post-merge hook in `git-templates/hooks/post-merge` checks for changes to `pnpm`, `yarn`, or `npm` lock files and reruns install commands if necessary.

## Additional Configurations

- **ZSH**: The setup script configures ZSH, including installing [ZPlug](https://github.com/zplug/zplug) and sourcing additional ZSH settings from `init.zsh`.
- **Bash**: Bash configuration is handled similarly, sourcing additional settings from `.bashrcadditions`.
- **Starship Prompt**: If Starship prompt isn’t installed, the script will install it and set up the configuration.

## Notes

- Enable `xterm-256color` in your terminal settings if you are SSH’ing into remote machines.
- For Solarized terminal support, install [dircolors-solarized](https://github.com/seebi/dircolors-solarized).
- If you use tmux, you can manually symlink the `.tmux.conf` file to your home directory.
