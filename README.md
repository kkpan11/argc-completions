# Argc-Completions

A multi-shell completion solution.

## How to use

### Install dependencies

- [argc](https://github.com/sigoden/argc): completion engine
- [jq](https://github.com/stedolan/jq): json processor

### Setup shell

Clone the repo.

```sh
git clone https://github.com/sigoden/argc-completions $HOME/.argc-completions
```

For bash, add the following code to `.bashrc`.
```sh
source "$HOME/.argc-completions/shell/argc-completions.bash" 
```

For zsh, add the following code to `.zshrc`.
```sh
source "$HOME/.argc-completions/shell/argc-completions.zsh" 
```

For fish, add the following code to `config.fish`.
```fish
source "$HOME/.argc-completions/shell/argc-completions.fish" 
```

For PowerShell, add the following code to `$PROFILE`.

```ps1
. "$env:USERPROFILE\.argc-completions\shell\argc-completions.ps1"
```

## How to write

Automatically generate with:

```
./generate.sh mycmd
```

> Command need to add to PATH enviroment variable.

## License

Copyright (c) 2022 sigoden.

argc is made available under the terms of the MIT License. 

See the LICENSE file for license details.