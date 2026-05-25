//
//  CommonSexView.m
//  UniversalApp
//
//  Created by bogokj on 2019/11/6.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "CommonSexView.h"

@interface CommonSexView ()

@property (strong, nonatomic) UIImageView *sexImageView;
@property (strong, nonatomic) UILabel *ageLabel;

@end

@implementation CommonSexView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setSex:(BogoSex)sex age:(NSInteger)age{
    if (![self.subviews containsObject:self.sexImageView]) {
        [self addSubview:self.sexImageView];
    }
    
    if (![self.subviews containsObject:self.ageLabel]) {
        [self addSubview:self.ageLabel];
    }
    
    [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-2.5);
        make.top.bottom.equalTo(self);
    }];
    self.sexImageView.image = [UIImage imageNamed:sex == BogoMale ? @"boy_icon" : @"girl_icon"];
//    if (age) {
//        [self.ageLabel setText:[NSString stringWithFormat:@"%ld",age]];
//        self.ageLabel.font = [UIFont systemFontOfSize:10];
//    }else{
//        [self.ageLabel setText:ASLocalizedString(@"保密")];
//        self.ageLabel.font = [UIFont systemFontOfSize:7];
//    }
}

- (UIImageView *)sexImageView{
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _sexImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _sexImageView;
}

- (UILabel *)ageLabel{
    if (!_ageLabel) {
        _ageLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _ageLabel.textColor = kWhiteColor;
        _ageLabel.font = [UIFont systemFontOfSize:10];
        _ageLabel.textAlignment = NSTextAlignmentRight;
    }
    return _ageLabel;
}

@end
