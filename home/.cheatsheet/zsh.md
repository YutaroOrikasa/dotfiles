### print all history
```
history -E 1
```

### without loding .zshrc
```
zsh --no-rcs
```

### benchmark .zshrc
```
time zsh -x -i -c exit
```

### count compinit
```
zsh -x -i -c exit 2>&1 | grep compinit$
```
