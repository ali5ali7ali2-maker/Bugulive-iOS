
//
//  NewestItemCell.m
//  BuguLive
//
//  Created by 丁凯 on 2017/8/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "NewestItemCell.h"
#import "LivingModel.h"
#import "HMHotItemModel.h"
#import "CustomEdgeInsetLabel.h"

@implementation NewestItemCell{
    CGFloat _labelTitleWidth;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.img_labels.hidden = YES;
    self.levelImageView.hidden = YES;
//    self.topConstraint.constant = 8;
    self.headImgView.layer.cornerRadius = 5;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.shadowView.layer.cornerRadius = 5;
    self.shadowView.layer.masksToBounds = YES;
    
    self.recordBtn.spacingBetweenImageAndTitle = 5;
    [self.recordBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    self.recordBtn.layer.cornerRadius = self.recordHeightConstraint.constant / 2;
    self.recordBtn.layer.masksToBounds = YES;
    self.recordLabel.hidden = YES;
    
    self.recordWidthConstraint.constant = 60;
    self.addressBtn.spacingBetweenImageAndTitle = 5;
    
//    if (_labelTitleWidth > kRealValue(20)) {
        self.labelWidthConstraint.constant = _labelTitleWidth;
        //TODO:uiview 单边圆角或者单边框
    
    
        
//    }
    
}

- (void)setModel:(HMHotItemModel *)model{
    
//    if (![BGUtils isBlankString:model.labels]) {
//                self.img_labels.hidden = NO;
//
//         [self.img_labels sd_setImageWithURL:[NSURL URLWithString:model.labels] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            CGSize size=image.size;
//             self.widthConstraint.constant = size.width / 3;
//             self.heightConstraint.constant = size.height / 3;
//             NSLog(@"%@",image);
//         }];
//        self.topConstraint.constant = 36;
//    }
    
    self.img_labels.hidden = YES;
    self.nickNameL.text = model.nick_name;
    if (StrValid(model.lable_title)) {
        [self.imgLabelBtn setTitle:[NSString stringWithFormat:@" %@ ",model.lable_title] forState:UIControlStateNormal];
        [self.imgLabelBtn setBackgroundColor:[UIColor colorWithHexString:model.lable_color]];
        self.imgLabelBtn.hidden = NO;
    }else{
        self.imgLabelBtn.hidden = YES;
    }
    
    
    
    //TODO:uiview 单边圆角或者单边框
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imgLabelBtn.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(11,11)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.imgLabelBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    self.imgLabelBtn.layer.mask = maskLayer;
    
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    [self.liveContentLabel setHidden:YES];
    [self.liveContentExtLabel setHidden:NO];
    self.watchBtn.spacingBetweenImageAndTitle = 2;
    self.watchBtn.imagePosition = QMUIButtonImagePositionLeft;
    if ([model.is_live_pay isEqualToString:@"1"]) {
        [self.recordBtn setTitle:ASLocalizedString(@"付费直播")forState:UIControlStateNormal];
        self.recordWidthConstraint.constant = 80;
        if([model.live_pay_type isEqualToString:@"1"])
        {
            self.liveContentLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@%@/场"),model.live_fee,[GlobalVariables sharedInstance].appModel.diamond_name];
        }
        else
        {
            self.liveContentLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@%@/分钟"),model.live_fee,[GlobalVariables sharedInstance].appModel.diamond_name];
        }
        if ([model.is_gaming isEqualToString:@"1"]) {
            self.liveContentExtLabel.text = model.game_name;
        }else{
            self.liveContentExtLabel.hidden = YES;
        }
    }else{
        [self.recordBtn setTitle:(model.live_in == FW_LIVE_STATE_ING ? ASLocalizedString(@"直播"): ASLocalizedString(@"回播")) forState:UIControlStateNormal];
        if ([model.is_gaming isEqualToString:@"1"]) {
            self.liveContentLabel.text = model.game_name;
        }else{
            self.liveContentLabel.hidden = YES;
            self.liveContentExtLabel.hidden = YES;
        }
    }
    [self.liveContentExtLabel setLocalizedString];
    [self.liveContentLabel setLocalizedString];
    self.isPKIngImg.hidden = YES;
    if ([model.is_video_pk isEqualToString:@"1"]) {
        self.isPKIngImg.hidden = NO;
    }
    
    self.levelImageView.hidden = YES;
    self.distanceLabel.hidden = YES;
    self.backgroundColor = kBackGroundColor;
//    [self.addressLabel setTextInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [self.nameLabel setText:model.nick_name];
    [self.watchCountLabel setText:model.watch_number];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.live_image] placeholderImage:kDefaultPreloadHeadImg];
    
    if (model.city.length > 0)
    {
        [self.addressBtn setTitle:[NSString stringWithFormat:@"%@",model.city] forState:UIControlStateNormal];
//        .text = [NSString stringWithFormat:@"%@",model.city];
    }else
    {
        [self.addressBtn setTitle:ASLocalizedString(@"火星")forState:UIControlStateNormal];
        
    }
    self.addressBtn.backgroundColor = kClearColor;
    [self.watchBtn setTitle:model.watch_number forState:UIControlStateNormal];
    [self isCheckModeWithUid:model.user_id];
}

