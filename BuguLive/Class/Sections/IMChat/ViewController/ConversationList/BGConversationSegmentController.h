//
//  BGConversationSegmentController.h
//  BuguLive
//
//  Created by 朱庆彬 on 2017/8/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBadgeView.h"
@class SFriendObj;

typedef void (^GoNextVCBlock)(int tag, SFriendObj *friend_Obj);

@interface BGConversationSegmentController : BGBaseViewController

@property (nonatomic, assign) BOOL mbhalf; //只有一半的情况

@property (nonatomic, strong) JSBadgeView *badgeTrade;
@property (nonatomic, retain) JSBadgeView *badgeFriend;
@property (nonatomic, strong) JSBadgeView *badgeStranger;
@property (copy, nonatomic) GoNextVCBlock goNextVCBlock;

+ (void)showIMChatInVCWithHalf:(UIViewController *)vc inView:(UIView *)inView;

+ (BGConversationSegmentController *)createIMChatVCWithHalf:(UIViewController *)full_VC isRelive:(BOOL)sender;

- (void)goNextVCBlock:(int)tag:(SFriendObj *)friend_Obj;

- (void)loadBtnBadageData;

@end
