### export public key
```
gpg --output gpg-public.key --armor --export ${user-id}
```

### import public key
```
gpg --import gpg-public.key
```

### trust public key
```
gpg --edit-key ${user-id} trust
```