The repository keeps track of changes to the configuration on \*nix operating system.

Following [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), the configuration
files are deployed in ~/.config to avoid polluting the user's home directory.

# Getting Started

## Prerequisites

* A Unix-like operating system. e.g., macOS and Linux

* bash, git and curl should be installed

* Internet connection

The install script checks the requirements above at startup, and will halt if any of these conditions are not met.

## How to use

1. Clone the repository

```bash
git clone --bare --depth=1 https://github.com/flyingice/.dotfiles ~/.dotfiles
alias dot='command git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot reset -- ~/tools && dot checkout -- ~/tools
```

2. Run the install script

```bash
~/tools/install.sh --release
```
 The script fetches source code from [Github](https://www.github.com) by default. If [Github](https://www.github.com) is not accessible from
 your region, pick a mirror site via `--url` and `--url-raw` options. For more information, run `~/tools/install.sh --help`.


> As an alternative, try to add the following configuration in */etc/hosts* in case the DNS of [Github](https://www.github.com) is polluted.
>  ```
> 20.205.243.166 github.com
> 185.199.108.133 raw.githubusercontent.com
>  ```
>
> The above mapping to the real IP address might not be valid anymore. Find the correct IP by running
>
> ```bash
> dig +nostats @8.8.8.8 -t A github.com

## FAQ

**I want to deploy the configuration for only one software package. e.g., Neovim**

This could be done without executing the install script.

```bash
git clone --bare --depth=1 https://github.com/flyingice/.dotfiles ~/.dotfiles
alias dot='command git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot reset -- ~/.config/nvim && dot checkout -- ~/.config/nvim
```
However, be cautious that some tools may not run properly without my zsh config. Take a look at those files in *.config/zsh*.

Alternatively, with zsh config installed, simply launch lazygit by running `lg` and checkout the corresponding config.
