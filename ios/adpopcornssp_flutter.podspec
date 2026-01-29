#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint adpopcornssp_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'adpopcornssp_flutter'
  s.version          = '1.0.15'
  s.summary          = 'AdPopcornSSP plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://adpopcorn.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'AdPopcorn' => 'mick.kim@adpopcorn.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AdPopcornSSP', '2.11.4'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
