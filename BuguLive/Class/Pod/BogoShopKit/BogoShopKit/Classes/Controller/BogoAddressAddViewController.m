//
//  BogoAddressAddViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import "BogoAddressAddViewController.h"
#import "BogoShopFillInfoCell.h"
#import "BogoShopFillInfoTextCell.h"
#import "BogoAddressDetailCell.h"
#import "BogoAddressDefaultCell.h"
#import "BogoAddressListModel.h"
#import <QMUIKit/QMUIKit.h>
#import "FDUIKitObjC.h"
#import <YYKit/YYKit.h>
#import "BogoShopKit.h"
#import "BogoAddressModel.h"
#import <MJExtension/MJExtension.h>
#import <BRPickerView/BRPickerView.h>
#import "BogoShopKit.h"
#import "BogoAlertView.h"

@interface BogoAddressAddViewController ()<BogoShopFillInfoTextCellDelegate,BogoAddressDetailCellDelegate,BogoAddressDefaultCellDelegate,BogoShopFillInfoTextCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) BogoAddressModel *addressModel;
@property(nonatomic, strong) NSMutableDictionary *param;

@property(nonatomic, strong) UIButton *saveBtn;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation BogoAddressAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestAddressData];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.saveBtn];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnAction)];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]} forState:UIControlStateNormal];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]} forState:UIControlStateHighlighted];
    [self.param setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    [self.param setObject:@"" forKey:@"remark"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoTextCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoTextCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoAddressDetailCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoAddressDetailCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoAddressDefaultCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoAddressDefaultCell class])];
    
}

- (void)setModel:(BogoAddressListModel *)model{
    _model = model;
    if (!model.sa_id.length) {
        _model = [[BogoAddressListModel alloc]init];
        [self.param setObject:@"0" forKey:@"status"];
        _isEdit = NO;
        self.title = @"添加地址";
    }else{
        _isEdit = YES;
        self.title = @"收货地址";
        [self.param setObject:model.sa_id forKey:@"id"];
        [self.param setObject:model.province forKey:@"province"];
        [self.param setObject:model.city forKey:@"city"];
        [self.param setObject:model.district forKey:@"county"];
        [self.param setObject:model.address forKey:@"address"];
        [self.param setObject:model.tel forKey:@"tel"];
        [self.param setObject:model.name forKey:@"name"];
        [self.param setObject:model.status forKey:@"status"];
        [self.param setObject:model.area_code.length ? model.area_code : @"" forKey:@"area_code"];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        self.tableView.height = 286 + 44 + 20;
        _saveBtn.top = self.tableView.bottom + 60;
    }
    [self.tableView reloadData];
}

