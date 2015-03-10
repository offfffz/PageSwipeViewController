#
# Be sure to run `pod lib lint PageSwipeViewController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PageSwipeViewController"
  s.version          = "0.1.0"
  s.summary          = "A tab application which is swipable between tabs."
  s.description      = <<-DESC
                       PageSwipeViewController is an easy way to implement page based application.
                        User can swipe through pages and the tab will focus on the recent page.
                       DESC
  s.homepage         = "https://github.com/offfffz/PageSwipeViewController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "offz" => "offfffz@gmail.com" }
  s.source           = { :git => "https://github.com/offfffz/PageSwipeViewController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/offfffz'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PageSwipeViewController' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Masonry', '~> 0.6.1'
end
