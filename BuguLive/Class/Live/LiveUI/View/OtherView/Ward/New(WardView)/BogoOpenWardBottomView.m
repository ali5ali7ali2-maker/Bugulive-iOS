//
//  BogoOpenWardBottomView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/10/9.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoOpenWardBottomView.h"

@implementation BogoOpenWardBottomView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
        // 阴影颜色
        line.layer.shadowColor = [UIColor blackColor].CGColor;
        // 阴影偏移，默认(0, -3)
        line.layer.shadowOffset = CGSizeMake(0,0);
        // 阴影透明度，默认0
        line.layer.shadowOpacity = 0.3;
        // 阴影半径，默认3
        line.layer.shadowRadius = 0.2;
        line.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        line.hidden = YES;
        [self setUpView];
        [self addSubview:line];
    }
    return self;
}

-(void)setUpView{
    
    self.timeBtn.hidden = YES;
    [self addSubview:self.myDiamondL];
    [self addSubview:self.timeBtn];
    [self addSubview:self.openBtn];
    
    self.openBtn.frame = CGRectMake(kScreenW - kRealValue(100 + 12), 0, kRealValue(100), kRealValue(34));
    self.openBtn.centerY = self.height / 2;
    self.openBtn.layer.cornerRadius = kRealValue(34 / 2);
    self.openBtn.layer.masksToBounds = YES;
    
}



- (void)setIs_guartian:(NSString *)is_guartian{
    if (is_guartian.integerValue == 1) {
        
        self.timeBtn.hidden = NO;
        self.myDiamondL.frame = CGRectMake(kRealValue(12), 2, kScreenW * 0.6, self.height / 2);
        self.timeBtn.frame = CGRectMake(kRealValue(12), self.myDiamondL.bottom - 4, kScreenW * 0.6, self.height / 2);
        [self.openBtn setTitle:ASLocalizedString(@"续费守护") forState:UIControlStateNormal];
    }else{
        self.timeBtn.hidden = YES;
        self.myDiamondL.frame = CGRectMake(kRealValue(12), 0, kScreenW * 0.6, self.height);
        
        [self.openBtn setTitle:ASLocalizedString(@"开通守护") forState:UIControlStateNormal];
    }
}

- (void)setGuartian_time:(NSString *)guartian_time{
    
    if (guartian_time.length > 10) {
        guartian_time = [guartian_time substringToIndex:10];
    }
    
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%@：%@",ASLocalizedString(@"到期时间"),guartian_time] forState:UIControlStateNormal];

}

- (void)setGuartian_icon:(NSString *)guartian_icon{
    
//    [self.timeBtn setImageWithURL:[NSURL URLWithString:guartian_icon] forState:UIControlStateNormal options:YYWebImageOptionUseNSURLCache];
//    WeakSelf
//    [self.timeBtn setImageWithURL:[NSURL URLWithString:guartian_icon] forState:UIControlStateNormal placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        image = [weakSelf scaleImage:image scaleToSize:CGSizeMake(kRealValue(50), kRealValue(18))];
//        [weakSelf.timeBtn setImage:image forState:UIControlStateNormal];
//    }];
    
    WeakSelf
    [self.timeBtn sd_setImageWithURL:[NSURL URLWithString:guartian_icon] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        image = [weakSelf scaleImage:image scaleToSize:CGSizeMake(kRealValue(50), kRealValue(18))];
        [weakSelf.timeBtn setImage:image forState:UIControlStateNormal];
    }];
    
//    [self.timeBtn sd_setImageWithURL:[NSURL URLWithString:guartian_icon] forState:UIControlStateNormal];
}

- (void)setDiamondStr:(NSString *)diamondStr{
    self.myDiamondL.text = [NSString stringWithFormat:@"%@：%@",ASLocalizedString(@"我的钻石"),diamondStr];
}

-(void)openBtnAction{
    if (self.clickOpenBtnBlock) {
        self.clickOpenBtnBlock(YES);
    }
}

-(QMUIButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_timeBtn setTitle:ASLocalizedString(@"到期时间") forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_timeBtn setTitleColor:[UIColor colorWithHexString:@"#AAAAAA"] forState:UIControlStateNormal];
        _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _timeBtn.imagePosition = QMUIButtonImagePositionLeft;
        _timeBtn.spacingBetweenImageAndTitle = 2;
    }
    return _timeBtn;
}

-(UILabel *)myDiamondL{
    if (!_myDiamondL) {
        _myDiamondL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW / 2, kRealValue(60))];
        _myDiamondL.font = [UIFont systemFontOfSize:14];
        _myDiamondL.textColor = [UIColor colorWithHexString:@"#666666"];
        _myDiamondL.textAlignment = NSTextAlignmentLeft;
        _myDiamondL.text = ASLocalizedString(@"我的钻石");
    }
    return _myDiamondL;
}

-(QMUIButton *)openBtn{
    if (!_openBtn) {
        QMUIButton *openBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [openBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [openBtn setBackgroundImage:[UIImage imageNamed:@"lr_btn_ward_bg"] forState:UIControlStateNormal];
        [openBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [openBtn addTarget:self action:@selector(openBtnAction) forControlEvents:UIControlEventTouchUpInside];
        openBtn.layer.cornerRadius = 20;
        openBtn.clipsToBounds = YES;
        _openBtn = openBtn;
    }
    return _openBtn;
}

- (UIImage*)scaleImage:(UIImage *)image scaleToSize:(CGSize)size{
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