- (void)setCellContent:(LivingModel *)LModel Type:(int)type{
    
     if (![BGUtils isBlankString:LModel.labels]) {
            self.img_labels.hidden = NO;

         [self.img_labels sd_setImageWithURL:[NSURL URLWithString:LModel.labels] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGSize size=image.size;
             self.widthConstraint.constant = size.width / 3;
             self.heightConstraint.constant = size.height / 3;
//             NSLog(@"%@",size);
             NSLog(@"%@",image);
             
         }];

        self.topConstraint.constant = 36;
     }else{
         self.topConstraint.constant = 12;
     }
    
    self.nickNameL.text = LModel.nick_name;
    self.img_labels.hidden = YES;
    
    if (StrValid(LModel.lable_title)) {
        [self.imgLabelBtn setTitle:[NSString stringWithFormat:@"%@",LModel.lable_title] forState:UIControlStateNormal];
        [self.imgLabelBtn setBackgroundColor:[UIColor colorWithHexString:LModel.lable_color]];
        self.imgLabelBtn.hidden = NO;
    }else{
        self.imgLabelBtn.hidden = YES;
    }
    
    if(LModel.password.length)
    {
        self.passwordImg.hidden = NO;
    }
    else
    {
        self.passwordImg.hidden = YES;
    }
    
    _labelTitleWidth = [NewestItemCell getWidthWithText:LModel.lable_title height:22 font:14] + kRealValue(20);
//
//    CGRect frame = CGRectMake(0, 10, _labelTitleWidth, 20);
//
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10,10)];//圆角大小
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = frame;
//    maskLayer.path = maskPath.CGPath;
//    self.imgLabelBtn.layer.mask = maskLayer;
    
//    [NewestItemCell getLabelHeightWithText:LModel.lable_title width:kScreenW * 0.5 font:14];
//    CGSize ss = [self.imgLabelBtn.titleLabel sizeThatFits:CGSizeMake(kScreenW, CGFLOAT_MAX)];
    
    self.labelWidthConstraint.constant = _labelTitleWidth ;

    
    
    self.isPKIngImg.hidden = YES;
    if ([LModel.is_video_pk isEqualToString:@"1"]) {
        self.isPKIngImg.hidden = NO;
    }
    
    if (type == 1) {
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        self.levelImageView.hidden = YES;
        self.distanceLabel.hidden = YES;
        [self.liveContentLabel setHidden:YES];
        [self.liveContentExtLabel setHidden:NO];
        
        if ([LModel.is_live_pay isEqualToString:@"1"]) {
            [self.recordBtn setTitle:ASLocalizedString(@"付费直播")forState:UIControlStateNormal];
            self.recordWidthConstraint.constant = 80;
            if([LModel.live_pay_type isEqualToString:@"1"])
            {
                self.liveContentLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@%@/场"),LModel.live_fee,[GlobalVariables sharedInstance].appModel.diamond_name];
            }
            else
            {
                self.liveContentLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@%@/分钟"),LModel.live_fee,[GlobalVariables sharedInstance].appModel.diamond_name];
            }
            if ([LModel.is_gaming isEqualToString:@"1"]) {
                [self.liveContentExtLabel setHidden:YES];
                self.liveContentExtLabel.text = LModel.game_name;
            }else{
                self.liveContentExtLabel.hidden = YES;
            }
        }else{
//            self.stateLabel.text = (LModel.live_in == FW_LIVE_STATE_ING ? ASLocalizedString(@"直播"): ASLocalizedString(@"回播"));
            [self.recordBtn setTitle:(LModel.live_in == FW_LIVE_STATE_ING ? ASLocalizedString(@"直播"): ASLocalizedString(@"回播")) forState:UIControlStateNormal];
            if ([LModel.is_gaming isEqualToString:@"1"]) {
                self.liveContentLabel.text = LModel.game_name;
                self.liveContentExtLabel.hidden = YES;

            }else{
                self.liveContentLabel.hidden = YES;
                self.liveContentExtLabel.hidden = YES;
            }
        }
        
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:LModel.live_image] placeholderImage:kDefaultPreloadHeadImg];
        
