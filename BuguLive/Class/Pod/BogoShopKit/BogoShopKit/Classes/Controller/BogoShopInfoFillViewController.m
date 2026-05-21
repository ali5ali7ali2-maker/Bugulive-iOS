//
//  BogoShopInfoFillViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import "BogoShopInfoFillViewController.h"
#import "FDUIKitObjC.h"
#import "BogoShopFillInfoCell.h"
#import "BogoShopFillInfoExtCell.h"
#import "BogoShopFillInfoCardCell.h"
#import "BogoShopFillInfoTextCell.h"
#import "BogoShopFillInfoHeaderView.h"
#import <BRPickerView/BRPickerView.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import "BogoShopFillInfoTipHeaderView.h"
#import "BogoShopKit.h"
#import "BogoShopKit.h"
#import "BogoShopTypeModel.h"
#import "BogoAddressModel.h"
#import <QMUIKit/QMUIKit.h>
#import "UIImageView+WebCache.h"
#import <Masonry/Masonry.h>
#import "BogoCategoryModel.h"
#import "FDNetworkObjC.h"
#import <MJExtension/MJExtension.h>
#import <YYKit/YYKit.h>
#import "BogoNetworkKit.h"
#import "BogoNetworkResponseModel.h"
@interface BogoShopInfoFillViewController ()<UITableViewDelegate,UITableViewDataSource,BogoShopFillInfoCardCellDelegate,BogoShopFillInfoExtCellDelegate,BogoShopFillInfoTextCellDelegate,BogoShopFillInfoCellDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *submitBtn;

@property(nonatomic, strong) NSMutableArray *typeArray;
@property(nonatomic, strong) NSMutableDictionary *param;

@property(nonatomic, strong) BogoAddressModel *addressModel;

@property(nonatomic, strong) NSMutableArray *banner;

@end

@implementation BogoShopInfoFillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = FD_WhiteColor;
    self.title = @"申请开店";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(35);
        make.right.equalTo(self.view).offset(-35);
        make.height.mas_equalTo(@40);
        make.bottom.equalTo(self.view).offset(-FD_Bottom_SafeArea_Height);
    }];
    [self requestTypeData];
    [self requestAddressData];
    [self.param setObject:[BogoNetwork shareInstance].token forKey:@"token"];
}

- (void)setStatus:(NSInteger)status{
    _status = status;
    if (status == 1) {
        self.submitBtn.hidden = YES;
        self.title = @"开店资料";
    }else if (status == 2){
        self.title = @"开店资料";
    }else if (status == 0){
       self.submitBtn.hidden = YES;
       self.title = @"开店资料";
    }else{
        self.title = @"填写资料";
    }
}

- (void)setModel:(BogoShopInfoModel *)model{
    _model = model;
    [self.param setDictionary:model.mj_keyValues];
    [self.tableView reloadData];
    [self requestAddressData];
}

