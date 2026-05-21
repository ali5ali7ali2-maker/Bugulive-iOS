//
//  BogoApplyRefundTableViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import "BogoApplyRefundViewController.h"
#import "BogoOrderDetailCommodityCell.h"
#import "BogoShopFillInfoCell.h"
#import "BogoCommodityInfoCell.h"
#import "BogoShopFillInfoExtCell.h"
#import "BogoShopFillInfoTextCell.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import "BogoRefundReasonModel.h"
#import "BogoShopKit.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <BRPickerView/BRPickerView.h>
#import "BogoOrderManageListModel.h"
#import "FDNetworkObjC.h"
#import <MJExtension/MJExtension.h>
#import "BogoShopRefundView.h"

@interface BogoApplyRefundViewController ()<UITableViewDelegate,UITableViewDataSource,BogoShopFillInfoExtCellDelegate,BogoCommodityInfoCellDelegate>

@property(nonatomic, strong) UIButton *applyBtn;
@property(nonatomic, strong) NSMutableArray *reasonArray;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableDictionary *param;
@property(nonatomic, strong) NSMutableArray *refund_img;

@property(nonatomic, strong) BogoShopRefundView *refundView;

@end

@implementation BogoApplyRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请退款";
    [self.view addSubview:self.tableView];
    [self requestData];
    [self.view addSubview:self.applyBtn];
    [self.param setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    [self.param setObject:@"17" forKey:@"status"];
}

- (void)setModel:(BogoOrderManageListModel *)model{
    _model = model;
    [self.applyBtn setTitle:@"申请退款" forState:UIControlStateNormal];
}

- (void)requestData{
//    http://xx.com/api/userorder/getReasonRefund
    [[BogoNetwork shareInstance] GET:@"order_api/getReasonRefundUrl" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
        for (NSDictionary *dict in result.data) {
            BogoRefundReasonModel *model = [BogoRefundReasonModel mj_objectWithKeyValues:dict];
            [self.reasonArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)btnAction:(UIButton *)sender{
//    http://xx.com/api/order_api/changeOrderStatusUrl
    [self.param setObject:self.model.so_id forKey:@"so_id"];
    
    NSString *reason = [self.param objectForKey:@"reason"];
    if (!reason.length) {
        [[FDHUDManager defaultManager] show:@"请选择退款原因" ToView:self.view];
        return;
    }
    
    [[BogoNetwork shareInstance] POST:@"order_api/changeOrderStatusUrl" param:self.param success:^(BogoNetworkResponseModel * _Nonnull result) {
        [[FDHUDManager defaultManager] show:@"申请退款成功" ToView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

#pragma mark - BogoShopFillInfoExtCellDelegate
-(void)extCell:(BogoShopFillInfoExtCell *)extCell didClickImageBtn:(UIButton *)sender{
    TZImagePickerController *picker = [[BogoImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:nil];
    picker.allowCrop = YES;
    picker.allowTakeVideo = NO;
    picker.allowPickingVideo = NO;
    picker.cropRect = CGRectMake(0, (FD_ScreenHeight - FD_ScreenWidth) / 2, FD_ScreenWidth, FD_ScreenWidth);
    __weak __typeof(self)weakSelf = self;
    [picker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[FDHUDManager defaultManager] showLoading:@"正在上传" ToView:strongSelf.view];
        [[FDOSSManager defaultManager] setup:^{
            [[FDOSSManager defaultManager] UPLOAD:UIImagePNGRepresentation(photos.lastObject) progress:^(float percent) {
                NSLog(@"上传进度:%f",percent);
            } success:^(NSString * _Nonnull resultStr) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FDHUDManager defaultManager] hideLoading];
                    [extCell addDeleteBtnToSuperView:sender];
                    [extCell addButton];
                    [sender setImage:photos.lastObject forState:UIControlStateNormal];
                    [self.refund_img replaceObjectAtIndex:sender.tag - kBogoShopFillInfoExtCellBaseTag withObject:resultStr];
                    [self.param setObject:[self.refund_img componentsJoinedByString:@","] forKey:@"refund_img"];
                });
            } failure:^(NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FDHUDManager defaultManager] show:error.localizedDescription ToView:self.view];
                });
            }];
        }];
        return;
        [[BogoNetwork shareInstance] GET:@"tools/qiniuToken" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
            BogoQiniuModel *model = [BogoQiniuModel mj_objectWithKeyValues:result.data];
            [[FDQiniuManager defaultManager] UPLOAD:UIImagePNGRepresentation(photos.lastObject) token:model.token progressHandler:^(float percent) {
                NSLog(@"上传进度:%f",percent);
            } completeHandler:^(FDQiniuResponseModel * _Nonnull response) {
                [[FDHUDManager defaultManager] hideLoading];
                [extCell addButton];
                [sender setImage:photos.lastObject forState:UIControlStateNormal];
                NSString *url = [NSString stringWithFormat:@"%@%@",model.domain,response.key];
                [self.refund_img replaceObjectAtIndex:sender.tag - kBogoShopFillInfoExtCellBaseTag withObject:url];
                [self.param setObject:[self.refund_img componentsJoinedByString:@","] forKey:@"refund_img"];
            }];
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
        }];
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - BogoCommodityInfoCellDelegate
-(void)infoCell:(BogoCommodityInfoCell *)infoCell didTextViewChange:(nonnull QMUITextView *)textField{
    [self.param setObject:textField.text forKey:@"content"];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            BogoOrderDetailCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoOrderDetailCommodityCell class]) forIndexPath:indexPath];
            cell.type = BogoOrderDetailCellTypeApplyRefund;
            [cell setModel:self.model];
            return cell;
        }
            break;
        case 1:
        {
            BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
            [cell setType:BogoShopFillInfoCellTypeOrderRefundReason];
            return cell;
        }
            break;
        case 2:
        {
            BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
            [cell setType:BogoShopFillInfoCellTypeOrderRefundAccount];
            
            NSString *priceStr = [NSString stringWithFormat:@"￥%.2f",self.model.money.floatValue / 100 * self.model.number.integerValue];
            if (self.model.status.integerValue > 1) {
                priceStr = [NSString stringWithFormat:@"￥%.2f",self.model.price.floatValue / 100];
            }
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:priceStr];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, @"￥".length)];
//            self.priceLabel.attributedText = attr;
            cell.rightTitleLabel.attributedText = attr;
            cell.rightTitleLabel.textColor = [UIColor qmui_colorWithHexString:@"#F42416"];