- (void)saveBtnAction{
    NSString *url = @"api/addressAddNewUrl";
    if (_isEdit) {
        url = @"api/addressEditNewUrl";
    }
    
    NSString *tel = [NSString stringWithFormat:@"%@",[self.param valueForKey:@"tel"]];
    
    if (tel.length != 11) {
        
        [[FDHUDManager defaultManager]show:@"手机号格式不正确" ToView:self.view];
        return;
    }
    
    
    [[BogoNetwork shareInstance] POST:url param:self.param success:^(BogoNetworkResponseModel * _Nonnull result) {
        [[FDHUDManager defaultManager] show:self.isEdit ? @"编辑成功" : @"添加成功" ToView:self.view];
//        if (!self.isEdit) {
            [self.navigationController popViewControllerAnimated:YES];
//        }
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
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
    self.addressModel = [BogoNetwork shareInstance].addressModel;
    for (BogoProvinceModel *model in self.addressModel.province_list) {
        if ([self.model.province isEqualToString:model.code]) {
            self.model.province = model.name;
            for (BogoCityModel *cityModel in model.citylist) {
                if ([self.model.city isEqualToString:cityModel.code]) {
                    self.model.city = cityModel.name;
                }
            }
        }
    }
}

- (void)textCell:(BogoShopFillInfoTextCell *)textCell didChangeText:(UITextField *)textField{
    if (textCell.type == BogoShopFillInfoTextCellTypeAddressTel) {
        [self.param setObject:textField.text forKey:@"tel"];
    }else if (textCell.type == BogoShopFillInfoTextCellTypeAddressName){
        [self.param setObject:textField.text forKey:@"name"];
    }
}

- (void)detailCell:(BogoAddressDetailCell *)detailCell didTextChange:(QMUITextView *)textView{
    [self.param setObject:textView.text forKey:@"address"];
}

- (void)defaultCell:(BogoAddressDefaultCell *)defaultCell didValueChanged:(UISwitch *)defaultSwitch{
    [self.param setObject:defaultSwitch.isOn ? @"1" : @"0" forKey:@"status"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self saveBtnAction];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isEdit) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    {
                        BogoShopFillInfoTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoTextCell class]) forIndexPath:indexPath];
                        [cell setType:BogoShopFillInfoTextCellTypeAddressName];
                        cell.delegate = self;
                        [cell.rightTextField setText:self.model.name];
                        return cell;
                    }
                    break;
                case 1:
                {
                    BogoShopFillInfoTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoTextCell class]) forIndexPath:indexPath];
                    [cell setType:BogoShopFillInfoTextCellTypeAddressTel];
                    cell.delegate = self;
                    [cell.rightTextField setText:self.model.tel];
                    return cell;
                }
                break;
                case 2:
                {
                    BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
                    [cell setType:BogoShopFillInfoCellTypeAddressArea];
                    [cell setRightTitle:[NSString stringWithFormat:@"%@%@%@",self.model.province.length ? self.model.province : @"",self.model.city.length ? self.model.city : @"",self.model.district.length ? self.model.district : @""]];
                    return cell;
                }
                break;
                case 3:
                {
                    BogoAddressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoAddressDetailCell class]) forIndexPath:indexPath];
                    cell.delegate = self;
                    [cell setDetailText:self.model.address];
                    return cell;
                }
                break;
                default:
                    return nil;
                    break;
            }
            break;
        case 1:
        {
            BogoAddressDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoAddressDefaultCell class]) forIndexPath:indexPath];
            cell.delegate = self;
            [cell setModel:self.model];
            return cell;
        }
            break;
        case 2:
        {
            BogoShopFillInfoTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoTextCell class]) forIndexPath:indexPath];
            cell.leftTitleLabel.hidden = NO;
            cell.rightTextField.hidden = YES;
            [cell.leftTitleLabel setText:@"删除地址"];
            cell.leftTitleLabel.textColor = [UIColor colorWithHexString:@""];
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
//            cell.textLabel.text = @"删除地址";
//            cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//            cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 3) {
        return 80;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 4)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 4)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 4;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 2) {
        BogoShopFillInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        BRAddressPickerView *pickerView = [[BRAddressPickerView alloc]initWithPickerMode:BRAddressPickerModeArea];
        [pickerView setSelectIndexs:@[@(0)]];
        pickerView.isAutoSelect = NO;
        [pickerView setDataSourceArr:self.addressModel.province_list];
        pickerView.resultBlock = ^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
            [cell setRightTitle:[NSString stringWithFormat:@"%@%@%@",province.name,city.name,area.name]];
            [self.param setObject:province.name forKey:@"province"];
            [self.param setObject:city.name forKey:@"city"];
            [self.param setObject:area.name forKey:@"county"];
            [self.param setObject:area.code forKey:@"area_code"];
        };
        [pickerView show];
    }
    if (indexPath.section == 2) {
        BogoAlertView *alert = [[BogoAlertView alloc] initWithTitle:@"是否删除当前地址" message:@""];
        [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
        [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
            //    http://xx.com/api/Shopuser/addressDelNew
            [[BogoNetwork shareInstance] POST:@"api/addressDelNewUrl" param:@{@"id":self->_model.sa_id,@"status":@"0"} success:^(BogoNetworkResponseModel * _Nonnull result) {
                    //删除成功
                [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSString * _Nonnull error) {
                    [[FDHUDManager defaultManager] show:error ToView:self.view];
                }];
        }]];
        [alert show:[UIApplication sharedApplication].keyWindow];
    }
}

- (NSMutableDictionary *)param{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 406) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 350, FD_ScreenWidth - 100, 40)];
        [_saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#F42416"]];
        _saveBtn.layer.cornerRadius = 20;
        _saveBtn.clipsToBounds = YES;
        [_saveBtn setTitle:@"保存并使用" forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_saveBtn setTitleColor:FD_WhiteColor forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

@end
