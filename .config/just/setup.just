_default:
    @just --list setup

# Edit this module.
edit:
    @"$EDITOR" {{ quote(source_file()) }}

##############################################################################

# Make ~/Dropbox/Data/just/$name.just imported by default.
activate-env name='home':
    ln -f -s ~/Dropbox/Data/just/{{ quote(name) }}.just ~/.config/just/_env.just

# Initialize Restic repo.
init-restic-repo name:
    agenvx restic restic -r ~/Dropbox/Data/restic/repos/{{ quote(name) }} init
    echo 'repo = "~/Dropbox/Data/restic/repos/{{ name }}"' > ~/.config/restic-driver/{{ quote(name) }}.toml

# Generate Zsh completion scripts.
generate-completions:
    just --completions zsh > ~/.zsh/functions_fallback/_just
    exec- deno completions zsh > ~/.zsh/functions_fallback/_deno
    exec- mise completions zsh > ~/.zsh/functions_fallback/_mise
    exec- rustup completions zsh > ~/.zsh/functions_fallback/_rustup
    exec- rustup completions zsh cargo > ~/.zsh/functions_fallback/_cargo
