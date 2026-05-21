//
//  BGTabBarCenterView.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/1/12.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "BGTabBarCenterView.h"
//#import "TXRTMPSDK/TXUGCRecord.h"

//#import <TXLiteAVSDK_UGC/TXUGCRecord.h>



@implementation BGTabBarCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.leftBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setImage:[UIImage imageNamed:@"dialog_start_live"] forState:UIControlStateNormal];
    [self.leftBtn setTitle:ASLocalizedString(@"立即查看")forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setImage:[UIImage imageNamed:@"dialog_take_photo"] forState:UIControlStateNormal];
    [self.rightBtn setTitle:ASLocalizedString(@"发布动态")forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftBtn.frame = CGRectMake(0, 20, kScreenW / 2, kScreenH / 2  - 20);
    self.rightBtn.frame = CGRectMake(kScreenW / 2, 20, kScreenW / 2, kScreenH / 2  - 20);
    
}

-(void)btnClick:(UIButton *)sender{
    
    
}

@end
