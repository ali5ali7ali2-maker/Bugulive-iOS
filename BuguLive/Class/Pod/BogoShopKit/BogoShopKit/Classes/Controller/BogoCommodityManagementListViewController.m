//
//  BogoCommodityManagementListViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/13.
//

#import "BogoCommodityManagementListViewController.h"
#import "BogoCommodityManagementListCell.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import "BogoCommodityManagementListModel.h"
#import "BogoCommodityAddViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>

@interface BogoCommodityManagementListViewController ()<BogoCommodityManagementListCellDelegate>

@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, assign) NSInteger page;

@end

@implementation BogoCommodityManagementListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = 1;
    
    
    self.tableView.frame = CGRectMake(self.tableView.fd_left, 0, FD_ScreenWidth, FD_ScreenHeight - 70 - 40 - 44 - [UIApplication sharedApplication].statusBarFrame.size.height);
    
    
    
    self.view.backgroundColor = FD_WhiteColor;
    self.tableView.backgroundColor = FD_WhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityManagementListCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoCommodityManagementListCell class])];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [self requestData];
}

- (void)headerRefresh{
    _page = 1;
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)requestData{
//    http://xx.com/api/Shopmanage/getGoodsList
    [[BogoNetwork shareInstance] GET:@"shop/goodsIndexUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"status":@(_type),@"page":@(_page)} success:^(BogoNetworkResponseModel * _Nonnull result) {
        if (_page == 1) {
            [self.dataArray removeAllObjects];
        }
        
        for (NSDictionary *dict in result.data) {
            BogoCommodityManagementListModel *model = [BogoCommodityManagementListModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        
        if (_page == 1) {
            [self.dataArray removeAllObjects];
        }
        
        [[FDHUDManager defaultManager] show:error ToView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

-(void)headerRefreshWithModelArr:(NSArray *)array{
    [self.dataArray removeAllObjects];
    for (NSDictionary *dict in array) {
        BogoCommodityManagementListModel *model = [BogoCommodityManagementListModel mj_objectWithKeyValues:dict];
        [self.dataArray addObject:model];
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - BogoCommodityManagementListCellDelegate
- (void)listCell:(BogoCommodityManagementListCell *)listCell didClickButton:(UIButton *)sender{
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"编辑"]) {
        BogoCommodityAddViewController *addVC = [[BogoCommodityAddViewController alloc]init];
        addVC.gid = listCell.model.gid;
        [self.navigationController pushViewController:addVC animated:YES];
    }else if ([title isEqualToString:@"查看"]){
        BogoCommodityAddViewController *addVC = [[BogoCommodityAddViewController alloc]init];
        addVC.gid = listCell.model.gid;
        addVC.isSee = YES;
        [self.navigationController pushViewController:addVC animated:YES];
    }
    else{
        if (1) {
            NSString *status = @"";
            if ([title isEqualToString:@"上架"]) {
                status = @"11";
                
                BogoAlertView *alert = [[BogoAlertView alloc]initWithTitle:@"确定上架此商品吗？" message:@""];
                [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
                [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
                    [self operateCommodity:listCell.model status:status title:title];
                }]];
                [alert show:[UIApplication sharedApplication].keyWindow];
            }else if ([title isEqualToString:@"下架"]){
                status = @"22";
                BogoAlertView *alert = [[BogoAlertView alloc]initWithTitle:@"确定下架此商品吗？" message:@""];
                [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
                [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
                    [self operateCommodity:listCell.model status:status title:title];
                }]];
                [alert show:[UIApplication sharedApplication].keyWindow];
            }else if ([title isEqualToString:@"删除"]){
                status = @"33";
                BogoAlertView *alert = [[BogoAlertView alloc]initWithTitle:@"确定要删除此商品吗？" message:@""];
                [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
                [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
                    [self operateCommodity:listCell.model status:status title:title];
                }]];
                [alert show:[UIApplication sharedApplication].keyWindow];
            }
        }else{
            NSString *url = @"";
            if ([title isEqualToString:@"上架"]) {
                url = @"api/goodsDistributionUrl";
            }else if ([title isEqualToString:@"下架"] || [title isEqualToString:@"删除"]){
                url = @"api/cancelDistributionUrl";
            }
            [[BogoNetwork shareInstance] POST:url param:@{@"token":[BogoNetwork shareInstance].token,@"gid":listCell.model.gid} success:^(BogoNetworkResponseModel * _Nonnull result) {
                [[FDHUDManager defaultManager] show:[NSString stringWithFormat:@"%@成功",title] ToView:self.view];
                [self requestData];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }
    }
}

- (void)operateCommodity:(BogoCommodityManagementListModel *)model status:(NSString *)status title:(NSString *)title{
    //    http://xx.com/api/Shopmanage/goodsStatus
    [[BogoNetwork shareInstance] POST:@"shop/editGoodsUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"gid":model.gid,@"status":status} success:^(BogoNetworkResponseModel * _Nonnull result) {
        [[FDHUDManager defaultManager] show:[NSString stringWithFormat:@"%@成功",title] ToView:self.view];
        [self requestData];
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
    BogoCommodityManagementListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoCommodityManagementListCell class]) forIndexPath:indexPath];
    
    if (self.dataArray.count > 0 ) {
        [cell setModel:self.dataArray[indexPath.row]];
    }
    
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 148;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIImage *)xy_noDataViewImage{
    return imageNamed(@"暂无商品_空状态");
}

- (NSString *)xy_noDataViewMessage{
    return @"暂无商品";
}

@end
