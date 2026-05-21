//
//  BogoLiveStartCartViewController.m
//  BuGuDY
//
//  Created by bogokj on 2020/3/27.
//  Copyright © 2020 宋晨光. All rights reserved.
//

#import "BogoLiveStartCartViewController.h"
#import "BogoLiveStartGoodListCell.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import "BogoShopKit.h"
#import <MJExtension/MJExtension.h>

@interface BogoLiveStartCartViewController ()<BogoLiveStartGoodListCellDelegate>

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, copy) changeCartCallBack changeCartCallBack;

@end

@implementation BogoLiveStartCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购物车";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoLiveStartGoodListCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoLiveStartGoodListCell class])];
    [self requestData];
}

#pragma mark - BogoLiveStartGoodListCellDelegate
- (void)listCell:(BogoLiveStartGoodListCell *)listCell didClickOperateBtn:(UIButton *)sender{
//    http://xx.com/api/Shoplive/delLiveGoods
    [[BogoNetwork shareInstance] POST:@"api/liveDelGoodsUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"gid":listCell.model.gid,@"lid":self.lid.length ? self.lid : @""} success:^(BogoNetworkResponseModel * _Nonnull result) {
        [self.dataArray removeObject:listCell.model];
        [self.tableView reloadData];
        if (_changeCartCallBack) {
            _changeCartCallBack(self.dataArray.count);
        }
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)requestData{
//    http://xx.com/api/Shoplive/liveGoodsList
    [[BogoNetwork shareInstance] GET:@"api/liveGoodsListUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"lid":self.lid.length ? self.lid : @""} success:^(BogoNetworkResponseModel * _Nonnull result) {
        for (NSDictionary *dict in result.data[@"data"]) {
            BogoCommodityDetailModel *model = [BogoCommodityDetailModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoLiveStartGoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoLiveStartGoodListCell class]) forIndexPath:indexPath];
    [cell setType:BogoLiveStartGoodListCellTypeList];
    [cell setModel:self.dataArray[indexPath.row]];
    cell.delegate = self;
    [cell setRow:indexPath.row + 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setChangeCartCallBack:(changeCartCallBack)changeCartCallBack{
    _changeCartCallBack = changeCartCallBack;
}

@end
