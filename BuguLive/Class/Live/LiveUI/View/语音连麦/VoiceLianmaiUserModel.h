//
//  VoiceLianmaiUserModel.h
//  BuguLive
//
//  Created by 志刚杨 on 2022/10/13.
//  Copyright © 2022 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceLianmaiUserModel : NSObject
@property(nonatomic, strong) NSString *head_image;
@property(nonatomic, assign) int is_open_wheat;
@property(nonatomic, strong) NSString *nick_name;
@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *coin;
@end

NS_ASSUME_NONNULL_END
