//
//  BogoOrderManageListViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import "BogoOrderManageListViewController.h"
#import "BogoOrderManageListModel.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import "BogoOrderManageListCell.h"
#import "BogoAlertView.h"
#import "BogoApplyRefundViewController.h"
#import "BogoOrderDetailViewController.h"
#import "BogoRefundDetailViewController.h"
#import "BogoCommodityTransferViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "BogoPayOrderModel.h"
#import "BogoPayKit.h"
#import "BogoPaySuccessViewController.h"
#import "BogoPayTypeModel.h"
#import <MJExtension/MJExtension.h>

@interface BogoOrderManageListViewController ()<BogoOrderManageListCellDeleghate>

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger page;

@end

@implementation BogoOrderManageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = FD_WhiteColor;
    self.tableView.backgroundColor = FD_WhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoOrderManageListCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoOrderManageListCell class])];
    _page = 1;
//    [self requestData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
    self.tableView.frame = CGRectMake(self.tableView.fd_left, 0, FD_ScreenWidth, FD_ScreenHeight - 40 - 44 - [UIApplication sharedApplication].statusBarFrame.size.height);
}

- (void)headerRefresh{
    _page = 1;
    [self requestData];
}

- (void)footerRefresh{
    _page ++;
    [self requestData];
}

