//
//  BogoShareInviteViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/11/6.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "BogoShareInviteViewController.h"

@interface BogoShareInviteViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UITableView *tableView;



@property(nonatomic, strong) UILabel *sumInomeLabel;////可提现金额
@property(nonatomic, strong) UILabel *sumPeopleLabel;//邀请人数

@property(nonatomic, strong) UIView *teamView;//我的团队group
@property(nonatomic, strong) UIView *withDrawView;//提现记录group

@end

@implementation BogoShareInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#2A1648"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 20, kRealValue(30), kRealValue(30));
    [backBtn setImage:[UIImage imageNamed:@"back_w"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self setUpView];
    
    
    [self.view addSubview:backBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)clickBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpView{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.scrollView.contentSize = CGSizeMake(0, kScreenH * 1.8);
    [self.view addSubview:self.scrollView];
    
    UIImageView *bgTopImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(421))];
    bgTopImgView.image = [UIImage imageNamed:@"bogo_invite_bgTop"];
    [self.scrollView addSubview:bgTopImgView];
    
    UIButton *inviteRuleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteRuleBtn.frame = CGRectMake(kScreenW - kRealValue(76) + 15, kRealValue(50), kRealValue(76), kRealValue(34.5));
    inviteRuleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [inviteRuleBtn setTitle:ASLocalizedString(@"邀请规则")forState:UIControlStateNormal];
    [inviteRuleBtn setTitleColor:[UIColor colorWithHexString:@"#2A1648"] forState:UIControlStateNormal];
    inviteRuleBtn.backgroundColor = [UIColor colorWithHexString:@"#1BB897"];
    inviteRuleBtn.layer.cornerRadius = kRealValue(34.5 / 2);
    inviteRuleBtn.layer.masksToBounds = YES;
    [inviteRuleBtn addTarget:self action:@selector(clickRuleBtn:) forControlEvents:UIControlEventTouchUpInside];
