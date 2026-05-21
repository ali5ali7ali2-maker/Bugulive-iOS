//
//  BGConversationServiceController.h
//  BuguLive
//
//  Created by 朱庆彬 on 2017/8/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseChatController.h"

@class SFriendObj;

typedef void (^BackOrGoNextVCBlock)(int tag);

@interface BGConversationServiceController : BGBaseChatController

@property (copy, nonatomic) BackOrGoNextVCBlock backOrGoNextVCBlock;

@property (nonatomic, strong) SFriendObj *mChatFriend;

+ (BGConversationServiceController *)makeChatVCWith:(SFriendObj *)chattag;

+ (BGConversationServiceController *)makeChatVCWith:(SFriendObj *)chattag isHalf:(BOOL)mbhalf;

+ (BGConversationServiceController *)createIMMsgVCWithHalfWith:(SFriendObj *)friend_Obj form:(UIViewController *)full_VC isRelive:(BOOL)sender;

@end
