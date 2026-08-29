# nixos-config

This repo **is** `/etc/nixos` (symlinked). Editing any file here is editing the live system config directly — there is no separate deploy step or copy.

After making changes, validate with:

```
./bin/validate
```

If the adaptation asked by user is not suported by native configuration and require custom script or workaround to make it work, ask the user before proceeding.