- (void)requestTypeData{
    __weak __typeof(self)weakSelf = self;
    [[BogoNetwork shareInstance] GET:@"api/catListUrl" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.typeArray removeAllObjects];
        for (NSDictionary *dict in result.data[@"list"]) {
            BogoCategoryModel *model = [BogoCategoryModel mj_objectWithKeyValues:dict];
            model.parentKey = @"-1";
            [strongSelf.typeArray addObject:model];
//            [strongSelf.typeArray addObjectsFromArray:model.children];
        }
    } failure:^(NSString * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[FDHUDManager defaultManager] show:error ToView:strongSelf.view];
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
    if (self.model) {
        for (BogoProvinceModel *province in self.addressModel.province_list) {
            if ([province.code isEqualToString:self.model.province]) {
                self.model.province = province.name;
            }
            for (BogoCityModel *city in province.citylist) {
                if ([city.code isEqualToString:self.model.city]) {
                    self.model.city = city.name;
                }
                for (BogoAreaModel *area in city.arealist) {
                    if ([area.code isEqualToString:self.model.county]) {
                        self.model.county = area.name;
                    }
                }
            }
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)submitBtnAction:(UIButton *)sender{
    
//    NSMutableDictionary *dic = self.param;
    
    
//    BogoShopFillInfoCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
////    [nameCell.righttit setText:_model.name];
//    NSString *name = nameCell.rightTitleLabel.text;
//
//    BogoShopFillInfoCell *idCardCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
////    [idCardCell.rightTextField setText:_model.name];
//    NSString *idCardStr = idCardCell.rightTitleLabel.text;
//
//    BogoShopFillInfoCell *mobilCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
////    [mobilCell.rightTextField setText:_model.name];
//    NSString *mobilStr = mobilCell.rightTitleLabel.text;
    
    NSString *shopTitle = [self.param objectForKey:@"title"];

    if (shopTitle.length > 8) {
        [[FDHUDManager defaultManager] show:@"店铺名称不得多于八个字" ToView:self.view];
        return;
    }

    [self.param setObject:@"2" forKey:@"model_id"];

//    [self.param setObject:name forKey:@"name"];
//    [self.param setObject:mobilStr forKey:@"mobile"];
//
//    [self.param setObject:idCardStr forKey:@"mobile"];
    NSString *id_card_number = [NSString stringWithFormat:@"%@",self.param[@"id_card_number"]];
    if (id_card_number.length) {
        if (![BogoShopInfoFillViewController checkUserIDCard:id_card_number]) {
            [[FDHUDManager defaultManager] show:@"身份证号不合法" ToView:self.view];
            return;
        }
    }
    
    [[BogoNetwork shareInstance] POST:@"api/shopApplyUrl" param:self.param success:^(BogoNetworkResponseModel * _Nonnull result) {
        [[FDHUDManager defaultManager] show:@"提交成功" ToView:[UIApplication sharedApplication].keyWindow];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
    
    
    
}

#pragma mark - BogoShopFillInfoCardCellDelegate
- (void)cardCell:(BogoShopFillInfoCardCell *)cardCell didClickFrontImageBtn:(UITapGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    TZImagePickerController *picker = [[BogoImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:nil];
    picker.allowTakeVideo = NO;
    picker.allowPickingVideo = NO;
    __weak __typeof(self)weakSelf = self;
    [picker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[FDHUDManager defaultManager] showLoading:@"正在上传" ToView:strongSelf.view];
        
        
        
        [[FDOSSManager defaultManager] setup:^{
            
            NSLog(@"imageph%@",photos.firstObject);
            
            
            [[FDOSSManager defaultManager] UPLOAD:UIImagePNGRepresentation(photos.lastObject) progress:^(float percent) {
                NSLog(@"上传进度:%f",percent);
            } success:^(NSString * _Nonnull resultStr) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FDHUDManager defaultManager] hideLoading];
                    [imageView setImage:photos.lastObject];
//                    cardCell.frontLabel.hidden = YES;
                    [self.param setObject:resultStr forKey:@"id_card1"];
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
//                NSLog(@"上传进度:%f",percent);
            } completeHandler:^(FDQiniuResponseModel * _Nonnull response) {
                [[FDHUDManager defaultManager] hideLoading];
                [imageView setImage:photos.lastObject];
//                cardCell.frontLabel.hidden = YES;
                [self.param setObject:[NSString stringWithFormat:@"%@%@",model.domain,response.key] forKey:@"id_card1"];
            }];
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
        }];
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)cardCell:(BogoShopFillInfoCardCell *)cardCell didClickBackImageBtn:(UITapGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    TZImagePickerController *picker = [[BogoImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:nil];
    picker.allowTakeVideo = NO;
    picker.allowPickingVideo = NO;
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
                    [imageView setImage:photos.lastObject];
//                    cardCell.backLabel.hidden = YES;
                    [self.param setObject:resultStr forKey:@"id_card2"];
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
//                NSLog(@"上传进度:%f",percent);
            } completeHandler:^(FDQiniuResponseModel * _Nonnull response) {
                [[FDHUDManager defaultManager] hideLoading];
                [imageView setImage:photos.lastObject];
//                cardCell.backLabel.hidden = YES;
                [self.param setObject:[NSString stringWithFormat:@"%@%@",model.domain,response.key] forKey:@"id_card2"];
            }];
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
        }];
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)cardCell:(BogoShopFillInfoCardCell *)cardCell didClickHandImageBtn:(UITapGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    TZImagePickerController *picker = [[BogoImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:nil];
    picker.allowTakeVideo = NO;
    picker.allowPickingVideo = NO;
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
                    [imageView setImage:photos.lastObject];
//                    cardCell.backLabel.hidden = YES;
                    [self.param setObject:resultStr forKey:@"holding_identity"];
                });
            } failure:^(NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FDHUDManager defaultManager] show:error.localizedDescription ToView:self.view];
                });
            }];
        }];
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)cardCell:(BogoShopFillInfoCardCell *)cardCell didClickLogoImageBtn:(UITapGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    TZImagePickerController *picker = [[BogoImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:nil];
    picker.allowTakeVideo = NO;
    picker.allowPickingVideo = NO;
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
                    [imageView setImage:photos.lastObject];
//                    cardCell.backLabel.hidden = YES;
                    [self.param setObject:resultStr forKey:@"logo"];
                });
            } failure:^(NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FDHUDManager defaultManager] show:error.localizedDescription ToView:self.view];
                });
            }];
        }];
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - BogoShopFillInfoExtCellDelegate
- (void)extCell:(BogoShopFillInfoExtCell *)extCell didClickImageBtn:(UIButton *)sender{
    TZImagePickerController *picker = [[BogoImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:nil];
    picker.allowTakeVideo = NO;
    picker.allowPickingVideo = NO;
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
                    [self.banner replaceObjectAtIndex:sender.tag - kBogoShopFillInfoExtCellBaseTag withObject:resultStr];
                    NSString *bannerStr = [self.banner componentsJoinedByString:@","];
                    while ([bannerStr hasSuffix:@","]) {
                        bannerStr = [bannerStr stringByReplacingCharactersInRange:NSMakeRange(bannerStr.length - 1, 1) withString:@""];
                    }
                    [self.param setObject:bannerStr forKey:@"banner"];
                    [sender setImage:photos.lastObject forState:UIControlStateNormal];
                    [extCell addDeleteBtnToSuperView:sender];
                    [extCell addButton];
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
                NSString *url = [NSString stringWithFormat:@"%@%@",model.domain,response.key];
                [self.banner replaceObjectAtIndex:sender.tag - kBogoShopFillInfoExtCellBaseTag withObject:url];
                NSString *bannerStr = [self.banner componentsJoinedByString:@","];
                while ([bannerStr hasSuffix:@","]) {
                    bannerStr = [bannerStr stringByReplacingCharactersInRange:NSMakeRange(bannerStr.length - 1, 1) withString:@""];
                }
                [self.param setObject:bannerStr forKey:@"banner"];
                [sender setImage:photos.lastObject forState:UIControlStateNormal];
                [extCell addDeleteBtnToSuperView:sender];
                [extCell addButton];
            }];
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
        }];
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)extCell:(BogoShopFillInfoExtCell *)extCell didClickImageDelBtn:(UIButton *)sender{
    [self.banner replaceObjectAtIndex:sender.tag - kBogoShopFillInfoExtCellBaseTag withObject:@""];
    NSString *bannerStr = [self.banner componentsJoinedByString:@","];
    while ([bannerStr hasSuffix:@","]) {
        bannerStr = [bannerStr stringByReplacingCharactersInRange:NSMakeRange(bannerStr.length - 1, 1) withString:@""];
    }
    [self.param setObject:bannerStr forKey:@"banner"];
}


