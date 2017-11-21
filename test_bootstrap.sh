#!/bin/bash
set -xv

rm -rf _tmp_test_bootstrap
mkdir _tmp_test_bootstrap

~/dotfiles/make_bootstrap.sh "$@"

mv bootstrap.sh bootstrap.tar.gz _tmp_test_bootstrap

export HOME="$PWD"/_tmp_test_bootstrap
cd $HOME
bash -c './bootstrap.sh;bash'
