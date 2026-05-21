//
//  LoginRecomCollectCell.m
//  BuguLive
//
//  Created by bugu on 2019/12/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "LoginRecomCollectCell.h"
@interface LoginRecomCollectCell ()

@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) QMUIButton *nameBtn;
@property(nonatomic, strong) UIImageView *selectedImageView;

@end
static NSString *const image_name_male = @"lr男生";
static NSString *const image_name_frmale = @"lr女生";

static NSString *const image_name_selected = @"lr选中";
static NSString *const image_name_selectedno = @"lr未选";


@implementation LoginRecomCollectCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}


- (void)initUI{
    
    _iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        //      imageView.layer.cornerRadius = 15;
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:@"lr头像"];
        imageView.layer.cornerRadius = kRealValue(65/2.0);
        imageView;
    });
    
    _selectedImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:image_name_selectedno];
        imageView.highlightedImage = [UIImage imageNamed:image_name_selected];
        
        imageView;
    });
    
    _nameBtn  = ({
        QMUIButton * btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:ASLocalizedString(@"神奇")forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:image_name_male] forState:UIControlStateNormal];
        btn.imagePosition = QMUIButtonImagePositionRight;
        btn.spacingBetweenImageAndTitle = 2;
        btn;
    });
    
    [self addSubview:_iconImageView];
    [self addSubview:_nameBtn];
    [self addSubview:_selectedImageView];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
   
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(10);
           make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(kRealValue(65));

       }];
    
    [_selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(_iconImageView);
           make.right.equalTo(_iconImageView);

       }];
    [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(6);
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
}


- (void)setModel:(HMHotItemModel *)model{
    [self.nameBtn setTitle:model.nick_name forState:UIControlStateNormal];

    if ([model.sex isEqualToString:@"1"]) {
         [self.nameBtn setImage:[UIImage imageNamed:@"dy_sex_male"] forState:UIControlStateNormal];
     }else{
         [self.nameBtn setImage:[UIImage imageNamed:@"dy_sex_female"] forState:UIControlStateNormal];
     }
    
    
       [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    _selectedImageView.highlighted = model.selected;
    
}

@end