#pragma mark - BogoShopFillInfoCellDelegate

-(void)shopFillInfoCellTextChange:(BogoShopFillInfoCell *)cell textField:(UITextField *)textField{
    switch (cell.type) {
            
        case BogoShopFillInfoCellTypeName:
            [self.param setObject:textField.text forKey:@"title"];
            break;
            
        case BogoShopFillInfoCellTypeIDNumber:
            [self.param setObject:textField.text forKey:@"id_card_number"];
            break;
            
        case BogoShopFillInfoCellTypeMobile:
            [self.param setObject:textField.text forKey:@"mobile"];
            break;
        case BogoShopFillInfoCellTypeShopTitle:
            [self.param setObject:textField.text forKey:@"title"];
        break;
         
        default:
            break;
    }
    
}

#pragma mark - BogoShopFillInfoTextCellDelegate

- (void)textCell:(BogoShopFillInfoTextCell *)textCell didChangeText:(UITextField *)textField{
    switch (textCell.type) {
        case BogoShopFillInfoCellTypeName:
            [self.param setObject:textField.text forKey:@"name"];
            break;
        case BogoShopFillInfoCellTypeIDNumber:
            [self.param setObject:textField.text forKey:@"id_card_number"];
            break;
            
        case BogoShopFillInfoCellTypeMobile:
            [self.param setObject:textField.text forKey:@"mobile"];
            break;
            
            
        case BogoShopFillInfoCellTypeShopTitle:
            [self.param setObject:textField.text forKey:@"title"];
            break;
        case BogoShopFillInfoTextCellTypeIDName:
            [self.param setObject:textField.text forKey:@"name"];
            break;
        case BogoShopFillInfoTextCellTypeIDNumber:
            [self.param setObject:textField.text forKey:@"id_card_number"];
            break;
        case BogoShopFillInfoTextCellTypeDetailAddress:
            [self.param setObject:textField.text forKey:@"address_info"];
            break;
            
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 1;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld%ld",indexPath.section,indexPath.row] forIndexPath:indexPath];
                    [cell setType:BogoShopFillInfoCellTypeType];
                    if (_model) {
                        [cell setRightTitle:_model.cat_name];
                    }
                    [cell setIsSee:(self.status == 0 || self.status == 1)];
                    return cell;
                }
                    break;
                case 1:
                {
                    BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld%ld",indexPath.section,indexPath.row] forIndexPath:indexPath];
                    [cell setType:BogoShopFillInfoCellTypeShopTitle];
                    if (_model.title.length) {
                        cell.rightTextField.text = _model.title;
                    }
                    cell.delegate = self;
                    [cell setIsSee:(self.status == 0 || self.status == 1)];
                    return cell;
                }
                    break;
                case 2:
                {
                    BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld%ld",indexPath.section,indexPath.row] forIndexPath:indexPath];
                    [cell setType:BogoShopFillInfoCellTypeAddress];
                    if (_model.city.length && _model.province.length) {
                        [cell setRightTitle:[NSString stringWithFormat:@"%@%@%@",_model.province,_model.city,_model.county]];
                    }
                    [cell setIsSee:(self.status == 0 || self.status == 1)];
                    return cell;
                }
                    break;
                case 3:
                {
                    BogoShopFillInfoTextCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld%ld",indexPath.section,indexPath.row] forIndexPath:indexPath];
                    cell.delegate = self;
                    [cell setType:BogoShopFillInfoTextCellTypeDetailAddress];
                    if (_model) {
                        [cell.rightTextField setText:_model.address_info];
                    }
                    [cell setIsSee:(self.status == 0 || self.status == 1)];
                    return cell;
                }
                    break;
//                case 3:
//                {
//                    BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld%ld",indexPath.section,indexPath.row] forIndexPath:indexPath];
//                    [cell setType:BogoShopFillInfoCellTypeAuth];
//                    return cell;
//                }
//                    break;
                case 4:
                {
                    BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld%ld",indexPath.section,indexPath.row] forIndexPath:indexPath];
                    [cell setType:BogoShopFillInfoCellTypeAvatar];
                    if (_model.logo.length) {
                        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_model.logo]];
                    }
                    [cell setIsSee:(self.status == 0 || self.status == 1)];
                    return cell;
                }
                    break;
                default:
                    return nil;
                    break;
            }
            break;
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld%ld",indexPath.section,indexPath.row] forIndexPath:indexPath];
                    cell.delegate = self;
                    [cell setType:BogoShopFillInfoCellTypeName];
                    if (_model) {
                        [cell.rightTextField setText:_model.name];
                    }
                    [cell setIsSee:(self.status == 0 || self.status == 1)];
                    return cell;
                }
                    break;
                case 1:
                {
                    BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld%ld",indexPath.section,indexPath.row] forIndexPath:indexPath];
                    cell.delegate = self;
                    [cell setType:BogoShopFillInfoCellTypeIDNumber];
                    if (_model) {
                        [cell.rightTextField setText:_model.id_card_number];
                    }
                    [cell setIsSee:(self.status == 0 || self.status == 1)];
                    return cell;
                }
                    break;
                case 2:
                {
                    BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld%ld",indexPath.section,indexPath.row] forIndexPath:indexPath];
                    cell.delegate = self;
                    [cell setType:BogoShopFillInfoCellTypeMobile];
                    if (_model) {
                        [cell.rightTextField setText:_model.id_card_number];
                    }
                    [cell setIsSee:(self.status == 0 || self.status == 1)];
                    return cell;
                }
                    break;
                default:
                    return nil;
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    BogoShopFillInfoCardCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld%ld",indexPath.section,indexPath.row] forIndexPath:indexPath];
                    cell.delegate = self;
                    if (_model.id_card1.length && _model.id_card2.length) {
                        
                    }
                    [cell setIsSee:(self.status == 0 || self.status == 1)];
                    return cell;
                }
                    break;
                case 1:
                {
                    BogoShopFillInfoExtCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld%ld",indexPath.section,indexPath.row] forIndexPath:indexPath];
                    cell.delegate = self;
                    [cell setIsSee:(self.status == 0 || self.status == 1)];
                    if (_model) {
                        [cell setModel:_model];
                    }
                    return cell;
                }
                    break;
                default:
                    return nil;
                    break;
            }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    return 50;
                }
                    break;
                case 1:
                {
                    return 50;
                }
                    break;
                case 2:
                {
                    return 50;
                }
                    break;
