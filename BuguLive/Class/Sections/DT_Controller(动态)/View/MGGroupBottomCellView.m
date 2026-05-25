//
//  MGGroupBottomCellView.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/4/23.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "MGGroupBottomCellView.h"

@implementation MGGroupBottomCellView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView
{
    NSArray *imgArr = @[@"mg_dy_comment",@"mg_dy_likes",@""];
    NSArray *titleArr = @[@"0",@"0",ASLocalizedString(@"转发")];
    for (int i = 0; i < 3; i ++) {
        QMUIButton *but = [QMUIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(50 * i, 0, 50, 30);
        but.tag = 10 + i;
        but.spacingBetweenImageAndTitle = 5;
        but.backgroundColor = [UIColor colorWithHexString:@"4b5255"];
        but.titleLabel.font = [UIFont systemFontOfSize:13];
        [but setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [but setTitle:titleArr[i] forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        but.imagePosition = QMUIButtonImagePositionLeft;
        [self addSubview:but];
        
        if (i == 0) {
            self.btnComment = but;
        }else if (i == 1){
            self.btnLike = but;
            
        }
        
    }
}

-(void)clickBtn:(UIButton *)sender{
    NSInteger tag = sender.tag;
    if (tag == 10) {
        if([self.delegate respondsToSelector:@selector(onComment)])
        {
            [self.delegate onComment];
        }
    }else if (tag == 11){
        if([self.delegate respondsToSelector:@selector(onLike)])
        {
            [self.delegate onLike];
        }
    }else if (tag == 12){
        if([self.delegate respondsToSelector:@selector(onShare)])
        {
            [self.delegate onShare];
        }
    }
}

-(void)resetBottomViewWithComment:(NSString *)comment likes:(NSString *)likes
{
//    QMUIButton *commentBtn = [self viewWithTag:10];
//    QMUIButton *likeBtn    = [self viewWithTag:11];
//
    [self.btnLike setTitle:likes forState:UIControlStateNormal];
    [self.btnComment setTitle:comment forState:UIControlStateNormal];
}

@end
