//
//  BogoNewsHeadView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/13.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoNewsHeadView.h"

@implementation BogoNewsHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setUpView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - kRealValue(4), kScreenW, kRealValue(kRealValue(4)))];
        line.backgroundColor = kClearColor;
        
        [self addSubview:line];
    }
    return self;
}

-(void)clickBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickHeadControl:)]) {
        [self.delegate clickHeadControl:sender.tag - 100];
    }
}

- (void)setModel:(BogoNewsTabNumModel *)model{
    QMUIButton *likeBtn = [self viewWithTag:100];
    QMUIButton *replyBtn = [self viewWithTag:100 + 1];
    likeBtn.shouldHideBadgeAtZero = YES;
    likeBtn.badgeValue = [NSString stringWithFormat:@"%ld",model.bzone_like];
    likeBtn.badgeOriginX = likeBtn.width / 2 + 10;
    likeBtn.badgeOriginY = likeBtn.top + 10;
    replyBtn.shouldHideBadgeAtZero = YES;
    replyBtn.badgeValue = [NSString stringWithFormat:@"%ld",model.bzone_reply];
    replyBtn.badgeOriginX = replyBtn.width / 2 + 10;
    replyBtn.badgeOriginY = replyBtn.top + 10;
}

-(void)setUpView{
    NSArray *listArr = @[ASLocalizedString(@"点赞"),ASLocalizedString(@"评论"),ASLocalizedString(@"粉丝"),ASLocalizedString(@"关注")];
    NSArray *imgArr = @[@"bogo_news_top_likes",@"bogo_news_top_comment",@"bogo_news_top_fans",@"bogo_news_top_concert"];
    CGFloat viewWidth = kScreenW / 4;
    for (int i = 0; i < 4; i ++) {
        QMUIButton *btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(viewWidth * i, 0, viewWidth, viewWidth);
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [btn setTitle:listArr[i] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.imagePosition = QMUIButtonImagePositionTop;
        btn.spacingBetweenImageAndTitle = 5;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//        btn.backgroundColor = ;
        [self addSubview:btn];
    }
}

@end