//                case 3:
//                {
//                    return 45;
//                }
//                    break;
                case 3:
                {
                    return 70;
                }
                    break;
                default:
                    return 0;
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    return 50;
                }
                    break;
                case 1:
                {
                    return 50;
                }
                    break;
                case 2:
                {
                    return 50;
                }
                    break;
                case 3:
                {
                    return 75;
                }
                    break;
                default:
                    return 0;
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    return 195;
                }
                    break;
                case 1:
                {
                    return 170;
                }
                    break;
                default:
                    return 0;
                    break;
            }
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 5:
        {
            BogoShopFillInfoTipHeaderView *headerView = (BogoShopFillInfoTipHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([BogoShopFillInfoTipHeaderView class])];
            NSString *text = @"";
            if (self.status == 0) {
                text = @"资料提交成功，请耐心等待审核";
            }else if (self.status == 1){
                text = @"您提交的资料已审核通过，恭喜开店成功！";
            }else if (self.status == 2){
                text = @"您提交的资料审核未通过，请修改后再提交";
            }else{
                text = @"请认真填写资料,资料提交成功后部分内容不可更改.";
            }
            [headerView setTitle:text];
            return headerView;
        }
            break;
        case 0:
        {
            BogoShopFillInfoHeaderView *headerView = (BogoShopFillInfoHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([BogoShopFillInfoHeaderView class])];
            [headerView.titleLabel setText:@"基本资料"];
            return headerView;
        }
            break;
        case 1:
        {
            BogoShopFillInfoHeaderView *headerView = (BogoShopFillInfoHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([BogoShopFillInfoHeaderView class])];
            [headerView.titleLabel setText:@"店铺资料"];
            return headerView;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 37;
            break;
        case 1:
            return 37;
            break;
        case 2:
            return 0;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 3)];
    view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.status == 0 || self.status == 1) {
//        return;
//    }
    [self.view endEditing:YES];
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    BogoShopFillInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    BRStringPickerView *pickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentLinkage];
                    [pickerView setTitle:@"选择类型"];
                    [pickerView setDataSourceArr:self.typeArray];
                    pickerView.selectIndexs = @[@(0)];
                    pickerView.resultModelArrayBlock = ^(NSArray<BRResultModel *> * _Nullable resultModelArr) {
                        BogoCategoryModel *childModel = resultModelArr.firstObject;
                        if ([childModel.parentKey isEqualToString:@"-1"]) {
                            childModel = resultModelArr.lastObject;
                        }
                        cell.rightTextField.text = childModel.value;
//                        [cell setRightTitle:childModel.value];
                        [self.param setObject:childModel.key forKey:@"cat_id"];
                    };
                    [pickerView show];
                }
                    break;
                case 2:
                {
                    BogoShopFillInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    BRAddressPickerView *pickerView = [[BRAddressPickerView alloc]initWithPickerMode:BRAddressPickerModeArea];
                    [pickerView setSelectIndexs:@[@(0)]];
                    pickerView.isAutoSelect = NO;
                    [pickerView setDataSourceArr:self.addressModel.province_list];
                    pickerView.resultBlock = ^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
//                        [cell setRightTitle:[NSString stringWithFormat:@"%@%@%@",province.name,city.name,area.name]];
                        
                        cell.rightTextField.text = [NSString stringWithFormat:@"%@%@%@",province.name,city.name,area.name];
                        
                        
                        
                        
                        [self.param setObject:province.name forKey:@"province"];
                        [self.param setObject:city.name forKey:@"city"];
                        [self.param setObject:area.name forKey:@"county"];
                        
                        [self.param setObject:area.code forKey:@"county_adcode"];
                        
                    };
                    [pickerView show];
                }
                    break;
