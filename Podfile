source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target 'iOSProjectSetup' do
    pod 'Alamofire', '4.7.3'
    pod 'RxSwift', '4.3.1'
    pod 'RxCocoa', '4.3.1'
end

target 'iOSProjectSetupTests' do
    pod 'RxSwift', '4.3.1'
    pod 'RxCocoa', '4.3.1'
    pod 'RxBlocking', '4.3.1'
    pod 'RxTest',     '4.3.1'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
        
            config.build_settings['SWIFT_VERSION'] = '4.2'
            config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = '$(inherited)'

            config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''

            if config.name == 'Release'
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
                else
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
            end
        end
    end
end