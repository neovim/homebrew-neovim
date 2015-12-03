homebrew-neovim
===============
[![Build Status](https://travis-ci.org/neovim/homebrew-neovim.svg?branch=master)](https://travis-ci.org/neovim/homebrew-neovim)

Homebrew formula for neovim.

## Usage

To install the latest release:

    $ brew install neovim/neovim/neovim

To **upgrade** from a previous version:

    $ brew update
    $ brew upgrade neovim

For instructions on how to install the Python modules, see [`:help nvim-python`][nvim-python].

If you instead want to install a developer version of Neovim based on the current GitHub revision, use:

    $ brew tap neovim/neovim
    $ brew install --HEAD neovim

To upgrade:

    $ brew update
    $ brew reinstall --HEAD neovim

## Filing an Issue

If you run into problems, make sure to follow the
[Troubleshooting](#troubleshooting) section below before filing an issue.  If
you still have problems:

* *Please search the issue tracker for your problem.*  GitHub does not show
  closed issues by default, but it will search them.  Many issues others have
  seen before and have been resolved already.  It's really a burden on the
  development team to come by and point out already solved issues to you.

* Please make sure to include the link to the result of your
  `brew gist-logs neovim` command.  We simply cannot debug issues without
  detailed information about the failure and `gist-logs` helps provide that.

* It's also helpful to capture the output of a verbose version of the install
  command you used.  Simply add the `-v` option to the command line and try
  again.  For example, `brew install neovim/neovim/neovim` would become `brew
  install -v neovim/neovim/neovim`.  Paste the result of this in your ticket,
  and make sure to wrap it with a text fence so it renders correctly:

      ```text
      # output goes here
      ```

## Troubleshooting

* Make sure you're using the right formula. `brew info neovim` should have a
  `From` line similar to this:

      From: https://github.com/neovim/homebrew-neovim/blob/master/Formula/neovim.rb

  If your formula points elsewhere, then you need to retap the neovim formula.
  Do so with the following sequence of commands:

  ```text
  $ brew uninstall neovim --force
  $ brew prune
  $ brew tap neovim/neovim
  $ brew tap --repair
  $ brew install neovim --HEAD
  ```
* If you encounter the error `Failed to update tap: neovim/neovim`, try:

  ```text
  $ brew untap neovim/neovim
  $ brew tap neovim/neovim
  ```
* Run `brew update` — then try again.
* Run `brew doctor` — the doctor diagnoses common issues.
* Check that **Command Line Tools for Xcode (CLT)** and/or **Xcode** are up to
  date by checking for updates in the App Store.
  * If the build fails with `fatal error: '__debug' file not found`,
    you have to install Xcode. This is due to a [bug in the Xcode CLT 6.3][clt-bug].
  * If the build fails with `ld: library not found for -lgcc_s`, make sure
    you have the same version of Xcode and Xcode CLT installed.
* Check the [Homebrew Troubleshooting][brew-trouble] page.  In particular, the
  [Check for common issues][brew-common] section.
* You can create a gist log with `brew gist-logs neovim`.
* Use `--verbose` to get the verbose output, i.e. `brew install --HEAD --verbose neovim`.
* Use `--debug` to be in the debug mode. In the debug mode, when failing, you
  can go into the interactive shell to check the building files before homebrew
  neutralizing them.
* If you encounter the error `CMAKE_USE_SYSTEM_CURL is ON but a curl is not found`,
  then you're missing the dependency for cURL that allows downloads over TLS.
  Refer to your operating system's section in [Linuxbrew Dependencies][linuxbrew-dependencies]
  to fix this.

[brew-common]: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Troubleshooting.md#check-for-common-issues
[brew-trouble]: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Troubleshooting.md
[clt-bug]: https://openradar.appspot.com/radar?id=6405426379751424
[nvim-python]: http://neovim.io/doc/user/nvim_python.html
[linuxbrew-dependencies]: https://github.com/Homebrew/linuxbrew#dependencies
