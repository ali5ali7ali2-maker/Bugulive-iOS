#
# Be sure to run `pod lib lint FDNetworkObjC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FDNetworkObjC'
  s.version          = '1.3.1'
  s.summary          = 'FDNetworkObjC是一个网络库，包含HTTP和HTTPS的网络请求GET/POST和七牛云/腾讯云/阿里云OSS上传功能'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://git.bogokj.com/fandong/FDNetworkObjC'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.author           = { 'fandongtongxue' => 'admin@fandong.me' }
  s.source           = { :git => 'http://git.bogokj.com/fandong/FDNetworkObjC.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'FDNetworkObjC/Classes/**/*'
  
  s.resource_bundles = {
    'FDNetworkObjC' => ['FDNetworkObjC/Assets/*']
  }

  s.dependency 'AFNetworking', '~> 4.0.1'
  s.dependency 'SDWebImage'
  s.dependency 'Qiniu'
  s.dependency 'FDFoundationObjC'
  s.dependency 'AliyunOSSiOS'
  
end
