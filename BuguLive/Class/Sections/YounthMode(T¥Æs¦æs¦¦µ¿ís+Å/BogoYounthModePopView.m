//
//  BogoYounthModePopView.m
//  AFNetworking
//
//  Created by 宋晨光 on 2021/9/11.
//

#import "BogoYounthModePopView.h"


@implementation BogoYounthModePopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kClearColor;
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kRealValue(62) / 2, kRealValue(290), kRealValue(264))];
    self.bgView.backgroundColor = kWhiteColor;
    self.bgView.layer.cornerRadius = 6;
    self.bgView.layer.masksToBounds = YES;
    
    self.topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kRealValue(56), kRealValue(62))];
    self.topImgView.centerX = self.width / 2;
    self.topImgView.image = [UIImage imageNamed:@"bogo_youth_TopImage"];
    
    self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, self.topImgView.bottom, self.bgView.width - kRealValue(15 * 2), kRealValue(20))];
    self.titleL.text = ASLocalizedString(@"青少年模式");
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    
    self.contentL.frame = CGRectMake(kRealValue(15), self.titleL.fd_bottom + kRealValue(10), self.bgView.width - kRealValue(15 * 2), kRealValue(100));
    
    self.confirmBtn.frame = CGRectMake(0, self.height - kRealValue(15) - kRealValue(40), kRealValue(180), kRealValue(40));
    self.inYounthBtn.frame = CGRectMake(kRealValue(15), self.confirmBtn.top - kRealValue(10) - kRealValue(20), self.width, kRealValue(20));
    self.titleL.centerX = self.contentL.centerX = self.bgView.centerX = self.topImgView.centerX = self.confirmBtn.centerX = self.inYounthBtn.centerX = self.width / 2;
    
    [self addSubview:self.bgView];
    [self addSubview:self.topImgView];
    [self addSubview:self.titleL];
    [self addSubview:self.contentL];
    
    [self addSubview:self.inYounthBtn];
    [self addSubview:self.confirmBtn];

}

-(void)clickInYountBtn:(UIButton *)sender{
    if (self.clickInYounthBlock) {
        self.clickInYounthBlock(YES);
    }
}

-(void)clickConfirmBtn:(UIButton *)sender{
    [GlobalVariables sharedInstance].isShutDownYoung = @"0";
    [self hide];
}

-(UILabel *)contentL{
    if (!_contentL) {
        _contentL = [UILabel new];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 2;  //设置行间距
        paragraphStyle.lineBreakMode = _contentL.lineBreakMode;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        NSString *content = ASLocalizedString(@"为呵护未成年人健康成长，布谷直播特别推出青少年模式，该模式下部分功能无法正常使用。请监护人主动选择，并设置监护密码。");
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];

        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],
                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"777777"],
                                     NSParagraphStyleAttributeName:paragraphStyle};
        [attributedString setAttributes:attributes range:NSMakeRange(0, attributedString.length)];
        _contentL.attributedText = attributedString;
        _contentL.numberOfLines = 0;
    }
    return _contentL;
}

-(UIButton *)inYounthBtn{
    if (!_inYounthBtn) {
        _inYounthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inYounthBtn setTitle:ASLocalizedString(@"进入青少年模式 >") forState:UIControlStateNormal];
        [_inYounthBtn setTitleColor:[UIColor colorWithHexString:@"#9152F8"] forState:UIControlStateNormal];
        _inYounthBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_inYounthBtn addTarget:self action:@selector(clickInYountBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inYounthBtn;
}

-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:ASLocalizedString(@"我知道了") forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"bogo_youth_confirmBtn"] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end
