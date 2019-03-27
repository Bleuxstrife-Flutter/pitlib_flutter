#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'pit_multiple_image_picker'
  s.version          = '0.0.5'
  s.summary          = 'PIT Multiple Image Picker'
  s.description      = <<-DESC
PIT Multiple Image Picker
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'ELCImagePickerController'
  s.ios.deployment_target = '8.0'
end

