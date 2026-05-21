//
//  AppchangeHeader.h
//  BuguLive
//
//  Created by xfg on 2017/3/14.
//  Copyright © 2017年 xfg. All rights reserved.

#ifndef AppchangeHeader_h
#define AppchangeHeader_h

#pragma mark - ----------------------- app名称、版本 -----------------------

// app名称
#define     AppName                 ASLocalizedString(@"VIP秀场")
// app时间版本号（主要用来提示升级等）
#define     VersionTime             @"2021101001"
//@"2017110902"
// app版本号


#define     VersionNum              @"2021101001"



#pragma mark - ----------------------- 接口地址等 -----------------------

// app是否打开域名备份功能 YES：开启 NO：关闭
#define     IsNeedStorageDoMainUrl  @"YES"
// app接口地址（如果有多个的话，可能是备用域名）
#define     AppDoMainUrlArray [NSArray arrayWithObjects:@"https://mapi.toplive.cc", nil]
#define ADMIN_API_URL @"https://adminapi.toplive.cc"
//[NSArray arrayWithObjects:@"http://live.bogokj.com", nil]
//开发
//#define     AppDoMainUrlArray       [NSArray arrayWithObjects:@"http://dev.live.bogokj.com", nil]
// app接口地址后缀
#define     AppDoMainUrlSuffix      @"/mapi/index.php"
//#define     AppDoMainUrlSuffix      @""

// app的H5页面初始化接口地址（非h5项目不需要填写该项）
#define     H5InitUrlStr            @"https://live.bogokj.com/app.php?act=init"
// app的H5页面主页（初始化地址失败时使用，非h5项目不需要填写该项）
#define     H5MainUrlStr            @"https://live.bogokj.com/index.php?show_prog=1"


#pragma mark - -------------------- 项目其他相关配置 -----------------------

// app是否需要开启AES加密 YES：开启 NO：关闭
#define     IsNeedAES               @"YES"
// AES加密的key，生成机制：“腾讯IM账号ID”后补“0”直到满足16位（注意：当且仅当 IsNeedAES == YES 时需要设置）
#define     AppAESKey               @"1400480612000000"
//@"1400039159000000"
//@"1400241175000000"


// 首次安装是否显示引导图 YES：开启 NO：关闭
#define     IsNeedFirstIntroduce    @"YES"
// 首次安装引导图的的张数（注意：当且仅当 IsNeedFirstIntroduce == YES 时需要设置）
#define     FirstIntroduceImgCount  @"3"
// 首次安装引导图的“立即体验”按钮的背景色（注意：当且仅当 IsNeedFirstIntroduce == YES 时需要设置）
#define     ExpBtnBackGroundColor   RGBA(255, 255, 255, 0)
// 首次安装引导图的“立即体验”按钮的Y值（注意：当且仅当 IsNeedFirstIntroduce == YES 时需要设置）
#define     ExpBtnBackY             kScreenH - 60

// 是否是AppStore版本 1：是 0：否
#ifndef kAppStoreVersion
#define kAppStoreVersion            0
#endif

// 审核时显示的主色调（苹果审核时，防止UI雷同的一种措施）
#define     kCheckVMainColor        RGB(255, 117, 81)

// 下拉刷新时由图片组成的类似GIF效果的图片数量
#define     kRefreshImgCount        34


#pragma mark - ----------------------- 其他第三方key等 -----------------------

// APP回调（注意需要跟Info.plist文件中的URL types的第一项保持一致）
#define     AlipayScheme            @"zhiboapp"
// 友盟KEY
#define     UmengKey                @"611a07a9e623447a331feef7"
// 友盟Secret
#define     UmengSecret             @"7vv2hnwhogd9cqwe503ezeaidm0xz3on"
// 微信AppID
#define     WeixinAppId             @"wxb4ee11cf13f0756a"
// 微信Secret
#define     WeixinSecret            @"9b2eb13b83bb19fd96cce55fe2c128c9"
// QQ的AppID
#define     QQAppId                 @""
// QQ的Secret
#define     QQSecret                @""
// 新浪AppID
#define     SinaAppId               @""
// 新浪Secret
#define     SinaSecret              @""
// 腾讯地图KEY
#define     QQMapKey                @"CJUBZ-C7RCU-L3FV7-4Q225-TBU5O-BMBLZ"
// 聚宝付的AppID
#define     JBFAppId                @"35656972"
// 百度地图key
#define     BaiduMapKey             @"uycVd7UYhOKUBOXhjCv7EgtKCMvugMsN"


#pragma mark - ----------------------- 直播SDK的key等 -----------------------

// 腾讯IM账号
#define     TXYSdkAccountType       @"0"
// 腾讯IM账号ID
#define     TXYSdkAppId             @"20010085"
//@"1400039135"

//

#define     AgoraAppId              @"7536c80dcbf84e79a883057edda1c8d7"


//直播SDK Licence
#define TXRTMPKey @"4455812430ce35c17ea78ee79f7071e1"
#define TXRTMPLicence @"https://license.vod2.myqcloud.com/license/v1/b9c4190bec109303af70d28f8623236c/TXLiveSDK.licence"


#pragma mark - ----------------------- app项目内的相关称呼 -----------------------

// app在直播中的名称（服务端有下发时优先用服务端下发的）
#define     ShortNameStr            ASLocalizedString(@"VIP秀场")
// app中账号的称呼（服务端有下发时优先用服务端下发的）
#define     AccountNameStr          ASLocalizedString(@"账号")
// app印票的称呼（服务端有下发时优先用服务端下发的）
#define     TicketNameStr           ASLocalizedString(@"印票")
// app钻石的称呼（服务端有下发时优先用服务端下发的）
#define     DiamondNameStr          ASLocalizedString(@"钻石")
#pragma mark - ----------------------- 项目类型及支持的模块 -----------------------

// 购物直播（h5嵌直播）项目  1：购物直播（h5嵌直播） 0：不支购物直播（h5嵌直播）
#ifndef kSupportH5Shopping
#define kSupportH5Shopping          0
#endif

// 自动发牌 1：显示自动手动发牌的控制按钮 0：不显示（只有手动发牌）
#ifndef kSupportArcGame
#define kSupportArcGame             1
#endif

#endif /* AppchangeHeader_h */

