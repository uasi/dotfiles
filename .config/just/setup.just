_default:
    @just --list setup

# Edit this module.
edit:
    @"$EDITOR" {{ quote(source_file()) }}

##############################################################################

# Make ~/Dropbox/Data/just/$name.just imported by default.
activate-env name='home':
    ln -f -s ~/Dropbox/Data/just/{{ quote(name) }}.just ~/.config/just/_env.just

# Generate Zsh completion scripts.
generate-completions:
    just --completions zsh > ~/.zsh/functions/_just
    exec? deno completions zsh > ~/.zsh/functions/_deno
    exec? mise completions zsh > ~/.zsh/functions/_mise
    exec? rustup completions zsh > ~/.zsh/functions/_rustup
    exec? rustup completions zsh cargo > ~/.zsh/functions/_cargo
