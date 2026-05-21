//
//  BogoOrderDetailViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/19.
//

#import "BogoOrderDetailViewController.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import "BogoShopKit.h"
#import "BogoShopFillInfoCell.h"
#import <YYKit/YYKit.h>
#import "BogoOrderDetailAddressCell.h"
#import "BogoOrderDetailCommodityCell.h"
#import "BogoOrderManageListModel.h"
#import "FDFoundationObjC.h"
#import "BogoPayKit.h"
#import "BogoCommodityTransferViewController.h"
#import "BogoPaySuccessViewController.h"
#import "BogoApplyRefundViewController.h"
#import "BogoPayTypeModel.h"
#import <MJExtension/MJExtension.h>

@interface BogoOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UIButton *leftBtn;
@property(nonatomic, strong) UIButton *middleBtn;
@property(nonatomic, strong) UIButton *rightBtn;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) BogoOrderDetailViewControllerType type;

@property(nonatomic, strong) UIButton *newLeftBtn;
@property(nonatomic, strong) UIButton *newMiddleBtn;
@property(nonatomic, strong) UIButton *newRightBtn;

@property(nonatomic, strong) BogoOrderManageListModel *model;

@end

@implementation BogoOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.so_id.length) {
        [self requestData];
    }
}

- (void)setSo_id:(NSString *)so_id{
    _so_id = so_id;
//    [self requestData];
}

