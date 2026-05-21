//
//  BogoOrderSubmitViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/24.
//

#import "BogoOrderSubmitViewController.h"
#import "BogoCartCell.h"
#import "BogoCartHeaderView.h"
#import "BogoCartBottomView.h"
#import "FDUIKitObjC.h"
#import "NSKeyedArchiver+FD.h"
#import "BogoCommodityDetailModel.h"
#import <YYKit/YYKit.h>
#import "BogoOrderSubmitAddressCell.h"
#import "BogoOrderSubmitSumCell.h"
#import "BogoAddressListViewController.h"
#import "BogoShopFillInfoCell.h"
#import "BogoCartModel.h"
#import "BogoShopKit.h"
#import "BogoAddressListModel.h"
#import "BogoPayKit.h"
#import "BogoPaySuccessViewController.h"
#import "BogoAddressModel.h"
#import "BogoShopFillInfoTextCell.h"
#import "BogoPayTypeModel.h"
#import "BogoDeductionCell.h"
#import "BogoDeductionModel.h"
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>

@interface BogoOrderSubmitViewController ()<UITableViewDelegate,UITableViewDataSource,BogoCartBottomViewDelegate,BogoShopFillInfoTextCellDelegate,BogoDeductionCellDelegate,BogoCartCellDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) BogoCartBottomView *bottomView;
@property(nonatomic, strong) BogoAddressListModel *addressModel;
@property(nonatomic, strong) NSMutableDictionary *param;
@property(nonatomic, strong) BogoAddressModel *addressDataModel;

@property(nonatomic, strong) NSMutableArray *remarkArray;

@property(nonatomic, strong) BogoPayOrderModel *orderModel;

@property(nonatomic, strong) BogoDeductionModel *deductionModel;

@end

@implementation BogoOrderSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认订单";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(FD_Bottom_SafeArea_Height + 50);
    }];
    [self.param setObject:[BogoNetwork shareInstance].token forKey:@"token"];
//    [self.param setObject:@"0" forKey:@"is_deduction"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceivePayResult:) name:@"PayResult" object:nil];
    [self requestAddressData];
}

- (void)onReceivePayResult:(NSNotification *)noti{
    NSString *str = noti.object;
    if ([str isEqualToString:@"ali_success"]) {
        BogoPaySuccessViewController *paySuccessVC = [[BogoPaySuccessViewController alloc]initWithNibName:NSStringFromClass([BogoPaySuccessViewController class]) bundle:kShopKitBundle];
        paySuccessVC.model = self.orderModel;
        [self.navigationController pushViewController:paySuccessVC animated:YES];
    }else if ([str isEqualToString:@"fail"]){
        [[FDHUDManager defaultManager] show:@"支付失败" ToView:self.view];
    }
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.tableView reloadData];
    double price = model.attr[model.selectAttrIndex].price.doubleValue * model.count / 100 + model.free_shipping.floatValue/100;
    [self.bottomView setPrice:[NSString stringWithFormat:@"%.2f",price]];
    [self.param setObject:model.gid forKey:@"gid"];
    [self.param setObject:model.attr[model.selectAttrIndex].sa_id forKey:@"attr_id"];
    [self.param setObject:@"1" forKey:@"shop_type"];
    [self.remarkArray addObject:@{@"sid":@"",@"user_remark":@""}];
    [self.param setObject:@"1" forKey:@"type"];
    
    //抵扣鑫值
//    /shopapi/order_api/getDeduction
    NSMutableArray *sa_ids = [NSMutableArray array];
    [sa_ids setArray:@[@{@"sa_id":self.model.attr[self.model.selectAttrIndex].sa_id,@"num":@(self.model.count)}]];
//    [[BogoNetwork shareInstance] POST:@"order_api/getDeduction" param:@{@"sa_ids":sa_ids.mj_JSONString} success:^(BogoNetworkResponseModel * _Nonnull result) {
////        "money": 6,
////        "ticket_sum": 6,
//        self.deductionModel = [BogoDeductionModel mj_objectWithKeyValues:result.data];
//        NSIndexPath *indexPath;
//        indexPath = [NSIndexPath indexPathForRow:4 inSection:1];
//        [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
////        BogoDeductionCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
////        [cell setTitle:[NSString stringWithFormat:@"可用%@鑫值抵扣%@元",self.deductionModel.ticket_sum,self.deductionModel.money]];
////        [self.bottomView setPrice:[NSString stringWithFormat:@"%.2f",self.bottomView.price.doubleValue - self.deductionModel.money.doubleValue]];
//    } failure:^(NSString * _Nonnull error) {
//        [[FDHUDManager defaultManager] show:error ToView:self.view];
//    }];
}

