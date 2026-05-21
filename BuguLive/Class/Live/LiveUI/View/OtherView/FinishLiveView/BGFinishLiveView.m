//
//  BGFinishLiveView.m
//  BuguLive
//
//  Created by bugu on 2019/12/10.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGFinishLiveView.h"

@implementation BGFinishLiveView

- (id)init
{
    self  = [[[NSBundle mainBundle] loadNibNamed:@"BGFinishLiveView" owner:self options:nil] lastObject];
    if(self)
    {
        self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        self.backgroundColor = kClearColor;
        self.bgView.backgroundColor = kGrayTransparentColor1;
        
//        // 毛玻璃效果
//        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        [self.bgView sendSubviewToBack:effectView];
////         bringSubviewToFront:effectView];
////         insertSubview:effectView atIndex:0];
//        [self.bgView addSubview:effectView];
        
        self.userHeadImgView.layer.borderWidth = 1;
        self.userHeadImgView.layer.borderColor = kWhiteColor.CGColor;
        self.userHeadImgView.layer.cornerRadius = CGRectGetHeight(self.userHeadImgView.frame)/2;
        self.userHeadImgView.clipsToBounds = YES;
        
        self.hostContrainerView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.19];
        self.audienceBGView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.19];
        self.audienceBGView.layer.cornerRadius = 4;
        self.audienceBGView.layer.masksToBounds = YES;
        self.audienceBGView.hidden = YES;
        
        self.lineView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.13];

        NSString * pk = @"0";
        NSString * str = [NSString stringWithFormat:ASLocalizedString(@"击败了%@%%的用户"),pk];

        NSMutableAttributedString *attribute =  [[NSMutableAttributedString alloc]initWithString:str];
          
          
        [attribute setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFE629"]}  range:NSMakeRange(ASLocalizedString(@"击败了").length, pk.length+1)];
          [_pkLabel setAttributedText:attribute];
        
        _pkLabel.hidden = YES;
        
        self.screenshotShareBtn.hidden = YES;
        self.consumStrLabel.text = [GlobalVariables sharedInstance].appModel.ticket_name;
        self.numberTitleStr.text = ASLocalizedString(@"观看人数");
        [self.backHomeBtn setTitle:ASLocalizedString(@"返回首页") forState:UIControlStateNormal];
        self.timeLab.text = ASLocalizedString(@"直播时长");
        
        [self.shareFollowBtn setTitle:ASLocalizedString(@"关注主播") forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.userHeadImgView.layer.cornerRadius = CGRectGetWidth(self.userHeadImgView.frame)/2;
    self.topBtnConstraint.constant = MG_TOP_MARGIN + 5;
}

- (IBAction)shareFollowAction:(id)sender {
    if (_shareFollowBlock)
    {
        _shareFollowBlock();
    }
}

- (IBAction)backHomeAction:(id)sender {
    if (_backHomeBlock)
       {
           _backHomeBlock();
       }
}

- (IBAction)screenshotShareBtnAction:(id)sender {
    if (_screenshotShareBlock)
    {
        _screenshotShareBlock();
    }
}
@end
