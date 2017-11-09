#!/bin/bash

# ./bootstrap.sh [arg]...
# arg: path to file or dir you want to stuff to bootstrap.tar

set -vx

set -e
cd ~

rm -rf bootstrap.tmp

mkdir bootstrap.tmp
cp -a .ssh bootstrap.tmp

for path in "$@";do
    cp -a "$path" bootstrap.tmp
done

cat > bootstrap.tmp/bootstrap.sh <<EOF
cd ~
git clone 'ssh://dotfiles-git-server/~/dotfiles'

EOF

chmod a+x bootstrap.tmp/bootstrap.sh

tar -c bootstrap.tmp > bootstrap.tar

cat > bootstrap.sh <<EOF
cd ~
tar -x < bootstrap.tar
mv bootstrap.tmp/.ssh .
echo 'please execute ./bootstrap.tmp/bootstrap.sh'

EOF

chmod a+x bootstrap.sh

