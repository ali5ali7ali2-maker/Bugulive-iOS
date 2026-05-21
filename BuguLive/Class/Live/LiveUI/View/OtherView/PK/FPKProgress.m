//
//  FPKProgress.m
//  FanweApp
//
//  Created by 志刚杨 on 2018/7/17.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "FPKProgress.h"

#define KPKRightOrLeftHeiht 20

#define KPKAudienceHeiht 36

@implementation FPKProgress
{
    UIView *pkRight;
    UIView *pkLeft;
    UILabel *valueLeft;
    UILabel *valueRight;
    //    UILabel *labTimer;//定时器
    //    NSTimer *timer;
    UIImageView *pkImage;
    //    UIImageView *pkDdate;
    //    UIButton *avatarImage;
//2020-1-3 修改pk进度
//    UIImageView *pkImageView;
    UIImageView *leftResultView;
    UIImageView *rightResultView;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = kGreenColor;
        [self createUI];
    }
    return self;
}

- (void)handleAvaTarEvent:(UIButton *)button {
    
}

- (void)setAvatar:(NSString *)avatar
{
        _avatar = avatar;
    //    [avatarImage sd_setImageWithURL:[NSURL URLWithString:self.avatar] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
}

-(void)createUI
{
    
    //    avatarImage = [[UIButton alloc] init];
    //    [avatarImage sd_setImageWithURL:[NSURL URLWithString:self.avatar] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
    //    [self addSubview:avatarImage];
    //    avatarImage.frame = CGRectMake(self.width - 80, 2, 30, 30);
    //    //    avatarImage.backgroundColor = kRedColor;
    //    avatarImage.layer.cornerRadius =  avatarImage.width/2;
    //    avatarImage.layer.masksToBounds = YES;
    //    [avatarImage addTarget:self action:@selector(handleAvaTarEvent:) forControlEvents:UIControlEventTouchUpInside];

    pkLeft = [[UIView alloc] init];
    pkLeft.backgroundColor =UIColorFromRGB(0x23B6F0);
    
    pkRight = [[UIView alloc] init];
    pkRight.backgroundColor =UIColorFromRGB(0xF5514D);
    
    pkLeft.backgroundColor = [UIColor colorWithHexString:@"#4FB5FA"];
    
    
    pkRight.backgroundColor = [UIColor colorWithHexString:@"#ED3B88"];
    
    pkLeft.frame = CGRectMake(0, 0, kScreenW / 2, KPKRightOrLeftHeiht);
    pkRight.frame = CGRectMake(0, 0, kScreenW, KPKRightOrLeftHeiht);
    
    self.pkAudienceView.frame = CGRectMake(0, KPKRightOrLeftHeiht, kScreenW, kRealValue(KPKAudienceHeiht));
    self.pkAudienceView.backgroundColor = kClearColor;
    
    [self addSubview:pkRight];
    [self addSubview:pkLeft];
    
    [self addSubview:self.pkAudienceView];
    
    //TODO:uiview 单边圆角或者单边框
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:pkRight.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(0,0)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = pkRight.bounds;
    maskLayer.path = maskPath.CGPath;
    pkRight.layer.mask = maskLayer;
    
    //TODO:uiview 单边圆角或者单边框
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:pkLeft.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(0,0)];//圆角大小
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = pkLeft.bounds;
    maskLayer1.path = maskPath1.CGPath;
    pkLeft.layer.mask = maskLayer1;
    
