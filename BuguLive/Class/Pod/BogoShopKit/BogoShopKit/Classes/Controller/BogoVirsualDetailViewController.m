//
//  BogoVirsualDetailViewController.m
//  BuguLive
//
//  Created by Mac on 2021/1/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoVirsualDetailViewController.h"
#import "BogoVirsualDetailListCell.h"
//#import "BogoVirtualListModel.h"
//#import "BogoVirsualDetailHeaderView.h"
//#import <BRPickerView/BRPickerView.h>
#import "BogoShopKit.h"
#import "FDUIKitObjC.h"
#import <MJRefresh/MJRefresh.h>
#import "BogoShopKit.h"
#import "BogoShopWithDrawListModel.h"
#import <MJExtension/MJExtension.h>
#import "BogoNetworkKit.h"
#import "BogoNetworkResponseModel.h"
@interface BogoVirsualDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, copy) NSString *time;//输入要查询的时间【格式：2021-04】

@end

@implementation BogoVirsualDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提现明细";
    [self.tableView registerNib:[UINib nibWithNibName:@"BogoVirsualDetailListCell" bundle:kShopKitBundle] forCellReuseIdentifier:@"BogoVirsualDetailListCell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"BogoVirsualDetailHeaderView" bundle:kShopKitBundle] forHeaderFooterViewReuseIdentifier:@"BogoVirsualDetailHeaderView"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = @"yyyy-MM";
    self.time = [formater stringFromDate:currentDate];
    
    self.tableView.frame = CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight - 52 - FD_Top_Height);
    
    [self headerRefresh];
}

- (void)headerRefresh{
    _page = 1;
    [self requestData];
}

- (void)footerRefresh{
    _page ++;
    [self requestData];
}

- (void)comeBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData{
//    NSString *api = @"coin_recode";
//    /shopapi/pay/shopRecordUrl?token=dbb5e1a7327a551baaffac3d83c75775
    [[BogoNetwork shareInstance] POST:@"pay/shopRecordUrl" param:nil success:^(BogoNetworkResponseModel * _Nonnull result) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dict in result.data) {
            BogoShopWithDrawListModel *model = [BogoShopWithDrawListModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        NSArray *array = result.data;
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
//    /mapi/public/index.php/api/record_api/coin_recode?uid=200696&token=2c759877ca8e7c9920b3668ffaa0776a&page=1&type=2
//    /mapi/public/index.php/api/record_api/earining_record?uid=200696&token=2c759877ca8e7c9920b3668ffaa0776a&num=10&page=1&type=2
//    if (self.type > BogoVirsualDetailViewControllerTypeConsume) {
//        api = @"earining_record";
//    }
//    if (self.type == BogoVirsualDetailViewControllerTypeInviteWithDraw){
//        api = @"invited_log";
//    }
//    [CYNET POSTv4C:@"record_api" a:api parameters:@{@"page":@(self.page),@"time":self.time,@"type":self.type > BogoVirsualDetailViewControllerTypeConsume ? @(self.type - BogoVirsualDetailViewControllerTypeProfit + 1) : @(self.type - BogoVirsualDetailViewControllerTypeRecharge + 1)} success:^(id responseObject) {
//        if (self.page == 1) {
//            [self.dataArray removeAllObjects];
//        }
//        for (NSDictionary *dict in responseObject) {
////            BogoVirtualListModel *model = [BogoVirtualListModel mj_objectWithKeyValues:dict];
////            [self.dataArray addObject:model];
//        }
//        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//    } failure:^(NSString *error) {
//        [[HUDHelper sharedInstance] tipMessage:error];
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoVirsualDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoVirsualDetailListCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
//        cell.type = self.type;
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (self.type == BogoVirsualDetailViewControllerTypeInviteWithDraw) {
//        return nil;
//    }
//    BogoVirsualDetailHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BogoVirsualDetailHeaderView"];
//    headerView.timeLabel.text = self.time;
//    headerView.userInteractionEnabled = YES;
//    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewAction)]];
//    return headerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (self.type == BogoVirsualDetailViewControllerTypeInviteWithDraw) {
//        return 0;
//    }
//    return 28;
//}

//- (void)headerViewAction{
//    __block BogoVirsualDetailHeaderView *headerView = [self.tableView headerViewForSection:0];
//    [headerView.triangleImageView setTransform:CGAffineTransformMakeRotation(180 *M_PI / 180)];
//    [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYM title:@"" selectValue:self.time minDate:nil maxDate:[NSDate date] isAutoSelect:NO resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
//        self.time = selectValue;
//        [self headerRefresh];
//        [headerView.triangleImageView setTransform:CGAffineTransformIdentity];
//    }];
//}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
