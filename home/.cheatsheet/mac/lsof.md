### list process of listening port
```sh
lsof -n -P -i | grep LISTEN
```

### list process of using specify port
eg. processes of using port 5000
```sh
lsof -n -P -i :5000
```