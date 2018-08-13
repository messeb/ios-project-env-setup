#!/bin/bash

# Checks if executable exists in current path
command_exists () {
  command -v "$1" > /dev/null 2>&1;
}

echo "iOS project setup ..."

# Check if user only wants to run unit tests
only_test=false
[ "$1" == "only_test" ] && only_test=true

# Check if user wants to create build envirnoment
# and execute the unit tests
with_test=false
[ "$1" == "with_test" ] && with_test=true

# Run fastlane unit tests
unit_test() {
  fastlane test
}

if $only_test 
then
  unit_test
  exit 0
fi

# Check if Ruby is installed
if ! command_exists ruby
then
  echo 'Ruby not found, please install it:'
  echo 'https://www.ruby-lang.org/en/downloads/'
  exit 1
fi

# Check if Homebrew is available
if ! command_exists brew
then
  echo 'Homebrew not found, please install it:'
  echo 'https://brew.sh/'
  exit 1
else
  echo "Update Homebrew ..."
  brew update
fi

# Install Bundler Gem
if ! command_exists bundle
then
  echo "Bundler not found, installing it ..."
  gem install bundler -v '~> 1.16.2'
else 
  echo "Update Bundler"
  gem update bundler '~> 1.16.2'
fi

# Install Ruby Gems
echo "Install Ruby Gems ..."
bundle install

# Install Cocopods dependencies
echo "Install Cocoapods"
pod install

# Install Carthage
echo "Install / Update carthage ..."
brew unlink carthage || true
brew install carthage
brew link --overwrite carthage

# Install Carthage dependencies
echo "Install Carthage Dependencies ..."
carthage bootstrap --platform ios --cache-builds

if $with_test
then
  unit_test
fi