# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def firebase_install
 pod 'GoogleMLKit/BarcodeScanning', '2.4.0'
 pod 'Google-Mobile-Ads-SDK'
end

target 'RealNameRegistraionBook' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

   firebase_install

  target 'RealNameRegistraionBookTests' do
    inherit! :search_paths
    # Pods for testing
   firebase_install
  end

  target 'RealNameRegistraionBookUITests' do
    # Pods for testing
  end

end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
