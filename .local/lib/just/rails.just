rspec_examples_status_file := 'spec/examples.txt'

# Dump Rails routes to ,routes.txt.
[group('rails')]
rails-dump-routes:
    bundle exec rails routes > ,routes.txt

# Run `bundle install` and `rails db:migrate`.
[group('rails')]
rails-sync:
    bundle install
    rails db:migrate
    rails db:migrate RAILS_ENV=test

# Run `rspec --only-failures`.
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
