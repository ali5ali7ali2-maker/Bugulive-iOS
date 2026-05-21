#use_frameworks!
platform :ios, '11.0' #手机的系统
#use_modular_headers!
source 'https://github.com/CocoaPods/Specs.git'
#source 'http://git.bogokj.com/fandong/BogoSpec.git'

target 'BuguLive' do

project 'BuguLive.xcodeproj'

pod 'AFNetworking','~>4.0'

pod 'LookinServer', :configurations => ['Debug']


pod 'MBProgressHUD'
pod 'SVProgressHUD'

pod 'IQKeyboardManager'
pod 'SDWebImage'
pod 'MJRefresh','~>3.4.2'
pod 'MJExtension'
pod 'FMDB'
pod 'AliyunOSSiOS','~>2.10.8'
pod 'BlocksKit','~>2.2.5'
pod 'FTUtils'
pod 'Reachability'
pod 'KVOController'
#pod 'MLeaksFinder'

pod 'MDRadialProgress'
pod 'UICountingLabel'
pod 'SDCycleScrollView','~>1.82'
#pod 'KLSwitch'
#pod 'MarqueeLabel'
#pod 'HMSegmentedControl'
#pod 'MMPopupView'

# 友盟统计
#pod 'UMengAnalytics'

#pod 'UMCCommon'
#pod 'UMCPush'#友盟推送
#pod 'UMCSecurityPlugins'




#pod 'TencentMap-SDK'



pod 'libksygpulive/KSYGPUResource'
pod 'libksygpulive/libksygpulive'


pod 'QMUIKit', '~> 4.1.3'



#pod 'WechatOpenSDK' #, '~> 2.9.3'
#pod 'AlipaySDK-iOS'


#pod 'Bugly'
pod 'LEEAlert'
pod 'LCActionSheet'
pod 'M80AttributedLabel'
pod 'TTTAttributedLabel'
pod 'XXNibBridge'

#直播腾讯云SDK
pod 'TXLiteAVSDK_Professional','9.1.10564'

#pod 'ZipArchive', '~> 1.4.0'

#音频播放
pod 'ZQPlayer'
#列表视频播放器
pod 'CLPlayer', '~> 1.2.7'
pod 'YYKit',:git => 'https://github.com/ivoidcat/YYKit'
#七牛
pod "Qiniu", "~> 7.2"

#pod 'FDUIKitObjC', :git => 'http://git.bogokj.com/fandong/FDUIKitObjC.git', :branch => 'master'
#pod 'BogoPayKit', :git => 'http://git.bogokj.com/fandong/BogoPayKit.git', :branch => 'ios_bogo_live_v3'
#pod 'FDNetworkObjC', :git => 'http://git.bogokj.com/fandong/FDNetworkObjC.git', :branch => 'ios_bogo_live_v3'

pod 'TYCyclePagerView'
pod 'NAKPlaybackIndicatorView'
pod 'ZLCollectionViewFlowLayout'
pod 'TZImagePickerController'
pod 'FDFullscreenPopGesture'
#启动页轮播图
pod 'XHLaunchAd'

pod "QPDialCodePickerView"

#pod 'LocalizedView'
#facebook
pod 'FBSDKLoginKit'
#pod 'UMShare/Social/Facebook'
#pod 'UMShare/Social/GooglePlus'

#facebook登录
#pod 'FBSDKLoginKit'


pod 'WoodPeckeriOS', :configurations => ['Debug']

#SJ视频播放器
#pod 'SJVideoPlayer'


#pod 'UIBarButtonItem-Badge-Coding'#右上方红字
pod 'BRPickerView'#选择器

pod 'ReactiveObjC'

pod 'ZFPlayer'
pod 'ZFPlayer/ControlView'
pod 'ZFPlayer/AVPlayer'

pod 'AFSoundManager'
#pod 'TXIMSDK_Plus_iOS','6.9.3557'
pod 'AgoraRtcEngine_iOS','3.7.0'

pod 'Firebase',:modular_headers => true
pod 'FirebaseAuth',:modular_headers => true
pod 'GoogleSignIn','7.0.0',:modular_headers => true
pod 'FirebaseCore',:modular_headers => true
pod 'GoogleUtilities', :modular_headers => true

pod 'FirebaseFirestore', :modular_headers => true
#pod 'SSZipArchive'
pod 'Protobuf'
#svga动画库
#pod 'SVGAPlayer', '~> 2.0.1'

pod "RxSwift"
pod 'RxCocoa'
pod 'RxDataSources'
pod 'SnapKit', '~> 5.0.0'
pod 'Then'
pod 'DynamicColor'
pod 'AutoInch'
pod 'GKPageScrollView'
pod 'GKPageSmoothView','1.9.4'
#pod 'JXCategoryView'
pod 'JXCategoryViewExt/SubTitleImage'
pod 'JXCategoryViewExt/Indicator/AlignmentLine'
pod 'WechatOpenSDK'
pod 'AlipaySDK-iOS'
pod 'GKNavigationBar'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
      target.build_configurations.each do |config|
          config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end
