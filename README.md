# homebrew-neovim

This Formula has been migrated to homebrew-core on June 25th, 2017 and no longer
requires you to tap the neovim tap before installing.

## Installation

To install the latest stable release:

    brew install neovim

To upgrade:

    brew update
    brew upgrade neovim

To install the latest, potentially unstable, version of Neovim from git HEAD:

    brew install --HEAD neovim

## Usage

The program name is `nvim` (not `neovim`).

    nvim

In nvim, run `:CheckHealth`. It checks for common problems and ensures best
practices.

[brew-trouble]: https://github.com/Homebrew/brew/blob/master/docs/Troubleshooting.md
[clt-bug]: https://openradar.appspot.com/radar?id=6405426379751424
[linuxbrew-dependencies]: https://github.com/Homebrew/linuxbrew#dependencies
