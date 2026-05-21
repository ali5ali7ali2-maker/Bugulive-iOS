//
//  VideoFrame.m
//  UniversalApp
//
//  Created by bugu on 2019/2/12.
//  Copyright © 2019年 voidcat. All rights reserved.
//

#import "VideoFrame.h"

@implementation VideoFrame

- (instancetype)init
{
    self =[super init];
    
    return self;
}

- (UIImageView *)video_coverImg
{
    if (!_video_coverImg)
    {
        __weak typeof(self)weakself =self;
        _video_coverImg =[[UIImageView alloc]init];
        _video_coverImg.contentMode = UIViewContentModeScaleAspectFill;
        _video_coverImg.layer.masksToBounds = YES;
        _video_coverImg.layer.cornerRadius = 4;
        [self addSubview:_video_coverImg];
        [_video_coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.centerY.width.height.equalTo(weakself);
            make.left.top.mas_equalTo(0);
            make.width.height.equalTo(weakself);
        }];
        UIView *mengbanView =[[UIView alloc]init];
        mengbanView.hidden = YES;
        [self addSubview:mengbanView];
        [mengbanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.width.height.equalTo(weakself);
        }];
        mengbanView.backgroundColor = kClearColor;
//        kBlackColor;
        mengbanView.alpha =0.46;
        _actionBtn =[[UIButton alloc]init];
        [self addSubview:_actionBtn];
        [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(weakself);
            make.width.height.equalTo(@50);
        }];
        _actionBtn.userInteractionEnabled = NO;
        [_actionBtn setImage:[UIImage imageNamed:@"aio_record_play_nor"] forState:0];
    }
    return _video_coverImg;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
