//
//  MGSignCollectCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/21.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGSignCollectCell.h"


@interface MGSignCollectCell ()
@property(nonatomic, strong) UIView *layerView;
@property(nonatomic, strong) UILabel *dayLabel;
@property(nonatomic, strong) UIImageView *giftImageView;

@property(nonatomic, strong) UILabel *scoreLabel;

@end

@implementation MGSignCollectCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void)initUI{
    
    _layerView = ({
        UIView *view = [[UIView alloc] init];
        view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        view.layer.cornerRadius = 5;
        view.layer.shadowColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:0.5].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,0);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 4;
        view;
    });
    [self addSubview:_layerView];
    
    
    _dayLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:10];
        label.text = ASLocalizedString(@"第1天");
        label;
    });
    _giftImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"礼物"];
        imageView;
    });
    _scoreLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#CD49FF"];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"+1";
        label;
    });
    
    [_layerView addSubview:_dayLabel];
    [_layerView addSubview:_giftImageView];
    [_layerView addSubview:_scoreLabel];

    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [_layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 0, 10, 0));
    }];
    
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.centerX.equalTo(_layerView);
    }];
    
    [_giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dayLabel.mas_bottom).offset(7);
        make.centerX.equalTo(_dayLabel);
        make.width.height.mas_equalTo(22);
    }];
    
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.mas_equalTo(-5);
      make.centerX.equalTo(_dayLabel);

    }];
}

- (void)setModel:(BGSignRewardModel *)model{
    _dayLabel.text = [NSString stringWithFormat:ASLocalizedString(@"第%@天"),model.day];
    _scoreLabel.text = [NSString stringWithFormat:@"+%@",model.num];
    self.alreadySign = model.is_sign.intValue;
}

- (void)setAlreadySign:(BOOL)alreadySign{
    
    if (alreadySign) {
        _layerView.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
       
    } else {
        _layerView.backgroundColor = [UIColor whiteColor];

    }
    
}

@end
