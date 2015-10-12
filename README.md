homebrew-neovim
===============
[![Build Status](https://travis-ci.org/neovim/homebrew-neovim.svg?branch=master)](https://travis-ci.org/neovim/homebrew-neovim)

Homebrew formula for neovim.

## Usage

```text
$ brew tap neovim/homebrew-neovim
$ brew install --HEAD neovim
```

To **upgrade** from a previous version:

```text
$ brew update
$ brew reinstall --HEAD neovim
```

For instructions on how to install the Python modules, see [`:help nvim-python`][nvim-python].

## Troubleshooting

* Make sure you're using the right formula. `brew info neovim` should have a
  `From` line similar to this:

  ```text
  From: https://github.com/neovim/homebrew-neovim/blob/master/Formula/neovim.rb
  ```

  If your formula points elsewhere, then you need to retap the neovim formula.
  Do so with the following sequence of commands:

  ```text
  $ brew uninstall neovim --force
  $ brew prune
  $ brew tap neovim/homebrew-neovim
  $ brew tap --repair
  $ brew install neovim --HEAD
  ```
* If you encounter the error `Failed to update tap: neovim/neovim`, try:

  ```text
  $ brew untap neovim/neovim
  $ brew tap neovim/homebrew-neovim
  ```
* Run `brew update` — then try again.
* Run `brew doctor` — the doctor diagnoses common issues.
* Check that **Command Line Tools for Xcode (CLT)** and/or **Xcode** are up to
  date by checking for updates in the App Store.
  * If the build fails with `fatal error: '__debug' file not found`,
    you have to install Xcode. This is due to a [bug in the Xcode CLT 6.3][clt-bug].
  * If the build fails with `ld: library not found for -lgcc_s`, make sure
    you have the same version of Xcode and Xcode CLT installed.
* You can create a gist log with `brew gist-logs neovim`.
* Use `--verbose` to get the verbose output, i.e. `brew install --HEAD --verbose neovim`.
* Use `--debug` to be in the debug mode. In the debug mode, when failing, you
  can go into the interactive shell to check the building files before homebrew
  neutralizing them.
* If you encounter the error `CMAKE_USE_SYSTEM_CURL is ON but a curl is not found`,
  then you're missing the dependency for cURL that allows downloads over TLS.
  Refer to your operating system's section in [Linuxbrew Dependencies][linuxbrew-dependencies]
  to fix this.

[clt-bug]: https://openradar.appspot.com/radar?id=6405426379751424
[nvim-python]: http://neovim.io/doc/user/nvim_python.html
[linuxbrew-dependencies]: https://github.com/Homebrew/linuxbrew#dependencies
