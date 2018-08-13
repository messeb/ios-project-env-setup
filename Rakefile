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

# Combines project setup with unit tests
task :setup_with_unit_test => [
    :setup,
    :unit_test
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

# Run fastlane unit tests
task :unit_test do 
    sh "fastlane test"
end
