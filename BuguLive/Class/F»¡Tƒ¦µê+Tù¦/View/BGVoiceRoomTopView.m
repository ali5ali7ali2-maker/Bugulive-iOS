//
//  BGVoiceRoomTopView.m
//  BuguLive
//
//  Created by 志刚杨 on 2022/4/18.
//  Copyright © 2022 xfg. All rights reserved.
//

#import "BGVoiceRoomTopView.h"

@interface BGVoiceRoomTopView ()

@end

@implementation BGVoiceRoomTopView

#pragma mark - LifeCycle
- (void)dealloc {
    [self removeNotificationObserver];
}

- (void)awakeFromNib {
    [super awakeFromNib];
     //设置view
     [self setupView];
    
     //请求数据
     [self requestData];
     
     //设置通知
     [self addNotificationObserver];
    
    
    [self.btnAnnouncement setTitle:[NSString stringWithFormat:ASLocalizedString(@"%@ 在线"),@"0"] forState:UIControlStateNormal];


    [self.btnAnnouncement setFont:[UIFont systemFontOfSize:11]];
    [self.btnAnnouncement  setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.btnAnnouncement.layer.cornerRadius = 13;
    self.btnAnnouncement.clipsToBounds = YES;
    self.btnAnnouncement .layer.cornerRadius = 13;
    self.btnAnnouncement .clipsToBounds = YES;
    self.btnAnnouncement .backgroundColor = [kWhiteColor colorWithAlphaComponent:0.15];

    
}

#pragma mark - View
- (void)setupView {
    ViewRadius(self.leftView, self.leftView.height/2);
    ViewRadius(self.headImage, self.headImage.height/2);
    
}

#pragma mark - Network
- (void)requestData {
    
}

- (IBAction)clickSwitch:(id)sender {
    
}

- (IBAction)btnClick:(id)sender {
    BGVoiceRoomTopViewClickType type = BGVoiceRoomTopViewClickTypeAnnouncement;
    if(sender == self.btnShare)
    {
        type = BGVoiceRoomTopViewClickTypeShare;
    }
    else if(sender == self.btnClose)
    {
        type = BGVoiceRoomTopViewClickTypeClose;
    }
    else if(sender == self.switchBtn)
    {
        type = BGVoiceRoomTopViewClickTypeSwitch;
    }
    
    if(self.btnClickBlok)
    {
        self.btnClickBlok(type);
    }
    
}

-(void)setLiveInfo:(CurrentLiveInfo *)liveInfo
{
    _liveInfo = liveInfo;
    if([_liveInfo.user_id isEqualToString:[IMAPlatform sharedInstance].host.userId])
    {
        self.switchBtn.hidden = NO;
        self.switchWidth.constant = 17;
    }
    else
    {
        self.switchBtn.hidden = YES;
        self.switchWidth.constant = 0;
    }
    self.roomTitle.text = liveInfo.video_title;
    self.roomID.text = [NSString stringWithFormat:@"ID:%@",liveInfo.room_id];
    if(liveInfo.luck_num.intValue > 0)
    {
        self.roomID.text = [NSString stringWithFormat:@"ID:%@",liveInfo.luck_num];
    }
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:liveInfo.podcast.user.head_image]];
}

#pragma mark- Delegate
#pragma mark UITableDatasource & UITableviewDelegate


#pragma mark - Private


#pragma mark - Event


#pragma mark - Public


#pragma mark - NSNotificationCenter
- (void)addNotificationObserver {
    
}

- (void)removeNotificationObserver {
    
}

#pragma mark - Setter


#pragma mark - Getter


@end