//    inviteRuleBtn.backgroundColor = kWhiteColor;
    
    
    
    
    UIImageView *topBgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(350))];
    topBgImgView.image = [UIImage imageNamed:@"bogo_task_invite_topBgImg"];
    topBgImgView.userInteractionEnabled = YES;
    
    //中间部分UI
    UIView *minddleView = [[UIImageView alloc]initWithFrame:CGRectMake(kRealValue(12), kRealValue(213), kScreenW - kRealValue(12 * 2), kRealValue(181))];
    minddleView.backgroundColor = kWhiteColor;
    minddleView.layer.cornerRadius = 5;
    minddleView.layer.masksToBounds = YES;
    
    //累计收益
    UILabel *sumInomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, kRealValue(40), kScreenW / 2, kRealValue(30))];
    sumInomeLabel.text = @"0.00";
    sumInomeLabel.textColor = [UIColor colorWithHexString:@"#926111"];
    sumInomeLabel.font = [UIFont systemFontOfSize:30];
    sumInomeLabel.textAlignment = NSTextAlignmentCenter;
    _sumInomeLabel = sumInomeLabel;
    //累MainScreenWidth
    UILabel *sumInomeStrLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kRealValue(88), kScreenW / 2, kRealValue(20))];
    sumInomeStrLabel.text = ASLocalizedString(@"可提现金额(元)");
    sumInomeStrLabel.textColor = [UIColor colorWithHexString:@"#FF553C"];
    sumInomeStrLabel.font = [UIFont systemFontOfSize:15];
    sumInomeStrLabel.textAlignment = NSTextAlignmentCenter;
    
    //成功邀请的人
    UILabel *sumPeopleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW / 2 - 10, kRealValue(40), kScreenW / 2, kRealValue(30))];
    sumPeopleLabel.text = @"0.00";
    sumPeopleLabel.textColor = [UIColor colorWithHexString:@"#926111"];
    sumPeopleLabel.font = [UIFont systemFontOfSize:30];
    sumPeopleLabel.textAlignment = NSTextAlignmentCenter;
    _sumPeopleLabel = sumPeopleLabel;
    
    UILabel *sumPeopleStrLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW / 2, kRealValue(88), kScreenW / 2, kRealValue(20))];
    sumPeopleStrLabel.text = ASLocalizedString(@"成功邀请(人)");
    sumPeopleStrLabel.textColor = [UIColor colorWithHexString:@"#FF553C"];
    sumPeopleStrLabel.font = [UIFont systemFontOfSize:15];
    sumPeopleStrLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [minddleView addSubview:sumInomeLabel];
    [minddleView addSubview:sumPeopleLabel];
    [minddleView addSubview:sumInomeStrLabel];
    [minddleView addSubview:sumPeopleStrLabel];
    
    UIButton *inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteBtn.frame = CGRectMake(0, minddleView.bottom + kRealValue(10), kRealValue(246), kRealValue(40));
    inviteBtn.centerX = kScreenW / 2;
    [inviteBtn setTitle:ASLocalizedString(@"立即邀请好友赚钱")forState:UIControlStateNormal];
    [inviteBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [inviteBtn setBackgroundImage:[UIImage imageNamed:@"bogo_invite_button"] forState:UIControlStateNormal];
    [inviteBtn addTarget:self action:@selector(clickInviteBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self.scrollView addSubview:topBgImgView];
    [self.scrollView addSubview:minddleView];
    [self.scrollView addSubview:inviteRuleBtn];
    [self.scrollView addSubview:inviteBtn];
    
    [self setUpTeamViewWithTop:inviteBtn.bottom];
    
    [self setUpWithDrawView];
}

-(void)setUpTeamViewWithTop:(CGFloat)top{
    UIView *teamView = [[UIView alloc]initWithFrame:CGRectMake(0, top, kScreenW, kRealValue(208))];
    self.teamView = teamView;
    UIButton *teamTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    teamTopBtn.frame = CGRectMake(0, kRealValue(30), kRealValue(192), kRealValue(24));
    teamTopBtn.centerX = kScreenW / 2;
    [teamTopBtn setTitle:ASLocalizedString(@"我的团队")forState:UIControlStateNormal];
    [teamTopBtn setBackgroundImage:[UIImage imageNamed:@"bogo_invite_teamLine"] forState:UIControlStateNormal];
    
    
    CGFloat viewWidth = (kScreenW - kRealValue(14.5 + 13) - 8.5) / 2;
    
    //一级团队
    UIImageView *firstTeamImgView = [[UIImageView alloc]initWithFrame:CGRectMake(14, teamTopBtn.bottom + kRealValue(24), viewWidth, kRealValue(130))];
    firstTeamImgView.image = [UIImage imageNamed:@"bogo_invite_firstTeam_bg"];
    firstTeamImgView.userInteractionEnabled = YES;
    UILabel *firstL = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, firstTeamImgView.width - 10, 49)];
    firstL.text = ASLocalizedString(@"一级团队");
    firstL.textColor = kWhiteColor;
    firstL.font = [UIFont systemFontOfSize:20];
    
    UIButton *firstInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    firstInfoBtn.frame = CGRectMake(kRealValue(16), firstL.bottom + kRealValue(40), kRealValue(75), kRealValue(30));
    [firstInfoBtn setTitle:ASLocalizedString(@"详情 >")forState:UIControlStateNormal];
    [firstInfoBtn setTitleColor:[UIColor colorWithHexString:@"#198ED5"] forState:UIControlStateNormal];
    [firstInfoBtn setBackgroundImage:[UIImage imageNamed:@"bogo_invite_firstTeam_button"] forState:UIControlStateNormal];
    firstInfoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    firstInfoBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    
    [firstTeamImgView addSubview:firstL];
    [firstTeamImgView addSubview:firstInfoBtn];
    
    //二级团队
    UIImageView *secondTeamImgView = [[UIImageView alloc]initWithFrame:CGRectMake(firstTeamImgView.right + kRealValue(8), teamTopBtn.bottom + kRealValue(24), viewWidth, kRealValue(62))];
    secondTeamImgView.image = [UIImage imageNamed:@"bogo_invite_secondTeam_bg"];
    secondTeamImgView.userInteractionEnabled = YES;
    UILabel *secondL = [[UILabel alloc]initWithFrame:CGRectMake(15, 22, kRealValue(70), kRealValue(28))];
    secondL.text = ASLocalizedString(@"二级团队");
    secondL.textColor = kWhiteColor;
    secondL.font = [UIFont systemFontOfSize:15];
    
    UIButton *secondInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secondInfoBtn.frame = CGRectMake(viewWidth - kRealValue(60 + 10), 0, kRealValue(61), kRealValue(28));
    [secondInfoBtn setTitle:ASLocalizedString(@"详情 >")forState:UIControlStateNormal];
    [secondInfoBtn setTitleColor:[UIColor colorWithHexString:@"#EC4164"] forState:UIControlStateNormal];
    [secondInfoBtn setBackgroundImage:[UIImage imageNamed:@"bogo_invite_firstTeam_button"] forState:UIControlStateNormal];
    secondInfoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    secondInfoBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    
    [secondTeamImgView addSubview:secondL];
    [secondTeamImgView addSubview:secondInfoBtn];
    
    //三级团队
    UIImageView *thirdTeamImgView = [[UIImageView alloc]initWithFrame:CGRectMake(firstTeamImgView.right + kRealValue(8), secondTeamImgView.bottom + kRealValue(5), viewWidth, kRealValue(62))];
    thirdTeamImgView.image = [UIImage imageNamed:@"bogo_invite_thirdTeam_bg"];
    thirdTeamImgView.userInteractionEnabled = YES;
    UILabel *thirdL = [[UILabel alloc]initWithFrame:CGRectMake(15, 22, kRealValue(70), kRealValue(28))];
    thirdL.text = ASLocalizedString(@"三级团队");
    thirdL.textColor = kWhiteColor;
    thirdL.font = [UIFont systemFontOfSize:15];
    
    UIButton *thirdInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdInfoBtn.frame = CGRectMake(viewWidth - kRealValue(60 + 10), 0, kRealValue(61), kRealValue(28));
    [thirdInfoBtn setTitle:ASLocalizedString(@"详情 >")forState:UIControlStateNormal];
    [thirdInfoBtn setTitleColor:[UIColor colorWithHexString:@"#F27A0C"] forState:UIControlStateNormal];
    [thirdInfoBtn setBackgroundImage:[UIImage imageNamed:@"bogo_invite_thirdTeam_button"] forState:UIControlStateNormal];
    thirdInfoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    thirdInfoBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    
    [thirdTeamImgView addSubview:thirdL];
    [thirdTeamImgView addSubview:thirdInfoBtn];
    
    
    [teamView addSubview:teamTopBtn];
    [teamView addSubview:firstTeamImgView];
    [teamView addSubview:secondTeamImgView];
    [teamView addSubview:thirdTeamImgView];
    
    [self.scrollView addSubview:teamView];
}

//提现记录
-(void)setUpWithDrawView{
    UIButton *withDrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withDrawBtn.frame = CGRectMake(0, self.teamView.bottom + kRealValue(30), kRealValue(192), kRealValue(24));
    [withDrawBtn setTitle:ASLocalizedString(@"提现记录")forState:UIControlStateNormal];
    [withDrawBtn setBackgroundImage:[UIImage imageNamed:@"bogo_invite_teamLine"] forState:UIControlStateNormal];
    withDrawBtn.centerX = kScreenW / 2;
    [self.scrollView addSubview:withDrawBtn];
}



//立即邀请好友赚钱
-(void)clickInviteBtn:(UIButton *)sender{
    
}

//邀请规则
-(void)clickRuleBtn:(UIButton *)sender{
    
}


@end
