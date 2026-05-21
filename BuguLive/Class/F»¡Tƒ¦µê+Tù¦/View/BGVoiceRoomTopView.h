//
//  BGVoiceRoomTopView.h
//  BuguLive
//
//  Created by 志刚杨 on 2022/4/18.
//  Copyright © 2022 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseXibView.h"


typedef NS_ENUM(NSUInteger, BGVoiceRoomTopViewClickType) {
    BGVoiceRoomTopViewClickTypeAnnouncement = 0,
    BGVoiceRoomTopViewClickTypeShare,
    BGVoiceRoomTopViewClickTypeClose,
    BGVoiceRoomTopViewClickTypeSwitch
};

@interface BGVoiceRoomTopView : BaseXibView
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *roomTitle;
@property (weak, nonatomic) IBOutlet UILabel *roomID;
@property (weak, nonatomic) IBOutlet UIButton *btnAnnouncement;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property(nonatomic, strong) CurrentLiveInfo *liveInfo;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchWidth;

@property(nonatomic, copy) void (^btnClickBlok)(BGVoiceRoomTopViewClickType type);
@end
