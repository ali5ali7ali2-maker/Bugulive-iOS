//
//  GuiZuRightsCollectCell.m
//  BuguLive
//
//  Created by bugu on 2019/12/2.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "GuiZuRightsCollectCell.h"

@interface GuiZuRightsCollectCell ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *nameLabel;


@end

@implementation GuiZuRightsCollectCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
  
    
    _nameLabel = ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.font = [UIFont systemFontOfSize:14];
        label.text = ASLocalizedString(@"玄铁身份");
        label;
    });
    _iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"身份-选中"];
        imageView;
    });
 
    
    [self addSubview:_iconImageView];
    [self addSubview:_nameLabel];

    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(5);
            make.centerX.equalTo(self);
        make.size.mas_equalTo(kRealValue(46));
          }];
  
    

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(_iconImageView.mas_bottom).offset(2);
        make.centerX.equalTo(_iconImageView);

      }];
 
}

- (void)setModel:(GuiZuRightsModel *)model{
    _nameLabel.text = model.name;
    _iconImageView.image = [UIImage imageNamed:model.image];
    _iconImageView.highlightedImage = [UIImage imageNamed:model.imageSelected];
    _iconImageView.highlighted = model.has;
}
@end
