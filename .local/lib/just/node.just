# Run update-browserslist-db.
update-browserslist-db:
    deno run --no-lock -A npm:update-browserslist-db@latest

# Run `anypm install` if needed.
[group('node')]
node-sync-if-needed:
    anypm name
    git exec-if-changed -v -S ".exec-if-changed.$(anypm name)-install.ignore" -p "$(anypm lockfile)" -- anypm install
