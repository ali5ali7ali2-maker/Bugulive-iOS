//
//  BogoVideoShopAddViewController.h
//  AFNetworking
//
//  Created by 宋晨光 on 2021/8/23.
//

//#import "BogoShopKit.h"




//#import <FDUIKitObjC/FDTableViewController.h>
#import "FDUIKitObjC.h"

@class BogoCommodityDetailModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^changeCartCallBack)(NSInteger badge);
typedef void(^selectVideoGoodCallBack)(BogoCommodityDetailModel *model);

@interface BogoVideoShopAddViewController : FDTableViewController

@property(nonatomic, assign) NSInteger vcType;

@property(nonatomic, assign) BOOL isVideoSelect;

@property(nonatomic, copy) NSString *lid;
@property(nonatomic, copy) NSString *key;


//@property(nonatomic, copy) void (^addShopModelBlock)(BogoCommodityDetailModel *model);

-(instancetype)initGoodViewControllerWithType:(NSInteger)type;

- (void)setChangeCartCallBack:(changeCartCallBack)changeCartCallBack;
- (void)setSelectVideoGoodCallBack:(selectVideoGoodCallBack)selectVideoGoodCallBack;

-(void)requestData;

//[self requestData];

@end

NS_ASSUME_NONNULL_END
