homebrew-neovim
===============
[![Build Status](https://travis-ci.org/neovim/homebrew-neovim.svg?branch=master)](https://travis-ci.org/neovim/homebrew-neovim)

Homebrew formula for neovim.

## Usage

```bash
$ brew tap neovim/neovim
$ brew install --HEAD neovim
```

## Troubleshooting

* Make sure you're using the right formula.  `brew info neovim` should have a
  From line similar to this:

  ```text
  From: https://github.com/neovim/homebrew-neovim/blob/master/Formula/neovim.rb
  ```

  If your formula points elsewhere, then you need to retap the neovim formula.
  Do so with the following sequence of commands:

  ```text
  brew uninstall neovim --force
  brew prune
  brew tap neovim/homebrew-neovim
  brew tap --repair
  brew install neovim --HEAD
  ```
* Run `brew update` — then try again.
* Run `brew doctor` — the doctor diagnoses common issues.
* Check that **Command Line Tools for Xcode (CLT)** and/or **Xcode** are up to
  date by checking for updates in the App Store.
* You can create a gist log with `brew gist-logs neovim`.
* Use `--verbose` to get the verbose output, i.e. `brew install --HEAD --verbose neovim`.
* Use `--debug` to be in the debug mode. In the debug mode, when failing, you
  can go into the interactive shell to check the building files before homebrew
  neutralizing them.