- (void)requestData{
    //http://xx.com/api/Shoporder/getOrderInfo
    [[BogoNetwork shareInstance] GET:@"order_api/getOrderInfoUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.so_id,@"type":@(_listType)} success:^(BogoNetworkResponseModel * _Nonnull result) {
        self.model = [BogoOrderManageListModel mj_objectWithKeyValues:result.data];
        [self.tableView reloadData];
        if (self->_listType == BogoOrderManageViewControllerTypeShop) {
            switch (self.model.status.integerValue) {[self.leftBtn removeFromSuperview];
                case 0:
                    //                    if (![self.view.subviews containsObject:self.middleBtn]) {
                    //                        [self.view addSubview:self.middleBtn];
                    //                    }
                    //                    if (![self.view.subviews containsObject:self.rightBtn]) {
                    //                        [self.view addSubview:self.rightBtn];
                    //                    }
                    ////                    [self.middleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    //                    [self.rightBtn setTitle:@"等待买家付款" forState:UIControlStateNormal];
                    break;
                case 1:
                    //                    if (![self.view.subviews containsObject:self.middleBtn]) {
                    //                        [self.view addSubview:self.middleBtn];
                    //                    }
                    [self.view addSubview:self.rightBtn];
                    //                    [self.middleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    [self.rightBtn setTitle:@"发货" forState:UIControlStateNormal];
                    break;
                case 2:
                    if (self.model.express_number.length) {
                        [self.view addSubview:self.rightBtn];
                        [self.rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    }
                    break;
                case 3:
                    [self.view addSubview:self.rightBtn];
                    [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    break;
                case 4:
                    [self.view addSubview:self.rightBtn];
                    [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    break;
                case 5:
                    [self.view addSubview:self.rightBtn];
                    [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            if (self.model.status.integerValue == 1 || self.model.status.integerValue == 2 || self.model.status.integerValue == 3 || self.model.status.integerValue == 11) {
                if (self.model.refund_status.integerValue == 11 || self.model.refund_status.integerValue == 17) {
                    [self removeAllButton];
                    if (![self.view.subviews containsObject:self.middleBtn]) {
                        [self.view addSubview:self.middleBtn];
                    }
                    [self.middleBtn setTitle:@"拒绝" forState:UIControlStateNormal];
                    if (![self.view.subviews containsObject:self.rightBtn]) {
                        [self.view addSubview:self.rightBtn];
                    }
                    [self.rightBtn setTitle:@"同意退款" forState:UIControlStateNormal];
                }else if (self.model.refund_status.integerValue == 12) {
                    [self removeAllButton];
                    if (![self.view.subviews containsObject:self.rightBtn]) {
                        [self.view addSubview:self.rightBtn];
                    }
                    [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                }else if (self.model.refund_status.integerValue == 13){
                    [self removeAllButton];
                    if (![self.view.subviews containsObject:self.rightBtn]) {
                        [self.view addSubview:self.rightBtn];
                    }
                    [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                }else if (self.model.refund_status.integerValue == 14){
                    [self removeAllButton];
                    [self recoverShopStatus];
                }else if (self.model.refund_status.integerValue == 18){
                    [self removeAllButton];
                    [self recoverShopStatus];
                }else{
                    
                }
            }
        }else{
            switch (self.model.status.integerValue) {
                case 0:
                    [self.view addSubview:self.middleBtn];
                    [self.view addSubview:self.rightBtn];
                    [self.middleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    [self.rightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
                    break;
                case 1:
                    [self.view addSubview:self.rightBtn];
                    [self.rightBtn setTitle:@"退款" forState:UIControlStateNormal];
                    break;
                case 2:
                    if (self.model.express_number.length) {
                        [self.view addSubview:self.leftBtn];
                        [self.leftBtn setTitle:@"退款" forState:UIControlStateNormal];
                        [self.view addSubview:self.middleBtn];
                        [self.middleBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                        [self.view addSubview:self.rightBtn];
                        [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    }else{
                        [self.view addSubview:self.middleBtn];
                        [self.middleBtn setTitle:@"退款" forState:UIControlStateNormal];
                        [self.view addSubview:self.rightBtn];
                        [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    }
                    break;
                case 3:
                    [self.view addSubview:self.rightBtn];
                    [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    break;
                case 4:
                    [self.view addSubview:self.rightBtn];
                    [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    break;
                case 6:
                    [self.view addSubview:self.rightBtn];
                    [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            if (self.model.status.integerValue == 1 || self.model.status.integerValue == 2 || self.model.status.integerValue == 3 || self.model.status.integerValue == 11) {
                if (self.model.refund_status.integerValue == 11 || self.model.refund_status.integerValue == 17) {
                    [self removeAllButton];
                    if (![self.view.subviews containsObject:self.rightBtn]) {
                        [self.view addSubview:self.rightBtn];
                    }
                    [self.rightBtn setTitle:@"取消退款" forState:UIControlStateNormal];
                }else if (self.model.refund_status.integerValue == 12) {
                    [self removeAllButton];
                    if (![self.view.subviews containsObject:self.rightBtn]) {
                        [self.view addSubview:self.rightBtn];
                    }
                    [self.rightBtn setTitle:@"完成退款" forState:UIControlStateNormal];
                }else if (self.model.refund_status.integerValue == 13){
                    [self removeAllButton];
                    if (![self.view.subviews containsObject:self.rightBtn]) {
                        [self.view addSubview:self.rightBtn];
                    }
                    [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                }else if (self.model.refund_status.integerValue == 14){
                    [self removeAllButton];
                    [self recoverUserStatus];
                }else if (self.model.refund_status.integerValue == 18){
                    [self removeAllButton];
                    [self recoverUserStatus];
                }else{
                    
                }
            }
        }
        [self fixColor:self.leftBtn];
        [self fixColor:self.middleBtn];
        [self fixColor:self.rightBtn];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)removeAllButton{
    [self.leftBtn removeFromSuperview];
    [self.rightBtn removeFromSuperview];
    [self.middleBtn removeFromSuperview];
}

- (void)recoverShopStatus{
    switch (self.model.status.integerValue) {
        case 1:
            //                    if (![self.view.subviews containsObject:self.middleBtn]) {
            //                        [self.view addSubview:self.middleBtn];
            //                    }
            if (![self.view.subviews containsObject:self.rightBtn]) {
                [self.view addSubview:self.rightBtn];
            }
            //                    [self.middleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"发货" forState:UIControlStateNormal];
            break;
        case 2:
            if (self.model.express_number.length) {
                if (![self.view.subviews containsObject:self.rightBtn]) {
                    [self.view addSubview:self.rightBtn];
                }
                [self.rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            }
            break;
            
        default:
            break;
    }
}

- (void)recoverUserStatus{
    switch (self.model.status.integerValue) {
        case 1:
            if (![self.view.subviews containsObject:self.rightBtn]) {
                [self.view addSubview:self.rightBtn];
            }
            [self.rightBtn setTitle:@"退款" forState:UIControlStateNormal];
            break;
        case 2:
            if (self.model.express_number.length) {
                [self.view addSubview:self.leftBtn];
                [self.leftBtn setTitle:@"退款" forState:UIControlStateNormal];
                if (![self.view.subviews containsObject:self.middleBtn]) {
                    [self.view addSubview:self.middleBtn];
                }
                [self.middleBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                if (![self.view.subviews containsObject:self.rightBtn]) {
                    [self.view addSubview:self.rightBtn];
                }
                [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            }else{
                if (![self.view.subviews containsObject:self.middleBtn]) {
                    [self.view addSubview:self.middleBtn];
                }
                [self.middleBtn setTitle:@"退款" forState:UIControlStateNormal];
                if (![self.view.subviews containsObject:self.rightBtn]) {
                    [self.view addSubview:self.rightBtn];
                }
                [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }
}

- (void)fixColor:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"立即付款"] || [sender.titleLabel.text isEqualToString:@"确认收货"] || [sender.titleLabel.text isEqualToString:@"退款"] || [sender.titleLabel.text isEqualToString:@"发货"] || [sender.titleLabel.text isEqualToString:@"同意退款"]) {
        if (sender == self.rightBtn) {
            sender.layer.borderColor = [UIColor colorWithHexString:@"F42416"].CGColor;
            sender.layer.borderWidth = 1;
            [sender setTitleColor:[UIColor colorWithHexString:@"F42416"] forState:UIControlStateNormal];
        }else{
            sender.layer.borderColor = [UIColor colorWithHexString:@"777777"].CGColor;
            sender.layer.borderWidth = 1;
            [sender setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        }
    }else{
        sender.layer.borderColor = [UIColor colorWithHexString:@"777777"].CGColor;
        sender.layer.borderWidth = 1;
        [sender setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
    }
}

- (void)btnAction:(UIButton *)sender{
    NSString *title = sender.titleLabel.text;
    if (_listType == BogoOrderManageViewControllerTypeShop) {
        //卖家
        if ([title isEqualToString:@"取消订单"]) {
            //取消订单（买家卖家）
            BogoAlertView *alert = [[BogoAlertView alloc] initWithTitle:@"确定取消订单?" message:@""];
            [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
            [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
                //                http://xx.com/api/order_api/changeOrderStatusUrl
                [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"status":@"4"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                    [[FDHUDManager defaultManager] show:@"取消订单成功" ToView:self.view];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSString * _Nonnull error) {
                    [[FDHUDManager defaultManager] show:error ToView:self.view];
                }];
            }]];
            [alert show:[UIApplication sharedApplication].keyWindow];
        }else if ([title isEqualToString:@"发货"]) {
            //发货
            BogoCommodityTransferViewController *vc = [[BogoCommodityTransferViewController alloc]init];
            vc.so_id = self.model.so_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([title isEqualToString:@"提醒买家付款"]) {
            //提醒买家付款
        }else if ([title isEqualToString:@"查看物流"]) {
            //查看物流（买家卖家）
            [UIPasteboard generalPasteboard].string = self.model.express_number;
            [[FDHUDManager defaultManager] show:@"物流单号已复制到剪贴板" ToView:self.view];
        }else if ([title isEqualToString:@"已完成"]) {
            //已完成do nothing
        }else if ([title isEqualToString:@"收到商品并退款"]) {
            //收到商品并退款
            [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"status":@"12"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                [[FDHUDManager defaultManager] show:@"同意退款" ToView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }else if ([title isEqualToString:@"同意退款"]) {
            //同意退款
            //            http://xx.com/api/order_api/requestOrderStatusUrl
            [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"status":@"12"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                [[FDHUDManager defaultManager] show:@"同意退款" ToView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }else if ([title isEqualToString:@"退款"]) {
            //退款（卖家买家）
            //            http://xx.com/api/order_api/requestOrderStatusUrl
            [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"status":@"12"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                [[FDHUDManager defaultManager] show:@"确认退款成功" ToView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }else if ([title isEqualToString:@"拒绝"]) {
            //拒绝
            //            http://xx.com/api/order_api/requestOrderStatusUrl
            [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"status":@"14"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                [[FDHUDManager defaultManager] show:@"拒绝退款成功" ToView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }else if ([title isEqualToString:@"删除订单"]){
            BogoAlertView *alert = [[BogoAlertView alloc] initWithTitle:@"确定删除订单?" message:@""];
            [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
            [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
                //                http://xx.com/api/order_api/changeOrderStatusUrl
                [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"status":@"6"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                    //                    [[FDHUDManager defaultManager] show:@"删除订单成功" ToView:self.view];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSString * _Nonnull error) {
                    [[FDHUDManager defaultManager] show:error ToView:self.view];
                }];
            }]];
            [alert show:[UIApplication sharedApplication].keyWindow];
        }
    }else{
        //买家
        if ([title isEqualToString:@"立即付款"]){
            [self requestPayType];
        }else if ([title isEqualToString:@"退款"] || [title isEqualToString:@"退款"]){
            //退款
            //            BogoAlertView *alert = [[BogoAlertView alloc] initWithTitle:@"确定退款?" message:@""];
            //            [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
            //            [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
            BogoApplyRefundViewController *applyRefundVC = [[BogoApplyRefundViewController alloc]init];
            applyRefundVC.model = self.model;
            [self.navigationController pushViewController:applyRefundVC animated:YES];
            //            }]];
            //            [alert show:[UIApplication sharedApplication].keyWindow];
        }else if ([title isEqualToString:@"退款"]){
            //退货退款
        }else if ([title isEqualToString:@"确认收货"]){
            //确认收货
            //                http://xx.com/api/order_api/changeOrderStatusUrl
            [[BogoNetwork shareInstance] POST:@"order_api/changeOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"status":@"3"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                [[FDHUDManager defaultManager] show:@"确认收货成功" ToView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }else if ([title isEqualToString:@"取消订单"]){
            BogoAlertView *alert = [[BogoAlertView alloc] initWithTitle:@"确定取消订单?" message:@""];
            [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
            [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
                //                http://xx.com/api/order_api/changeOrderStatusUrl
                [[BogoNetwork shareInstance] POST:@"order_api/changeOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"status":@"4"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                    [[FDHUDManager defaultManager] show:@"取消订单成功" ToView:self.view];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSString * _Nonnull error) {
                    [[FDHUDManager defaultManager] show:error ToView:self.view];
                }];
            }]];
            [alert show:[UIApplication sharedApplication].keyWindow];
        }else if ([title isEqualToString:@"查看物流"]){
            [UIPasteboard generalPasteboard].string = self.model.express_number;
            [[FDHUDManager defaultManager] show:@"物流单号已复制到剪贴板" ToView:self.view];
        }else if ([title isEqualToString:@"删除订单"]){
            BogoAlertView *alert = [[BogoAlertView alloc] initWithTitle:@"确定删除订单?" message:@""];
            [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
            [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
                //                http://xx.com/api/order_api/changeOrderStatusUrl
                [[BogoNetwork shareInstance] POST:@"order_api/changeOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"status":@"5"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                    //                    [[FDHUDManager defaultManager] show:@"删除订单成功" ToView:self.view];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSString * _Nonnull error) {
                    [[FDHUDManager defaultManager] show:error ToView:self.view];
                }];
            }]];
            [alert show:[UIApplication sharedApplication].keyWindow];
        }else if ([title isEqualToString:@"取消退款"]){
            [[BogoNetwork shareInstance] POST:@"order_api/changeOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"status":@"18"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                //                    [[FDHUDManager defaultManager] show:@"删除订单成功" ToView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }else if ([title isEqualToString:@"完成退款"]){
            [[BogoNetwork shareInstance] POST:@"order_api/changeOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"status":@"13"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                //                    [[FDHUDManager defaultManager] show:@"删除订单成功" ToView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }
    }
}

- (void)requestPayType{
    //    http://xx.com/api/Shoppay/payType
    [[BogoNetwork shareInstance] GET:@"pay/getPayType" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
        FDActionSheet *as = [[FDActionSheet alloc]initWithTitle:@"" message:@""];
        for (NSDictionary *dict in result.data) {
            BogoPayTypeModel *typeModel = [BogoPayTypeModel mj_objectWithKeyValues:dict];
            [as addAction:[FDAction actionWithTitle:typeModel.name type:FDActionTypeDefault CallBack:^{
                [self realPay:typeModel.pt_id];
            }]];
        }
        [as addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
        [as show:[UIApplication sharedApplication].keyWindow];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)realPay:(NSString *)pt_id{
    //立即付款
    //            http://xx.com/api/Shoppay/doPayNew
    [[BogoNetwork shareInstance] POST:@"Shoppay/doPayNew" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"pt_id":pt_id} success:^(BogoNetworkResponseModel * _Nonnull result) {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.type != BogoOrderDetailViewControllerTypeRefund) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type != BogoOrderDetailViewControllerTypeRefund) {
        if (section == 0) {
            return 1;
        }
        if (self.listType == BogoOrderManageViewControllerTypeUser) {
            return 7;
        }else{
            return 8;
        }
    }
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type != BogoOrderDetailViewControllerTypeRefund) {
        if (indexPath.section == 0) {
            BogoOrderDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoOrderDetailAddressCell class]) forIndexPath:indexPath];
            [cell setModel:self.model];
            return cell;
        }else{
            if (indexPath.row == 0) {
                BogoOrderDetailCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoOrderDetailCommodityCell class]) forIndexPath:indexPath];
                cell.type = BogoOrderDetailCellTypeOrderDetail;
                [cell setModel:self.model];
                return cell;
            }
            BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
            [cell setType:BogoShopFillInfoCellTypeOrderTransfer + indexPath.row - 1];
            switch (indexPath.row) {
                case 1:
                    if (self.model.free_shipping.integerValue == 0) {
                        [cell setRightTitle:@"免运费"];
                        cell.rightTitleLabel.font = [UIFont systemFontOfSize:14];
                        cell.rightTitleLabel.textColor = [UIColor colorWithHexString:@"777777"];
                    }else{
                        [cell setRightTitle:[NSString stringWithFormat:@"￥%.2f",self.model.free_shipping.floatValue / 100]];
                    }
                    break;
                case 2:
                    [cell setRightTitle:self.model.order_id];
                    break;
                case 3:
                    [cell setRightTitle:[NSDate fd_getTimeFromTimestamp:self.model.add_time.doubleValue]];
                    break;
                case 4:
                    if (self.listType == BogoOrderManageViewControllerTypeShop) {
                        [cell setRightTitle:self.model.uid];
                    }else{
                        [cell setType:BogoShopFillInfoCellTypeOrderPayType];
                        [cell setRightTitle:self.model.pay_type_name];
                    }
                    break;
                case 5:
                    if (self.listType == BogoOrderManageViewControllerTypeShop) {
                        [cell setType:BogoShopFillInfoCellTypeOrderDeliver];
                        [cell setRightTitle:self.model.express_number.length ? self.model.express_name : @"无需寄件"];
                    }else{
                        [cell setType:BogoShopFillInfoCellTypeOrderDeliver];
                        [cell setRightTitle:self.model.express_number.length ? self.model.express_name : @"无需寄件"];
                    }
                    cell.rightTitleLabel.hidden = self.model.status.integerValue <= 1;
                    cell.leftTitleLabel.hidden = self.model.status.integerValue <= 1;
                    break;
                case 6:
                    if (self.listType == BogoOrderManageViewControllerTypeShop) {
                        [cell setType:BogoShopFillInfoCellTypeOrderPayType];
                        [cell setRightTitle:self.model.pay_type_name];
                    }else{
                        [cell setType:BogoShopFillInfoCellTypeOrderRemark];
                        [cell setRightTitle:self.model.user_remark];
                    }
                    break;
                case 7:
                    [cell setType:BogoShopFillInfoCellTypeOrderMessage];
                    [cell setRightTitle:self.model.user_remark];
                    break;
                default:
                    break;
            }
            return cell;
        }
    }
    if (indexPath.row == 0) {
        BogoOrderDetailCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoOrderDetailCommodityCell class]) forIndexPath:indexPath];
        cell.type = BogoOrderDetailCellTypeOrderDetail;
        return cell;
    }else if (indexPath.row > 0 && indexPath.row < 7){
        BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
        [cell setType:BogoShopFillInfoCellTypeOrderRefundReason + indexPath.row - 1];
        return cell;
    }else if (indexPath.row == 7){
        BogoOrderDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoOrderDetailAddressCell class]) forIndexPath:indexPath];
        return cell;
    }else{
        BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
        [cell setType:BogoShopFillInfoCellTypeOrderTransfer + indexPath.row - 8];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type != BogoOrderDetailViewControllerTypeRefund) {
        if (indexPath.section == 0) {
            return 69;
        }else{
            if (indexPath.row == 0) {
                return 120;
            }
            if (indexPath.row == 5) {
                if (self.model.status.integerValue > 1) {
                    return  50;
                }
                return 0;
            }
            return 50;
        }
    }
    if (indexPath.row == 0) {
        return 100;
    }else if (indexPath.row > 0 && indexPath.row < 6){
        return 50;
    }else if (indexPath.row == 6){
        return 60;
    }else if (indexPath.row == 7){
        return 85;
    }else{
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.type != BogoOrderDetailViewControllerTypeRefund) {
        if (section == 0) {
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 3)];
            headerView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
            return headerView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.type != BogoOrderDetailViewControllerTypeRefund) {
        if (section == 0) {
            return 3;
        }
    }
    return 0;
}

- (UIButton *)middleBtn{
    if (!_middleBtn) {
        _middleBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.rightBtn.fd_left - 90, FD_ScreenHeight - FD_Top_Height - FD_Bottom_SafeArea_Height - 28 - 10, 80, 28)];
        [_middleBtn setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
        [_middleBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _middleBtn.layer.cornerRadius = 14;
        _middleBtn.clipsToBounds = YES;
        [_middleBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        // gradient
        //        CAGradientLayer *gl = [CAGradientLayer layer];
        //        gl.frame = CGRectMake(0,0,FD_ScreenWidth - 70,40);
        //        gl.startPoint = CGPointMake(0, 0.5);
        //        gl.endPoint = CGPointMake(1, 0.5);
        //        gl.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:116/255.0 blue:44/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:222/255.0 green:29/255.0 blue:22/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:137/255.0 blue:96/255.0 alpha:1.0].CGColor];
        //        gl.locations = @[@(0), @(1.0f)];
        //        [_middleBtn.layer insertSublayer:gl below:_middleBtn.titleLabel.layer];
        _middleBtn.layer.borderColor = [UIColor colorWithHexString:@"#777777"].CGColor;
        _middleBtn.layer.borderWidth = 1;
    }
    return _middleBtn;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.middleBtn.fd_left - 90, FD_ScreenHeight - FD_Top_Height - FD_Bottom_SafeArea_Height - 28 - 10, 80, 28)];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
        [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _leftBtn.layer.cornerRadius = 14;
        _leftBtn.clipsToBounds = YES;
        _leftBtn.layer.borderColor = [UIColor colorWithHexString:@"#777777"].CGColor;
        _leftBtn.layer.borderWidth = 1;
        [_leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, FD_ScreenHeight - FD_Top_Height - FD_Bottom_SafeArea_Height - 28 - 10, 80, 28)];
        _rightBtn.right = FD_ScreenWidth - 10;
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"#F42416"] forState:UIControlStateNormal];
        [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _rightBtn.layer.cornerRadius = 14;
        _rightBtn.clipsToBounds = YES;
        _rightBtn.layer.borderColor = [UIColor colorWithHexString:@"F42416"].CGColor;
        _rightBtn.layer.borderWidth = 1;
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"#F42416"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        // gradient
        //        CAGradientLayer *gl = [CAGradientLayer layer];
        //        gl.frame = CGRectMake(0,0,( FD_ScreenWidth - 60 ) / 2,40);
        //        gl.startPoint = CGPointMake(0, 0.5);
        //        gl.endPoint = CGPointMake(1, 0.5);
        //        gl.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:116/255.0 blue:44/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:222/255.0 green:29/255.0 blue:22/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:137/255.0 blue:96/255.0 alpha:1.0].CGColor];
        //        gl.locations = @[@(0), @(1.0f)];
        //        [_rightBtn.layer insertSublayer:gl below:_rightBtn.titleLabel.layer];
    }
    return _rightBtn;
}

- (UIButton *)newLeftBtn{
    if (!_newLeftBtn) {
        _newLeftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 80, 28)];
        if (@available(iOS 11.0, *)) {
            _newLeftBtn.fd_bottom = self.view.fd_bottom - FD_Bottom_SafeArea_Height - 20;
        } else {
            // Fallback on earlier versions
            _newLeftBtn.fd_bottom = self.view.fd_bottom - 20;
        }
        [_newLeftBtn setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
        [_newLeftBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _newLeftBtn.layer.cornerRadius = 14;
        _newLeftBtn.clipsToBounds = YES;
        _newLeftBtn.layer.borderColor = [UIColor colorWithHexString:@"##777777"].CGColor;
        _newLeftBtn.layer.borderWidth = 1;
        [_newLeftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _newLeftBtn;
}

- (UIButton *)newMiddleBtn{
    if (!_newMiddleBtn) {
        _newMiddleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 28)];
        if (@available(iOS 11.0, *)) {
            _newMiddleBtn.fd_bottom = self.view.fd_bottom - FD_Bottom_SafeArea_Height - 20;
        } else {
            // Fallback on earlier versions
            _newMiddleBtn.fd_bottom = self.view.fd_bottom - 20;
        }
        _newMiddleBtn.centerX = self.view.centerX;
        [_newMiddleBtn setTitleColor:[UIColor colorWithHexString:@"#F42416"] forState:UIControlStateNormal];
        [_newMiddleBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _newMiddleBtn.layer.cornerRadius = 14;
        _newMiddleBtn.clipsToBounds = YES;
        _newMiddleBtn.layer.borderColor = [UIColor colorWithHexString:@"#F42416"].CGColor;
        _newMiddleBtn.layer.borderWidth = 1;
        [_newMiddleBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _newMiddleBtn;
}

- (UIButton *)newRightBtn{
    if (!_newRightBtn) {
        _newRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 28)];
        _newRightBtn.right = FD_ScreenWidth - 20;
        if (@available(iOS 11.0, *)) {
            _newRightBtn.fd_bottom = self.view.fd_bottom - FD_Bottom_SafeArea_Height - 20;
        } else {
            // Fallback on earlier versions
            _newRightBtn.fd_bottom = self.view.fd_bottom - 20;
        }
        [_newRightBtn setTitleColor:[UIColor colorWithHexString:@"#F42416"] forState:UIControlStateNormal];
        [_newRightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _newRightBtn.layer.cornerRadius = 14;
        _newRightBtn.clipsToBounds = YES;
        _newRightBtn.layer.borderColor = [UIColor colorWithHexString:@"#F42416"].CGColor;
        _newRightBtn.layer.borderWidth = 1;
        [_newRightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        // gradient
        //        CAGradientLayer *gl = [CAGradientLayer layer];
        //        gl.frame = CGRectMake(0,0,( FD_ScreenWidth - 60 ) / 2,40);
        //        gl.startPoint = CGPointMake(0, 0.5);
        //        gl.endPoint = CGPointMake(1, 0.5);
        //        gl.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:116/255.0 blue:44/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:222/255.0 green:29/255.0 blue:22/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:137/255.0 blue:96/255.0 alpha:1.0].CGColor];
        //        gl.locations = @[@(0), @(1.0f)];
        //        [_newRightBtn.layer insertSublayer:gl below:_newRightBtn.titleLabel.layer];
    }
    return _newRightBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight - 48 - FD_Top_Height - FD_Bottom_SafeArea_Height - 10) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        NSBundle *bundle = kShopKitBundle;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoOrderDetailAddressCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoOrderDetailAddressCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoOrderDetailCommodityCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoOrderDetailCommodityCell class])];
    }
    return _tableView;
}

@end
