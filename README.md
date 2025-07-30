# My dotfiles

## Installation

Generally, it is best to clone this repo into your home directory as `~/dotfiles`, but the install script should be capable of installing everything correctly regardless of where the actual repo is and what the user's working directory is when executing the installer. The caveat, of course, is that an attempt at recursion by naming this repo something unfortunate (like `~/bin` or `~/src`) would likely cause some unexpected behavior.

To install, execute or source the installation script as shown below. Note that the shebang for this script might not match the bash executable path on your system, nor does any specification appropriately standardize this much more than `/bin/sh`.
```bash
$> ./install.sh
```

## Licensing

I don't think this repo needs a license, but be wary of the submodules. Anything that might be licensed is likely to come from there.
