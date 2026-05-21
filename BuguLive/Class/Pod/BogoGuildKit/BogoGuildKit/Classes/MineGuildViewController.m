//
//  MineGuildViewController.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/24.
//

#import "MineGuildViewController.h"
#import <QMUIKit/QMUIKit.h>
#import "FDUIKitObjC.h"
#import "GuildCreateViewController.h"
#import "GuildListViewController.h"
#import "GuildDetailView.h"
#import "GuildMemberViewController.h"
#import "GuildMemberRankViewController.h"
#import "BogoNetworkKit.h"
#import "GuildDetailModel.h"
#import "GuildCreateViewController.h"
#import "GuildMemberSubViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface MineGuildViewController ()<GuildDetailViewDelegate,GuildCreateViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *noView;
@property (weak, nonatomic) IBOutlet QMUIButton *createBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *joinBtn;
@property(nonatomic, strong) GuildDetailView *detailView;
@property(nonatomic, strong) GuildDetailModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation MineGuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.family_id.integerValue) {
        [self addDetailView:self.family_id];
        self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    }else{
        self.noView.hidden = NO;
        self.scrollView.mj_header = nil;
    }
    self.createBtn.imagePosition = QMUIButtonImagePositionTop;
    self.createBtn.spacingBetweenImageAndTitle = 5;
    self.joinBtn.imagePosition = QMUIButtonImagePositionTop;
    self.joinBtn.spacingBetweenImageAndTitle = 5;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guildChange:) name:kNotificationGuildChangeKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRefresh) name:@"RECEIVE_GUILD_REFRESH_TYPE" object:nil];
    
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    
    [self.createBtn setTitle:ASLocalizedString(@"创建公会") forState:UIControlStateNormal];
    [self.joinBtn setTitle:ASLocalizedString(@"加入公会") forState:UIControlStateNormal];
    self.titleLabel.text = ASLocalizedString(@"您还未加入公会哦 您可以创建一个自己的公会也可以选择加入一个公会");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData:self.family_id];
}

- (void)guildChange:(NSNotification *)noti{
    NSString *family_id = (NSString *)noti.object;
    if (family_id.integerValue) {
        [self addDetailView:family_id];
        self.noView.hidden = YES;
    }else{
        self.noView.hidden = NO;
        [self.detailView removeFromSuperview];
        self.scrollView.mj_header = nil;
    }
}

- (void)headerRefresh{
    [self requestData:self.family_id];
}

- (void)addDetailView:(NSString *)family_id{
    self.family_id = family_id;
    [self.contentView addSubview:self.detailView];
    [self performSelector:@selector(updateDetailViewFrame) withObject:nil afterDelay:0.25];
    [self requestData:family_id];
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
     }
    
}

- (void)requestData:(NSString *)family_id{
//    if (self.family_id.integerValue) {
//        [self addDetailView:self.family_id];
//        self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
//    }else{
//        self.noView.hidden = NO;
//        self.scrollView.mj_header = nil;
//    }
    if (family_id.length == 0) {
        return;
    }
    
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"family_id":family_id,@"ctl":@"family",@"act":@"guild_index"} success:^(BogoNetworkResponseModel * _Nonnull result) {
        self.model = [GuildDetailModel mj_objectWithKeyValues:result.data];
        self.detailView.model = self.model;
        [self.scrollView.mj_header endRefreshing];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
        self.detailView.model = nil;
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self.scrollView.mj_header endRefreshing];
        self.scrollView.mj_header = nil;
        self.noView.hidden = NO;
        [self.detailView removeFromSuperview];
        [self updateDetailViewFrame];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGuildRankUpdateKey object:nil];
        
    }];
}

- (void)updateDetailViewFrame{
    self.detailView.frame = CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight);
}

