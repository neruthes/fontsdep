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
            "CTAN:tex-gyre/opentype/texgyretermes-{regular,bold,italic,bolditalic}.otf",
            "https://github.com/stipub/stixfonts/raw/refs/heads/master/fonts/static_otf/STIXTwoText-{Regular,Italic,Bold,BoldItalic}.otf"
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
Identifier string expansion is supported; if you write `CTAN:{1,2}.otf`,
this tool will expand it to `CTAN:1.otf` and `CTAN:2.otf` as two different URLs.
This tool will resolve an identifier to a URL according to internal rules.

### Namespaces
- `CTAN`: Expands to `https://mirrors.ctan.org/fonts/` so the path part starts with `tex-gyre`, etc.
- `https` and `http`: Passes through as raw URL.

### Formats
If URL ends with certain string, this tool will do special handling after downloading.

- `.zip`: Creates corresponding `X.zip.d` directory and extracts archived files into it and deletes all files except `*.{otf,ttf,ttc}`.



## Future Plans
- Support extracting fonts from `.deb` files fetched from distro mirrors.





# Copyright

Copyright (c) 2026 Neruthes. Released with the GNU GPL 2.0 license.

