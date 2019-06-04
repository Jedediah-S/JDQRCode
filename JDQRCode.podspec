#
# Be sure to run `pod lib lint JDQRCode.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JDQRCode'
  s.version          = '0.1.0'
  s.summary          = '二维码生成和识别'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
二维码生成和识别。可生成彩色二维码、带logo二维码l；扫描识别二维码信息。
                       DESC

  s.homepage         = 'https://github.com/Jedediah-S/JDQRCode'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jedediah' => '13432414304@163.com' }
  s.source           = { :git => 'https://github.com/Jedediah-S/JDQRCode.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'JDQRCode/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JDQRCode' => ['JDQRCode/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
