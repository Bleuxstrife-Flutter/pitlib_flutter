#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'pit_payment'
  s.version          = '0.0.3'
  s.summary          = 'Payment Solution by PIT'
  s.description      = <<-DESC
Payment Solution by PIT
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'MidtransCoreKit', '~> 1.14.1'
  s.static_framework = true
  s.ios.deployment_target = '8.0'
end

