//
//  CommonLocationView.m
//  UniversalApp
//
//  Created by bogokj on 2019/12/20.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "CommonLocationView.h"

@interface CommonLocationView ()

@property (strong, nonatomic) UIImageView *locationBgImageView;
@property (strong, nonatomic) UIImageView *locationImageView;
@property (strong, nonatomic) UILabel *locationLabel;

@end

@implementation CommonLocationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setLocation:(NSString *)location{
    _location = location;
//    if (![self.subviews containsObject:self.locationBgImageView]) {
//        [self addSubview:self.locationBgImageView];
//    }
    
    if (![self.subviews containsObject:self.locationImageView]) {
        [self addSubview:self.locationImageView];
    }
    
    if (![self.subviews containsObject:self.locationLabel]) {
        [self addSubview:self.locationLabel];
    }
    
//    [self.locationBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.width.equalTo(@(9.5));
        make.centerY.equalTo(self);
        make.height.equalTo(@(13));
    }];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationImageView.mas_right).offset(5);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-5);
    }];
    [self.locationLabel setText:location];
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize lableSize = [self.locationLabel sizeThatFits:size];
    return CGSizeMake(18 + lableSize.width + 5, 15);
}

- (UIImageView *)locationBgImageView{
    if (!_locationBgImageView) {
        _locationBgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _locationBgImageView.contentMode = UIViewContentModeScaleToFill;
        _locationBgImageView.image = [UIImage imageNamed:@"address1"];
    }
    return _locationBgImageView;
}

- (UIImageView *)locationImageView{
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _locationImageView.image = [UIImage imageNamed:@"address"];
    }
    return _locationImageView;
}

- (UILabel *)locationLabel{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _locationLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _locationLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _locationLabel.textAlignment = NSTextAlignmentRight;
    }
    return _locationLabel;
}

@end
