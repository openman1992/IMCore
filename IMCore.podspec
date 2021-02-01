#
# Be sure to run `pod lib lint IMCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IMCore'
  s.version          = '0.1.2'
  s.summary          = 'A short description of IMCore.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yangjun/IMCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangjun' => '237414238@qq.com' }
  s.source           = { :git => 'https://github.com/openman1992/IMCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'IMCore/Classes/Headers/**/*'
  #s.static_framework = true
  s.xcconfig = {
      'ENABLE_BITCODE' => 'NO'
  }
  s.subspec 'Mars' do |ss|
      ss.vendored_frameworks = 'IMCore/Vendors/*.framework'
      #ss.source_files = 'NetProtocol/*.framework/Headers/**/*.h'
      #ss.public_header_files = 'NetProtocol/*.framework/Headers/**/*.h'
      ss.frameworks = 'CoreTelephony', 'Foundation', 'SystemConfiguration', 'UIKit'
      ss.libraries = "z", "resolv.9"
      
      ss.preserve_paths = 'IMCore/Vendors/*.framework'
      ss.pod_target_xcconfig = {'LD_RUNPATH_SEARCH_PATHS' => '$(PODS_ROOT)/IMCore/Vendors/', 'VALID_ARCHS' => 'x86_64 arm64'}
      end
  # s.resource_bundles = {
  #   'IMCore' => ['IMCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
