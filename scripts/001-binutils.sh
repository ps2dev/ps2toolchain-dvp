#!/bin/bash
# 001-binutils.sh by ps2dev developers

## Exit with code 1 when any command executed returns a non-zero exit code.
onerr()
{
  exit 1;
}
trap onerr ERR

## Read information from the configuration file.
source "$(dirname "$0")/../config/ps2toolchain-dvp-config.sh"

## Download the source code.
REPO_URL="$PS2TOOLCHAIN_DVP_BINUTILS_REPO_URL"
REPO_REF="$PS2TOOLCHAIN_DVP_BINUTILS_DEFAULT_REPO_REF"
REPO_FOLDER="$(s="$REPO_URL"; s=${s##*/}; printf "%s" "${s%.*}")"

# Checking if a specific Git reference has been passed in parameter $1
if test -n "$1"; then
  REPO_REF="$1"
  printf 'Using specified repo reference %s\n' "$REPO_REF"
fi

if test ! -d "$REPO_FOLDER"; then
  git clone --depth 1 -b "$REPO_REF" "$REPO_URL" "$REPO_FOLDER"
else
  git -C "$REPO_FOLDER" fetch origin
  git -C "$REPO_FOLDER" reset --hard "origin/$REPO_REF"
  git -C "$REPO_FOLDER" checkout "$REPO_REF"
fi

cd "$REPO_FOLDER"

TARGET_ALIAS="dvp"
TARG_XTRA_OPTS=""
OSVER=$(uname)

# setting lt_cv_sys_max_cmd_len works around ancient libtool bugs
if [ "${OSVER:0:10}" == MINGW64_NT ]; then
  export lt_cv_sys_max_cmd_len=8000
  export CC=x86_64-w64-mingw32-gcc
  TARG_XTRA_OPTS="--host=x86_64-w64-mingw32"
  CFLAGS="$CFLAGS -DHAVE_DECL_ASPRINTF -DHAVE_DECL_VASPRINTF"
elif [ "${OSVER:0:10}" == MINGW32_NT ]; then
  export lt_cv_sys_max_cmd_len=8000
  export CC=i686-w64-mingw32-gcc
  TARG_XTRA_OPTS="--host=i686-w64-mingw32"
  CFLAGS="$CFLAGS -DHAVE_DECL_ASPRINTF -DHAVE_DECL_VASPRINTF"
elif [ "${OSVER:0:9}" == "CYGWIN_NT" ]; then
  export lt_cv_sys_max_cmd_len=8000
  TARG_XTRA_OPTS="--host=x86_64-pc-cygwin"
fi

## Determine the maximum number of processes that Make can work with.
PROC_NR=$(getconf _NPROCESSORS_ONLN)

## For each target...
for TARGET in "dvp"; do
  ## Create and enter the toolchain/build directory
  rm -rf "build-$TARGET"
  mkdir "build-$TARGET"
  cd "build-$TARGET"

  ## Configure the build.
  ../configure \
    --quiet \
    --prefix="$PS2DEV/$TARGET_ALIAS" \
    --target="$TARGET" \
    --disable-nls \
    --disable-build-warnings \
    $TARG_XTRA_OPTS

  ## Compile and install.
  make --quiet -j "$PROC_NR" CFLAGS="$CFLAGS -D_FORTIFY_SOURCE=0 -O2 -Wno-implicit-function-declaration" LDFLAGS="$LDFLAGS -s"
  make --quiet -j "$PROC_NR" install
  make --quiet -j "$PROC_NR" clean

  ## Exit the build directory.
  cd ..

  ## End target.
done
