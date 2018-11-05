### disconnect
```
<Enter>~.
```

### list escape sequence (show help)
```
<Enter>~?
```

### port forwarding
forwarding port from localhost to server via remote.
```
ssh remote -N -L localhost:8080:server:80
```
[client]---->[localhost:8080]---->[remote]---->[server:80]

### reverse port forwarding
forwarding port from remote to server via localhost.
```
ssh gateway -N -R localhost:8080:server:80
```
[server:80]<----[localhost]<----[remote:8080]<----[client]
