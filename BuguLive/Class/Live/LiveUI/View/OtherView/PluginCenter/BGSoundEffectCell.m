//
//  BGSoundEffectCell.m
//  BuguLive
//
//  Created by bugu on 2019/12/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGSoundEffectCell.h"

@interface BGSoundEffectCell ()

@property(nonatomic, strong) UIView *bgView;

@property(nonatomic, strong) UIImageView *bgImageView;

@property(nonatomic, strong) UIImageView *leftImageView;

@property(nonatomic, strong) UIImageView *rightImageView;

@end

static NSString *const image_name_bg = @"lr背景";
static NSString *const image_name_sound = @"lr声音";

@implementation BGSoundEffectCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    
    _bgImageView = ({
           UIImageView *imageView = [[UIImageView alloc] init];
           imageView.image = [UIImage imageNamed:image_name_bg];
        imageView.contentMode = UIViewContentModeScaleToFill;
           imageView;
       });
    
    
    _leftImageView = ({
              UIImageView *imageView = [[UIImageView alloc] init];
              imageView.image = [UIImage imageNamed:image_name_sound];
              
              imageView;
          });
    
       
    _rightImageView = ({
                 UIImageView *imageView = [[UIImageView alloc] init];
                 imageView.image = [UIImage imageNamed:image_name_sound];
                 
                 imageView;
             });
    _titleLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = kWhiteColor;
        label.font = [UIFont systemFontOfSize:14];
        label.text = ASLocalizedString(@"音效");
        label;
    });
          
    [self addSubview:_bgImageView];
    [self addSubview:_titleLabel];
    [self addSubview:_leftImageView];
    [self addSubview:_rightImageView];

    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 5, 5, 5));

    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLabel.mas_left).offset(-4);
        make.centerY.mas_equalTo(0);

    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(_titleLabel.mas_right).offset(4);
           make.centerY.mas_equalTo(0);

       }];
    
    
}

- (void)setModel:(BGSoundEffectModel *)model{
    _titleLabel.text = model.name;
    
}

@end
