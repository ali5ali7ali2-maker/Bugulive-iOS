//
//  BogoNobleBottomView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoNobleBottomView.h"

@implementation BogoNobleBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(68))];
    imgView.image = [UIImage imageNamed:@"bogo_noble_bottomBgImg"];
    imgView.userInteractionEnabled = YES;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kRealValue(10), 0, kScreenW * 0.5, kRealValue(64))];
    label.text =ASLocalizedString( @"元/1月");
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    self.priceLabel = label;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"bogo_noble_openBtnImg"] forState:UIControlStateNormal];
    [btn setTitle:ASLocalizedString(@"立即开通") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickOpenBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(kScreenW - kRealValue(12 + 130), 0, kRealValue(130), kRealValue(40));
    self.openBtn = btn;
    
    [self addSubview:imgView];
    [self addSubview:label];
    [self addSubview:btn];
    
    
    self.openBtn.centerY = self.height / 2;
}

- (void)setModel:(BogoNobleRechargeModel *)model{
    
    NSString *content = [NSString stringWithFormat:ASLocalizedString(@"%@钻石/%@%@"),model.money,model.day,model.unit];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:content];
    NSRange range = [content rangeOfString:model.money];//范围
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#BB934E"],
                                NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:range];//添加属性
    
    [self.priceLabel setAttributedText:attStr];
    
    
}

- (void)setIsOpen:(BOOL)isOpen{
    _isOpen = isOpen;
    if (isOpen) {
        [self.openBtn setBackgroundImage:[UIImage imageNamed:@"bogo_noble_Alert_ConfirmBtn_select"] forState:UIControlStateNormal];
        [self.openBtn setTitle:ASLocalizedString(@"已开通") forState:UIControlStateNormal];
    }else{
        [self.openBtn setBackgroundImage:[UIImage imageNamed:@"bogo_noble_openBtnImg"] forState:UIControlStateNormal];
        [self.openBtn setTitle:ASLocalizedString(@"立即开通") forState:UIControlStateNormal];
    }
    
    
    
}

-(void)clickOpenBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(protocolClickOpenBtn)]) {
        [self.delegate protocolClickOpenBtn];
    }
}


@end
