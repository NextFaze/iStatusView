#
# Be sure to run `pod lib lint iStatusView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'iStatusView'
  s.version          = '0.4.0'
  s.summary          = 'iStatusView is a convenient way to show loading and message status in a view.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
iStatusView is a view that can be added to any other, like the view of a UIViewController.
Use iStatusView to show loading progress with any indicator, customisable text and an icon.
When an error has occured, the message can be displayed, and a rety button can be shown.
                       DESC

  s.homepage         = 'https://github.com/NextFaze/iStatusView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'awulf' => 'awulf@pacmeb.com' }
  s.source           = { :git => 'https://github.com/NextFaze/iStatusView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'iStatusView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'iStatusView' => ['iStatusView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