- (IBAction)createBtnAction:(QMUIButton *)sender {
    sender.userInteractionEnabled = NO;
    
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"ctl":@"family",@"act":@"guild_join_status"} success:^(BogoNetworkResponseModel * _Nonnull result) {
        sender.userInteractionEnabled = YES;

        NSString *is_join = [NSString stringWithFormat:@"%@",result.data[@"is_join"]];
        if (is_join.integerValue) {
            FDAlertView *alert = [[FDAlertView alloc]initWithTitle:@"" message:ASLocalizedString(@"您的加入申请还在审核中，此时创建公会则会撤销之前的加入申请")];
            [alert addAction:[FDAction actionWithTitle:ASLocalizedString(@"取消") type:FDActionTypeCancel CallBack:nil]];
            [alert addAction:[FDAction actionWithTitle:ASLocalizedString(@"确定") type:FDActionTypeDefault CallBack:^{
//                /mapi/index.php?ctl=family&act=guild_join&family_id=59
//                        /mapi/index.php?ctl=family&act=clean_guild
                [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"ctl":@"family",@"act":@"clean_guild"} success:nil failure:nil];
                GuildCreateViewController *createVC = [[GuildCreateViewController alloc]initWithNibName:@"GuildCreateViewController" bundle:kBogoGuildKitBundle];
                createVC.delegate = self;
                [self.navigationController pushViewController:createVC animated:YES];
            }]];
            [alert show:[UIApplication sharedApplication].keyWindow];
        }else{
            GuildCreateViewController *createVC = [[GuildCreateViewController alloc]initWithNibName:@"GuildCreateViewController" bundle:kBogoGuildKitBundle];
            createVC.delegate = self;
            createVC.clickCancleBlock = ^(BOOL isRefresh) {
                [self requestData:self.family_id];
            };
            [self.navigationController pushViewController:createVC animated:YES];
        }
    } failure:^(NSString * _Nonnull error) {
        sender.userInteractionEnabled = YES;
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
    
//    [[BogoNetwork shareInstance] GET:@"api/getIsCertificationUrl" param:nil success:^(BogoNetworkResponseModel * _Nonnull result) {
////        "state": "0", 是否实名认证【0未认证；1已认证；2审核不通过；3审核中】
////                "shop_status": -1 是否认证店铺【0 审核中 1通过 2失败 -1未提交】
//        NSInteger state = [NSString stringWithFormat:@"%@",result.data[@"state"]].integerValue;
//        NSInteger shop_status = [NSString stringWithFormat:@"%@",result.data[@"shop_status"]].integerValue;
//        if (state == 0 || state == 2) {
//            FDAlertView *alert = [[FDAlertView alloc]initWithTitle:@"" message:ASLocalizedString(@"账户还未进行实名认证，不能创建公会")];
//            [alert addAction:[FDAction actionWithTitle:ASLocalizedString(@"取消") type:FDActionTypeCancel CallBack:nil]];
//            [alert addAction:[FDAction actionWithTitle:ASLocalizedString(@"实名认证") type:FDActionTypeDefault CallBack:^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGuildToAuthKey object:nil];
//            }]];
//            [alert show:[UIApplication sharedApplication].keyWindow];
//        }else if (state == 3){
//            [[FDHUDManager defaultManager] show:ASLocalizedString(@"实名认证审核中") ToView:self.view];
//        }else if (state == 1){
//            [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"ctl":@"family",@"act":@"guild_join_status"} success:^(BogoNetworkResponseModel * _Nonnull result) {
//                NSString *is_join = [NSString stringWithFormat:@"%@",result.data[@"is_join"]];
//                if (is_join.integerValue) {
//                    FDAlertView *alert = [[FDAlertView alloc]initWithTitle:@"" message:ASLocalizedString(@"您的加入申请还在审核中，此时创建公会则会撤销之前的加入申请")];
//                    [alert addAction:[FDAction actionWithTitle:ASLocalizedString(@"取消") type:FDActionTypeCancel CallBack:nil]];
//                    [alert addAction:[FDAction actionWithTitle:ASLocalizedString(@"确定") type:FDActionTypeDefault CallBack:^{
//        //                /mapi/index.php?ctl=family&act=guild_join&family_id=59
////                        /mapi/index.php?ctl=family&act=clean_guild
//                        [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"ctl":@"family",@"act":@"clean_guild"} success:nil failure:nil];
//                        GuildCreateViewController *createVC = [[GuildCreateViewController alloc]initWithNibName:@"GuildCreateViewController" bundle:kBogoGuildKitBundle];
//                        createVC.delegate = self;
//                        [self.navigationController pushViewController:createVC animated:YES];
//                    }]];
//                    [alert show:[UIApplication sharedApplication].keyWindow];
//                }else{
//                    GuildCreateViewController *createVC = [[GuildCreateViewController alloc]initWithNibName:@"GuildCreateViewController" bundle:kBogoGuildKitBundle];
//                    createVC.delegate = self;
//                    createVC.clickCancleBlock = ^(BOOL isRefresh) {
//                        [self requestData:self.family_id];
//                    };
//                    [self.navigationController pushViewController:createVC animated:YES];
//                }
//            } failure:^(NSString * _Nonnull error) {
//                [[FDHUDManager defaultManager] show:error ToView:self.view];
//            }];
//            
//        }
//        sender.userInteractionEnabled = YES;
//    } failure:^(NSString * _Nonnull error) {
//        [[FDHUDManager defaultManager] show:error ToView:self.view];
//        sender.userInteractionEnabled = YES;
//    }];
}

