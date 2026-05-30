//
//  BogoNoblePayModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/25.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BogoNoblePayListModel;

NS_ASSUME_NONNULL_BEGIN

@interface BogoNoblePayModel : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *img;
@property(nonatomic, strong) NSArray<BogoNoblePayListModel *> *list;
@property(nonatomic, strong) NSString *status;

@end

@interface BogoNoblePayListModel : NSObject

@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *money;
@property(nonatomic, strong) NSString *day;
@property(nonatomic, strong) NSString *hot;
@property(nonatomic, strong) NSString *addtime;
@property(nonatomic, strong) NSString *nobleid;
@property(nonatomic, strong) NSString *sort;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *integral;
@property(nonatomic, strong) NSString *unit;

@property(nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
