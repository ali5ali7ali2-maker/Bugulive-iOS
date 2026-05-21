//
//  FocusOnCollectCell.m
//  BuguLive
//
//  Created by bugu on 2019/11/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "FocusOnCollectCell.h"

@interface FocusOnCollectCell ()
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIImageView *iconImageView;

@property(nonatomic, strong) UILabel *nickNameLabel;

@property(nonatomic, strong) UIButton *followBtn;


@end
static NSString *const image_name_bg = @"关注背景";
static NSString *const image_name_btn = @"bogo_follow_btn";

@implementation FocusOnCollectCell
- (instancetype)initWithFrame:(CGRect)frame {
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
        imageView;
    });
    _iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 25;
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"com_preload_head_img"];
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImgView:)];
        [imageView addGestureRecognizer:tapImg];
        imageView;
    });
    _nickNameLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = ASLocalizedString(@"小草莓");
        label;
    });
    
    _followBtn = ({
              UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
              [btn setBackgroundImage:[UIImage imageNamed:ASLocalizedString(@"bogo_follow_btn")] forState:UIControlStateNormal];
            
              [btn addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
              btn;
          });
    
    
    [self.contentView addSubview:_bgImageView];
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_nickNameLabel];
    [self.contentView addSubview:_followBtn];
}



- (void)followAction {

    if (self.followBlock) {
        self.followBlock();
    }
    
//    !self.followBlock ? : self.followBlock();
}

-(void)clickImgView:(UITapGestureRecognizer *)sender{
    if (self.clickImgBlock) {
        self.clickImgBlock(self.user.id);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealValue(15));
         make.centerX.equalTo(self);
         make.size.mas_equalTo(kRealValue(50));
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(kRealValue(3));
        make.width.mas_equalTo(self.contentView.width - kRealValue(15));
        make.centerX.equalTo(self);
    }];
    
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.bottom.mas_equalTo(-15);
        make.top.equalTo(_nickNameLabel.mas_bottom).offset(3);
          make.centerX.equalTo(self);
        make.width.mas_equalTo(kRealValue(52));
        make.height.mas_equalTo(kRealValue(25));
    }];
}



- (void)setUser:(HMHotItemModel *)user{
    _user = user;
    self.nickNameLabel.text = user.nick_name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:user.head_image] placeholderImage:kDefaultPreloadHeadImg];
    if ([user.id isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
        self.followBtn.hidden = YES;
    }else{
//        self.followBtn.hidden = NO;
    }
}


@end