//                case 3:
//                {
//                    BogoShopFillInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                    BRStringPickerView *pickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
//                    [pickerView setTitle:@"请选择认证类型"];
//                    [pickerView setDataSourceArr:@[@"个体工商户",@"企业"]];
//                    pickerView.selectIndex = 0;
//                    pickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
//                        [cell setRightTitle:resultModel.value];
//                    };
//                    [pickerView show];
//                }
//                    break;
                    case 3:
                {
                    return;
                    BogoShopFillInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    TZImagePickerController *picker = [[BogoImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:nil];
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
                }
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        NSBundle *bundle = kShopKitBundle;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, FD_Bottom_SafeArea_Height + 40 + 20, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:bundle] forCellReuseIdentifier:@"UITableViewCell10"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:bundle] forCellReuseIdentifier:@"UITableViewCell11"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:bundle] forCellReuseIdentifier:@"UITableViewCell12"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoTextCell class]) bundle:bundle] forCellReuseIdentifier:@"UITableViewCell13"];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:bundle] forCellReuseIdentifier:@"UITableViewCell13"];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:bundle] forCellReuseIdentifier:@"UITableViewCell04"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:bundle] forCellReuseIdentifier:@"UITableViewCell00"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:bundle] forCellReuseIdentifier:@"UITableViewCell01"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:bundle] forCellReuseIdentifier:@"UITableViewCell02"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCardCell class]) bundle:bundle] forCellReuseIdentifier:@"UITableViewCell20"];
        
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoTextCell class]) bundle:bundle] forCellReuseIdentifier:@"UITableViewCell20"];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoExtCell class]) bundle:bundle] forCellReuseIdentifier:@"UITableViewCell21"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoHeaderView class]) bundle:bundle] forHeaderFooterViewReuseIdentifier:NSStringFromClass([BogoShopFillInfoHeaderView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoTipHeaderView class]) bundle:bundle] forHeaderFooterViewReuseIdentifier:NSStringFromClass([BogoShopFillInfoTipHeaderView class])];
    }
    return _tableView;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_submitBtn setTitle:@"提交审核" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:FD_WhiteColor forState:UIControlStateNormal];
        
        [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _submitBtn.layer.cornerRadius = 20;
        _submitBtn.clipsToBounds = YES;
        [_submitBtn setBackgroundColor:[UIColor colorWithHexString:@"f42416"]];
        [_submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // gradient
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,0,FD_ScreenWidth - 70,40);
//        gl.startPoint = CGPointMake(0, 0.5);
//        gl.endPoint = CGPointMake(1, 0.5);
//        gl.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:116/255.0 blue:44/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:222/255.0 green:29/255.0 blue:22/255.0 alpha:1.0].CGColor];
//        gl.locations = @[@(0), @(1.0f)];
//        [_submitBtn.layer insertSublayer:gl below:_submitBtn.titleLabel.layer];
    }
    return _submitBtn;
}

