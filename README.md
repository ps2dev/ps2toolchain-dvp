![CI](https://github.com/ps2dev/ps2toolchain-dvp/workflows/CI/badge.svg)
![CI-Docker](https://github.com/ps2dev/ps2toolchain-dvp/workflows/CI-Docker/badge.svg)

# ps2toolchain-dvp

This program will automatically build and install a DVP compiler which is used in the creation of homebrew software for the Sony PlayStation® 2 videogame system.

## **ATENTION!**

If you're trying to install in your machine the **WHOLE PS2 Development Environment** this is **NOT** the repo to use, you should use instead the [ps2dev](https://github.com/ps2dev/ps2dev "ps2dev") repo.

## What these scripts do

These scripts download (with wget) and install [binutils 2.14](http://www.gnu.org/software/binutils/ "binutils") (dvp).

## Requirements

1.  Install gcc/clang, make, patch, git, texinfo and wget if you don't have those.

2.  Ensure that you have enough permissions for managing PS2DEV location (default to `/usr/local/ps2dev`). PS2DEV location MUST NOT have spaces or special characters in its path! For example, on Linux systems you can set access for the current user by running commands:

```bash
export PS2DEV=/usr/local/ps2dev
sudo mkdir -p $PS2DEV
sudo chown -R $USER: $PS2DEV
```

3.  Add this to your login script (example: `~/.bash_profile`)

```bash
export PS2DEV=/usr/local/ps2dev
export PATH=$PATH:$PS2DEV/dvp/bin
```

4.  Run toolchain.sh
    `./toolchain.sh`
