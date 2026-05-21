//
//  BogoRoomUIViewController.h
//  BuguLive
//
//  Created by 志刚杨 on 2022/4/7.
//  Copyright © 2022 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomModel.h"
#import "BGVoiceRoomTopView.h"
#import "RoomMicUserListView.h"
#import "RoomLiveMicView.h"
@protocol BogoRoomUIViewControllerDelegate <NSObject>
@optional
-(void)needOpenRTCAudio:(BOOL)audio;

-(void)clickUser:(UserModel *)model;

- (void)micView:(RoomLiveMicView *)micView didClickAnnouncementBtn:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_BEGIN

@interface BogoRoomUIViewController : UIViewController
@property(nonatomic, strong)    RoomModel *model;
@property(nonatomic, strong) CurrentLiveInfo *live_info;
@property(nonatomic, strong) BGVoiceRoomTopView *roomTopView;
@property(nonatomic, weak) id<BogoRoomUIViewControllerDelegate> delegate;
@property(nonatomic, strong) RoomMicUserListView *userListView;
@property(nonatomic, weak) UIView *supperView;
@property(nonatomic, strong) RoomLiveMicView *micView;
- (void)micView:(RoomLiveMicView *)micView didClickNumberBtn:(UIButton *)sender;
- (void)showMicView;
@end

NS_ASSUME_NONNULL_END