//    pkRight.y = self.height - pkRight.height;
//    pkLeft.y = self.height - pkLeft.height;
    
    //    self.layer.cornerRadius = self.height/2;
    self.layer.masksToBounds = YES;
    valueLeft = [[UILabel alloc] init];
    
    valueLeft.frame = CGRectMake(5, 0, 100, 20);
    valueLeft.textColor = [UIColor whiteColor];
    valueLeft.textAlignment = NSTextAlignmentLeft;
    valueLeft.font = [UIFont systemFontOfSize:14];
    [self addSubview:valueLeft];
    valueRight = [[UILabel alloc] init];
    valueRight.frame = CGRectMake(self.width - 100 - 5, 0, 100, 20);
    valueRight.textColor = [UIColor whiteColor];
    valueRight.textAlignment = NSTextAlignmentRight;
    valueRight.font = [UIFont systemFontOfSize:14];
    
    if(_leftIsMe == YES)
    {
        valueLeft.text = [NSString stringWithFormat:ASLocalizedString(@"我方：%f"),_rightValue];
        valueRight.text = [NSString stringWithFormat:ASLocalizedString(@"%f：对方"),_leftValue];
    }
    else
    {
        valueLeft.text = [NSString stringWithFormat:ASLocalizedString(@"对方：%f"),_rightValue];
        valueRight.text = [NSString stringWithFormat:ASLocalizedString(@"%f：我方"),_leftValue];
    }
    
    [self addSubview:valueRight];
    
    //    labTimer = [[UILabel alloc] init];
    //    labTimer.textColor = kWhiteColor;
    //    labTimer.text = @"";
    //    labTimer.font = [UIFont systemFontOfSize:12];
    //    //    _countDown = 60;
    //    FWWeakify(self)
    //    timer = [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
    //        FWStrongify(self)
    //        if(self->_countDown == 0)
    //        {
    //            [self->timer invalidate];
    //            self->timer = nil;
    //            self->labTimer.text = [NSString stringWithFormat:ASLocalizedString(@"结束")];
    //            //            ctl=pk&act=punishment_time
    //            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //            [dict setObject:@"pk" forKey:@"ctl"];
    //            [dict setObject:@"punishment_time" forKey:@"act"];
    //            [dict setObject:[IMAPlatform sharedInstance].host.imUserId forKey:@"user_id"];
    //            [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
    //                if ([responseJson toInt:@"status"] == 1) {
    //                    NSLog(@"%s\n%@",__func__,responseJson);
    //                }
    //            } FailureBlock:^(NSError *error) {
    //                //do nothing
    //            }];
    //        }
    //        else
    //        {
    //            self->_countDown--;
    //            self->labTimer.text = [NSString stringWithFormat:ASLocalizedString(@"%d秒"),_countDown];
    //        }
    //    } repeats:YES];
    
    
    [valueLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(self);
        //        valueLeft.frame = CGRectMake(5, 0, 100, 20);
    }];
    
    [valueRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-5));
        make.top.equalTo(self);
    }];
    

    
    pkImage = [[UIImageView alloc] init];
    pkImage.image = [UIImage imageNamed:@"JianBianVS"];
    [self addSubview:pkImage];
    pkImage.contentMode = UIViewContentModeScaleAspectFit;
    [pkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        //        make.height.equalTo(30);
    }];
  
    leftResultView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:leftResultView];

    [leftResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(valueLeft.mas_centerY);
        make.right.equalTo(self.mas_centerX).offset(-5);
        make.size.mas_equalTo(CGSizeMake(34, 20));
    }];
    
    rightResultView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:rightResultView];
    
    [rightResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(valueLeft.mas_centerY);
        make.left.equalTo(self.mas_centerX).offset(5);
        make.size.mas_equalTo(CGSizeMake(34, 20));
    }];
    
}

- (void)switchToPunish:(int)time{

    //2020-1-4 pk结束
    NSDictionary *dic2=@{@"leftValue":[NSString stringWithFormat:@"%.f",_leftValue],
                         @"rightValue":[NSString stringWithFormat:@"%.f",_rightValue]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"endpkview" object:dic2];
    if (_leftValue > _rightValue) {
        //左边胜利,右边失败
        leftResultView.image = [UIImage imageNamed:@"ic_live_pk_win"];
        rightResultView.image = [UIImage imageNamed:@"ic_live_pk_lose"];
    }else if (_leftValue < _rightValue){
        //左边失败,右边胜利
        leftResultView.image = [UIImage imageNamed:@"ic_live_pk_lose"];
        rightResultView.image = [UIImage imageNamed:@"ic_live_pk_win"];
    }else{
        //左边平局,右边平局
        leftResultView.image = [UIImage imageNamed:@"ic_live_pk_draw"];
        rightResultView.image = [UIImage imageNamed:@"ic_live_pk_draw"];
    }

    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithDouble:0.25];
    animation.toValue = [NSNumber numberWithDouble:1];
    animation.duration= 0.25;
    animation.autoreverses= NO;
    [leftResultView.layer addAnimation:animation forKey:@"scale"];
    [rightResultView.layer addAnimation:animation forKey:@"scale"];
    
}

-(void)setLeftIsMe:(BOOL)leftIsMe
{
    _leftIsMe = leftIsMe;
   
    valueLeft.text = [NSString stringWithFormat:ASLocalizedString(@"我方 %.0f"),_leftValue];
    valueRight.text = [NSString stringWithFormat:ASLocalizedString(@"%.0f 对方"),_rightValue];
}