- (NSMutableArray *)typeArray{
    if (!_typeArray) {
        _typeArray = [NSMutableArray array];
    }
    return _typeArray;
}

- (NSMutableArray *)banner{
    if (!_banner) {
        _banner = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@""]];
    }
    return _banner;
}

- (NSMutableDictionary *)param{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

#pragma mark - 检查身份证是否正确
+ (BOOL)checkUserIDCard:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length = 0;
    if (!value) {
        return NO;
    } else {
        length = value.length;
        //不满足15位和18位，即身份证错误
        if (length != 15 && length != 18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
    // 检测省份身份行政区代码
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO; //标识省份代码是否正确
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag = YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return NO;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    //分为15位、18位身份证进行校验
    switch (length) {
        case 15:
            //获取年份对应的数字
            year = [value substringWithRange:NSMakeRange(6, 2)].intValue + 1900;
            if (year %4 == 0 || (year %100 == 0 && year %4 == 0)) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                //测试出生日期的合法性
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];
            } else {
                //测试出生日期的合法性
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"options:NSRegularExpressionCaseInsensitive error:nil];
            }
            //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            if (numberofMatch > 0) {
                return YES;
            } else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6, 4)].intValue;
            if (year %4 == 0 || (year %100 == 0 && year %4 == 0)) {
                //测试出生日期的合法性
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];
            } else {
                //测试出生日期的合法性
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            
            if (numberofMatch > 0) {
                //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
                int S = [value substringWithRange:NSMakeRange(0, 1)].intValue * 7 + [value substringWithRange:NSMakeRange(10, 1)].intValue * 7 + [value substringWithRange:NSMakeRange(1, 1)].intValue * 9 + [value substringWithRange:NSMakeRange(11, 1)].intValue * 9 + [value substringWithRange:NSMakeRange(2, 1)].intValue * 10 + [value substringWithRange:NSMakeRange(12, 1)].intValue * 10 + [value substringWithRange:NSMakeRange(3, 1)].intValue * 5 + [value substringWithRange:NSMakeRange(13, 1)].intValue * 5 + [value substringWithRange:NSMakeRange(4, 1)].intValue * 8 + [value substringWithRange:NSMakeRange(14, 1)].intValue * 8 + [value substringWithRange:NSMakeRange(5, 1)].intValue * 4 + [value substringWithRange:NSMakeRange(15,1)].intValue * 4 + [value substringWithRange:NSMakeRange(6, 1)].intValue * 2 + [value substringWithRange:NSMakeRange(16, 1)].intValue * 2 + [value substringWithRange:NSMakeRange(7, 1)].intValue * 1 + [value substringWithRange:NSMakeRange(8, 1)].intValue * 6 + [value substringWithRange:NSMakeRange(9, 1)].intValue * 3;
                //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
                int Y = S %11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                //3：获取校验位
                M = [JYM substringWithRange:NSMakeRange(Y, 1)];
                NSString *lastStr = [value substringWithRange:NSMakeRange(17, 1)];
                NSLog(@"%@",M);
                NSLog(@"%@",[value substringWithRange:NSMakeRange(17, 1)]);
                //4：检测ID的校验位
                if ([lastStr isEqualToString:@"x"]) {
                    if ([M isEqualToString:@"X"]) {
                        return YES;
                    } else {
                        return NO;
                    }
                } else {
                    if ([M isEqualToString:[value substringWithRange:NSMakeRange(17, 1)]]) {
                        return YES;
                    } else {
                        return NO;
                    }
                }
            } else {
                return NO;
            }
        default:
            return NO;
    }
}

@end
