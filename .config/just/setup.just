_default:
    @just --list setup

# Make ~/Dropbox/Data/just/$name.just imported by default.
activate-env name='home':
    ln -f -s ~/Dropbox/Data/just/{{ quote(name) }}.just ~/.config/just/_env.just

# Edit this module.
edit:
    @"$EDITOR" {{ quote(source_file()) }}
