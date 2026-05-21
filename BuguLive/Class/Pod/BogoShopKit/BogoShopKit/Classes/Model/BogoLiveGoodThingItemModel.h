//
//  BogoLiveGoodThingItemModel.h
//
//
//  Created by JSONConverter on 2021/07/15.
//  Copyright © 2021年 JSONConverter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BogoLiveGoodThingItemModelGoods;

@interface BogoLiveGoodThingItemModel: NSObject
@property (nonatomic, strong) NSArray<BogoLiveGoodThingItemModelGoods *> *goods;
@property (nonatomic, copy) NSString *head_image;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger max_watch_number;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, assign) NSInteger room_type;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) NSInteger group_id;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) NSInteger live_in;

@end

@interface BogoLiveGoodThingItemModelGoods: NSObject
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger original_price;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, copy) NSString *model_id;
@property (nonatomic, copy) NSString *link_url;
@end
