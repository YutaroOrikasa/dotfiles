### export public key
```
gpg --output gpg-public.key --armor --export ${user-id}
```

### import public key
```
gpg --import gpg-public.key
```
