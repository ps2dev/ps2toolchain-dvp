#!/bin/sh
# check-make.sh by Naomi Peori (naomi@peori.ca)

## Check for make.
if [ "$(uname)" = "OpenBSD" ]; then
    gmake -v 1> /dev/null || { echo "ERROR: Install make before continuing."; exit 1; }
else
    make -v 1> /dev/null || { echo "ERROR: Install make before continuing."; exit 1; }
fi
