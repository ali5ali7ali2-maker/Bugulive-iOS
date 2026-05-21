//
//  WardPriceButton.m
//  BuguLive
//
//  Created by 范东 on 2019/1/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "WardPriceButton.h"

@interface WardPriceButton()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIImageView *recomendImageView;
@property (nonatomic, strong) UIImageView *vipImageView;


@end

@implementation WardPriceButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.selectImageView];
        [self initSubview];
    }
    return self;
}

- (void)initSubview{
    [self addSubview:self.titleLabel];
    [self addSubview:self.priceLabel];
}

- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    [self setData];
}

- (void)setSelected:(BOOL)selected{
    self.selectImageView.hidden = !selected;
    self.recomendImageView.image = [UIImage imageNamed:@"lr_img_ward_recomend"];
//    selected ? [UIImage imageNamed:@"lr_img_ward_recomend"] : [UIImage imageNamed:@"lr_img_ward_recomend_nor"];
    self.vipImageView.image = [UIImage imageNamed:@"lr_img_ward_vip"];
//    selected ? [UIImage imageNamed:@"lr_img_ward_vip"] : [UIImage imageNamed:@"lr_img_ward_vip_nor"];
    self.titleLabel.textColor = selected ? [UIColor colorWithHexString:@"#333333"] : [UIColor colorWithHexString:@"#666666"];
    self.priceLabel.textColor = selected ? [UIColor colorWithHexString:@"#333333"] : [UIColor colorWithHexString:@"#666666"];
    self.backgroundColor = selected ? kWhiteColor : [UIColor colorWithHexString:@"#F4F4F4"];
}

- (void)setData{
    self.titleLabel.text = self.dict[@"name"];
    self.titleLabel.width = [self.titleLabel.text textSizeIn:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:15]].width;
    
    self.priceLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@钻石"),self.dict[@"coin"]];
    if ([self.dict[@"type"] isEqualToString:@"1"]) {
        //增加推荐按钮
        self.titleLabel.centerX = self.width / 2;
        [self addSubview:self.recomendImageView];
    }else if ([self.dict[@"type"] isEqualToString:@"2"]){
        
        //增加推荐按钮
        self.titleLabel.centerX = self.width / 2;
        [self addSubview:self.vipImageView];
        
//        //增加尊贵按钮
//        self.titleLabel.left = ( self.width - 30 - self.titleLabel.width ) / 2 + 30;
//        [self addSubview:self.vipImageView];
    }else{
        self.titleLabel.centerX = self.width / 2;
    }
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.width, 20)];
        _titleLabel.textColor = kBlackColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom, self.width, 20)];
        _priceLabel.textColor = kBlackColor;
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont systemFontOfSize:15];
    }
    return _priceLabel;
}

- (UIImageView *)selectImageView{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height - 18, 13, 18)];
        _selectImageView.image = [UIImage imageNamed:@"lr_img_ward_price_sel"];
        _selectImageView.centerX = self.width / 2;
        _selectImageView.hidden = YES;
    }
    return _selectImageView;
}

- (UIImageView *)recomendImageView{
    if (!_recomendImageView) {
        _recomendImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 19)];
        _recomendImageView.bottom = self.titleLabel.top;

        _recomendImageView.left = self.titleLabel.right;

        _recomendImageView.image = [UIImage imageNamed:@"lr_img_ward_recomend"];
    }
    return _recomendImageView;
}

- (UIImageView *)vipImageView{
    if (!_vipImageView) {
        _vipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 19)];
        
        _vipImageView.bottom = self.titleLabel.top;

       _vipImageView.left = self.titleLabel.right;
        
//        _vipImageView.right = self.titleLabel.left;
//        _vipImageView.centerY = self.titleLabel.centerY;
        _vipImageView.image = [UIImage imageNamed:@"lr_img_ward_vip"];
    }
    return _vipImageView;
}

@end
