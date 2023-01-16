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
ssh remote -N -L local_bind:8080:webserver:80
```
[client]---->[local_bind:8080]->[local]---->[remote]---->[webserver:80]

### reverse port forwarding
forwarding port from remote to server via localhost.
```
ssh remote -N -R remote_bind:8080:webserver:80
```
[webserver:80]<----[local]<----[remote]<-[remote_bind:8080]<----[client]