- (void)setUid:(NSString *)uid{
    _uid = uid;
    if (uid) {
        [self.param setObject:uid forKey:@"share_uid"];
    }
}

- (void)setDistribution_id:(NSString *)distribution_id{
    _distribution_id = distribution_id;
    if (distribution_id) {
        [self.param setObject:distribution_id forKey:@"distribution_id"];
    }
}

- (void)setCartDataArray:(NSArray *)cartDataArray{
    _cartDataArray = cartDataArray;
    [self.tableView reloadData];
    double price = 0;
    for (BogoCartModel *model in cartDataArray) {
        for (BogoCartListModel *listModel in model.cart_list) {
            price = price + listModel.price.doubleValue * listModel.num / 100;
            price = price + listModel.free_shipping.doubleValue / 100;
        }
        [self.remarkArray addObject:@{@"sid":@"",@"user_remark":@""}];
    }
    [self.bottomView setPrice:[NSString stringWithFormat:@"%.2f",price]];
    [self.param setObject:@"2" forKey:@"type"];
    
    
    //抵扣鑫值
//    /shopapi/order_api/getDeduction
    NSMutableArray *sa_ids = [NSMutableArray array];
    for (BogoCartModel *model in self.cartDataArray) {
        for (BogoCartListModel *listModel in model.cart_list) {
            NSDictionary *dict = @{@"sa_id":listModel.sa_id,@"num":@(listModel.num)};
            [sa_ids addObject:dict];
        }
    }
//    [[BogoNetwork shareInstance] POST:@"order_api/getDeduction" param:@{@"sa_ids":sa_ids.mj_JSONString} success:^(BogoNetworkResponseModel * _Nonnull result) {
////        "money": 6,
////        "ticket_sum": 6,
//        self.deductionModel = [BogoDeductionModel mj_objectWithKeyValues:result.data];
//        NSIndexPath *indexPath;
//        BogoCartModel *model = self.cartDataArray.lastObject;
//        indexPath = [NSIndexPath indexPathForRow:model.cart_list.count + 2 inSection:self.cartDataArray.count];
//        [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
////        [self.bottomView setPrice:[NSString stringWithFormat:@"%.2f",self.bottomView.price.doubleValue - self.deductionModel.money.doubleValue]];
//    } failure:^(NSString * _Nonnull error) {
//        [[FDHUDManager defaultManager] show:error ToView:self.view];
//    }];
}

- (void)requestAddressData{
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[kShopKitBundle pathForResource:@"cityJson" ofType:@"json"]] options:NSJSONReadingMutableContainers error:nil];
//    BogoNetworkResponseModel *result = [BogoNetworkResponseModel mj_objectWithKeyValues:dict];
//    BogoAddressModel *model = [BogoAddressModel mj_objectWithKeyValues:result.data];
//    for (BogoProvinceModel *provinceModel in model.province_list) {
//        NSMutableArray *tempCityArray = [NSMutableArray array];
//        for (BogoCityModel *cityModel in model.city_list) {
//            NSMutableArray *tempAreaArray = [NSMutableArray array];
//            for (BogoAreaModel *areaModel in model.county_list) {
//                if ([areaModel.p isEqualToString:cityModel.code]) {
//                    [tempAreaArray addObject:areaModel];
//                }
//            }
//            if ([cityModel.p isEqualToString:provinceModel.code]) {
//                [tempCityArray addObject:cityModel];
//            }
//            cityModel.arealist = tempAreaArray;
//        }
//        provinceModel.citylist = tempCityArray;
//    }
    self.addressDataModel = [BogoNetwork shareInstance].addressModel;
    [self requestData];
}

