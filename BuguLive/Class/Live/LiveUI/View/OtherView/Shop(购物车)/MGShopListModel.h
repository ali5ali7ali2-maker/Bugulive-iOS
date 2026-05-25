//
//  MGShopListModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/7/17.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGShopListModel : NSObject

@property(nonatomic, strong) NSString *shop_price;
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *create_time;
@property(nonatomic, strong) NSString *shop_name;
@property(nonatomic, strong) NSString *shop_logo;
@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *shop_url;

@end

NS_ASSUME_NONNULL_END
