# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Lunttery' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Lunttery
  pod 'Alamofire','~> 4.0'
  pod 'SwiftyJSON'
  pod 'SDWebImage'
  pod 'FacebookCore'
  pod 'FacebookLogin'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.name != 'Debug'
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
                else
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
            end
        end
    end
end
