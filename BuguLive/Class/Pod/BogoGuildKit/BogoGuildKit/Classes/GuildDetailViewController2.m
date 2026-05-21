//
//  GuildDetailViewController2.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import "GuildDetailViewController2.h"
#import "GuildDetailView.h"
#import "FDUIKitObjC.h"
#import "GuildDetailModel.h"
#import "BogoNetworkKit.h"
#import "GuildMemberSubViewController.h"
#import "GuildMemberRankViewController.h"
#import "GuildListViewController.h"



@interface GuildDetailViewController2 ()<GuildDetailViewDelegate>

@property(nonatomic, strong) GuildDetailView *detailView;
@property(nonatomic, strong) GuildDetailModel *model;

@end

@implementation GuildDetailViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.detailView];
    [self performSelector:@selector(updateDetailViewFrame) withObject:nil afterDelay:0.25];
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"family_id":SafeStr(self.family_id),@"ctl":@"family",@"act":@"guild_index"} success:^(BogoNetworkResponseModel * _Nonnull result) {
        self.model = [GuildDetailModel mj_objectWithKeyValues:result.data];
        self.detailView.model = self.model;
        self.title = self.model.family_info.family_name;
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)updateDetailViewFrame{
    self.detailView.frame = CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight);
}

#pragma mark - GuildDetailViewDelegate
- (void)detailView:(GuildDetailView *)detailView didClickJoinBtnAction:(UIButton *)sender{
//    /mapi/index.php?ctl=family&act=guild_join_status
//    is_join": 0  //是否有待审核的公会 1有；0否
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"ctl":@"family",@"act":@"guild_join_status"} success:^(BogoNetworkResponseModel * _Nonnull result) {
        NSString *is_join = [NSString stringWithFormat:@"%@",result.data[@"is_join"]];
        if (is_join.integerValue) {
            FDAlertView *alert = [[FDAlertView alloc]initWithTitle:@"" message:ASLocalizedString(@"您的加入申请还在审核中，如再加入其他公会则自动撤销之前的加入申请")];
            [alert addAction:[FDAction actionWithTitle:ASLocalizedString(@"取消") type:FDActionTypeCancel CallBack:nil]];
            [alert addAction:[FDAction actionWithTitle:ASLocalizedString(@"确定") type:FDActionTypeDefault CallBack:^{
//                /mapi/index.php?ctl=family&act=guild_join&family_id=59
                [self joinGuild:detailView.model.family_info.family_id];
            }]];
            [alert show:[UIApplication sharedApplication].keyWindow];
        }else{
            [self joinGuild:detailView.model.family_info.family_id];
        }
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)joinGuild:(NSString *)family_id{
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"family_id":family_id,@"ctl":@"family",@"act":@"guild_join"} success:^(BogoNetworkResponseModel * _Nonnull result) {
        [[FDHUDManager defaultManager] show:result.error ToView:[UIApplication sharedApplication].keyWindow];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGuildChangeKey object:self.detailView.model.family_info.family_type.integerValue == 1 ? @"" : family_id];
        for (UIViewController *subVC in self.navigationController.viewControllers) {
            if ([subVC isKindOfClass:[GuildListViewController class]]) {
                [self.navigationController popToViewController:subVC animated:YES];
                break;
            }
        }
        
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)detailView:(GuildDetailView *)detailView didClickMemberViewAction:(UIView *)sender{
    GuildMemberSubViewController *memberVC = [[GuildMemberSubViewController alloc]initWithNibName:@"GuildMemberSubViewController" bundle:kBogoGuildKitBundle];
    memberVC.family_id = detailView.model.family_info.family_id;
    memberVC.type = GuildMemberSubViewControllerTypeMember;
    memberVC.familyModel = detailView.model.family_info;
    [self.navigationController pushViewController:memberVC animated:YES];
}

- (void)detailView:(GuildDetailView *)detailView didClickRankViewAction:(UIView *)sender{
    GuildMemberRankViewController *rankVC = [[GuildMemberRankViewController alloc]init];
    rankVC.family_id = detailView.model.family_info.family_id;
    rankVC.isFromDetailVC = YES;
    [self.navigationController pushViewController:rankVC animated:YES];
}

- (GuildDetailView *)detailView{
    if (!_detailView) {
        _detailView = [kBogoGuildKitBundle loadNibNamed:@"GuildDetailView" owner:nil options:nil].lastObject;
        _detailView.delegate = self;
    }
    return _detailView;
}

@end
