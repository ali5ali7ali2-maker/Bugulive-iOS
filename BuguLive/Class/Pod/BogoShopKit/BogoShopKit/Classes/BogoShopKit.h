//
//  BogoShopKit.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

//#ifndef BogoShopKit_h
//#define BogoShopKit_h

typedef NS_ENUM(NSInteger, BogoOrderManageViewControllerType) {
    BogoOrderManageViewControllerTypeShop = 1,
    BogoOrderManageViewControllerTypeUser = 2
};

//22:全部，0:待付款, 1:待发货,2:待收货,3:待评价,11 退款/货
typedef NS_ENUM(NSInteger, BogoOrderManageListViewControllerType) {
    //用户
    BogoOrderManageListViewControllerTypeAll = 22,
    BogoOrderManageListViewControllerTypeWaitPurchase = 0,
    BogoOrderManageListViewControllerTypeWaitTransfer = 1,
    BogoOrderManageListViewControllerTypeTransfered = 2,
    BogoOrderManageListViewControllerTypeWaitEvaluate = 3,
    BogoOrderManageListViewControllerTypeRefund = 11,
    //商家
    BogoOrderManageListViewControllerTypeFinished = 5
};

typedef NS_ENUM(NSInteger, BogoCommodityManagementViewControllerType) {
    BogoCommodityManagementViewControllerTypeAll = 0,
    BogoCommodityManagementViewControllerTypeAuthSuccess = 1,
    BogoCommodityManagementViewControllerTypeOnSale = 11,
    BogoCommodityManagementViewControllerTypeOffSale = 22,
    BogoCommodityManagementViewControllerTypeEmpty = 44,
    BogoCommodityManagementViewControllerTypeAuthFailed = 2,
};

typedef NS_ENUM(NSInteger, BogoShopBuySource) {
    BogoShopBuySourceLive,
    BogoShopBuySourceVideo,
    BogoShopBuySourceShop,
};

typedef NS_ENUM(NSInteger, BogoOrderDetailViewControllerType) {
    BogoOrderDetailViewControllerTypeWaitTransfer = 1,
    BogoOrderDetailViewControllerTypeTransfered = 2,
    BogoOrderDetailViewControllerTypeWaitRefund = 3,
    BogoOrderDetailViewControllerTypeRefund = 11
};

#import "BogoMineShopViewController.h"
#import "BogoShopAgreementViewController.h"
#import "BogoShopInfoViewController.h"
#import "BogoCartViewController.h"
#import "BogoClassicsViewController.h"
#import "BogoGoodDetailViewController.h"
#import "BogoOrderManageViewController.h"
#import "BogoCommodityManagementViewController.h"
#import "BogoCommodityDetailModel.h"
#import "BogoShopInfoModel.h"
#import "BogoShopInfoFillViewController.h"
#import "BogoPayTypeModel.h"
#import "BogoImagePickerViewController.h"
#import "BogoCategoryViewController.h"

#import "BogoShopDetailGoodCell.h"
#import "BogoAlertView.h"
#import "BogoGoodSharePopView.h"

#import "FDUIKitObjC.h"
#import "BogoCommodityManagementSearchBar.h"

#import "BogoOtherShopDetailViewController.h"

#import "BogoShopViewController.h"
#import "BogoLiveGoodThingsViewController.h"
#import "BogoTopSalesViewController.h"

#import "BogoLiveCartPopView.h"
#import "BogoLiveGoodAddViewController.h"
#import "BogoShopExplainView.h"

#import "BogoWithDrawViewController.h"
#import "BogoShopDataViewController.h"

#import "BogoVideoGoodControl.h"
#import "BogoShopVideoGoodEditViewController.h"

#import "UIButton+Badge.h"

//#define kShopKitBundle [BogoShopKit getBundleWithFName:@"BogoShopKit" bName:@"BogoShopKit"]

#define kShopKitBundle [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"BogoShopKit")] pathForResource:@"BogoShopKit" ofType:@"bundle"]]

#define imageNamed(name) [UIImage imageNamed:name inBundle:kShopKitBundle compatibleWithTraitCollection:nil]

//#define imageNamed(name) [BogoShopKit getImageWithName:name type:@"png"]

#define GoToLiveFromShopKit @"GoToLiveFromShopKit"
#define GoToUserPageFromShopKit @"GoToUserPageFromShopKit"
#define GoToUserMsgVCShopKit @"GoToUserMsgVCShopKit"

@interface BogoShopKit : NSObject

+(NSBundle *)getBundleWithFName:(NSString *)fName bName:(NSString *)bName;

+ (UIImage *)getImageWithName:(NSString *)name type:(NSString *)type;

@end

//#endif /* BogoShopKit_h */
