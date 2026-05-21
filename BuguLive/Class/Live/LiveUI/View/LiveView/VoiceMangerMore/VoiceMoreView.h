//
//  VoiceMoreView.h
//  BuguLive
//
//  Created by voidcat on 2024/5/25.
//  Copyright © 2024 xfg. All rights reserved.
//

#import "BaseXibView.h"

@interface VoiceMoreView : BaseXibView
@property (weak, nonatomic) IBOutlet UIView *gameViewContent;
@property (weak, nonatomic) IBOutlet QMUIButton *redPackButton;
@property (weak, nonatomic) IBOutlet QMUIButton *wishListButton;
@property (weak, nonatomic) IBOutlet QMUIButton *managementButton;
@property(nonatomic, assign) int user_role;
@property(nonatomic, strong) NSString *liveId;
//点击了心愿单block
@property(nonatomic, copy) void(^clickWishListBlock)(void);

//点击房间管理
@property(nonatomic, copy) void(^clickManagementBlock)(void);

@end