-(void)setRightValue:(float)rightValue
{
    _rightValue = rightValue;
    if (leftResultView.image || rightResultView.image) {
        return;
    }
   
    valueLeft.text = [NSString stringWithFormat:ASLocalizedString(@"我方：%.0f"),_leftValue];
    valueRight.text = [NSString stringWithFormat:ASLocalizedString(@"%.0f：对方"),_rightValue];
    
    //计算动画
    float pkwidth = 0;
    
    if(_leftValue > _rightValue)
    {
        float percentage = _leftValue/(_rightValue+_leftValue);
        pkwidth = self.width * percentage;
//        self.width/2 + self.width/2*percentage;
    }else if (_leftValue == _rightValue){
        pkwidth = self.width/2;
    }else{
        float percentage = _rightValue/(_rightValue+_leftValue);
//        pkwidth = self.width/2 - self.width/2*percentage;
        pkwidth = self.width * (1 - percentage);
    }
    
    if(isnan(pkwidth))
       {
           pkwidth = self.width/2;
       }
       
       
       [UIView animateWithDuration:0.8 animations:^{
           
           UIBezierPath *maskPath1;
           if (pkwidth == self.width) {
               maskPath1 = [UIBezierPath bezierPathWithRoundedRect:pkLeft.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(0,0)];//圆角大小
           }else{
               maskPath1 = [UIBezierPath bezierPathWithRoundedRect:pkLeft.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(0,0)];//圆角大小
           }
           
           
           
           
           
           CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
           maskLayer1.frame = pkLeft.bounds;
           maskLayer1.path = maskPath1.CGPath;
           pkLeft.layer.mask = maskLayer1;
           
           pkLeft.frame = CGRectMake(0, 0, pkwidth, KPKRightOrLeftHeiht);
//           pkLeft.y = self.height - pkLeft.height;
       }];
}



-(void)setLeftValue:(float)leftValue
{
    _leftValue = leftValue;
    if (leftResultView.image || rightResultView.image) {
        return;
    }
    //    if(_leftIsMe == YES)
    //    {
    //        valueLeft.text = [NSString stringWithFormat:ASLocalizedString(@"我方: %.0f"),_leftValue];
    //        valueRight.text = [NSString stringWithFormat:ASLocalizedString(@"对方: %.0f"),_rightValue];
    //
    //    }
    //    else
    //    {
    //        valueLeft.text = [NSString stringWithFormat:ASLocalizedString(@"对方: %.0f"),_rightValue];
    //        valueRight.text = [NSString stringWithFormat:ASLocalizedString(@"我方: %.0f"),_leftValue];
    //    }
    valueLeft.text = [NSString stringWithFormat:ASLocalizedString(@"我方：%.0f"),_leftValue];
    valueRight.text = [NSString stringWithFormat:ASLocalizedString(@"%.0f：对方"),_rightValue];
    
    //计算动画
    float pkwidth = 0;
    
    if(_leftValue > _rightValue)
    {
        float percentage = _leftValue/(_rightValue+_leftValue);
//        pkwidth = self.width/2 + self.width/2*percentage;
        pkwidth = self.width * percentage;
    }else if (_leftValue == _rightValue){
        pkwidth = self.width/2;
    }else
    {
        float percentage = _rightValue/(_rightValue+_leftValue);
        pkwidth = self.width * (1 - percentage);
//        self.width/2 - self.width/2*percentage;
    }
    
    if(isnan(pkwidth))
        {
            pkwidth = self.width/2;
        }
    //    pkwidth = kScreenW -50;
    [UIView animateWithDuration:0.8 animations:^{
        pkLeft.frame = CGRectMake(0, 0, pkwidth, KPKRightOrLeftHeiht);
//        pkLeft.y = self.height - pkLeft.height;
    }];
}

- (void)setModel:(BogoPkProgressModel *)model{
    
    NSLog(@"%@",self.room_id);
    NSLog(@"model.gift_list1.firstObject%@",model.gift_list1.firstObject);
    
    self.pkAudienceView.room_id = self.room_id;
    self.pkAudienceView.model = model;
    
}

-(void)showPublishView{
    if (_leftValue > _rightValue) {
        //左边胜利,右边失败
        leftResultView.image = [UIImage imageNamed:@"ic_live_pk_win"];
        rightResultView.image = [UIImage imageNamed:@"ic_live_pk_lose"];
    }else if (_leftValue < _rightValue){
        //左边失败,右边胜利
        leftResultView.image = [UIImage imageNamed:@"ic_live_pk_lose"];
        rightResultView.image = [UIImage imageNamed:@"ic_live_pk_win"];
    }else{
        //左边平局,右边平局
        leftResultView.image = [UIImage imageNamed:@"ic_live_pk_draw"];
        rightResultView.image = [UIImage imageNamed:@"ic_live_pk_draw"];
    }

    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithDouble:0.25];
    animation.toValue = [NSNumber numberWithDouble:1];
    animation.duration= 0.25;
    animation.autoreverses= NO;
    [leftResultView.layer addAnimation:animation forKey:@"scale"];
    [rightResultView.layer addAnimation:animation forKey:@"scale"];
}


-(BogoPkAudienceView *)pkAudienceView{
    if (!_pkAudienceView) {
        _pkAudienceView = [[BogoPkAudienceView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(KPKAudienceHeiht))];
    }
    return _pkAudienceView;
}


- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
