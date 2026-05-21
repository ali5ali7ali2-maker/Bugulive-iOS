//
//  GuildMemberSubViewController.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import "GuildMemberSubViewController.h"
#import "GuildMemberListCell.h"
#import "FDUIKitObjC.h"
#import "BogoNetworkKit.h"
#import "GuildDetailModel.h"
#import <MJRefresh/MJRefresh.h>

@interface GuildMemberSubViewController ()<UITableViewDelegate,UITableViewDataSource,GuildMemberListCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray <GuildDetailModelLists *>*dataArray;
@property(nonatomic, assign) NSInteger page;


@end

@implementation GuildMemberSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = ASLocalizedString(@"公会成员");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GuildMemberListCell" bundle:kBogoGuildKitBundle] forCellReuseIdentifier:@"GuildMemberListCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [self headerRefresh];
}

- (void)headerRefresh{
    self.page = 1;
    [self requestData];
}

- (void)footerRefresh{
    self.page = self.page + 1;
    [self requestData];
}

- (void)requestData{
//    /mapi/index.php?ctl=family&act=guild_member_list&family_id=59&type=1
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"ctl":@"family",@"act":@"guild_member_list",@"type":@(self.type),@"family_id":self.family_id,@"page":@(self.page)} success:^(BogoNetworkResponseModel * _Nonnull result) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *array = (NSArray *)result.data;
        for (NSDictionary *dict in array) {
            GuildDetailModelLists *model = [GuildDetailModelLists mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (array.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - GuildMemberListCellDelegate
- (void)listCell:(GuildMemberListCell *)listCell didClickAgreeBtn:(UIButton *)sender{
    //    审核状态【1同意 ；2拒绝】
    //    /mapi/index.php?ctl=family&act=guild_confirm&to_user_id=166111&is_agree=1
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"ctl":@"family",@"act":@"guild_confirm",@"to_user_id":listCell.model.uid,@"is_agree":@"1"} success:^(BogoNetworkResponseModel * _Nonnull result) {
        [self headerRefresh];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)listCell:(GuildMemberListCell *)listCell didClickDeleteBtn:(UIButton *)sender{
    FDAlertView *alert = [[FDAlertView alloc]initWithTitle:@"" message:ASLocalizedString(@"是否踢出该成员")];
    [alert addAction:[FDAction actionWithTitle:ASLocalizedString(@"取消")  type:FDActionTypeCancel CallBack:nil]];
    [alert addAction:[FDAction actionWithTitle:ASLocalizedString(@"确定")  type:FDActionTypeDefault CallBack:^{
        //    /mapi/index.php?ctl=family&act=guild_del&to_user_id=166373
        [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"ctl":@"family",@"act":@"guild_del",@"to_user_id":listCell.model.uid} success:^(BogoNetworkResponseModel * _Nonnull result) {
            [self headerRefresh];
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
        }];
    }]];
    [alert show:[UIApplication sharedApplication].keyWindow];
}

- (void)listCell:(GuildMemberListCell *)listCell didClickRefuseBtn:(UIButton *)sender{
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"ctl":@"family",@"act":@"guild_confirm",@"to_user_id":listCell.model.uid,@"is_agree":@"2"} success:^(BogoNetworkResponseModel * _Nonnull result) {
        [self headerRefresh];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GuildMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuildMemberListCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row < self.dataArray.count) {
        cell.familyModel = self.familyModel;
        cell.type = self.type;
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GuildDetailModelLists *model = self.dataArray[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGuildToUserPageKey object:model.uid];
}

- (NSMutableArray<GuildDetailModelLists *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
