//
//  MGLiveWishModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/5.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGLiveWishUserModel;

typedef enum : NSUInteger {
    MGWISHTYPE_ADD,//添加礼物和数量
    MGWISHTYPE_ADD_GIFT,//添加礼物
    MGWISHTYPE_LIST,//心愿单列表
    MGWISHTYPE_GENERATE,//生成心愿
} MGADD_WISH;


NS_ASSUME_NONNULL_BEGIN

@interface MGLiveWishModel : NSObject


//
@property(nonatomic, strong) NSString *g_id;//礼物id

//心愿单列表
@property(nonatomic, strong) NSString *g_name;
@property(nonatomic, strong) NSString *g_icon;
@property(nonatomic, strong) NSString *g_now_num;//现在已经贡献的礼物数量

//添加礼物和数量
@property(nonatomic, strong) NSString *g_num;//总共的礼物数量
@property(nonatomic, strong) NSString *txt;//描述
//礼物列表model
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *score;
@property(nonatomic, strong) NSString *diamonds;
@property(nonatomic, strong) NSString *icon;
@property(nonatomic, strong) NSString *ticket;
@property(nonatomic, strong) NSString *is_much;
@property(nonatomic, strong) NSString *sort;

@property(nonatomic, strong) NSArray *top_user;

@end


@interface MGLiveWishUserModel : NSObject

@property(nonatomic, strong) NSString *head_image;
@property(nonatomic, strong) NSString *nick_name;
@property(nonatomic, strong) NSString *gift_num;


@end

NS_ASSUME_NONNULL_END
