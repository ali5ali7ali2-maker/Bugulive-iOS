//
//  CarAnimationPlayer.m
//  FanweApp
//
//  Created by 志刚杨 on 2017/12/20.
//  Copyright © 2017年 voidcat. All rights reserved.
//

#import "CarAnimationPlayer.h"

@interface CarAnimationPlayer()<SVGAPlayerDelegate>

@end

static SVGAParser *parser;

@implementation CarAnimationPlayer
{
    NSURL *svgUrl;
    UIImageView *rankImgView;
    UILabel *userNameLabel;
    UILabel *contentlab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.aPlayer];
        self.aPlayer.delegate = self;
        self.aPlayer.frame = self.bounds;
        self.aPlayer.height -= 80;
        self.aPlayer.y += 80;
        self.aPlayer.loops = 1;
        self.aPlayer.contentMode =  UIViewContentModeScaleAspectFit;
        self.aPlayer.clearsAfterStop = YES;
        
//        self.aPlayer.backgroundColor = kRedColor;
        parser = [[SVGAParser alloc] init];
        
        _titleView = [[UIImageView alloc]init];
        _titleView.left = kScreenW + kRealValue(120);
        _titleView.top = kStatusBarHeight + 180;
        UIImage *image = [UIImage imageNamed:@"car_img_tip_bg"];
//        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0, 25) resizingMode:UIImageResizingModeStretch];
        [_titleView setImage:image];
        _titleView.size = image.size;
//        _titleView.contentMode = UIViewContentModeScal;
        [self addSubview:_titleView];
        rankImgView = [[UIImageView alloc] init];
        rankImgView.layer.cornerRadius = 24;
        rankImgView.clipsToBounds = YES;
        contentlab = [[UILabel alloc] init];
        userNameLabel = [[UILabel alloc] init];
        userNameLabel.textColor = RGB(246, 219, 154);
        userNameLabel.font = [UIFont systemFontOfSize:13];
        contentlab.font = [UIFont systemFontOfSize:13];
        contentlab.textColor = kWhiteColor;
//        contentlab.textColor = KHighlight;
        [_titleView addSubview:rankImgView];
        [_titleView addSubview:userNameLabel];
        [_titleView addSubview:contentlab];
        
        
        
        [self setUpLayout];
        
        
    }
    return self;
}

-(void)setUpLayout
{
    
    [rankImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleView);
        make.left.equalTo(_titleView).offset(2);
        make.width.equalTo(@48);
        make.height.equalTo(@48);
    }];
    
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(_titleView).offset(5);
        make.left.equalTo(rankImgView.mas_right).offset(5);
        make.height.equalTo(@13);
    }];
//    rankImgView.frame = CGRectMake(0, 120+kStatusBarHeight, 28, 13);
//    userNameLabel.frame = CGRectMake(rankImgView.right + 5, 120+kStatusBarHeight, [userNameLabel.text textSizeIn:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:15]].width, 15);
//    contentlab.frame = CGRectMake(userNameLabel.right + 5, 120+kStatusBarHeight, [contentlab.text textSizeIn:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:15]].width, 15);
    
    [contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_titleView).offset(-5);
        make.left.equalTo(rankImgView.mas_right).offset(5);
        make.height.equalTo(@13);
    }];
}

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player;
{
    if([self.delegate respondsToSelector:@selector(CarAnimationHiddenPlayerDelegate)])
    {
        [self.delegate CarAnimationHiddenPlayerDelegate];
    }
}
-(void)setContent:(UserModel *)userModel
{
    
    [rankImgView sd_setImageWithURL:[NSURL URLWithString:userModel.head_image] placeholderImage:kDefaultPreloadHeadImg];
    userNameLabel.text = userModel.nick_name;
    contentlab.text = [NSString stringWithFormat:ASLocalizedString(@"乘坐【%@】驾到"),userModel.noble_car_name];
    
    svgUrl = [NSURL URLWithString:userModel.noble_car_url];
    [parser parseWithURL:svgUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        self.aPlayer.videoItem = videoItem;
        [self.aPlayer startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        [[BGHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:ASLocalizedString(@"座驾播放错误%@"),error]];
    }];
    
    [UIView animateWithDuration:1 animations:^{
        CGRect frame = _titleView.frame;
        frame.origin.x= ( kScreenW - _titleView.width )/ 2;
        _titleView.frame = frame;
    }];
}
- (SVGAPlayer *)aPlayer {
    if (_aPlayer == nil) {
        _aPlayer = [[SVGAPlayer alloc] init];
    }
    return _aPlayer;
}

@end
