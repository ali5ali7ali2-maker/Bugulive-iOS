//
//  BogoNetworkInitModel.h
//  BogoNetworkKit
//
//  Created by bogokj on 2020/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoNetworkInitUrlModel : NSObject

@property(nonatomic, copy) NSString *superior_url;
@property(nonatomic, copy) NSString *recommend_url;
@property(nonatomic, copy) NSString *earnings_url;
@property(nonatomic, copy) NSString *waiting_earning_url;
@property(nonatomic, copy) NSString *giving_url;
@property(nonatomic, copy) NSString *customer_url;
@property(nonatomic, copy) NSString *withdrawal_url;
@property(nonatomic, copy) NSString *car_url;
@property(nonatomic, copy) NSString *feedback_url;

//Myearnings_url    string    虚拟收益
//coin_url    string    我的消费余额
@property(nonatomic, copy) NSString *Myearnings_url;
@property(nonatomic, copy) NSString *coin_url;

//"red_packet_url": "http:\/\/kh.zhang.shop.anbig.com\/bogovue\/#\/RedPacket",
//"send_red_packet_url": "http:\/\/kh.zhang.shop.anbig.com\/bogovue\/#\/SendRedPacket"

@property(nonatomic, copy) NSString *red_packet_url;
@property(nonatomic, copy) NSString *send_red_packet_url;

@property(nonatomic, copy) NSString *host_url;

//share_live_url    string    直播间分享路径 传值:lid 直播间id
//share_shop_url    string    商品分享路径 传值:gid 商品id uid 分享人id

@property(nonatomic, copy) NSString *share_live_url;
@property(nonatomic, copy) NSString *share_shop_url;

@end

@interface BogoNetworkInitModel : NSObject

//{
//    "agreement_url" = "http://kh.zhang.shop.anbig.com/api/content/agreement/?id=2";
//    "android_url" = "https://www.pgyer.com/6GUv";
//    "android_version" = 20190324;
//    "area_money" = 1999;
//    "bogokj_beauty_sdk_key" = "";
//    "brokerage_money" = 199;
//    "common_problem_url" = "http://kh.zhang.shop.anbig.com/api/content/agreement/?id=1";
//    "force_update" = 1;
//    "host_money" = 99;
//    img = "http://douyin.qiniu.bugukj.com/image/k2zhtf8o_6l5a5mbco4s15dce0631d3b9b.png";
//    "invite_install_url" = "http://kh.zhang.shop.anbig.com/api/invite/invite_install";
//    "invite_url" = "http://kh.zhang.shop.anbig.com/api/invite/index";
//    "ios_url" = "https://testflight.apple.com/join/08My4zYm";
//    "ios_version" = 20190909;
//    "is_beauty" = 1;
//    "licence_key" = 3a71a923a141d91f803dfaa46fb7534a;
//    "licence_url" = "http://license.vod2.myqcloud.com/license/v1/18b181183dc380b61e86cb01f01a2edb/TXLiveSDK.licence";
//    "live_agreement_url" = "http://kh.zhang.shop.anbig.com/api/content/agreement/?id=3";
//    "live_broadcas_url" = "http://kh.zhang.shop.anbig.com/api/video/live_broadcast";
//    "live_notice" = "\U6211\U4eec\U63d0\U5021\U7eff\U8272\U76f4\U64ad,\U5c01\U9762\U548c\U76f4\U64ad\U5185\U5bb9\U542b\U5438\U70df\U3001\U4f4e\U4fd7\U3001\U5f15\U8bf1\U3001\U66b4\U9732\U7b49\U90fd\U5c06\U4f1a\U88ab\U5c01\U505c\U8d26\U53f7\U3002\U7f51\U8b6624\U5c0f\U65f6\U5de1\U67e5\U54e6~---\U5c71\U4e1c\U5e03\U8c37\U9e1f\U7f51\U7edc\U79d1\U6280";
//    "live_select_goods_url" = "http://videoshop.bogokj.com/LiveSelectGoods";
//    "live_shop_url" = "http://kh.zhang.shop.anbig.com/api/shop/live_shop_list";
//       logo = "http://douyin.qiniu.bugukj.com/image/jxzwmyk0_6cbzp92p89pi5d285426cbd4e.png";
//       "max_RecordTime" = 30;
//       name = "APP\U542f\U52a8\U56fe";
//       "palace_url" = "http://kh.zhang.shop.anbig.com/api/palace/palace";
//       "partner_money" = 599;
//       "plug_ad_url" = "";
//       "qiniu_storage_open" = 1;
//       "qq_login" = 1;
//       "share_url" = "http://kh.zhang.shop.anbig.com/api/share";
//       "shop_apply_url" = "http://videoshop.bogokj.com/shopApply";
//       "shop_goods_url" = "http://videoshop.bogokj.com/Goods";
//       "shop_select_goods_url" = "http://videoshop.bogokj.com/ShopSelectGoods";
//       "shop_url" = "http://videoshop.bogokj.com/Shop";
//       "shop_user_order_url" = "http://videoshop.bogokj.com/UserOrder";
//       "shops_agreement" = "http://kh.zhang.shop.anbig.com/api/content/store_information";
//       "site_images" =     (
//                   {
//               "plug_ad_name" = "App\U542f\U52a8\U56fe\U8f6e\U64ad3";
//               "plug_ad_pic" = "http://douyin.qiniu.bugukj.com/image/k3z87zso_6avsarwmkbpn5deefe4bca896.png";
//               "plug_ad_url" = "";
//           },
//                   {
//               "plug_ad_name" = "App\U542f\U52a8\U56fe\U8f6e\U64ad1";
//               "plug_ad_pic" = "http://douyin.qiniu.bugukj.com/image/k3z87ng8_z3bzpyityz5deefe3b00e40.png";
//               "plug_ad_url" = "";
//           },
//                   {
//               "plug_ad_name" = "App\U542f\U52a8\U56fe\U8f6e\U64ad2";
//               "plug_ad_pic" = "http://douyin.qiniu.bugukj.com/image/k3z87eyo_5pjof01f9a285deefe30b77fe.png";
//               "plug_ad_url" = "";
//           }
//       );
//        "sms_color" =     {
//                "gift_content_color" = "#FFFFFF";
//                "gift_name_color" = "#FFF199FF";
//                "sys_color" = "#FFF199FF";
//                "text_content_color" = "#FFFFFF";
//                "text_name_color" = "#FFF199FF";
//            };
//            "start_figure" = 3;
//            "start_figure_switch" = 2000;
//            "store_deposit" = 1000;
//            "tencent_video_sdk_key" = 4455812430ce35c17ea78ee79f7071e1;
//            "tencent_video_sdk_licence" = "http://license.vod2.myqcloud.com/license/v1/b9c4190bec109303af70d28f8623236c/TXUgcSDK.licence";
//            "traders_money" = 19999;
//            "user_shopinfo_url" = "http://videoshop.bogokj.com/Shopinfo";
//            "vip_page_invite_user_url" = "http://kh.zhang.shop.anbig.com/api/content/?id=2";
//            "vip_page_look_video_url" = "http://kh.zhang.shop.anbig.com/api/content/?id=1";
//            "vip_watch_video_number" = 10;
//            "virtual_coin" = "\U94bb\U77f3";
//            "wallet_url" = "http://kh.zhang.shop.anbig.com/api/wallet";
//            "wechat_login" = 1;
//            "win_virtual_coin_img" = "http://kh.zhang.shop.anbig.com/api/content/?id=3";
//            'store_deposit':'1000',
//            'host_money':  99,
//            'brokerage_money' : 199,
//            'partner_money': 599;
//            'area_money' : 1999;
//            'traders_money': 19999;
//        }

