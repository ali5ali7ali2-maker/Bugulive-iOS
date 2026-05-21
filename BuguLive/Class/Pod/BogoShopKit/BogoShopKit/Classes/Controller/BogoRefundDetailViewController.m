//
//  BogoRefundDetailViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import "BogoRefundDetailViewController.h"
#import "BogoOrderDetailCommodityCell.h"
#import "BogoShopFillInfoCell.h"
#import "BogoCommodityInfoCell.h"
#import "BogoShopFillInfoExtCell.h"
#import "BogoShopFillInfoTextCell.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import "BogoShopKit.h"
#import "BogoRefundDetailModel.h"
#import "BogoOrderManageListModel.h"
#import <MJExtension/MJExtension.h>
#import "BogoRefundDetailStatuCell.h"
#import "BogoApplyRefundViewController.h"
#import <YYKit/YYKit.h>
#import "BogoOrderManageListModel.h"
#import "BogoNetworkKit.h"
#import "BogoNetworkResponseModel.h"

@interface BogoRefundDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BogoShopFillInfoExtCellDelegate>

@property(nonatomic, strong) BogoRefundDetailModel *model;
@property(nonatomic, strong) UIButton *leftBtn;
@property(nonatomic, strong) UIButton *rightBtn;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation BogoRefundDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款详情";
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:imageNamed(@"shop_back") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIBarButtonItem *fixItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixItem.width = -3;
    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
        backBtn.contentEdgeInsets =UIEdgeInsetsMake(0, -9, 0, 0);
        backBtn.imageEdgeInsets =UIEdgeInsetsMake(0, -9, 0, 0);
        self.navigationItem.leftBarButtonItem = backItem;
    }else{
        self.navigationItem.leftBarButtonItems = @[fixItem,backItem];
    }
    [self.view addSubview:self.tableView];
}

