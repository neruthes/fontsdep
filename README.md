# fontsdep

Per-repository on-demand font dependency installer.

This is a shell script, so only GNU/Linux is officially supported.
Might be ported to Node.js in future?


## Installation
### Flavor 1: Explicit Dependency
Install this package as a yarn dependency, or other package manager you prefer.

```sh
yarn add 'https://github.com/neruthes/fontsdep#1.0.0'
# Will I publish to NPM?
```

### Flavor 2: Direct Inclusion
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
            "CTAN:tex-gyre/opentype/texgyretermes-regular.otf",
            "CTAN:tex-gyre/opentype/texgyretermes-bold.otf",
            "CTAN:tex-gyre/opentype/texgyretermes-italic.otf",
            "CTAN:tex-gyre/opentype/texgyretermes-bolditalic.otf"
        ]
    }
}
```

### Installing Fonts
Run the command manually or in a CI script.
Or, if you use a `./make.sh path/to/target.typ` to handle complex Typst/LaTeX building workflows,
run the command before each build.
This tool internally has a 7-day cache policy, so font files will not be downloaded over-repetitively.

```sh
bash fontsdep.sh
# -- OR --
bash node_modules/fontsdep/src/main/fontsdep.sh
```



## Managing Fonts List
You should set a list of font file identifiers, each of them is in the `ns:path` format.
Currently this tool supports only the `CTAN` namespace; more may be added in future.
This tool will resolve an identifier to URLs.

TODO: Support extracting fonts from `.deb` files fetched from distro mirrors.





# Copyright

Copyright (c) 2026 Neruthes. Released with the GNU GPL 2.0 license.

