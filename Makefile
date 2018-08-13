# Checks if executable exists in current path
RUBY := $(shell command -v ruby 2>/dev/null)
HOMEBREW := $(shell command -v brew 2>/dev/null)
BUNDLER := $(shell command -v bundle 2>/dev/null)

# Default target, if no is provided
default: setup

# Steps for project environment setup
setup: \
	pre_setup \
	check_for_ruby \
	check_for_homebrew \
	update_homebrew \
	install_carthage \
	install_bundler_gem \
	install_ruby_gems \
	install_carthage_dependencies \
	install_cocoapods

# Combines project setup with unit tests
setup_with_unit_test: \
	setup \
	unit_test

# Pre-setup steps
pre_setup:
	$(info iOS project setup ...)

# Check if Ruby is installed
check_for_ruby:
	$(info Checking for Ruby ...)

ifeq ($(RUBY),)
	$(error Ruby is not installed)
endif

# Check if Homebrew is available
check_for_homebrew:
	$(info Checking for Homebrew ...)

ifeq ($(HOMEBREW),)
	$(error Homebrew is not installed)
endif

# Update Homebrew
update_homebrew:
	$(info Update Homebrew ...)

	brew update

# Install Bundler Gem
install_bundler_gem:
	$(info Checking and install bundler ...)

ifeq ($(BUNDLER),)
	gem install bundler -v '~> 1.16'
else
	gem update bundler '~> 1.16'
endif

# Install Ruby Gems
install_ruby_gems:
	$(info Install RubyGems ...)

	bundle install

# Install Cocopods dependencies
install_cocoapods:
	$(info Install Cocoapods ...)

	pod install

# Install Carthage
install_carthage:
	$(info Install Carthage ...)

	brew unlink carthage || true
	brew install carthage
	brew link --overwrite carthage

# Install Carthage dependencies
install_carthage_dependencies:
	$(info Install Carthage Dependencies ...)

	carthage bootstrap --platform ios --cache-builds

# Run fastlane unit tests
unit_test:
	$(info Run Unittests ...)

	fastlane test
