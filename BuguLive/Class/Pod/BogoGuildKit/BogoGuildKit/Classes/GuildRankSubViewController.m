//
//  GuildRankSubViewController.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/26.
//

#import "GuildRankSubViewController.h"
#import "GuildRankTopCell.h"
#import "GuildRankListCell.h"
#import "GuildRankBottomView.h"
#import "GuildDetailModel.h"
#import "BogoNetworkKit.h"
#import "FDUIKitObjC.h"
#import <MJRefresh/MJRefresh.h>
#import "GuildDetailViewController2.h"

@interface GuildRankSubViewController ()<UITableViewDelegate,UITableViewDataSource,GuildRankTopCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) GuildRankBottomView *bottomView;
@property(nonatomic, strong) NSMutableArray <GuildDetailModelFamily_info *>*familyDataArray;
@property(nonatomic, strong) NSMutableArray <GuildDetailModelLists *>*userDataArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@end

@implementation GuildRankSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GuildRankTopCell" bundle:kBogoGuildKitBundle] forCellReuseIdentifier:@"GuildRankTopCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GuildRankListCell" bundle:kBogoGuildKitBundle] forCellReuseIdentifier:@"GuildRankListCell"];
    if (self.type > GuildRankSubViewControllerTypeDay) {
        if (self.isFromDetailVC) {
            self.tableViewBottomConstraint.constant = 0;
        }else{
            [self.view addSubview:self.bottomView];
            [self performSelector:@selector(updateBottomViewHeight) withObject:nil afterDelay:0.25];
            self.tableViewBottomConstraint.constant = FD_Bottom_Height;
        }
    }else{
        self.tableViewBottomConstraint.constant = 0;
    }
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:kNotificationGuildRankUpdateKey object:nil];
}

- (void)updateBottomViewHeight{
    self.bottomView.frame = CGRectMake(0, FD_ScreenHeight - FD_Bottom_Height - FD_Top_Height - 40, FD_ScreenWidth, FD_Bottom_Height);
}

- (void)requestData{
//    /mapi/index.php?ctl=family&act=guild_ranking&type=all
    NSString *type = @"";
    NSString *act = @"";
    if (self.type == GuildRankSubViewControllerTypeAll) {
        type = @"all";
        act = @"guild_ranking";
    }else if (self.type == GuildRankSubViewControllerTypeWeek) {
        type = @"week";
        act = @"guild_ranking";
    }else if (self.type == GuildRankSubViewControllerTypeDay) {
        type = @"day";
        act = @"guild_ranking";
    }else if (self.type == GuildRankSubViewControllerTypeMemberAll) {
        type = @"all";
        act = @"guild_contribution";
    }else if (self.type == GuildRankSubViewControllerTypeMemberDay) {
        type = @"day";
        act = @"guild_contribution";
    }
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"ctl":@"family",@"act":act,@"type":type,@"family_id":self.family_id.integerValue ? self.family_id : @""} success:^(BogoNetworkResponseModel * _Nonnull result) {
        if (self.type > GuildRankSubViewControllerTypeDay) {
            [self.userDataArray removeAllObjects];
            for (NSDictionary *dict in result.data[@"list"]) {
                GuildDetailModelLists *model = [GuildDetailModelLists mj_objectWithKeyValues:dict];
                [self.userDataArray addObject:model];
            }
            GuildDetailModelLists *userModel = [GuildDetailModelLists mj_objectWithKeyValues:result.data[@"user"]];
            self.bottomView.model = userModel;
        }else{
            [self.familyDataArray removeAllObjects];
            for (NSDictionary *dict in result.data) {
                GuildDetailModelFamily_info *model = [GuildDetailModelFamily_info mj_objectWithKeyValues:dict];
                [self.familyDataArray addObject:model];
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - GuildRankTopCellDelegate
- (void)topCell:(GuildRankTopCell *)topCell didClickViewAction:(UITapGestureRecognizer *)sender{
    if (self.type > GuildRankSubViewControllerTypeDay) {
        UIView *view = sender.view;
        NSInteger index = view.tag - 100;
        if (self.userDataArray.count > 0 && index == 0) {
            GuildDetailModelLists *model = self.userDataArray[index];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGuildToUserPageKey object:model.uid];
        }else if (self.userDataArray.count > 1 && index == 1){
            GuildDetailModelLists *model = self.userDataArray[index];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGuildToUserPageKey object:model.uid];
        }else if (self.userDataArray.count > 2 && index == 2){
            GuildDetailModelLists *model = self.userDataArray[index];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGuildToUserPageKey object:model.uid];
        }
    }else{
        UIView *view = sender.view;
        NSInteger index = view.tag - 100;
        if (self.familyDataArray.count > 0 && index == 0) {
            GuildDetailViewController2 *detailVC = [[GuildDetailViewController2 alloc]init];
            detailVC.family_id = self.familyDataArray[index].id;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (self.familyDataArray.count > 1 && index == 1){
            GuildDetailViewController2 *detailVC = [[GuildDetailViewController2 alloc]init];
            detailVC.family_id = self.familyDataArray[index].id;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (self.familyDataArray.count > 2 && index == 2){
            GuildDetailViewController2 *detailVC = [[GuildDetailViewController2 alloc]init];
            detailVC.family_id = self.familyDataArray[index].id;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : (self.type > GuildRankSubViewControllerTypeDay ? (self.userDataArray.count > 3 ? self.userDataArray.count - 3 : 0) : (self.familyDataArray.count > 3 ? self.familyDataArray.count - 3 : 0));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GuildRankTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuildRankTopCell" forIndexPath:indexPath];
        if (self.type > GuildRankSubViewControllerTypeDay) {
            if (self.userDataArray.count) {
                cell.userDataArray = self.userDataArray;
            }
        }else{
            if (self.familyDataArray.count) {
                cell.familyDataArray = self.familyDataArray;
            }
        }
        cell.type = self.type;
        cell.delegate = self;
        return cell;
    }
    GuildRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuildRankListCell" forIndexPath:indexPath];
    if (self.type > GuildRankSubViewControllerTypeDay) {
        if (indexPath.row + 3 < self.userDataArray.count) {
            cell.userModel = self.userDataArray[indexPath.row + 3];
        }
    }else{
        if (indexPath.row + 3 < self.familyDataArray.count) {
            cell.familyModel = self.familyDataArray[indexPath.row + 3];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? 240 : 74;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type > GuildRankSubViewControllerTypeDay) {
        GuildDetailModelLists *model = self.userDataArray[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGuildToUserPageKey object:model.uid];
    }else{
        GuildDetailViewController2 *detailVC = [[GuildDetailViewController2 alloc]init];
        detailVC.family_id = self.familyDataArray[indexPath.item].id;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (GuildRankBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [kBogoGuildKitBundle loadNibNamed:@"GuildRankBottomView" owner:nil options:nil].lastObject;
    }
    return _bottomView;
}

- (NSMutableArray<GuildDetailModelFamily_info *> *)familyDataArray{
    if (!_familyDataArray) {
        _familyDataArray = [NSMutableArray array];
    }
    return _familyDataArray;
}

- (NSMutableArray<GuildDetailModelLists *> *)userDataArray{
    if (!_userDataArray) {
        _userDataArray = [NSMutableArray array];
    }
    return _userDataArray;
}

@end