- (IBAction)joinBtnAction:(QMUIButton *)sender {
    GuildListViewController *listVC = [[GuildListViewController alloc]initWithNibName:@"GuildListViewController" bundle:kBogoGuildKitBundle];
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark - GuildCreateViewControllerDelegate
- (void)createVC:(GuildCreateViewController *)createVC didCreateFinished:(NSString *)family_id{
    if (family_id.integerValue) {
        self.noView.hidden = YES;
        [self addDetailView:family_id];
    }
}

- (void)createVC:(GuildCreateViewController *)createVC didEditFinished:(NSString *)family_id{
    [self requestData:family_id];
}

#pragma mark - GuildDetailViewDelegate
- (void)detailView:(GuildDetailView *)detailView didClickMemberViewAction:(UIView *)sender{
    if (detailView.model.family_info.status.integerValue == 0) {
        [[FDHUDManager defaultManager] show:ASLocalizedString(@"您的创建公会申请，正在审核中...") ToView:self.view];
        return;
    }
    if ([[BogoNetwork shareInstance].uid isEqualToString:detailView.model.family_info.user_id]) {
        GuildMemberViewController *memberVC = [[GuildMemberViewController alloc]init];
        memberVC.family_id = detailView.model.family_info.family_id;
        memberVC.familyModel = detailView.model.family_info;
        [self.navigationController pushViewController:memberVC animated:YES];
    }else{
        GuildMemberSubViewController *memberVC = [[GuildMemberSubViewController alloc]initWithNibName:@"GuildMemberSubViewController" bundle:kBogoGuildKitBundle];
        memberVC.family_id = detailView.model.family_info.family_id;
        memberVC.type = GuildMemberSubViewControllerTypeMember;
        memberVC.familyModel = detailView.model.family_info;
        [self.navigationController pushViewController:memberVC animated:YES];
    }
}

- (void)detailView:(GuildDetailView *)detailView didClickApplyViewAction:(UIView *)sender{
    if (detailView.model.family_info.status.integerValue == 0) {
        [[FDHUDManager defaultManager] show:ASLocalizedString(@"您的创建公会申请，正在审核中...") ToView:self.view];
        return;
    }
    GuildMemberViewController *memberVC = [[GuildMemberViewController alloc]init];
    memberVC.family_id = detailView.model.family_info.family_id;
    memberVC.showIndex = 1;
    memberVC.familyModel = detailView.model.family_info;
    [self.navigationController pushViewController:memberVC animated:YES];
}

- (void)detailView:(GuildDetailView *)detailView didClickDeleteBtnAction:(UIButton *)sender{
//    /mapi/index.php?ctl=family&act=dissolve_guild
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"family_id":self.family_id,@"ctl":@"family",@"act":@"dissolve_guild"} success:^(BogoNetworkResponseModel * _Nonnull result) {
        self.noView.hidden = NO;
        [self.detailView removeFromSuperview];
        self.scrollView.mj_header = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGuildRankUpdateKey object:nil];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)detailView:(GuildDetailView *)detailView didClickQuitBtnAction:(UIButton *)sender{
//    /mapi/index.php?ctl=family&act=guild_logout&family_id=59
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"family_id":self.family_id,@"ctl":@"family",@"act":@"guild_logout"} success:^(BogoNetworkResponseModel * _Nonnull result) {
        self.noView.hidden = NO;
        [self.detailView removeFromSuperview];
        self.scrollView.mj_header = nil;
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)detailView:(GuildDetailView *)detailView didClickEditBtnAction:(UIButton *)sender{
    GuildCreateViewController *editVC = [[GuildCreateViewController alloc]initWithNibName:@"GuildCreateViewController" bundle:kBogoGuildKitBundle];
    editVC.model = detailView.model.family_info;
    editVC.delegate = self;
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)detailView:(GuildDetailView *)detailView didClickRankViewAction:(UIView *)sender{
    if (detailView.model.family_info.status.integerValue == 0) {
        [[FDHUDManager defaultManager] show:ASLocalizedString(@"您的创建公会申请，正在审核中...") ToView:self.view];
        return;
    }
    GuildMemberRankViewController *rankVC = [[GuildMemberRankViewController alloc]init];
    rankVC.family_id = detailView.model.family_info.family_id;
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