@property(nonatomic, copy) NSString *agreement_url;
@property(nonatomic, copy) NSString *android_url;
@property(nonatomic, copy) NSString *android_version;
@property(nonatomic, copy) NSString *area_money;
@property(nonatomic, copy) NSString *bogokj_beauty_sdk_key;
@property(nonatomic, copy) NSString *brokerage_money;
@property(nonatomic, copy) NSString *common_problem_url;
@property(nonatomic, copy) NSString *force_update;
@property(nonatomic, copy) NSString *host_money;
@property(nonatomic, copy) NSString *img;
@property(nonatomic, copy) NSString *invite_install_url;
@property(nonatomic, copy) NSString *invite_url;
@property(nonatomic, copy) NSString *ios_url;
@property(nonatomic, copy) NSString *ios_version;
@property(nonatomic, copy) NSString *is_beauty;
@property(nonatomic, copy) NSString *licence_key;
@property(nonatomic, copy) NSString *licence_url;
@property(nonatomic, copy) NSString *live_agreement_url;
@property(nonatomic, copy) NSString *live_broadcas_url;
@property(nonatomic, copy) NSString *live_notice;
@property(nonatomic, copy) NSString *live_select_goods_url;
@property(nonatomic, copy) NSString *live_shop_url;
@property(nonatomic, copy) NSString *logo;
@property(nonatomic, copy) NSString *max_RecordTime;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *palace_url;
@property(nonatomic, copy) NSString *partner_money;
@property(nonatomic, copy) NSString *plug_ad_url;
@property(nonatomic, copy) NSString *qiniu_storage_open;
@property(nonatomic, copy) NSString *qq_login;
@property(nonatomic, copy) NSString *share_url;
@property(nonatomic, copy) NSString *shop_apply_url;
@property(nonatomic, copy) NSString *shop_goods_url;
@property(nonatomic, copy) NSString *shop_select_goods_url;
@property(nonatomic, copy) NSString *shop_url;
@property(nonatomic, copy) NSString *shop_user_order_url;
@property(nonatomic, copy) NSString *shops_agreement;
@property(nonatomic, strong) NSArray *site_images;
@property(nonatomic, strong) id sms_color;
@property(nonatomic, copy) NSString *start_figure;
@property(nonatomic, copy) NSString *start_figure_switch;
@property(nonatomic, copy) NSString *store_deposit;
@property(nonatomic, copy) NSString *tencent_video_sdk_key;
@property(nonatomic, copy) NSString *tencent_video_sdk_licence;
@property(nonatomic, copy) NSString *traders_money;
@property(nonatomic, copy) NSString *user_shopinfo_url;
@property(nonatomic, copy) NSString *vip_page_invite_user_url;
@property(nonatomic, copy) NSString *vip_page_look_video_url;
@property(nonatomic, copy) NSString *vip_watch_video_number;
@property(nonatomic, copy) NSString *virtual_coin;
@property(nonatomic, copy) NSString *wallet_url;
@property(nonatomic, copy) NSString *wechat_login;
@property(nonatomic, copy) NSString *win_virtual_coin_img;
@property (nonatomic, strong) BogoNetworkInitUrlModel *h5_url;
@property (nonatomic, strong) BogoNetworkInitUrlModel *vue_url;

@end

NS_ASSUME_NONNULL_END
