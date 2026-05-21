//
//  RedPacketView.m
//  UniversalApp
//
//  Created by voidcat on 2024/10/11.
//  Copyright © 2024 voidcat. All rights reserved.
//

#import "RedPacketView.h"
#import "BGRedPackModel.h"
#import "BGOpenRedPackView.h"
@implementation RedPacketView

- (instancetype)initWithAvatarImage:(NSString *)avatarImage nickname:(NSString *)nickname {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        //背景图
        UIImageView *bgImg = [[UIImageView alloc] init];
        bgImg.image = [UIImage imageNamed:@"红包2"];
        [self addSubview:bgImg];

        [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        // Avatar Image View
        self.avatarImageView = [[UIImageView alloc] init];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:SafeStr(avatarImage)]];
        self.avatarImageView.layer.cornerRadius = 16; // Assuming avatar size is 50x50
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.avatarImageView.layer.borderWidth = 2;
        [self addSubview:self.avatarImageView];
        
        // Nickname Label
        self.nicknameLabel = [[UILabel alloc] init];
        self.nicknameLabel.text = nickname;
        self.nicknameLabel.textColor = [UIColor colorWithHexString:@"#FFED8E"];
        self.nicknameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.nicknameLabel];
        
        // Message Label
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.text = @"Sent you a lucky bag";
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.messageLabel];
        
        // Open Button
        self.openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.openButton setTitle:@"Open" forState:UIControlStateNormal];
        self.openButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.openButton setTitleColor:[UIColor colorWithHexString:@"#FF3811"] forState:UIControlStateNormal];
        self.openButton.backgroundColor = [UIColor colorWithHexString:@"#FFD863"];
        self.openButton.layer.cornerRadius = 9.5;
        self.openButton.layer.masksToBounds = YES;
        [self.openButton addTarget:self action:@selector(openButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.openButton];
        
        // Layout
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        
        [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_top);
            make.left.equalTo(self.avatarImageView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.openButton.mas_left).offset(-10);
        }];
        
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nicknameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.nicknameLabel.mas_left);
            make.right.lessThanOrEqualTo(self.openButton.mas_left).offset(-10);
        }];
        
        [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.avatarImageView.mas_centerY);
            make.right.equalTo(self).offset(-30);
            make.size.mas_equalTo(CGSizeMake(44, 19));
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 需要延迟执行的代码
            [self dismiss];
        });
    }
    return self;
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view.mas_top).offset(70);
        make.width.mas_equalTo(view);
        make.height.mas_equalTo(50);
    }];
}

- (void)dismiss {
    [self removeFromSuperview];
}



- (void)openButtonTapped:(UIButton *)sender {
    [self dismiss];
    [self joinRoom];
    // Handle open button tap event
    NSLog(@"Open button tapped");
//    if (self.delegate && [self.delegate respondsToSelector:@selector(openButtonTapped)]) {
//        [self.delegate openButtonTapped];
//    }
}

- (UIViewController*)currentViewController{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (true) {
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        } else if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else {
            break;
        }
    }
    return vc;
}

- (void)joinRoom{
    
    BGRedPackModel *user = [BGRedPackModel new];
    user.head_image = self.customMessageModel.dicData[@"head_image"];
    
    user.nick_name = self.customMessageModel.dicData[@"nick_name"];
    user.id = self.customMessageModel.dicData[@"surprise_id"];

    BGOpenRedPackView *readView = [[BGOpenRedPackView alloc] init];
//    readView.video_id = self.video_id;
    readView.userModel = user;
    readView.frame = CGRectMake(40, 0, kScreenW-40*2, kScreenH-140*2);
    readView.userModel = user;
//    readView.backgroundColor = kRedColor;
    [readView show:[self currentViewController].view type:FDPopTypeCenter];
    
//    NSString *voice_id = [NSString stringWithFormat:@"%@",_dict[@"voice_id"]];
//    if(!StrValid(voice_id))
//    {
//        return;
//    }
//    if (!kAppDelegate.containerVC.roomVc) {
//        kAppDelegate.containerVC.roomVc = [[BogoRoomViewController alloc]init];
//        kAppDelegate.containerVC.roomVc.id = [NSString stringWithFormat:@"%@",voice_id];
//
//        kAppDelegate.containerVC.roomVc.id = voice_id;
//    }else{
//        if (![voice_id isEqualToString:kAppDelegate.containerVC.roomVc.model.voice.user_id]) {
//            [kAppDelegate.containerVC.roomVc leaveChannel];
//            kAppDelegate.containerVC.roomVc = [[BogoRoomViewController alloc]init];
//            kAppDelegate.containerVC.roomVc.id = [NSString stringWithFormat:@"%@",voice_id];
//        }
//    }
//    [kAppDelegate.containerVC controlAction:nil];
}


@end
