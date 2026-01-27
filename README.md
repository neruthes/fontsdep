# fontsdep

Per-repository on-demand font dependency installer.

This is a shell script, so only GNU/Linux is officially supported.
Might be ported to Node.js in future?


## Installation
### Explicit Dependency
Install this package as a yarn dependency, or other flavor you prefer.

```
yarn add https://github.com/neruthes/fontsdep
```

### Direct Inclusion
Put the `fontsdep.sh` at the root of your repository.
You can occasionally run `bash fontsdep.sh u` to make it self-update.

## Usage
### Project Configuration
Add some data to your package.json to declare the needed fonts.

```json
{
    "fontsdep": {
    "dest": "_fontsdir",
    "list": [
        "CTAN:tex-gyre/opentype/texgyretermes-regular.otf"
    ]
  }
}
```

## Managing Fonts List
You should set a list of font file identifiers, each of them is in the `ns:path` format.
Currently this tool supports only the `CTAN` namespace; more may be added in future.
This tool will resolve an identifier to URLs.

TODO: Support extracting fonts from `.deb` files fetched from distro mirrors.





# Copyright

Copyright (c) 2026 Neruthes. Released with the GNU GPL 2.0 license.

