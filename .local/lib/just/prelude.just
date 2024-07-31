__list__:
    @just --list --justfile={{ quote(justfile()) }}

# Edit this Justfile.
edit:
    @"$EDITOR" {{ quote(justfile()) }}
