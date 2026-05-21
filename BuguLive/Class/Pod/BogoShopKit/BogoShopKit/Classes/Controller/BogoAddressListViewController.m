//
//  BogoAddressListViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import "BogoAddressListViewController.h"
#import "BogoShopKit.h"
#import "BogoShopKit.h"
#import "BogoAddressListCell.h"
#import "BogoAddressListModel.h"
#import "FDUIKitObjC.h"
#import "BogoAddressAddViewController.h"
#import "BogoAddressModel.h"
#import <MJExtension/MJExtension.h>
#import "BogoAlertView.h"
#import <YYKit/YYKit.h>

@interface BogoAddressListViewController ()<BogoAddressListCellDelegate>

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) BogoAddressModel *addressModel;
@property(nonatomic, copy) didSelectCallBack didSelectCallBack;

@end

@implementation BogoAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加新地址" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"],NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"],NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateHighlighted];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoAddressListCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoAddressListCell class])];
    
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
}

- (void)backBtnAction:(UIButton *)sender{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.addressModel) {
        [self requestData];
    }else{
        [self requestAddressData];
    }
}

- (void)setDidSelectCallBack:(didSelectCallBack)didSelectCallBack{
    _didSelectCallBack = didSelectCallBack;
}

- (void)add{
    BogoAddressAddViewController *addVC = [[BogoAddressAddViewController alloc]init];
    addVC.model = nil;
    [self.navigationController pushViewController:addVC animated:YES];
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
    [self requestData];
}

-(void)requestData{
    //http://xx.com/api/Shop/addressList
    [[BogoNetwork shareInstance] GET:@"api/addressListUrl" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
        [self.dataArray removeAllObjects];
        for (NSDictionary *dict in result.data) {
            BogoAddressListModel *model = [BogoAddressListModel mj_objectWithKeyValues:dict];
            for (BogoProvinceModel *province in self.addressModel.province_list) {
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
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        if (self.model) {
            NSInteger index = -1;
            for (BogoAddressListModel *model in self.dataArray) {
                if (model.sa_id.integerValue == self.model.sa_id.integerValue) {
                    index = [self.dataArray indexOfObject:model];
                }
            }
            if (index != -1) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

#pragma mark - BogoAddressListCellDelegate
- (void)listCell:(BogoAddressListCell *)listCell didClickEditBtn:(UIButton *)sender{
    BogoAddressAddViewController *addVC = [[BogoAddressAddViewController alloc]init];
    addVC.model = listCell.model;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoAddressListCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoAddressListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_didSelectCallBack) {
        _didSelectCallBack(cell.model);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        BogoAddressAddViewController *addVC = [[BogoAddressAddViewController alloc]init];
        addVC.model = cell.model;
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
