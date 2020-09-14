### print all history with timestamp
```sh
history -f 1
# or
fc -lf 1
```

### print last 100 history with timestamp
```sh
history -f -100
# or
fc -lf -100
```

### without loding .zshrc
```
zsh --no-rcs
```

### benchmark .zshrc
```
time zsh -i -c exit
```

### count compinit
```
zsh -x -i -c exit 2>&1 | grep compinit$
```
