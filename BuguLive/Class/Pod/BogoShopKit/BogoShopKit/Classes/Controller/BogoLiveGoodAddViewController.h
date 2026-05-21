//
//  BogoLiveGoodAddViewController.h
//  BuGuDY
//
//  Created by bogokj on 2020/3/27.
//  Copyright © 2020 宋晨光. All rights reserved.
//

#import "FDTableViewController.h"
@class BogoCommodityDetailModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^changeCartCallBack)(NSInteger badge);
typedef void(^selectVideoGoodCallBack)(BogoCommodityDetailModel *model);

typedef NS_ENUM(NSInteger, BogoLiveGoodAddViewControllerType) {
    BogoLiveGoodAddViewControllerTypeLive,
    BogoLiveGoodAddViewControllerTypeVideo,
};

@interface BogoLiveGoodAddViewController : FDTableViewController

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