- (void)backBtnAction:(UIButton *)sender{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setSo_id:(NSString *)so_id{
    _so_id = so_id;
    [self requestData];
}

- (void)requestData{
//http://xx.com/api/Shoporder/getRefundInfo
    [[BogoNetwork shareInstance] GET:@"order_api/getRefundInfoUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.so_id} success:^(BogoNetworkResponseModel * _Nonnull result) {
        self.model = [BogoRefundDetailModel mj_objectWithKeyValues:result.data];
        [self.tableView reloadData];
        if (self.listType == BogoOrderManageViewControllerTypeShop) {
            //卖家
            if (self.orderModel.refund_status.integerValue == 11 || self.orderModel.refund_status.integerValue == 17) {
                [self.view addSubview:self.leftBtn];
                [self.leftBtn setTitle:@"拒绝" forState:UIControlStateNormal];
                [self.view addSubview:self.rightBtn];
                [self.rightBtn setTitle:@"同意退款" forState:UIControlStateNormal];
            }else if (self.orderModel.refund_status.integerValue == 13){
                [self.view addSubview:self.rightBtn];
                [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            }
        }else{
            //买家
            if (self.orderModel.refund_status.integerValue == 11 || self.orderModel.refund_status.integerValue == 17) {
                [self.view addSubview:self.rightBtn];
                [self.rightBtn setTitle:@"取消退款" forState:UIControlStateNormal];
            }else if (self.orderModel.refund_status.integerValue == 12) {
                [self.view addSubview:self.rightBtn];
                [self.rightBtn setTitle:@"完成退款" forState:UIControlStateNormal];
                self.rightBtn.layer.borderColor = [UIColor colorWithHexString:@"#777777"].CGColor;
                self.rightBtn.layer.borderWidth = 1;
                [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
            }else if (self.orderModel.refund_status.integerValue == 14){
                [self.view addSubview:self.rightBtn];
                if (self.orderModel.status.integerValue > 1) {
                    [self.rightBtn setTitle:@"退款" forState:UIControlStateNormal];
                }else{
                    [self.rightBtn setTitle:@"退款" forState:UIControlStateNormal];
                }
            }else if (self.orderModel.refund_status.integerValue == 18){
                [self.view addSubview:self.rightBtn];
                if (self.orderModel.status.integerValue > 1) {
                    [self.rightBtn setTitle:@"退款" forState:UIControlStateNormal];
                }else{
                    [self.rightBtn setTitle:@"退款" forState:UIControlStateNormal];
                }
            }else if (self.orderModel.refund_status.integerValue == 13){
                [self.view addSubview:self.rightBtn];
                [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            }
        }
        [self fixColor:self.rightBtn];
        [self fixColor:self.leftBtn];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
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
            if ([title isEqualToString:@"同意退款"]) {
                //同意退款
                //            http://xx.com/api/Shoporder/requestOrderStatus
                [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"status":@"12"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                    [[FDHUDManager defaultManager] show:@"同意退款" ToView:self.view];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSString * _Nonnull error) {
                    [[FDHUDManager defaultManager] show:error ToView:self.view];
                }];
            }else if ([title isEqualToString:@"退款"]) {
                //退款（卖家买家）
                //            http://xx.com/api/Shoporder/requestOrderStatus
                [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"so_id":self.model.so_id,@"status":@"12"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                    [[FDHUDManager defaultManager] show:@"确认退款成功" ToView:self.view];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSString * _Nonnull error) {
                    [[FDHUDManager defaultManager] show:error ToView:self.view];
                }];
            }else if ([title isEqualToString:@"拒绝"]) {
                //拒绝
    //            http://xx.com/api/Shoporder/requestOrderStatus
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
            if ([title isEqualToString:@"退款"] || [title isEqualToString:@"退款"]){
                //退款
    //            BogoAlertView *alert = [[BogoAlertView alloc] initWithTitle:@"确定退款?" message:@""];
    //            [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
    //            [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
                    BogoApplyRefundViewController *applyRefundVC = [[BogoApplyRefundViewController alloc]init];
                    applyRefundVC.model = self.model;
                    [self.navigationController pushViewController:applyRefundVC animated:YES];
    //            }]];
    //            [alert show:[UIApplication sharedApplication].keyWindow];
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

#pragma mark - Section
- (void)extCell:(BogoShopFillInfoExtCell *)extCell didClickImageBtn:(UIButton *)sender{
    NSArray *imageUrlArray = [self.model.refund_img componentsSeparatedByString:@","];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *url in imageUrlArray) {
        if (url.length > 1) {
            FDPhotoGroupItem *item = [[FDPhotoGroupItem alloc]init];
            item.largeImageURL = [NSURL URLWithString:url];
//            item.thumbView = sender.imageView;
            [tempArray addObject:item];
        }
    }
    
    for (int i = 0; i < tempArray.count; i++) {
        FDPhotoGroupItem *item = tempArray[i];
        if (i == sender.tag - kBogoShopFillInfoExtCellBaseTag) {
            item.thumbView = sender.imageView;
        }
    }
    
    FDPhotoGroupView *groupView = [[FDPhotoGroupView alloc]initWithGroupItems:tempArray];
    [groupView presentFromImageView:sender.imageView toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.listType == BogoOrderManageViewControllerTypeShop) {
        if (self.model.refund_img.length > 3) {
            return 10;
        }
        return 9;
    }else{
        if (self.model.refund_img.length > 3) {
            return 9;
        }
        return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            BogoOrderDetailCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoOrderDetailCommodityCell class]) forIndexPath:indexPath];
            cell.type = BogoOrderDetailCellTypeOrderDetail;
            BogoOrderManageListModel *model = [BogoOrderManageListModel mj_objectWithKeyValues:self.model.mj_keyValues];
            [cell setModel:model];
            return cell;
        }
            break;
        case 1:
        {
            BogoRefundDetailStatuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoRefundDetailStatuCell" forIndexPath:indexPath];
//            退款详情状态 //0退款中,1已退款,2拒绝 3取消退款
            if (self.listType == BogoOrderManageViewControllerTypeShop) {
                switch (self.orderModel.refund_status.integerValue) {
                    case 11:
                    case 17:
                        cell.statusLabel.text = @"请等待商家处理";
                        cell.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#F42416"];
                        break;
                    case 12:
                        cell.statusLabel.text = @"退款中";
                        cell.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#F42416"];
                        break;
                    case 13:
                        cell.statusLabel.text = @"已确认退款";
                        cell.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#F42416"];
                        break;
                    case 18:
                        cell.statusLabel.text = @"已取消退款";
                        cell.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#F42416"];
                        break;
                    case 14:
                        cell.statusLabel.text = @"商家拒绝退款";
                        cell.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#F42416"];
                        break;
                    default:
                        break;
                }
            }else{
                switch (self.orderModel.refund_status.integerValue) {
                    case 11:
                    case 17:
                        cell.statusLabel.text = @"请等待商家处理";
                        cell.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#F42416"];
                        break;
                    case 12:
                        cell.statusLabel.text = @"退款中";
                        cell.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#F42416"];
                        break;
                    case 13:
                        cell.statusLabel.text = @"已确认退款";
                        cell.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#F42416"];
                        break;
                    case 18:
                        cell.statusLabel.text = @"已取消退款";
                        cell.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#F42416"];
                        break;
                    case 14:
                        cell.statusLabel.text = @"商家拒绝退款";
                        cell.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#F42416"];
                        break;
                    default:
                        break;
                }
            }
            
            return cell;
        }
            break;
        case 2:
        {
            BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
            [cell setType:BogoShopFillInfoCellTypeOrderRefundReason];
            [cell setRightTitle:self.model.reason];
            return cell;
        }
            break;
        case 3:
        {
            BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
            [cell setType:BogoShopFillInfoCellTypeOrderRefundAccount];
            cell.rightTitleLabel.textColor = [UIColor qmui_colorWithHexString:@"#F42416"];
            NSString *priceText = [NSString stringWithFormat:@"￥%.2f",self.model.money.floatValue/100];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:priceText];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, @"￥".length)];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium] range:NSMakeRange(@"￥".length, attr.length - @"￥".length)];
            cell.rightTitleLabel.attributedText = attr;
            return cell;
        }
            break;
        case 4:
        {
            if (self.listType == BogoOrderManageViewControllerTypeShop) {
                BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
                [cell setType:BogoShopFillInfoCellTypeOrderID];
                [cell setRightTitle:self.orderModel.uid];
                return cell;
            }else{
                BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
                [cell setType:BogoShopFillInfoCellTypeOrderRefundPhone];
                [cell setRightTitle:self.model.tel];
                return cell;
            }
        }
            break;
        case 5:
        {
            if (self.listType == BogoOrderManageViewControllerTypeShop) {
                BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
                [cell setType:BogoShopFillInfoCellTypeOrderRefundPhone];
                [cell setRightTitle:self.model.tel];
                return cell;
            }else{
                BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
                [cell setType:BogoShopFillInfoCellTypeOrderRefundApplyTime];
                [cell setRightTitle:[NSDate fd_getTimeFromTimestamp:self.model.create_time.doubleValue]];
                return cell;
            }
            
        }
            break;
        case 6:
        {
            if (self.listType == BogoOrderManageViewControllerTypeShop) {
                BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
                [cell setType:BogoShopFillInfoCellTypeOrderRefundApplyTime];
                [cell setRightTitle:[NSDate fd_getTimeFromTimestamp:self.model.create_time.doubleValue]];
                return cell;
            }else{
                BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
                [cell setType:BogoShopFillInfoCellTypeOrderRefundNo];
                [cell setRightTitle:self.model.order_id];
                return cell;
            }
        }
            break;
        case 7:
            if (self.listType == BogoOrderManageViewControllerTypeShop) {
                BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
                [cell setType:BogoShopFillInfoCellTypeOrderRefundNo];
                [cell setRightTitle:self.model.order_id];
                return cell;
            }else{
                //退款说明
                BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
                [cell setType:BogoShopFillInfoCellTypeOrderRefundInfo];
                [cell setRightTitle:self.model.content];
                return cell;
            }
            break;
        case 8:
            if (self.listType == BogoOrderManageViewControllerTypeShop) {
                //退款说明
                BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
                [cell setType:BogoShopFillInfoCellTypeOrderRefundInfo];
                [cell setRightTitle:self.model.content];
                return cell;
            }else{
                //退款凭证
                BogoShopFillInfoExtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoShopFillInfoExtCell" forIndexPath:indexPath];
                [cell setIsSee:YES];
                if (self.model) {
                    [cell setRefundModel:self.model];
                    cell.delegate = self;
                }
                return cell;
            }
            break;
        case 9:
            if (self.listType == BogoOrderManageViewControllerTypeShop) {
                //退款凭证
                BogoShopFillInfoExtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoShopFillInfoExtCell" forIndexPath:indexPath];
                [cell setIsSee:YES];
                if (self.model) {
                    [cell setRefundModel:self.model];
                    cell.delegate = self;
                }
                return cell;
            }
            return nil;
            break;

        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 120;
            break;
        case 1:
            return 17;
            break;
        case 7:
            if (self.listType == BogoOrderManageViewControllerTypeUser) {
                return MAX([self.model.content boundingRectWithSize:CGSizeMake(FD_ScreenWidth - 107.5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height + 33, 50);
            }
            return 50;
        case 8:
            if (self.listType == BogoOrderManageViewControllerTypeUser) {
                return 170;
            }else{
                return MAX([self.model.content boundingRectWithSize:CGSizeMake(FD_ScreenWidth - 107.5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height + 33, 50);
            }
            break;
        case 9:
            if (self.listType == BogoOrderManageViewControllerTypeShop) {
                return 170;
            }
            return 50;
            break;
        default:
            return 50;
            break;
    }
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(FD_ScreenWidth - 185, FD_ScreenHeight - FD_Top_Height - FD_Bottom_SafeArea_Height - 28 - 10, 80, 28)];
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

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight - 48 - FD_Bottom_SafeArea_Height - FD_Top_Height - 10) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        NSBundle *bundle = kShopKitBundle;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoOrderDetailCommodityCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoOrderDetailCommodityCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoRefundDetailStatuCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoRefundDetailStatuCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoExtCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoExtCell class])];
    }
    return _tableView;
}

@end
