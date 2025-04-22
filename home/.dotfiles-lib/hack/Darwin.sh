alias ls='ls -G'

alias t='open -a Terminal .'

alias compinit='compinit -u'

# for homebrew
export PATH="/usr/local/sbin:$PATH"

export PATH=~/.usr/mac/bin:"$PATH"

# Enable touch id on sudo
# https://gist.githubusercontent.com/YutaroOrikasa/de463d655e15eac1d959a3f57e988f7e
(
    grep -q 'auth       sufficient     pam_tid.so' /etc/pam.d/sudo && exit 0

    sudo patch -d/ -b -p0 <<EOF
--- /etc/pam.d/sudo.orig
+++ /etc/pam.d/sudo
@@ -1,4 +1,5 @@
 # sudo: auth account password session
+auth       sufficient     pam_tid.so
 auth       sufficient     pam_smartcard.so
 auth       required       pam_opendirectory.so
 account    required       pam_permit.so
EOF
)
