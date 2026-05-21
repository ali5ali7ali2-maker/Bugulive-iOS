//
//  BGNoContentView.m
//  BuguLive
//
//  Created by xfg on 2017/8/29.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGNoContentView.h"

@implementation BGNoContentView

+ (instancetype)noContentWithFrame:(CGRect)frame
{
    BGNoContentView *tmpView = [[[NSBundle mainBundle] loadNibNamed:@"BGNoContentView" owner:self options:nil] lastObject];
    tmpView.userInteractionEnabled = NO;
    tmpView.frame = frame;
    return tmpView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self creatMyUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    for (UIView *subView in self.subviews) {
        [subView setLocalizedString];
    }
}

- (void)creatMyUI
{
    for (UIView *subView in self.subviews) {
        [subView setLocalizedString];
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    imageView.image = [UIImage imageNamed:@"com_no_content"];
    [self addSubview:imageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), 150, 25)];
    label.text = ASLocalizedString(@"暂无数据");
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = kLightGrayColor;
    [self addSubview:label];
    
}

@end