- (void)requestData{
    NSString *url = @"order_api/shopOrderListUrl";
    if (_listType == BogoOrderManageViewControllerTypeUser) {
        url = @"order_api/userOrderListUrl";
    }
//    http://xx.com/api/shoporder/shopOrderList
    [[BogoNetwork shareInstance] GET:url param:@{@"token":[BogoNetwork shareInstance].token,@"status":@(_type),@"page":@(_page)} success:^(BogoNetworkResponseModel * _Nonnull result) {
        if (self->_page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dict in result.data[@"data"]) {
            BogoOrderManageListModel *model = [BogoOrderManageListModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if ([result.data[@"data"] count] < [result.data[@"per_page"] integerValue]) {
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

#pragma mark - BogoOrderManageListCellDeleghate
- (void)listCell:(BogoOrderManageListCell *)listCell didClickBtn:(UIButton *)sender{
    NSString *title = sender.titleLabel.text;
    if (_listType == BogoOrderManageViewControllerTypeShop) {
        //卖家
        if ([title isEqualToString:@"取消订单"]) {
            //取消订单（买家卖家）
            BogoAlertView *alert = [[BogoAlertView alloc] initWithTitle:@"确定取消订单?" message:@""];
            [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
            [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
                //                http://xx.com/api/order_api/changeOrderStatusUrl
                [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":listCell.model.so_id,@"status":@"4"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                    [[FDHUDManager defaultManager] show:@"取消订单成功" ToView:self.view];
                    [self headerRefresh];
                } failure:^(NSString * _Nonnull error) {
                    [[FDHUDManager defaultManager] show:error ToView:self.view];
                }];
            }]];
            [alert show:[UIApplication sharedApplication].keyWindow];
        }else if ([title isEqualToString:@"发货"]) {
            //发货
            BogoCommodityTransferViewController *vc = [[BogoCommodityTransferViewController alloc]init];
            vc.so_id = listCell.model.so_id;
            vc.clickTransferBlock = ^(BOOL isSuccess) {
                [self headerRefresh];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([title isEqualToString:@"提醒买家付款"]) {
            //提醒买家付款
        }else if ([title isEqualToString:@"查看物流"]) {
            //查看物流（买家卖家）
            [UIPasteboard generalPasteboard].string = listCell.model.express_number;
            [[FDHUDManager defaultManager] show:@"物流单号已复制到剪贴板" ToView:self.view];
        }else if ([title isEqualToString:@"已完成"]) {
            //已完成do nothing
        }else if ([title isEqualToString:@"收到商品并退款"]) {
            //收到商品并退款
            [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":listCell.model.so_id,@"status":@"12"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                [[FDHUDManager defaultManager] show:@"同意退款" ToView:self.view];
                [self headerRefresh];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }else if ([title isEqualToString:@"同意退款"]) {
            //同意退款
            //            http://xx.com/api/Shoporder/requestOrderStatus
            [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":listCell.model.so_id,@"status":@"12"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                [[FDHUDManager defaultManager] show:@"同意退款" ToView:self.view];
                [self headerRefresh];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }else if ([title isEqualToString:@"退款"]) {
            //退款（卖家买家）
            //            http://xx.com/api/Shoporder/requestOrderStatus
            [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":listCell.model.so_id,@"status":@"12"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                [[FDHUDManager defaultManager] show:@"确认退款成功" ToView:self.view];
                [self headerRefresh];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }else if ([title isEqualToString:@"拒绝"]) {
            //拒绝
//            http://xx.com/api/Shoporder/requestOrderStatus
            [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":listCell.model.so_id,@"status":@"14"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                [[FDHUDManager defaultManager] show:@"拒绝退款成功" ToView:self.view];
                [self headerRefresh];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }else if ([title isEqualToString:@"删除订单"]){
            BogoAlertView *alert = [[BogoAlertView alloc] initWithTitle:@"确定删除订单?" message:@""];
            [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
            [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
//                http://xx.com/api/order_api/changeOrderStatusUrl
                [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":listCell.model.so_id,@"status":@"6"} success:^(BogoNetworkResponseModel * _Nonnull result) {
//                    [[FDHUDManager defaultManager] show:@"删除订单成功" ToView:self.view];
                    [self headerRefresh];
                } failure:^(NSString * _Nonnull error) {
                    [[FDHUDManager defaultManager] show:error ToView:self.view];
                }];
            }]];
            [alert show:[UIApplication sharedApplication].keyWindow];
        }
    }else{
        //买家
        if ([title isEqualToString:@"立即付款"]){
            [self requestPayType:listCell.model];
        }else if ([title isEqualToString:@"退款"] || [title isEqualToString:@"退款"]){
            //退款
//            BogoAlertView *alert = [[BogoAlertView alloc] initWithTitle:@"确定退款?" message:@""];
//            [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
//            [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
                BogoApplyRefundViewController *applyRefundVC = [[BogoApplyRefundViewController alloc]init];
                applyRefundVC.model = listCell.model;
                [self.navigationController pushViewController:applyRefundVC animated:YES];
//            }]];
//            [alert show:[UIApplication sharedApplication].keyWindow];
        }else if ([title isEqualToString:@"退款"]){
            //退货退款
        }else if ([title isEqualToString:@"确认收货"]){
            //确认收货
            //                http://xx.com/api/order_api/changeOrderStatusUrl
            [[BogoNetwork shareInstance] POST:@"order_api/changeOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":listCell.model.so_id,@"status":@"3"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                [[FDHUDManager defaultManager] show:@"确认收货成功" ToView:self.view];
                [self headerRefresh];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }else if ([title isEqualToString:@"取消订单"]){
            BogoAlertView *alert = [[BogoAlertView alloc] initWithTitle:@"确定取消订单?" message:@""];
            [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
            [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
//                http://xx.com/api/order_api/changeOrderStatusUrl
                [[BogoNetwork shareInstance] POST:@"order_api/changeOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":listCell.model.so_id,@"status":@"4"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                    [[FDHUDManager defaultManager] show:@"取消订单成功" ToView:self.view];
                    [self headerRefresh];
                } failure:^(NSString * _Nonnull error) {
                    [[FDHUDManager defaultManager] show:error ToView:self.view];
                }];
            }]];
            [alert show:[UIApplication sharedApplication].keyWindow];
        }else if ([title isEqualToString:@"查看物流"]){
            [UIPasteboard generalPasteboard].string = listCell.model.express_number;
            [[FDHUDManager defaultManager] show:@"物流单号已复制到剪贴板" ToView:self.view];
        }else if ([title isEqualToString:@"删除订单"]){
            BogoAlertView *alert = [[BogoAlertView alloc] initWithTitle:@"确定删除订单?" message:@""];
            [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
            [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
//                http://xx.com/api/order_api/changeOrderStatusUrl
                [[BogoNetwork shareInstance] POST:@"order_api/changeOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":listCell.model.so_id,@"status":@"5"} success:^(BogoNetworkResponseModel * _Nonnull result) {
//                    [[FDHUDManager defaultManager] show:@"删除订单成功" ToView:self.view];
                    [self headerRefresh];
                } failure:^(NSString * _Nonnull error) {
                    [[FDHUDManager defaultManager] show:error ToView:self.view];
                }];
            }]];
            [alert show:[UIApplication sharedApplication].keyWindow];
        }else if ([title isEqualToString:@"取消退款"]){
            [[BogoNetwork shareInstance] POST:@"order_api/changeOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":listCell.model.so_id,@"status":@"18"} success:^(BogoNetworkResponseModel * _Nonnull result) {
//                    [[FDHUDManager defaultManager] show:@"删除订单成功" ToView:self.view];
                [self headerRefresh];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }else if ([title isEqualToString:@"完成退款"]){
            [[BogoNetwork shareInstance] POST:@"order_api/changeOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":listCell.model.so_id,@"status":@"13"} success:^(BogoNetworkResponseModel * _Nonnull result) {
//                    [[FDHUDManager defaultManager] show:@"删除订单成功" ToView:self.view];
                [self headerRefresh];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }
    }
}

- (void)realPay:(BogoOrderManageListModel *)model pt_id:(NSString *)pt_id{
    //立即付款
    //            http://xx.com/api/Shoppay/doPayNew
    [[BogoNetwork shareInstance] GET:@"pay/doPayNew" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":model.so_id,@"pt_id":pt_id} success:^(BogoNetworkResponseModel * _Nonnull result) {
        BogoPayOrderModel *model = [BogoPayOrderModel mj_objectWithKeyValues:result.data];
        [[BogoPayManager defaultManager] pay:model.type == 1 ? BogoPayTypeAliPay : BogoPayTypeWeChat orderModel:model];
        [[BogoPayManager defaultManager] setBogo_payResponseCallBack:^(BogoPayResponseModel * _Nonnull responseModel) {
            if (responseModel.isSuccess) {
                BogoPaySuccessViewController *paySuccessVC = [[BogoPaySuccessViewController alloc]initWithNibName:NSStringFromClass([BogoPaySuccessViewController class]) bundle:kShopKitBundle];
                paySuccessVC.model = model;
                [self.navigationController pushViewController:paySuccessVC animated:YES];
            }else{
                [[FDHUDManager defaultManager] show:@"支付失败" ToView:self.view];
            }
        }];
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

- (void)requestPayType:(BogoOrderManageListModel *)model{
//    http://xx.com/api/Shoppay/payType
    [[BogoNetwork shareInstance] GET:@"pay/getPayType" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
        FDActionSheet *as = [[FDActionSheet alloc]initWithTitle:@"" message:@""];
        for (NSDictionary *dict in result.data) {
            BogoPayTypeModel *typeModel = [BogoPayTypeModel mj_objectWithKeyValues:dict];
            [as addAction:[FDAction actionWithTitle:typeModel.name type:FDActionTypeDefault CallBack:^{
                [self realPay:model pt_id:typeModel.pt_id];
            }]];
        }
        [as addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
        [as show:[UIApplication sharedApplication].keyWindow];
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
    BogoOrderManageListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoOrderManageListCell class]) forIndexPath:indexPath];
    [cell setListType:_listType];
    BogoOrderManageListModel *model = [self.dataArray objectAtIndex:indexPath.row];

    [cell setModel:model];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_listType == BogoOrderManageViewControllerTypeShop) {
        BogoOrderManageListModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if (model.status.integerValue == 0 || model.refund_status.integerValue == 12 || (model.status.integerValue == 2 && !model.express_number.length && model.refund_status.integerValue != 17 && model.refund_status.integerValue != 11 && model.refund_status.integerValue != 13)) {
            return 180;
        }
    }
    return 225;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoOrderManageListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.model.refund_status.integerValue > 0 && cell.model.refund_status.integerValue != 14 && cell.model.refund_status.integerValue != 18) {
        BogoRefundDetailViewController *vc = [[BogoRefundDetailViewController alloc]init];
        vc.so_id = cell.model.so_id;
        vc.listType = _listType;
        BogoOrderManageListModel *model = [self.dataArray objectAtIndex:indexPath.row];
        vc.orderModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        BogoOrderDetailViewController *vc = [[BogoOrderDetailViewController alloc]init];
        vc.listType = _listType;
        vc.so_id = cell.model.so_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
