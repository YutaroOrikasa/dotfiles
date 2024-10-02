zmodload zsh/zprof

__zshrc() {
    . ~/.zshrc
}

__zshrc

zprof >~/zprof.txt
echo 'export zprof result into ~/zprof.txt'
