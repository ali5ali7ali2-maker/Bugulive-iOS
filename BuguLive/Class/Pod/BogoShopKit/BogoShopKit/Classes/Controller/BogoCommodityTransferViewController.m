//
//  BogoCommodityTransferViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/19.
//

#import "BogoCommodityTransferViewController.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import "BogoShopFillInfoCell.h"
#import "BogoShopFillInfoTextCell.h"
#import "BRStringPickerView.h"
#import "BogoShopKit.h"
#import "BogoTransferModel.h"
#import <MJExtension/MJExtension.h>

@interface BogoCommodityTransferViewController ()<UITableViewDelegate,UITableViewDataSource,BogoShopFillInfoTextCellDelegate>

@property(nonatomic, strong) UIButton *confirmBtn;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableDictionary *param;
@property(nonatomic, strong) NSMutableArray *transferArray;

@end

@implementation BogoCommodityTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发货";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"无需寄件" style:UIBarButtonItemStylePlain target:self action:@selector(noTransferBtnAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor qmui_colorWithHexString:@"#F42416"],NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.confirmBtn];
    [self.param setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    [self.param setObject:@"2" forKey:@"status"];
    [self requestData];
}

- (void)noTransferBtnAction{
    //            http://xx.com/api/Shoporder/requestOrderStatus
    [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:self.param success:^(BogoNetworkResponseModel * _Nonnull result) {
        [[FDHUDManager defaultManager] show:@"发货成功" ToView:self.view];
        
        if (self.clickTransferBlock) {
            self.clickTransferBlock(YES);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)setSo_id:(NSString *)so_id{
    _so_id = so_id;
    [self.param setObject:_so_id forKey:@"so_id"];
}

- (void)requestData{
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
}

- (void)confirmBtnAction:(UIButton *)sender{

    BogoShopFillInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (!cell.rightTitleLabel.text.length) {
        [[FDHUDManager defaultManager] show:@"未选择快递公司" ToView:self.view];
        return;
    }
    BogoShopFillInfoTextCell *textCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (!textCell.rightTextField.text.length) {
        [[FDHUDManager defaultManager] show:@"未填写快递单号" ToView:self.view];
        return;
    }

    //            http://xx.com/api/Shoporder/requestOrderStatus
    [[BogoNetwork shareInstance] POST:@"order_api/requestOrderStatusUrl" param:self.param success:^(BogoNetworkResponseModel * _Nonnull result) {
        [[FDHUDManager defaultManager] show:@"发货成功" ToView:self.view];
        
        if (self.clickTransferBlock) {
            self.clickTransferBlock(YES);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

#pragma mark - BogoShopFillInfoTextCellDelegate
- (void)textCell:(BogoShopFillInfoTextCell *)textCell didChangeText:(UITextField *)textField{
    [self.param setObject:textField.text forKey:@"express_number"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
        [cell setType:BogoShopFillInfoCellTypeSelectTransfer];
        return cell;
    }
    BogoShopFillInfoTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoTextCell class]) forIndexPath:indexPath];
    [cell setType:BogoShopFillInfoTextCellTypeEditTransferNo];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        BogoShopFillInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        BRStringPickerView *pickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
        [pickerView setTitle:@"请选择快递公司"];
        [pickerView setDataSourceArr:self.transferArray];
        pickerView.selectIndex = 0;
        pickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            [cell setRightTitle:resultModel.value];
            cell.rightTitleLabel.textColor = [UIColor qmui_colorWithHexString:@"F42416"];
            [self.param setObject:resultModel.value forKey:@"express_name"];
        };
        [pickerView show];
    }
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 236, FD_ScreenWidth - 100, 40)];
        [_confirmBtn setTitle:@"确认发货" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:FD_WhiteColor forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_confirmBtn setBackgroundColor:[UIColor qmui_colorWithHexString:@"#FC3205"]];
        _confirmBtn.layer.cornerRadius = 20;
        _confirmBtn.clipsToBounds = YES;
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        // gradient
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,0,FD_ScreenWidth - 70,40);
//        gl.startPoint = CGPointMake(0, 0.5);
//        gl.endPoint = CGPointMake(1, 0.5);
//        gl.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:116/255.0 blue:44/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:222/255.0 green:29/255.0 blue:22/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:137/255.0 blue:96/255.0 alpha:1.0].CGColor];
//        gl.locations = @[@(0), @(1.0f)];
//        [_confirmBtn.layer insertSublayer:gl below:_confirmBtn.titleLabel.layer];
    }
    return _confirmBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 100) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        NSBundle *bundle = kShopKitBundle;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoTextCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoTextCell class])];
    }
    return _tableView;
}

- (NSMutableDictionary *)param{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

- (NSMutableArray *)transferArray{
    if (!_transferArray) {
        _transferArray = [NSMutableArray array];
    }
    return _transferArray;
}

@end
