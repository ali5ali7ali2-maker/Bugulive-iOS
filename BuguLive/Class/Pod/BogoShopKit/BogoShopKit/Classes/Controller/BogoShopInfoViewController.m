//
//  BogoShopInfoViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/17.
//

#import "BogoShopInfoViewController.h"
#import "BogoShopKit.h"
#import "FDUIKitObjC.h"
#import "BogoShopInfoTopCell.h"
#import "BogoShopFillInfoCell.h"
#import "BogoShopKit.h"
#import "BogoShopInfoModel.h"
#import "UIImageView+WebCache.h"
#import "BogoTransferModel.h"
#import <BRPickerView/BRPickerView.h>
#import "BogoAddressModel.h"
#import "BogoShopFillInfoTextCell.h"
#import "UIViewController+Bogo.h"
#import <QMUIKit/QMUIKit.h>
#import <Masonry/Masonry.h>
#import "FDNetworkObjC.h"
#import <MJExtension/MJExtension.h>
#import "BogoNetworkKit.h"
#import "BogoNetworkResponseModel.h"
@interface BogoShopInfoViewController ()<UITableViewDelegate,UITableViewDataSource,BogoShopFillInfoTextCellDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) BogoShopInfoModel *model;
@property(nonatomic, strong) UIButton *saveBtn;
@property(nonatomic, strong) NSMutableArray *transferArray;
@property(nonatomic, strong) NSMutableDictionary *param;

@property(nonatomic, strong) BogoAddressModel *addressModel;

@end

@implementation BogoShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"店铺资料";
    [self.view addSubview:self.tableView];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"余额" style:UIBarButtonItemStylePlain target:self action:@selector(balanceBtnAction)];
    [self.view addSubview:self.saveBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(44);
        make.height.mas_equalTo(@40);
        make.right.equalTo(self.view).offset(-44);
        make.bottom.equalTo(self.view).offset(-FD_Bottom_SafeArea_Height);
    }];
    [self requestData];
    [self requestAddData];
}