#pragma mark - BogoCartCellDelegate
- (void)cartCell:(BogoCartCell *)cartCell didInputValue:(NSInteger)num{
    if (self.model) {
        self.model.count = num;
        double price = self.model.attr[cartCell.model.selectAttrIndex].price.doubleValue * self.model.count / 100 + self.model.free_shipping.floatValue;
        [self.bottomView setPrice:[NSString stringWithFormat:@"%.2f",price]];
        
    }else{
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cartCell];
        BogoCartModel *model = self.cartDataArray[indexPath.section - 1];
        for (BogoCartListModel *listModel in model.cart_list) {
            if ([cartCell.listModel.gid isEqualToString:listModel.gid]) {
                listModel.num = num;
            }
        }
        double price = 0;
        for (BogoCartModel *model in self.cartDataArray) {
            for (BogoCartListModel *listModel in model.cart_list) {
                price = price + listModel.price.doubleValue * listModel.num / 100;
                price = price + listModel.free_shipping.doubleValue/100;
            }
        }
        [self.bottomView setPrice:[NSString stringWithFormat:@"%.2f",price]];
    }
    [self.tableView reloadData];
}

#pragma mark - BogoDeductionCellDelegate
- (void)deductionCell:(BogoDeductionCell *)deductionCell didClickSelectBtn:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        //使用抵扣
        [self.bottomView setPrice:[NSString stringWithFormat:@"%.2f",self.bottomView.price.doubleValue - self.deductionModel.money.doubleValue / 100]];
        [self.param setObject:@"1" forKey:@"is_deduction"];
    }else{
        //不使用抵扣
        [self.bottomView setPrice:[NSString stringWithFormat:@"%.2f",self.bottomView.price.doubleValue + self.deductionModel.money.doubleValue / 100]];
        [self.param setObject:@"0" forKey:@"is_deduction"];
    }
}

