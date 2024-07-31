rspec_examples_status_file := 'spec/examples.txt'

# Run rspec --only-failures.
[group('rspec')]
rspec-only-failures:
    bundle exec rspec --only-failures

# Remove persisted spec statuses.
[group('rspec')]
x-rspec-forget file=rspec_examples_status_file:
    rm -f {{ quote(file) }}

# Fix *.rb files which are modified or staged.
[group('rubocop')]
rubocop-fix-dirty:
    ( git ls-files --modified ; git diff --name-only --staged ) | grep '\.rb$' | xargs bundle exec rubocop -a

# Fix *.rb files which are changed between the default branch and HEAD.
[group('rubocop')]
rubocop-fix-head:
    git diff --name-only "$(git guess-default-branch)" | grep '\.rb$' | xargs bundle exec rubocop -a
