//
//  MGRecommdHeadView.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/7/10.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "MGRecommdHeadView.h"

@implementation MGRecommdHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [self addSubview:self.regalControl];
    [self addSubview:self.charmControl];
}

-(UIControl *)regalControl{
    if (!_regalControl) {
        
        CGFloat viewWidth = (kScreenW - kRealValue(8 * 2) - kRealValue(10)) / 2;
        
        _regalControl = [[UIControl alloc]initWithFrame:CGRectMake(kRealValue(8), kRealValue(10), viewWidth, kRealValue(73))];
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(14, 14, viewWidth - 14 * 2, kRealValue(20))];
        titleL.text = ASLocalizedString(@"富豪榜");
        titleL.font = [UIFont systemFontOfSize:18];
        titleL.textColor = kWhiteColor;
        
        
        UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:_regalControl.bounds];
        bgImgView.image = [UIImage imageNamed:@"mg_recommand_head_regal"];
        

        UILabel *contenL = [[UILabel alloc]initWithFrame:CGRectMake(titleL.left, titleL.bottom + kRealValue(9), viewWidth - 14 * 2, kRealValue(20))];
        contenL.text = ASLocalizedString(@"尽显王者荣耀");
        contenL.font = [UIFont systemFontOfSize:14];
        contenL.textColor = kWhiteColor;
        _regalLabel = contenL;
        
        
        
        [_regalControl addSubview:bgImgView];
        [_regalControl addSubview:titleL];
        [_regalControl addSubview:contenL];
        [_regalControl addTarget:self action:@selector(clickRegalBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _regalControl;
}

-(UIControl *)charmControl{
    if (!_charmControl) {
        
        CGFloat viewWidth = (kScreenW - kRealValue(8 * 2) + kRealValue(10)) / 2;
        
        _charmControl = [[UIControl alloc]initWithFrame:CGRectMake(kScreenW / 2 + kRealValue(10 / 2), kRealValue(10), viewWidth, kRealValue(73))];
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(14, 14, viewWidth - 14 * 2, kRealValue(20))];
        titleL.text = ASLocalizedString(@"魅力榜");
        titleL.font = [UIFont systemFontOfSize:18];
        titleL.textColor = kWhiteColor;
        
        
        UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:_regalControl.bounds];
        bgImgView.image = [UIImage imageNamed:@"mg_recommand_head_charm"];
        
        UILabel *contenL = [[UILabel alloc]initWithFrame:CGRectMake(titleL.left, titleL.bottom + kRealValue(9), viewWidth - 14 * 2, kRealValue(20))];
        contenL.text = ASLocalizedString(@"魅力释放中");
        contenL.font = [UIFont systemFontOfSize:14];
        contenL.textColor = kWhiteColor;
        
        _charmLabel = contenL;
        
        [_charmControl addSubview:bgImgView];
        [_charmControl addSubview:titleL];
        [_charmControl addSubview:contenL];
        [_charmControl addTarget:self action:@selector(clickCharmBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _charmControl;
}

-(void)clickRegalBtn:(UIControl *)sender{
    
    ConsumptionViewController *vc = [[ConsumptionViewController alloc]init];
    vc.isHiddenTabbar = YES;
    vc.view.backgroundColor = kWhiteColor;
    vc.listDayViewController.delegate = self;
    vc.listMonthViewController.delegate = self;
    vc.listTotalViewController.delegate = self;
    [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
}

-(void)clickCharmBtn:(UIControl *)sender{
    ContributionViewController *vc = [[ContributionViewController alloc]init];
    vc.isHiddenTabbar = YES;
    vc.view.backgroundColor = kWhiteColor;
    vc.ContriDayViewController.delegate = self;
    vc.ContriMonthViewController.delegate = self;
    vc.ContriTotalViewController.delegate = self;
    [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
}

- (void)pushToHomePage:(UserModel *)model
{
    SHomePageVC *homeVC = [[SHomePageVC alloc]init];
    homeVC.user_id = model.user_id;
//    homeVC.user_nickname =model.nick_name;
    homeVC.type = 0;
    
    if ([model.is_noble_ranking_stealth isEqualToString:@"1"] && ![model.user_id isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
        [FanweMessage alertHUD:ASLocalizedString(@"不能查看神秘人信息")];
        return;
    }
    
    [[AppDelegate sharedAppDelegate]pushViewController:homeVC animated:YES];
}


@end
