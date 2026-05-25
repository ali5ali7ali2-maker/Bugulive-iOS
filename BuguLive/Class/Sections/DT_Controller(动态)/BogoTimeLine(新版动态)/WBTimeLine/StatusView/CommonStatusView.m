//
//  CommonStatusView.m
//  UniversalApp
//
//  Created by bogokj on 2019/11/19.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "CommonStatusView.h"

@interface CommonStatusView ()

@property (strong, nonatomic) UIView *indicatorView;
@property (strong, nonatomic) UILabel *indicatorLabel;

@end

@implementation CommonStatusView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        [self addSubview:self.indicatorView];
        [self addSubview:self.indicatorLabel];
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(5, 5));
            make.left.equalTo(self).offset(5);
            make.centerY.equalTo(self);
        }];
        [self.indicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.indicatorView.mas_right).offset(5);
            make.centerY.equalTo(self.indicatorView);
        }];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    [self addSubview:self.indicatorView];
    [self addSubview:self.indicatorLabel];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
    }];
    [self.indicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.indicatorView.mas_right).offset(5);
        make.centerY.equalTo(self.indicatorView);
        make.right.equalTo(self).offset(-5);
    }];
}

- (void)setType:(CommonStatusViewType)type{
    _type = type;
    switch (type) {
        case CommonStatusViewTypeOnline:
            self.indicatorView.backgroundColor = [UIColor colorWithHexString:@"#0ABA07"];
            self.indicatorLabel.text = NSLocalizedString(@"在线",nil);
            break;
        case CommonStatusViewTypeBlindDate:
            self.indicatorView.backgroundColor = [UIColor colorWithHexString:@"#FC3382"];
            self.indicatorLabel.text = NSLocalizedString(@"相亲中",nil);
            break;
        case CommonStatusViewTypeManyPeople:
            self.indicatorView.backgroundColor = [UIColor colorWithHexString:@"#FFC74C"];
            self.indicatorLabel.text = NSLocalizedString(@"交友中",nil);
            break;
        default:
            break;
    }
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize lableSize = [self.indicatorLabel sizeThatFits:size];
    return CGSizeMake(lableSize.width + 10, 20);
}

- (UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]initWithFrame:CGRectZero];
        _indicatorView.clipsToBounds = YES;
        _indicatorView.layer.cornerRadius = 2.5;
    }
    return _indicatorView;
}

- (UILabel *)indicatorLabel{
    if (!_indicatorLabel) {
        _indicatorLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _indicatorLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _indicatorLabel.font = [UIFont systemFontOfSize:11];
    }
    return _indicatorLabel;
}

@end
