# homebrew-neovim

[![Build Status](https://travis-ci.org/neovim/homebrew-neovim.svg?branch=master)](https://travis-ci.org/neovim/homebrew-neovim)

Homebrew formula for Neovim.

## Install

To install the latest stable release from homebrew core:

    brew install neovim

To upgrade:

    brew update
    brew upgrade neovim

To install the latest, potentially unstable, development version of Neovim:

    brew install --HEAD neovim

## Use

The program name is `nvim` (not `neovim`).

    nvim

In nvim, run `:CheckHealth`. It checks for common problems and best practices.

## Report

If you run into problems, follow the
[Troubleshooting](#troubleshooting) section below before filing an issue.  If
you still have problems:

* *Search the issue tracker for your problem.*  GitHub does not show
  closed issues by default, but it will search them.  Many issues have 
  been resolved already.

* Include the link to the result of your
  `brew gist-logs neovim` command.  We cannot debug issues without
  detailed information about the failure.

* It helps to capture the verbose (`-v`) install output.
  For example, `brew install neovim` would become `brew
  install -v neovim`.  Paste the output in your bug report,
  and make sure to wrap it with a "fence" so it renders correctly:

      ```
      # output goes here
      ```

## Troubleshoot

* Run `brew update` then try again.
* Run `brew doctor` to diagnose common issues.
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
[linuxbrew-dependencies]: https://github.com/Homebrew/linuxbrew#dependencies