-(void)requestData{
    //http://xx.com/api/Shop/addressList
    [[BogoNetwork shareInstance] GET:@"api/addressListUrl" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
        for (NSDictionary *dict in result.data) {
            BogoAddressListModel *model = [BogoAddressListModel mj_objectWithKeyValues:dict];
            for (BogoProvinceModel *province in self.addressDataModel.province_list) {
                if ([province.code isEqualToString:model.province]) {
                    model.province = province.name;
                }
                for (BogoCityModel *city in province.citylist) {
                    if ([city.code isEqualToString:model.city]) {
                        model.city = city.name;
                    }
                    for (BogoAreaModel *area in city.arealist) {
                        if ([area.code isEqualToString:model.district]) {
                            model.district = area.name;
                        }
                    }
                }
            }
            if (model.status.intValue == 1) {
                self.addressModel = model;
                [self.param setObject:model.sa_id forKey:@"sa_id"];
            }
        }
        [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

#pragma mark - BogoCartBottomViewDelegate
- (void)bottomView:(BogoCartBottomView *)bottomView didClickAccountBtn:(UIButton *)sender{
    
    if (self.addressModel) {
        [self requestPayType];
    }else{
        [[FDHUDManager defaultManager]show:@"请先添加收货地址" ToView:self.view];
    }
}

- (void)realPay{
    //    http://xx.com/api/Shoppay/orderAddNew
    if (self.model) {
        [self.param setObject:@(self.model.count) forKey:@"num"];
    }else{
        NSMutableArray *shop_cart_id = [NSMutableArray array];
        for (BogoCartModel *model in self.cartDataArray) {
            for (BogoCartListModel *listModel in model.cart_list) {
                [shop_cart_id addObject:listModel.id];
            }
        }
        [self.param setObject:[shop_cart_id componentsJoinedByString:@","] forKey:@"cart_id"];
    }
    __block NSString *pt_id = [NSString stringWithFormat:@"%@",self.param[@"pt_id"]];
    [self.param setObject:[self.remarkArray mj_JSONString] forKey:@"user_remark"];
    [[BogoNetwork shareInstance] POST:@"shop/go_pay" param:self.param success:^(BogoNetworkResponseModel * _Nonnull result) {
        BogoPayOrderModel *model = [BogoPayOrderModel mj_objectWithKeyValues:result.data];
        self.orderModel = model;
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
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)requestPayType{
//    http://xx.com/api/Shoppay/payType
    [[BogoNetwork shareInstance] GET:@"pay/getPayType" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
        FDActionSheet *as = [[FDActionSheet alloc]initWithTitle:@"" message:@""];
        for (NSDictionary *dict in result.data) {
            BogoPayTypeModel *typeModel = [BogoPayTypeModel mj_objectWithKeyValues:dict];
            [as addAction:[FDAction actionWithTitle:typeModel.name type:FDActionTypeDefault CallBack:^{
                [self.param setObject:typeModel.pt_id forKey:@"pt_id"];
                [self realPay];
            }]];
        }
        [as addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
        [as show:[UIApplication sharedApplication].keyWindow];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

#pragma mark - BogoShopFillInfoTextCellDelegate
- (void)textCell:(BogoShopFillInfoTextCell *)textCell didChangeText:(UITextField *)textField{
//    {"sid":"店铺ID","user_remark":"备注"}
    if (self.model) {
        //单商品
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.model.sid forKey:@"sid"];
        [dict setObject:textField.text forKey:@"user_remark"];
        [self.remarkArray replaceObjectAtIndex:0 withObject:dict];
    }else{
        //从购物车过来多商品
        NSIndexPath *indexPath = [self.tableView indexPathForCell:textCell];
        BogoCartModel *model = self.cartDataArray[indexPath.section - 1];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:model.sid forKey:@"sid"];
        [dict setObject:textField.text forKey:@"user_remark"];
        [self.remarkArray replaceObjectAtIndex:indexPath.section - 1 withObject:dict];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.model) {
        return 2;
    }
    return self.cartDataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (self.model) {
        return 3 + 1;
    }else{
        BogoCartModel *model = self.cartDataArray[section - 1];
        return model.cart_list.count + 2 + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BogoOrderSubmitAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoOrderSubmitAddressCell class]) forIndexPath:indexPath];
        [cell setModel:self.addressModel];
        return cell;
    }
    if (self.model) {
        if (indexPath.row == 0) {
            BogoCartCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoCartCell class]) forIndexPath:indexPath];
            [cell setType:BogoCartCellTypeOrderSubmit];
            [cell setModel:self.model];
            cell.delegate = self;
            return cell;
        }
        if (indexPath.row == 1) {
            BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
            [cell setType:BogoShopFillInfoCellTypeOrderSubmitTransfer];
            BogoCommodityDetailModel *model = self.model;
            NSString *text = @"";
            if (model.free_shipping.floatValue == 0) {
                text = @"￥0";
            }else{
                text = [NSString stringWithFormat:@"快递:￥%.2f",model.free_shipping.floatValue/100];
            }
            NSString *rightText = text;
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:rightText];
            if (model.free_shipping.floatValue == 0) {
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, @"￥".length)];
            }else{
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(@"快递:".length, @"￥".length)];
            }
            cell.rightTitleLabel.attributedText = attr;
            return cell;
        }
        if (indexPath.row == 2) {
            
            BogoOrderSubmitSumCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoOrderSubmitSumCell class]) forIndexPath:indexPath];
            BogoCommodityDetailModel *model = self.model;
            double price = _model.attr[model.selectAttrIndex].price.doubleValue * model.count / 100 + _model.free_shipping.floatValue / 100;
            NSString *priceStr = [NSString stringWithFormat:@"￥%.2f",price];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:priceStr];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, @"￥".length)];
            [cell.sumLabel setAttributedText:attr];
            return cell;
        }
        if (indexPath.row == 3) {
            
            
            BogoShopFillInfoTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoTextCell class]) forIndexPath:indexPath];
            cell.delegate = self;
            [cell setType:BogoShopFillInfoTextCellTypeOrderSubmitRemark];
            return cell;
        }
        if (indexPath.row == 4) {
            //兑换
            //兑换
            BogoDeductionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoDeductionCell class]) forIndexPath:indexPath];
            cell.delegate = self;
            if (self.deductionModel) {
                [cell setTitle:[NSString stringWithFormat:@"可用%@鑫值抵扣%.2f元",self.deductionModel.ticket_sum,self.deductionModel.money.doubleValue / 100]];
            }
            return cell;
        }
    }else{
        BogoCartModel *model = self.cartDataArray[indexPath.section - 1];
        if (indexPath.row < model.cart_list.count) {
            BogoCartCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoCartCell class]) forIndexPath:indexPath];
            [cell setType:BogoCartCellTypeOrderSubmit];
            [cell setListModel:model.cart_list[indexPath.row]];
            cell.delegate = self;
            return cell;
        }
        if (indexPath.row == model.cart_list.count) {
            BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
            [cell setType:BogoShopFillInfoCellTypeOrderSubmitTransfer];
            BogoCartModel *model = self.cartDataArray[indexPath.section - 1];
            double free_shipping = 0;
            for (BogoCartListModel *listModel in model.cart_list) {
                free_shipping = free_shipping + listModel.free_shipping.floatValue;
            }
            NSString *text = @"";
            if (free_shipping == 0) {
                text = @"￥0";
            }else{
                text = [NSString stringWithFormat:@"快递:￥%.2f",free_shipping/100];
            }
            NSString *rightText = text;
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:rightText];
            if (free_shipping == 0) {
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, @"￥".length)];
            }else{
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(@"快递:".length, @"￥".length)];
            }
            
            cell.rightTitleLabel.attributedText = attr;
            return cell;
        }
        if (indexPath.row == model.cart_list.count + 1) {
            BogoShopFillInfoTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoTextCell class]) forIndexPath:indexPath];
            [cell setType:BogoShopFillInfoTextCellTypeOrderSubmitRemark];
            cell.delegate = self;
            return cell;
        }
        if (indexPath.row == model.cart_list.count + 2) {
            BogoOrderSubmitSumCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoOrderSubmitSumCell class]) forIndexPath:indexPath];
            BogoCartModel *model = self.cartDataArray[indexPath.section - 1];
            double price = 0;
            for (BogoCartListModel *listModel in model.cart_list) {
                price = price + listModel.price.floatValue * listModel.num;
                price = price + listModel.free_shipping.floatValue;
            }
            NSString *priceStr = [NSString stringWithFormat:@"￥%.2f",price / 100];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:priceStr];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, @"￥".length)];
            [cell.sumLabel setAttributedText:attr];
            return cell;
        }
        if (indexPath.row == model.cart_list.count + 2) {
            //兑换
            BogoDeductionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoDeductionCell class]) forIndexPath:indexPath];
            cell.delegate = self;
            if (self.deductionModel) {
                [cell setTitle:[NSString stringWithFormat:@"可用%@鑫值抵扣%.2f元",self.deductionModel.ticket_sum,self.deductionModel.money.doubleValue / 100]];
            }
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }
    if (self.model) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                return 140;
            }
            return 50;
        }
    }else{
        BogoCartModel *model = self.cartDataArray[indexPath.section - 1];
        if (indexPath.row < model.cart_list.count) {
            return 140;
        }
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        if (self.model) {
            BogoCartHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([BogoCartHeaderView class])];
            headerView.section = section;
            [headerView setType:BogoCartHeaderViewTypeOrderSubmit];
            [headerView setModel:self.model];
            return headerView;
        }else{
            BogoCartHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([BogoCartHeaderView class])];
            headerView.section = section;
            [headerView setType:BogoCartHeaderViewTypeOrderSubmit];
            [headerView setCartModel:self.cartDataArray[section - 1]];
            return headerView;
        }
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"F3f3f3"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        return 55;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BogoAddressListViewController *addressVC = [[BogoAddressListViewController alloc]init];
        [addressVC setDidSelectCallBack:^(BogoAddressListModel * _Nonnull model) {
            self.addressModel = model;
            [self.param setObject:model.sa_id forKey:@"sa_id"];
            [tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
        }];
        addressVC.model = self.addressModel;
        [self.navigationController pushViewController:addressVC animated:YES];
    }
}

- (BogoCartBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [kShopKitBundle loadNibNamed:NSStringFromClass([BogoCartBottomView class]) owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
        [_bottomView setType:BogoCartBottomViewTypeOrderSubmit];
    }
    return _bottomView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, FD_Bottom_SafeArea_Height + 50, 0);
        _tableView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCartCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoCartCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoOrderSubmitAddressCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoOrderSubmitAddressCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoOrderSubmitSumCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoOrderSubmitSumCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoTextCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoTextCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCartHeaderView class]) bundle:kShopKitBundle] forHeaderFooterViewReuseIdentifier:NSStringFromClass([BogoCartHeaderView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoDeductionCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoDeductionCell class])];
    }
    return _tableView;
}

- (NSMutableDictionary *)param{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

- (NSMutableArray *)remarkArray{
    if (!_remarkArray) {
        _remarkArray = [NSMutableArray array];
    }
    return _remarkArray;
}

@end
