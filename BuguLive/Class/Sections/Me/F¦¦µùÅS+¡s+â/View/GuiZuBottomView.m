//
//  GuiZuBottomView.m
//  BuguLive
//
//  Created by bugu on 2019/12/2.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "GuiZuBottomView.h"
@interface GuiZuBottomView ()

@property(nonatomic, strong) UILabel *giftLabel;
@property(nonatomic, strong) UILabel *moneyLabel;
@property(nonatomic, strong) UIButton *sureBtn;

@end
@implementation GuiZuBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = kWhiteColor;
    self.layer.shadowColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:0.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,-1);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 2;
    
    _giftLabel = ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"";
        label;
    });
    _moneyLabel = ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"";
        label;
    });
    
    _sureBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"贵族立即开通按钮"] forState:UIControlStateNormal];
        //            [btn setTitle:ASLocalizedString(@"知道啦")forState:UIControlStateNormal];
        //            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        //            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:_giftLabel];
    [self addSubview:_moneyLabel];
    [self addSubview:_sureBtn];
    
}

- (void)sureAction{
    
    !self.buyBlock ? : self.buyBlock();
    
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    
    [_giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(13);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-9);
    }];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
    }];
    
}


- (void)setDataWithGift:(NSString *)gift money:(NSString *)money day:(NSString *)day{
    
    NSString * str = [NSString stringWithFormat:ASLocalizedString(@"立即获得%@钻石"),gift];
    
    NSMutableAttributedString *attribute =  [[NSMutableAttributedString alloc]initWithString:str];
    
    
    [attribute setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#BC8D50"]}  range:NSMakeRange(ASLocalizedString(@"立即获得").length, gift.length)];
    [_giftLabel setAttributedText:attribute];
    _moneyLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@元/%@天"),money,day];
}



@end
