//
//  UserView.h
//  BuguLive
//
//  Created by 志刚杨 on 2023/1/3.
//  Copyright © 2023 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UserView;
@protocol UserViewDelegate <NSObject>
@optional
/**
 数据加载完成
 */
-(void)clickUserView:(UserView *)view;
//添加点击videoBtn或voiceBtn代理
-(void)clickVideoBtn:(UserView *)view;
-(void)clickVoiceBtn:(UserView *)view;

//点击关闭按钮
-(void)clickCloseBtn:(UserView *)view;
@end


@interface UserView : UIView
+(instancetype)getView;
-(void)frontView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property(nonatomic, assign) BOOL select;
@property(nonatomic, strong) NSString *uid;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *giftButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property(nonatomic, strong) id<UserViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIView *muteVideoView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property(nonatomic, assign) int totalVolume;
@property (weak, nonatomic) IBOutlet UIView *breathView;

@end