- (BOOL)navigationShouldPopOnBackButton{
    if (self.param.allValues.count) {
        BogoAlertView *alert = [[BogoAlertView alloc]initWithTitle:@"提示" message:@"确定放弃保存"];
        [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
        [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alert show:self.view];
        return NO;
    }
    return YES;
}

- (void)balanceBtnAction{
    
}

- (void)requestData{
//    http://xx.com/api/Shopmanage/getShopInfo
    [[BogoNetwork shareInstance] GET:@"api/getShopInfoUrl" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
        self.model = [BogoShopInfoModel mj_objectWithKeyValues:result.data];
        [self.param setObject:self.model.province ? self.model.province : @"" forKey:@"province"];
        [self.param setObject:self.model.city ? self.model.city : @"" forKey:@"city"];
        [self.param setObject:self.model.county ? self.model.county : @"" forKey:@"county"];
        [self.param setObject:self.model.express_id ? self.model.express_id : @"" forKey:@"express_id"];
        [self.param setObject:self.model.address_info ? self.model.address_info : @"" forKey:@"address_info"];
        [self.param setObject:self.model.refund_city ? self.model.refund_city : @"" forKey:@"refund_city"];
        [self.param setObject:self.model.refund_county ? self.model.refund_county : @"" forKey:@"refund_county"];
        [self.param setObject:self.model.refund_province ? self.model.refund_province : @"" forKey:@"refund_province"];
        [self.param setObject:self.model.refund_address_info ? self.model.refund_address_info : @"" forKey:@"refund_address_info"];
        [self.tableView reloadData];
        if (self.addressModel) {
            for (BogoProvinceModel *province in self.addressModel.province_list) {
                if ([province.code isEqualToString:self.model.province]) {
                    self.model.province = province.name;
                }
                if ([province.code isEqualToString:self.model.refund_province]) {
                    self.model.refund_province = province.name;
                }
                for (BogoCityModel *city in province.citylist) {
                    if ([city.code isEqualToString:self.model.city]) {
                        self.model.city = city.name;
                    }
                    if ([city.code isEqualToString:self.model.refund_city]) {
                        self.model.refund_city = city.name;
                    }
                    for (BogoAreaModel *area in city.arealist) {
                        if ([area.code isEqualToString:self.model.county]) {
                            self.model.county = area.name;
                        }
                        if ([area.code isEqualToString:self.model.refund_county]) {
                            self.model.refund_county = area.name;
                        }
                    }
                }
            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1],[NSIndexPath indexPathForRow:5 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            
        }
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
    
}

- (void)requestAddData{
    //http://xx.com/api/shoporder/getExpressList
    [[BogoNetwork shareInstance] GET:@"order_api/getExpressListUrl" param:nil success:^(BogoNetworkResponseModel * _Nonnull result) {
        for (NSDictionary *dict in result.data) {
            BogoTransferModel *model = [BogoTransferModel mj_objectWithKeyValues:dict];
            [self.transferArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
    
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
    self.addressModel = [BogoNetwork shareInstance].addressModel;
    
    
    for (BogoProvinceModel *province in self.addressModel.province_list) {
        if ([province.code isEqualToString:self.model.province]) {
            self.model.province = province.name;
        }
        if ([province.code isEqualToString:self.model.refund_province]) {
            self.model.refund_province = province.name;
        }
        for (BogoCityModel *city in province.citylist) {
            if ([city.code isEqualToString:self.model.city]) {
                self.model.city = city.name;
            }
            if ([city.code isEqualToString:self.model.refund_city]) {
                self.model.refund_city = city.name;
            }
            for (BogoAreaModel *area in city.arealist) {
                if ([area.code isEqualToString:self.model.county]) {
                    self.model.county = area.name;
                }
                if ([area.code isEqualToString:self.model.refund_county]) {
                    self.model.refund_county = area.name;
                }
            }
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1],[NSIndexPath indexPathForRow:5 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)saveBtnAction:(UIButton *)sender{
//    http://xx.com/api/Shopmanage/settingShop
    [self.param setValuesForKeysWithDictionary:@{@"token":[BogoNetwork shareInstance].token}];
    [[BogoNetwork shareInstance] POST:@"api/settingShopUrl" param:self.param success:^(BogoNetworkResponseModel * _Nonnull result) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

#pragma mark - BogoShopFillInfoTextCellDelegate
- (void)textCell:(BogoShopFillInfoTextCell *)textCell didChangeText:(UITextField *)textField{
    if (textCell.type == BogoShopFillInfoTextCellTypeSendAddress) {
        [self.param setObject:textField.text forKey:@"address_info"];
    }else if (textCell.type == BogoShopFillInfoTextCellTypeRefundAddress){
        [self.param setObject:textField.text forKey:@"refund_address_info"];
    }else{
        [self.param setObject:textField.text forKey:@"title"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 7;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BogoShopInfoTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopInfoTopCell class])];
        [cell setModel:self.model];
        return cell;
    }
    BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class])];
    switch (indexPath.row) {
        case 0:
            cell.type = BogoShopFillInfoCellTypeShopAvatar + indexPath.row;
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.model.logo]];
            return cell;
            break;
        case 1:
        {
//            [cell setRightTitle:self.model.title];
            BogoShopFillInfoTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoTextCell class])];
            [textCell setType:BogoShopFillInfoTextCellTypeShopTitle];
            textCell.delegate = self;
            [textCell.rightTextField setText:self.model.title];
            return textCell;
        }
            break;
        case 2:
            cell.type = BogoShopFillInfoCellTypeShopAvatar + indexPath.row;
            [cell setRightTitle:self.model.express_name];
            return cell;
            break;
        case 3:
            cell.type = BogoShopFillInfoCellTypeShopAvatar + indexPath.row;
            [cell setRightTitle:[NSString stringWithFormat:@"%@%@%@",self.model.province,self.model.city,self.model.county]];
            return cell;
            break;
        case 4:
        {
            BogoShopFillInfoTextCell *newCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoTextCell class])];
            newCell.delegate = self;
            [newCell setType:BogoShopFillInfoTextCellTypeSendAddress];
            [newCell.rightTextField setText:self.model.address_info];
            return newCell;
        }
            break;
        case 5:
            cell.type = BogoShopFillInfoCellTypeShopRefund;
            [cell setRightTitle:[NSString stringWithFormat:@"%@%@%@",self.model.refund_province,self.model.refund_city,self.model.refund_county]];
            return cell;
            break;
        case 6:
        {
            BogoShopFillInfoTextCell *newCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoTextCell class])];
            newCell.delegate = self;
            [newCell setType:BogoShopFillInfoTextCellTypeRefundAddress];
            [newCell.rightTextField setText:self.model.refund_address_info];
            return newCell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }
    switch (indexPath.row) {
        case 0:
            return 60;
            break;
        default:
            return 50;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 5)];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //修改头像
            BogoShopFillInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            BogoImagePickerViewController *picker = [[BogoImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:nil];
            picker.allowTakeVideo = NO;
            picker.allowPickingVideo = NO;
            picker.allowCrop = YES;
            picker.cropRect = CGRectMake(0, (FD_ScreenHeight - FD_ScreenWidth) / 2, FD_ScreenWidth, FD_ScreenWidth);
            __weak __typeof(self)weakSelf = self;
            [picker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [cell setRightImage:photos.lastObject];
                [[FDHUDManager defaultManager] showLoading:@"正在上传" ToView:strongSelf.view];
                [[FDOSSManager defaultManager] setup:^{
                    [[FDOSSManager defaultManager] UPLOAD:UIImagePNGRepresentation(photos.lastObject) progress:^(float percent) {
                        NSLog(@"上传进度:%f",percent);
                    } success:^(NSString * _Nonnull resultStr) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[FDHUDManager defaultManager] hideLoading];
                            [self.param setObject:resultStr forKey:@"logo"];
                        });
                    } failure:^(NSError * _Nonnull error) {
                        [[FDHUDManager defaultManager] show:error.localizedDescription ToView:self.view];
                    }];
                }];
                return;
                [[BogoNetwork shareInstance] GET:@"tools/qiniuToken" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
                    BogoQiniuModel *model = [BogoQiniuModel mj_objectWithKeyValues:result.data];
                    [[FDQiniuManager defaultManager] UPLOAD:UIImagePNGRepresentation(photos.lastObject) token:model.token progressHandler:^(float percent) {
                        NSLog(@"上传进度:%f",percent);
                    } completeHandler:^(FDQiniuResponseModel * _Nonnull response) {
                        [[FDHUDManager defaultManager] hideLoading];
                        [self.param setObject:[NSString stringWithFormat:@"%@%@",model.domain,response.key] forKey:@"logo"];
                    }];
                } failure:^(NSString * _Nonnull error) {
                    [[FDHUDManager defaultManager] show:error ToView:self.view];
                }];
            }];
            [self presentViewController:picker animated:YES completion:nil];
        }else if (indexPath.row == 2) {
            //修改快递地址
            BogoShopFillInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            BRStringPickerView *pickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
            [pickerView setTitle:@"请选择快递公司"];
            [pickerView setDataSourceArr:self.transferArray];
            pickerView.selectIndex = 0;
            pickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
                [cell setRightTitle:resultModel.value];
                [self.param setObject:resultModel.key forKey:@"express_id"];
            };
            [pickerView show];
        }else if (indexPath.row == 3){
            //修改发货地址
            BogoShopFillInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            BRAddressPickerView *pickerView = [[BRAddressPickerView alloc]initWithPickerMode:BRAddressPickerModeArea];
            [pickerView setSelectIndexs:@[@(0)]];
            pickerView.isAutoSelect = NO;
            [pickerView setDataSourceArr:self.addressModel.province_list];
            pickerView.resultBlock = ^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
                [cell setRightTitle:[NSString stringWithFormat:@"%@%@%@",province.name,city.name,area.name]];
                [self.param setObject:province.code forKey:@"province"];
                [self.param setObject:city.code forKey:@"city"];
                [self.param setObject:area.code forKey:@"county"];
            };
            [pickerView show];
        }else if (indexPath.row == 5){
            //修改发货地址
            BogoShopFillInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            BRAddressPickerView *pickerView = [[BRAddressPickerView alloc]initWithPickerMode:BRAddressPickerModeArea];
            [pickerView setSelectIndexs:@[@(0)]];
            pickerView.isAutoSelect = NO;
            [pickerView setDataSourceArr:self.addressModel.province_list];
            pickerView.resultBlock = ^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
                [cell setRightTitle:[NSString stringWithFormat:@"%@%@%@",province.name,city.name,area.name]];
                [self.param setObject:province.code forKey:@"refund_province"];
                [self.param setObject:city.code forKey:@"refund_city"];
                [self.param setObject:area.code forKey:@"refund_county"];
            };
            [pickerView show];
        }
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 40 + FD_Bottom_SafeArea_Height, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        NSBundle *bundle = kShopKitBundle;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoTextCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoTextCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopInfoTopCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoShopInfoTopCell class])];
    }
    return _tableView;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        // Fallback on earlier versions
        _saveBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0, 0, FD_ScreenWidth - 88, 40);
        gl.startPoint = CGPointMake(0, 0.5);
        gl.endPoint = CGPointMake(1, 0.5);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:116/255.0 blue:44/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:222/255.0 green:29/255.0 blue:22/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        [_saveBtn.layer insertSublayer:gl below:_saveBtn.titleLabel.layer];
        
        _saveBtn.layer.cornerRadius = 20;
        _saveBtn.clipsToBounds = YES;
    }
    return _saveBtn;
}

- (NSMutableArray *)transferArray{
    if (!_transferArray) {
        _transferArray = [NSMutableArray array];
    }
    return _transferArray;
}

- (NSMutableDictionary *)param{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

@end
