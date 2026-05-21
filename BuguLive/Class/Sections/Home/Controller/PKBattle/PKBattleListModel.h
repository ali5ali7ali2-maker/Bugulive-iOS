//
//  PKBattleListModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/1.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKBattleListModel : NSObject

@property(nonatomic, strong) NSString *emcee_user_id1;
@property(nonatomic, strong) NSString *emcee_user_id2;
@property(nonatomic, strong) NSString *group_id1;
@property(nonatomic, strong) NSString *group_id2;
@property(nonatomic, strong) NSString *play_url1;
@property(nonatomic, strong) NSString *play_url2;
@property(nonatomic, strong) NSString *create_time;
@property(nonatomic, assign) NSString *pk_ticket1;
@property(nonatomic, strong) NSString *pk_ticket2;
@property(nonatomic, strong) NSString *time;
@property(nonatomic, strong) NSString *room_id1;
@property(nonatomic, strong) NSString *room_id2;
@property(nonatomic, strong) NSString *channelid1;
@property(nonatomic, strong) NSString *channelid2;
@property(nonatomic, strong) NSString *name1;
@property(nonatomic, strong) NSString *name2;
@property(nonatomic, strong) NSString *head_image1;
@property(nonatomic, strong) NSString *head_image2;
@property(nonatomic, strong) NSString *emcee_play_url1;
@property(nonatomic, strong) NSString *emcee_play_url2;
@property(nonatomic, strong) NSString *has_focus1;
@property(nonatomic, strong) NSString *has_focus2;
@property(nonatomic, strong) NSString *pk_time;
@property(nonatomic, strong) NSString *win_user_id;
@property(nonatomic, strong) NSString *pk_status;

@property(nonatomic, strong) NSString *city1;
@property(nonatomic, strong) NSString *city2;

@property(nonatomic, strong) NSString *live_image1;
@property(nonatomic, strong) NSString *live_image2;

@end

NS_ASSUME_NONNULL_END
