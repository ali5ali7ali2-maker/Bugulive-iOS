//
//  BogoNobleListModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BogoNobleUserInfoModel;
@class BogoNobleListTypeModel;
@class BogoNobleListSubTypeModel;
@class BogoNobleRechargeModel;


NS_ASSUME_NONNULL_BEGIN

@interface BogoNobleListModel : NSObject

@property(nonatomic, strong) BogoNobleUserInfoModel *user_info;


@property (nonatomic, strong) NSArray<BogoNobleListTypeModel *> *list;
@property(nonatomic, copy) NSString *status;

@end

@interface BogoNobleRechargeModel : NSObject

@property(nonatomic, strong) NSString *id;
@property(nonatomic, copy) NSString *money;
@property(nonatomic, copy) NSString *day;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, copy) NSString *hot;
@property(nonatomic, copy) NSString *addtime;
@property(nonatomic, copy) NSString *nobleid;
@property(nonatomic, copy) NSString *sort;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *integral;
@property(nonatomic, copy) NSString *unit;

@end

@interface BogoNobleUserInfoModel : NSObject

@property(nonatomic, strong) NSString *id;
@property(nonatomic, copy) NSString *noble_time;
@property(nonatomic, copy) NSString *nobleid;

@end

@interface BogoNobleListTypeModel : NSObject

@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *icon;//贵族图标
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *sort;
@property(nonatomic, strong) NSString *addtime;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *title_img;
@property(nonatomic, strong) NSString *shop_icon;
@property(nonatomic, strong) NSString *star_box;

@property(nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) NSArray<BogoNobleListSubTypeModel *> *noble_type;
@property(nonatomic, strong) BogoNobleRechargeModel *noble_recharge;

@end

@interface BogoNobleListSubTypeModel : NSObject

@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *instructions;
@property(nonatomic, strong) NSString *instructions_img;
@property(nonatomic, strong) NSString *noble_stealth;
@property(nonatomic, strong) NSString *icon;
@property(nonatomic, strong) NSString *noicon;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *sort;
@property(nonatomic, strong) NSString *addtime;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *carid;
@property(nonatomic, strong) NSString *experience;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *is_type;


@end


NS_ASSUME_NONNULL_END
