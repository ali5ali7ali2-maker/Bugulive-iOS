//
//  ChatFriendCell.m
//  BuguLive
//
//  Created by 朱庆彬 on 2017/8/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ChatFriendCell.h"
#import "JSBadgeView.h"
#import "M80AttributedLabel.h"

@implementation ChatFriendCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.mheadimg.layer.cornerRadius = 40 / 2;
    self.mheadimg.layer.borderWidth = 1;
    self.mheadimg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.mjsbadge.badgeAlignment = JSBadgeViewAlignmentCenter;
    self.mmsg.font = kAppSmallTextFont;
    self.mmsg.textColor = [UIColor colorWithHexString:@"777777"];
    self.mmsg.backgroundColor = kClearColor;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 63.5, kScreenW-20, 0.5)];
    lineView.backgroundColor = kClearColor;
    [self addSubview:lineView];
    
    
    self.mlevel.hidden =  YES;
    self.viconImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setUnReadCount:(int)count
{
    if (count)
        self.mjsbadge.badgeText = [NSString stringWithFormat:@"%d", count];
    else
        self.mjsbadge.badgeText = nil;
}

@end
