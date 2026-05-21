#
# Be sure to run `pod lib lint FDUIKitObjC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FDUIKitObjC'
  s.version          = '2.0.0'
  s.summary          = 'FDUIKitObjC是一个UI库，包含自定义ActionSheet，自定义AlertView，照片浏览器，自定义PopView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://git.bogokj.com/fandong/FDUIKitObjC'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.author           = { 'fandongtongxue' => 'admin@fandong.me' }
  s.source           = { :git => 'http://git.bogokj.com/fandong/FDUIKitObjC.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'FDUIKitObjC/Classes/**/*'
    
   s.dependency 'YYKit'
   s.dependency 'MBProgressHUD'
   s.dependency 'Masonry'
   s.dependency 'FDFullscreenPopGesture'
   s.dependency 'MJRefresh'
   s.dependency 'FDFoundationObjC'
   
end
