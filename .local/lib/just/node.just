# Run update-browserslist-db.
[group('cli')]
update-browserslist-db RELOAD='no':
    deno run --no-lock -A {{ if RELOAD == 'no' { '' } else { '--reload' } }} npm:update-browserslist-db@latest

# Run `anypm install` if needed.
[group('node')]
node-sync-if-needed:
    anypm name
    git exec-if-changed -v -S ".exec-if-changed.$(anypm name)-install.ignore" -p "$(anypm lockfile)" -- anypm install