//        [self.nameLabel setText:LModel.nick_name];
        [self.nameLabel setText:LModel.title];
        [self.watchCountLabel setText:LModel.watch_number];
        [self.watchBtn setTitle:LModel.watch_number forState:UIControlStateNormal];
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:LModel.live_image] placeholderImage:kDefaultPreloadHeadImg];
        if (LModel.city.length > 0){
            [self.addressBtn setTitle:[NSString stringWithFormat:@"%@",LModel.city] forState:UIControlStateNormal];
        }else
        {
            [self.addressBtn setTitle:ASLocalizedString(@"火星")forState:UIControlStateNormal];
        }
        
        self.addressBtn.hidden = YES;
    }else{
        
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;

//        self.recordLabel.text = (LModel.live_in == FW_LIVE_STATE_ING ? ASLocalizedString(@"直播"): ASLocalizedString(@"回播"));
        [self.recordBtn setTitle:(LModel.live_in == FW_LIVE_STATE_ING ? ASLocalizedString(@"直播"): ASLocalizedString(@"回播")) forState:UIControlStateNormal];
//        [self.stateLabel setHidden:NO];
//        [self.recordLabel setHidden:NO];
        
        [self.liveContentLabel setHidden:YES];
        [self.liveContentExtLabel setHidden:YES];
        [self.addressBtn setHidden:NO];
        [self.liveContentLabel setHighlighted:YES];
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:LModel.live_image] placeholderImage:kDefaultPreloadHeadImg];
        [self.nameLabel setText:LModel.title];
        
        [self.watchCountLabel setHidden:NO];
        self.watchBtn.hidden = NO;
        [self.watchBtn setTitle:LModel.watch_number forState:UIControlStateNormal];
//        [self.recordLabel setHidden:YES];
        [self.watchingLabel setHidden:YES];
        self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%@",LModel.user_level]];
        
        self.distanceLabel.hidden = YES;
        
        if (LModel.city.length > 0)
        {
            [self.addressBtn setTitle:[NSString stringWithFormat:@"%@",LModel.city] forState:UIControlStateNormal];
//                .text = [NSString stringWithFormat:@"%@",LModel.city];
        }else
        {
            [self.addressBtn setTitle:ASLocalizedString(@"火星")forState:UIControlStateNormal];

        }

    }
    
    
    if(LModel.is_voice == 1)
    {
        [self.recordBtn setTitle:ASLocalizedString(@"语音直播") forState:UIControlStateNormal];
        self.recordWidthConstraint.constant = 100;

    }
    
    self.backgroundColor = kBackGroundColor;
    self.addressBtn.backgroundColor = kClearColor;
    self.watchBtn.spacingBetweenImageAndTitle = 4;
    self.watchBtn.imagePosition = QMUIButtonImagePositionLeft;
    [self isCheckModeWithUid:LModel.user_id];
    
    [self setAnnimateImage];
}

//判断是否是审核模式
-(void)isCheckModeWithUid:(NSString *)uid{
    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version] )
    {
        [self.headImgView sd_setImageWithURL:nil placeholderImage:[[GlobalVariables sharedInstance]getKatongImageWidthID:uid]];
        self.img_labels.hidden = YES;
    }
}


-(void)setAnnimateImage{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"mg_home_jump%d",i]]];
    }
    
    self.recordBtn.imageView.image = arr.firstObject;

    self.recordBtn.imageView.animationImages = arr;

    //动画的总时长(一组动画坐下来的时间 6张图片显示一遍的总时间)

    self.recordBtn.imageView.animationDuration = 2;

    self.recordBtn.imageView.animationRepeatCount = 0;//动画进行几次结束

    [self.recordBtn.imageView startAnimating];//开始动画

    // [imageView stopAnimating];//停止动画

    self.recordBtn.imageView.userInteractionEnabled = YES;
    
}

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
 
    return rect.size.height;
}

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
 
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.width;
}

- (void)layoutSubviews{
    
    self.labelWidthConstraint.constant = _labelTitleWidth;
//    //TODO:uiview 单边圆角或者单边框
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imgLabelBtn.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10,10)];//圆角大小
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.imgLabelBtn.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.imgLabelBtn.layer.mask = maskLayer;
    
    
//    CGRect frame = CGRectMake(self.imgLabelBtn.left, self.imgLabelBtn.y, _labelTitleWidth, self.imgLabelBtn.height);
//
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10,10)];//圆角大小
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = frame;
//    maskLayer.path = maskPath.CGPath;
//    self.imgLabelBtn.layer.mask = maskLayer;
    
//    _labelTitleWidth = [NewestItemCell getWidthWithText:LModel.lable_title height:22 font:14] + kRealValue(20);
    
    CGRect frame = CGRectMake(0, 0, _labelTitleWidth, 20);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(10,10)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    self.imgLabelBtn.layer.mask = maskLayer;
}

@end
