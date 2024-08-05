rspec_examples_status_file := 'spec/examples.txt'

# Dump Rails routes to ,routes.txt.
[group('rails')]
rails-dump-routes:
    bundle exec rails routes > ,routes.txt

# Run `bundle install` and `rails db:migrate` unconditionally.
[group('rails')]
rails-sync:
    bundle install
    rails db:migrate
    rails db:migrate RAILS_ENV=test

# Run `bundle install` and `rails db:migrate` if needed.
[group('rails')]
rails-sync-if-needed:
    git exec-if-changed -v -S .exec-if-changed.bundle-install.ignore -p Gemfile.lock -- bundle install
    git exec-if-changed -v -S .exec-if-changed.rails-db-migrate-dev.ignore -p db/migrate -- bundle exec rails db:migrate
    git exec-if-changed -v -S .exec-if-changed.rails-db-migrate-test.ignore -p db/migrate -- bundle exec rails db:migrate RAILS_ENV=test

# Run `rspec` against spec files changed between the default branch and HEAD.
[group('rspec')]
rspec-head:
     git diff --name-only "$(git guess-default-branch)" | grep '_spec\.rb$' | xargs bundle exec rspec

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
