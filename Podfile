# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

def testing_pods
    pod 'Quick'
    pod 'Nimble'
end

target 'SampleBarCodeScanner' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!


  target 'SampleBarCodeScannerTests' do
    inherit! :search_paths
    # Pods for testing
	testing_pods
  end

end
