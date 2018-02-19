#!/bin/sh

set -e

if [ -n "${IGNORE_LEGACY-}" ]; then
  echo "$(tput bold)Nothing to test!"
  exit 0;
fi

echo "$(tput bold)Enforcing old RuboCop version: $(tput sgr0)"
sed -i.bak "s/'>= 0.45.0'/'>= 0.45.0', '0.46.0'/" ducalis.gemspec
bundle install --no-deployment --quiet --no-color
bundle show rubocop
echo "$(tput bold)Running rspec on old RuboCop version: $(tput sgr0)"
bundle exec rspec --format progress
echo "$(tput bold)Enforcing new RuboCop version: $(tput sgr0)"
mv ducalis.gemspec.bak ducalis.gemspec
bundle install --no-deployment --quiet --no-color
bundle show rubocop
echo "$(tput bold)Running rspec on new RuboCop version: $(tput sgr0)"
bundle exec rspec --format progress
