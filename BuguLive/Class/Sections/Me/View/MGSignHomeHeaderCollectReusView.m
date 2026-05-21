//
//  MGSignHomeHeaderCollectReusView.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/21.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGSignHomeHeaderCollectReusView.h"

@interface MGSignHomeHeaderCollectReusView ()

@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIImageView *giftImgVIew;

@property(nonatomic, strong) UIImageView *titleImgView;



@end

static NSString *const image_name_bg = @"mg_sign_bg_ImgView";
static NSString *const image_label = @"mg_sign_label_ImgView";
static NSString *const image_gift_btn = @"mg_sign_gift_ImgView";

@implementation MGSignHomeHeaderCollectReusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.backgroundColor = kClearColor;
    }
    return self;
}
- (void)initUI {
    
    
    _bgImageView = ({
        UIImageView * iv = [[UIImageView alloc] init];
        iv.image = [UIImage imageNamed:image_name_bg];
        iv.userInteractionEnabled = YES;
        iv;
    });
    
 

    
    _giftImgVIew = ({
        UIImageView * iv = [[UIImageView alloc] init];
        iv.image = [UIImage imageNamed:image_gift_btn];
        iv;
    });
    
    _titleImgView = ({
        UIImageView * iv = [[UIImageView alloc] init];
        iv.image = [UIImage imageNamed:image_label];
        iv;
    });
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"pl_publishlive_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:_bgImageView];
    [_bgImageView addSubview:_titleImgView];
    [_bgImageView addSubview:_giftImgVIew];
    [_bgImageView addSubview:self.closeBtn];
    
//    _bgView=({
//        UIView * view = [[UIView alloc]init];
//        view;
//    });
//
//    [_bgImageView addSubview:_bgView];
}

-(void)clickBack:(UIButton *)sender{
    if (self.clickCloseBlock) {
        self.clickCloseBlock(YES);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _bgImageView.frame = CGRectMake(0, -4 , kRealValue(278), kRealValue(95));
    
    _titleImgView.frame = CGRectMake(kRealValue(25), kRealValue(37), kRealValue(127), kRealValue(34));
    
    _giftImgVIew.frame = CGRectMake(_titleImgView.right + kRealValue(9), kRealValue(11), kRealValue(87), kRealValue(92));
    
    _closeBtn.frame = CGRectMake(_bgImageView.width - kRealValue(35) - kRealValue(5),  kRealValue(5), kRealValue(35), kRealValue(35));
    
//    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
//        make.height.mas_equalTo(95);
//    }];
//
//    [_titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(25);
//        make.top.mas_equalTo(37);
//        make.width.mas_equalTo(127);
//        make.height.mas_equalTo(34);
//    }];
//
//    [_giftImgVIew mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_titleImgView.right).offset(9);
//        make.top.mas_equalTo(11);
//        make.width.mas_equalTo(87);
//        make.height.mas_equalTo(92);
//    }];
    
    
    
    
//    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
//        make.left.mas_equalTo(40);
//        //        make.width.mas_equalTo(30*4);
//        make.height.mas_equalTo(45);
//
//    }];
    
    
}

@end