//            [cell setRightTitle:@"￥369"];
            return cell;
        }
            break;
        case 3:
        {
            BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
            [cell setType:BogoShopFillInfoCellTypeOrderRefundPhone];
            
            [cell setRightTitle:self.model.tel];
            return cell;
        }
            break;
        case 4:
        {
            BogoCommodityInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoCommodityInfoCell class]) forIndexPath:indexPath];
            cell.delegate = self;
            cell.type = BogoCommodityInfoCellTypeRefundDesc;
            return cell;
            
            
        }
            break;
            
        case 5:
        {
            BogoShopFillInfoExtCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoExtCell class]) forIndexPath:indexPath];
            cell.delegate = self;
            cell.isSee = NO;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        self.refundView.listArr = self.reasonArray;
        __weak __typeof(self)weakSelf = self;
        self.refundView.clickConfirmBlock = ^(BogoRefundReasonModel * _Nonnull model) {
        
            if (model) {
                BogoShopFillInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell setRightTitle:model.value];
                NSString *r_id = [NSString stringWithFormat:@"%@",model.key];
                [weakSelf.param setObject:r_id forKey:@"reason_id"];
                [weakSelf.param setObject:model.value forKey:@"reason"];
            }
            
        };
        [self.refundView show:self.view type:FDPopTypeBottom];
//        BogoShopFillInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        BRStringPickerView *pickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
//        [pickerView setTitle:@"请选择退款原因"];
//        [pickerView setDataSourceArr:self.reasonArray];
//        pickerView.selectIndex = 0;
//        pickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
//            [cell setRightTitle:resultModel.value];
//            NSString *r_id = [NSString stringWithFormat:@"%@",resultModel.key];
//            [self.param setObject:r_id forKey:@"reason_id"];
//            [self.param setObject:resultModel.value forKey:@"reason"];
//        };
//        [pickerView show];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 120;
            break;
        case 4:
            return 70;
            break;
        case 5:
            return 170;
            break;
        default:
            return 50;
            break;
    }
}

- (UIButton *)applyBtn{
    if (!_applyBtn) {
        _applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(35, 0, FD_ScreenWidth - 70, 40)];
        if (@available(iOS 11.0, *)) {
            _applyBtn.fd_bottom = self.view.fd_bottom - FD_Bottom_SafeArea_Height - 20 - 40 - 20;
        } else {
            // Fallback on earlier versions
            _applyBtn.fd_bottom = self.view.fd_bottom - 20 - 40 - 10;
        }
        [_applyBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        [_applyBtn setTitleColor:FD_WhiteColor forState:UIControlStateNormal];
        [_applyBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _applyBtn.layer.cornerRadius = 20;
        _applyBtn.clipsToBounds = YES;
        [_applyBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_applyBtn setBackgroundImage:[UIImage imageNamed:@"bogo_shop_refund_confirmBtn" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }
    return _applyBtn;
}

- (NSMutableArray *)reasonArray{
    if (!_reasonArray) {
        _reasonArray = [NSMutableArray array];
    }
    return _reasonArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        if (@available(iOS 11.0, *)) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight - 80 - FD_Bottom_SafeArea_Height) style:UITableViewStylePlain];
        } else {
            // Fallback on earlier versions
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight - 80) style:UITableViewStylePlain];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoOrderDetailCommodityCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoOrderDetailCommodityCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoCommodityInfoCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoExtCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoExtCell class])];
    }
    return _tableView;
}

- (NSMutableDictionary *)param{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
        [_param setObject:@"" forKey:@"reason_id"];
        [_param setObject:@"" forKey:@"reason"];
    }
    return _param;
}

- (NSMutableArray *)refund_img{
    if (!_refund_img) {
        _refund_img = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
            [_refund_img addObject:@""];
        }
    }
    return _refund_img;
}

-(BogoShopRefundView *)refundView{
    if (!_refundView) {
        _refundView = [[BogoShopRefundView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenWidth)];
    }
    return _refundView;
}

@end
