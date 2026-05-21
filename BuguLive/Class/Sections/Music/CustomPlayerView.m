//
//  CustomPlayerView.m
//  BuguLive
//
//  Created by voidcat on 2024/5/23.
//  Copyright © 2024 xfg. All rights reserved.
//

#import "CustomPlayerView.h"

@implementation CustomPlayerView

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setupViews];
        [self setupConstraints];
        [self setupRoundedCorners];
        [self setupShadow];
    }

    return self;
}

- (void)setupRoundedCorners {
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
//                                                    byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
//                                                          cornerRadii:CGSizeMake(20.0, 20.0)];
//                                                          
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.layer.mask = maskLayer;
}

- (void)setupShadow {
//    CALayer *subLayer = [CALayer layer];
//    CGRect fixframe = CGRectMake(0, 0, SCREEN_WIDTH, 74);
//    subLayer.frame= fixframe;
//    subLayer.cornerRadius=10;
//    subLayer.backgroundColor=[UIColor whiteColor].CGColor;
//    subLayer.masksToBounds=NO;
//    subLayer.shadowColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
//    subLayer.shadowOffset = CGSizeMake(0,-1);;//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
////    subLayer.shadowOpacity = 0.8;//阴影透明度，默认0
//    subLayer.shadowRadius = 4;//阴影半径，默认3
//    [self.layer insertSublayer:subLayer atIndex:0];
    
    self.layer.shadowOffset = CGSizeMake(0,-1);
//    subLayer.cornerRadius=10;
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 4;
    self.layer.shadowColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    self.layer.cornerRadius = 10;

}

- (void)setupViews {
    self.backgroundColor = kWhiteColor;
    self.songTitleLabel = [[UILabel alloc] init];
    self.songTitleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    self.songTitleLabel.font = [UIFont systemFontOfSize:16];
    self.songTitleLabel.text = ASLocalizedString(@"未播放");
    [self addSubview:self.songTitleLabel];

    self.songSlider = [[UISlider alloc] init];
    [self addSubview:self.songSlider];
    //滑动条禁止拖动
    self.songSlider.enabled = NO;
    UIImage *img = [UIImage imageNamed:@"圆圈"];

    [self.songSlider setThumbImage: img forState:UIControlStateNormal];
    [self.songSlider setThumbImage: img  forState:UIControlStateHighlighted];


    
    self.songTimeLabel = [[UILabel alloc] init];
    self.songTimeLabel.text = @"00:00";
    self.songTimeLabel.font = [UIFont systemFontOfSize:12];
    self.songTimeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:self.songTimeLabel];

    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playPauseButton setImage:[UIImage imageNamed:@"未播"] forState:UIControlStateNormal];
    [self.playPauseButton setImage:[UIImage imageNamed:@"播放大"] forState:UIControlStateSelected];
    [self.playPauseButton addTarget:self action:@selector(handlePlayEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
    [self addSubview:self.playPauseButton];
}
- (void)handlePlayEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected)
    {
        if(self.play)
        {
            self.play(self.chosemusic);
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopMusic" object:nil];

    }
}
- (void)setupConstraints {
    [self.songTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.left.equalTo(self).offset(20);
    }];

    [self.songSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-65);
        make.top.equalTo(self.songTitleLabel.mas_bottom).offset(7.5);
    }];

    [self.songTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.songSlider.mas_bottom).offset(6.5);
    }];
    
    [self.playPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.songSlider.mas_right).offset(20);
        make.width.and.height.equalTo(@25);
        make.centerY.equalTo(self.songSlider.mas_centerY);
    }];
}
@end
