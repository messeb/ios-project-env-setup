# Setup an iOS project environment

  ![iOS Project setup](files/ios-project-setup.gif)

Nowadays an iOS project is more than only a `*.xcodeproj` file with some self-written Objective-C or Swift files. We have a lot of direct and indirect external dependencies in our projects and each new developer on the project or the build server have to get these. Developers need these before working on the app and the build server to build and deploy the app.

#### Contact

<a href="https://to.messeb.com/twitter"><img src="http://github.messeb.com.s3.amazonaws.com/assets/messeb-twitter-btn.png" width="120" height="34" style="max-width:100%;"></a> <br>
Follow me on Twitter: [@_messeb](https://to.messeb.com/twitter) 

<a href="https://to.messeb.com/contact"><img src="http://github.messeb.com.s3.amazonaws.com/assets/messeb-linkedin-btn.png" width="120" height="34" style="max-width:100%;"></a> <br>
Contact me on LinkedIn: [@messingfeld](https://to.messeb.com/contact)

--- 
#### Table of Content
* [Types of dependencies](#types-of-dependencies)
* [Solutions for code dependencies](#solutions-for-code-dependencies)
* [Managing dependency chain](#managing-dependency-chain)
* [Solutions](#solutions)
    * [Shell script](#shell-script)
    * [Makefile](#makefile)
    * [Rakefile](#rakefile)
* [Conclusion](#conclusion)
* [Demo project](#demo-project)
--- 

## Types of dependencies

We can separate the project dependencies into different categories:

**Code**:  Because we don’t want reinvent the wheel for parts of our apps again and again, we use third-party libraries for common use cases. E.g. we use [Alamofire](https://github.com/Alamofire/Alamofire "Alamofire") for our network stack. Also, we want use the latest and hopefully greatest version of each dependency, to get the newest features and especially critical bug fixes almost automatically. To reach this goal you should use a dependency manager, which cares about these problems. The principle „never change a running“ system should not apply to third-party dependencies. Especially if these are responsible for critical parts of the app, like encryption.

**Code Dependency Manager**:  To manage code dependencies in our project we currently have two famous dependency management systems in our iOS world: [Cocoapods](https://github.com/CocoaPods/CocoaPods "Cocoapods") and [Carthage](https://github.com/Carthage/Carthage "Carthage"). Both have almost the same feature set and care about two important requirements: 
1. Install the same versions of the dependencies on every system, so that every developer and the build server creates the same app artefact. 
1. Support updating a to dedicated or latest version of the dependencies

But neither _Cocoapods_ or _Carthage_ are bundled with macOS, therefore we have to install at least one of them. _Cocoapods_ is available as Ruby Gem and the preferred way to install _Carthage_ is via a _Homebrew_ package.

**Dependency Manager Management**:  To manage our iOS dependency manager, we should use some kind of dependency manager, too. 
_Cocoapods_ is available as Ruby Gem. So we should create a `Gemfile` for these type of dependencies (a `Gemfile` is like the `Podfile` for Ruby developers). We then need to use the _bundler_ Ruby Gem to manage the dependencies in the `Gemfile`. Look at [https://rubygems.org](https://rubygems.org/ "https://rubygems.org") and [https://bundler.io/](https://bundler.io/) for detailed information.
We install _Carthage_ with _Homebrew_ via a shell command: `brew install carthage`. _Homebrew_ itself is only available through a Ruby installation script. (See [https://brew.sh](https://brew.sh/ "https://brew.sh"))

**Ruby**:  The prime dependency in this dependency chain is Ruby. The good news is that it is directly available in the latest macOS, in a 'not so old' version too! If you want the latest or a special version of Ruby you have to install it another way. Besides compiling it from source code, you can use _RVM_ or _rbenv_, which provides an environment management for _Ruby_.

## Solutions for code dependencies

After we see what dependencies our iOS project really has, we could look at possible solutions for managing them:

### Under version control

If you put your code dependencies in your version control system, you will have a compile-ready state of the project in your repository. Then it’s not needed, at least for the build server, to have a way to install all the other indirect dependencies, like _Cocoapods_. But a developer, who wants install new or update old code dependency, will need them. 

### Not under version control

If you not put the code dependencies under version control, you have to provide a way that your colleagues and the build server can resolve and fetch them. The most important part is that everyone gets the same versions of each dependency, which is ensured via the `*.lock`  / `*.resolved` files of each dependency manager. These files freeze the versions of used dependencies and you have to force update the dependency versions for newer versions.
In this solution, it will be also easy to add, update or remove a dependency in each step, because every developer has the needed environment for it.  E.g. _fastlane_ is also provided as a Ruby Gem, so you only need to modify the `Gemfile` of the project and update the `Gemfile.lock`.
An negative aspect is, that all of the dependencies have to always be available. Nowadays, most of the code dependency are public hosted on Github.com and will be consumed from there. If a developer decides to remove their library from Github.com you need to change the dependency or try to find another source for it.


Regardless which way you choose, in my opinion you should provide an easy way to setup the whole project environment. 

## Managing dependency chain

Currently there is no single right way to manage the whole dependency chain for an iOS project environment. It depends on the project and what parts should be provided for the developers and what parts they want manage by their own. Especially for Xcode (Mac App Store or direct download from developer portal) and Ruby (_RVM_ or _rbenv_), each developer has their favourite way to manage it.


So, there is a part of the chain, which should already exists on the developers computer or the build server. For the rest, there are three common ways to install all the project dependencies: Shell script, Makefile and Rake script.

### Base setup

The base setup, which should be already on the developers computers, normally contains Xcode, Ruby and Homebrew. It depends whether you use _Cocoapods_ or _Carthage_ if you need _Homebrew_. But we can use this as starting point.

**Xcode**:  You can install the latest release version of Xcode via the Mac App Store ([https://itunes.apple.com/app/xcode/id497799835](https://itunes.apple.com/app/xcode/id497799835)), or via an direct download from the Apple Developer portal ([https://developer.apple.com/download/](https://developer.apple.com/download/)). If you use the Mac App Store version, you can auto update to the latest version, but keep in mind that not every project is directly ready to run with the latest Xcode. 

**Ruby**:  You can download the source code and compile it by your own ([https://www.ruby-lang.org/en/downloads/](https://www.ruby-lang.org/en/downloads/)). Or you use third party tools to manage it, like [rbenv](https://github.com/rbenv/rbenv) or [RVM](http://rvm.io/). With the third party tools you can easily update or switch the current used Ruby version. So, you should really have a look at it.

**Homebrew**:  To install _Homebrew_ a script is provided on the project website [brew.sh](https://brew.sh/). If you have installed it already, _Homebrew_ can be self upgraded with the command: `brew update`

### Dependency setup

**Ruby dependencies**:  External dependencies for Ruby scripts are normally be managed via the packet manager system `RubyGems`. With the Gem _bundler_ it's possible to install Gems from a _Gemfile_ like this:

```ruby
ruby "~> 2.5.1"

source 'https://rubygems.org'
gem 'cocoapods', '~> 1.5.3'
gem 'fastlane', '~> 2.100.1'
```

To install these dependencies, you only have to run `bundle install`. The first run of it produces also a `Gemfile.lock` file, which locks the version numbers for other clients. So it's guaranteed that the same artefact is produced on every system. Therefore the `Gemfile.lock` should be committed in the project Git repository.

**Cocoapods dependencies**:  Cocoapods manages the dependencies in their  _Podfile_ and _Podfile.lock_ files. With a call of `pod install` you install all the right versions of the dependencies. With `pod update` you can update the _Podfile.lock_ after changes in _Podfile_. The _Podfile.lock_ also needs to be in you project Git repository.

**Carthage dependencies**:  Like _Cocoapods_, _Carthage_ has it's _Cartfile_ and _Cartfile.resolved_ with the specified versions of the dependencies. Using `carthage bootstrap` you can build the frameworks. The _Cartfile.resolved_ should also be in your Git repository. 


To install all the dependency a developer has to run the following commands:

```bash
# Installs bundler gem
gem install bundler

# Installs Gems with versions of Gemfile.lock
bundle install

# Installs Pods with versions of Podfile.lock
pod install

# Builds the frameworks with code versions of Cartfile.resolved
carthage boostrap 
```

## Solutions

After you have the base setup of your iOS project environment you have to find an easy and predictable way to execute all the steps for setup the iOS project environment. You should prevent your developer to read a long potential outdated documentation.

We want do the following steps:
* Check if Ruby is available
* Check if Homebrew is available
* Install Ruby Gems
* Install Cocoapods dependencies
* Install Carthage dependencies
* Open for additional steps

Additional steps could be triggering the build process and run the unit test, like with fastlane:

```bash
fastlane test
```

So the best way would be a solution where these steps are running with the other steps, but it should be also possible to run the additional steps only by their own, because you already could have setup your project environment.

### Shell script
The shell script solution is inspired by the [Firefox iOS App](https://github.com/mozilla-mobile/firefox-ios/) and their solution can be found here: [bootstrap.sh](https://github.com/mozilla-mobile/firefox-ios/blob/master/bootstrap.sh)

The script will be executed from top to bottom and performs all the necessary steps to setup the project environment. 

**Pros**:
* Same syntax as manual entered commands
* Groups manual entered commands into one file
* Can contain checks for dependencies
* Customisable and extendible with functions

**Cons**:
* Bash syntax
* No selective running of steps
* No easy integration of optional additional steps


I added the `command_exists` function, to check if a executable is available in the current shell path.

```bash
#!/bin/bash

# Checks if executable exists in current path
command_exists () {
  command -v "$1" > /dev/null 2>&1;
}

echo "iOS project setup ..."

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

```

A new developer only needs to run `./project_setup.sh` to setup the iOS project environment.

If you want to add additional steps, you should write additional functions for each step. With parameters at the call of `./project_setup.sh`, you can control which step will be executed. For example, if we want to run our unit test, it would look like this

```bash
#!/bin/bash

echo "iOS project setup ..."

# Check if user only wants to run unit tests
only_test=false
[ "$1" == "only_test" ] && only_test=true

# Check if user wants to create build environment
# and execute the unit tests
with_test=false
[ "$1" == "with_test" ] && with_test=true

# Run fastlane unit tests
unit_test() {
  fastlane test
}

# Run only unit tests
if $only_test 
then
  unit_test
  exit 0
fi

#
# All boostrapping steps
#

# Run unit tests after project setup
if $with_test
then
  unit_test
fi
```

We define a `unit_test` function, which will executed if the first parameter is `only_test` or `with_test`. You can call the shell script with

```bash
./project_setup.sh only_test
```

or

```bash
./project_setup.sh with_test
```

For `only_test`, the function `unit_test` will be executed at the beginning and the script ends. For `with_test`, the whole bootstrapping steps will be executed and afterwards the function `unit_test`. Without parameters only the project setup will be executed.

### Makefile

Inspired by the [Kickstarter](https://github.com/kickstarter/ios-oss "Kickstarter") ([Makefile](https://github.com/kickstarter/ios-oss/blob/master/Makefile "Makefile")) and [Wikipedia](https://github.com/wikimedia/wikipedia-ios "Wikipedia") ([Makefile](https://github.com/wikimedia/wikipedia-ios/blob/develop/Makefile "Makefile")) app, a Makefile can also be a solution to execute all the steps with one command.

Unlike the shell script solution, it does not execute all the steps from top to bottom,. It executes a `target` block using it's name like:

```bash
make target_name
```

Only the commands in this `target` will be executed. But you can define other `targets` which should be executed before. So you have a chain of commands which will be executed one after the other which you can see it in the example.

You can also define a default `target` which will be executed if no `target` name is given.

**Pros**:
* Same syntax as manual entered commands
* Groups manual entered commands in one file
* Can contain checks for dependencies
* Selective running of steps
* Easy integration of optional additional steps

**Cons**:
* Makefile syntax
* Limited customisable and extensible with targets


A Makefile can look like the example below and contain setup steps for each project as target.
The `setup` target only has other targets as dependencies and doesn’t execute anything. Targets with a colon after the target name will be executed in top to bottom order. So you can manage the execution order of your steps. 

The syntax of a Makefile is a little complicated, like the checks of the existing Ruby or Homebrew binaries shows, but normally you don’t need to know more. If you interested, read more in the [make documentation](https://www.gnu.org/software/make/manual/make.html "make documentation").

```bash
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

```

Each of the targets can also be execute on their own. You have to execute `make` with the specific target name, like `make install_ruby_gems`

So, it's also easy to add additional steps in our project setup. If you want to add a unit test to it, you can define an additional target (`unit_test`).
If you want to execute the `setup` and the `unit_test` target together, you can define an additional target with these targets as dependency.

```bash
# Combines project setup with unit tests
setup_with_unit_test: \
    setup \
    unit_test

#
# All other boostrapping steps
#

# Run fastlane unit tests
unit_test:
    $(info Run Unittests ...)

    fastlane test
```

So you can call 

```bash
make unit_test
```

to run only the unit tests, and 

```bash
make setup_with_unit_test
```

if you need also the project setup. Especially on an build server the last command is very useful.

### Rakefile

The [Wordpress](https://github.com/wordpress-mobile/WordPress-iOS/ "Wordpress") ([Rakefile](https://github.com/wordpress-mobile/WordPress-iOS/blob/develop/Rakefile "Rakefile")) app uses a Rakefile for its project setup. This is similar to the Makefile solution, but it uses the Ruby variant of make: [rake](https://github.com/ruby/rake "rake")

We don’t need a check for Ruby because Ruby and `rake` are preconditions on the developers system to execute the Rakefile tasks.

Otherwise, the Rakefile solution is very similar to a Makefile.
Each project setup step is in a `task` block and can be execute by its name, e.g. `rake check_homebrew`.
It is also possible to have a default `task`, which will be execute if you only call `rake`, and each of the tasks can depend on others.

**Pros**:
* Groups manual entered commands in one file
* Can contain checks for dependencies
* Selective running of steps
* Easy integration of optional additional steps
* Customisation of build process via Ruby functionality

**Cons**:
* Needs rake on system
* Rakefile syntax
* Executes shell commands over an additional Ruby function `sh`

You can see an example below. The main task is `setup`, which has other tasks as dependencies. You can define dependencies with an arrow operator pointing to the list of the dependencies.

Each of the tasks can contain any Ruby code. So if you are familiar with Ruby you can adapt this solution very quickly. But you can also see that you will mostly execute shell commands from your Ruby script. That’s why you should decide for yourself if you really need this additional abstraction layer.


```ruby
# Checks if executable exists in current path
def command?(command)
    system("command -v #{command} > /dev/null 2>&1")
end

# Default target, if no is provided
task default: [:setup]

# Steps for project environment setup
task :setup => [
    :pre_setup,
    :check_for_homebrew, 
    :update_homebrew,
    :install_bundler_gem,
    :install_ruby_gems,
    :install_carthage,
    :install_cocoapods_dependencies,
    :install_carthage_dependencies,
]

# Pre-setup steps
task :pre_setup do 
    puts "iOS project setup ..."
end

# Check if Homebrew is available
task :check_for_homebrew do
    puts "Checking Homebrew ..."
    if not command?('brew')
        STDERR.puts "Homebrew not found, please install it:"
        STDERR.puts "https://brew.sh/"
        exit
    end
end

# Update Homebrew
task :update_homebrew do 
    puts "Updating Homebrew ..."
    sh "brew update"
end

# Install Bundler Gem
task :install_bundler_gem do 
    if not command?('bundle')
        sh "gem install bundler -v '~> 1.16'"
    else
        sh "gem update bundler '~> 1.16'"
    end
end

# Install Ruby Gems
task :install_ruby_gems do
    sh "bundle install"
end

# Install Cocopods dependencies
task :install_cocoapods_dependencies do
    sh "pod install"
end

# Install Carthage
task :install_carthage do 
    sh "brew unlink carthage || true"
    sh "brew install carthage"
    sh "brew link --overwrite carthage"
end

# Install Carthage dependencies
task :install_carthage_dependencies do
    sh "carthage bootstrap --platform ios --cache-builds"
end
```

To add additional steps, you only have to add another task, like one for the unit tests

```ruby
# Run fastlane unit tests
task :unit_test do 
    sh "fastlane test"
end
```

You can call this directly with `rake unit_test`. To combine the project setup with the execution of the unit tests, you can define an extra task for it, which has the both tasks as dependencies.

```ruby
# Combines project setup with unit tests
task :setup_with_unit_test => [
    :setup,
    :unit_test
]
```

This can be execute with 

```ruby
rake setup_with_unit_test
```

## Conclusion

If you use a shell script, a Makefile, a Rakefile or something else, you will provide an easy bootstrapping script for your iOS project. This makes it much easier for new developers to start and a build server needs only a one liner to build and deploy the app. The trouble with setting this up and learning some new script languages will it be worth it.

Now, you can also easily use cloud continuous integration services like Travis CI, CircleCI or bitrise.io. Normally in the configuration of these services you will select an Xcode version and have also Ruby and Homebrew available. So your execution step will be the same as every developer does on their local machine: `make setup_with_unit_test`.

My preferred solution is a Makefile, because it has a integrated dependency management between the targets and is directly callable, which is not as easy in a shell script solution. It also relies on `make`, which comes with every macOS in contrast to `rake`.
If you need to execute more complex steps, which is not a strength of a Makefile, your can break the steps into multiple Shell or Ruby scripts and call them from your Makefile.

## Demo project

I have provided a demo project, where you can test all three solutions on your own.

**Shell script**

Project setup:

```bash
./project_setup.sh
```

Project setup with unit tests:

```bash
./project_setup.sh with_test
```

Unit tests:

```bash
./project_setup.sh only_test
```


**Makefile**

Project setup:

```bash
make setup
```

Project setup with unit tests:

```bash
make setup_with_unit_test
```

Unit tests:

```bash
make unit_test
```


**Rake**

Project setup:

```bash
rake setup
```

Project setup with unit tests:

```bash
rake setup_with_unit_test
```

Unit tests:

```bash
rake unit_test
```


The iOS project contains both, Cocoapods and Carthage dependencies to show the different steps. Normally you would only use one of these code dependency manager. A fastlane `test` lane is also provided to execute example unit tests.
