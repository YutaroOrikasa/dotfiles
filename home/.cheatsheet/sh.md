### Passing argument to script read from stdin
`sh -s - arg1 arg2 ...` or `sh -s -- arg1 arg2 ...`

`arg1 arg2 ...` is passed as `$1 $2 ...`

eg:
```sh
echo 'echo $1 $2' | bash -s -- arg1 arg2
```
