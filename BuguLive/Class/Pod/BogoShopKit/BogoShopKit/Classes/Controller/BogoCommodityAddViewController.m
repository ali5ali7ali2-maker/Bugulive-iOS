//
//  BogoCommodityAddViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/14.
//

#import "BogoCommodityAddViewController.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import "BogoShopFillInfoHeaderView.h"
#import "BogoCommodityMainPicCell.h"
#import "BogoCommodityInfoCell.h"
#import "BogoCommodityDetailCell.h"
#import "BogoCommodityModelAddCell.h"
#import "BogoCommodityModelEditHeaderView.h"
#import "BogoShopKit.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <YYKit/YYKit.h>
#import "BogoCommodityDetailModel.h"
#import <QMUIKit/QMUIKit.h>
#import <Masonry/Masonry.h>
#import "FDUIKitObjC.h"
#import "FDNetworkObjC.h"
#import <MJExtension/MJExtension.h>

static CGFloat const kViewHeight = 140 + 140 + 20;
static NSInteger const kImgNum = 30;

@interface BogoCommodityAddViewController ()<UITableViewDelegate,UITableViewDataSource,BogoCommodityInfoCellDelegate,BogoCommodityModelEditHeaderViewDelegate,BogoCommodityDetailCellDelegate,BogoCommodityMainPicCellDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray <BogoCommodityDetailAttrModel *>*modelArray;

@property(nonatomic, strong) NSMutableArray *mainPicArray;//轮播图
@property(nonatomic, strong) NSMutableArray *detailPicArray;//详情图
@property(nonatomic, strong) NSMutableArray *detailPicBtnArray;//详情图

@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *saveBtn;

@property(nonatomic, strong) NSMutableDictionary *params;

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, assign) CGFloat detailContentViewHeight;

@end

@implementation BogoCommodityAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BogoCommodityDetailAttrModel *model = [[BogoCommodityDetailAttrModel alloc]init];
    [self.modelArray addObject:model];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.saveBtn];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@(( FD_ScreenWidth - 60 ) / 2));
        make.bottom.equalTo(self.view).offset(-FD_Bottom_SafeArea_Height);
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@(( FD_ScreenWidth - 60 ) / 2));
        make.bottom.equalTo(self.view).offset(-FD_Bottom_SafeArea_Height);
    }];
    
    [self.params setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    self.model = [[BogoCommodityDetailModel alloc]init];
    _detailContentViewHeight = 110;
}

- (void)setGid:(NSString *)gid{
    _gid = gid;
    if (gid.length) {
        self.title = @"编辑商品";
        [self requestData];
    }else{
        self.title = @"添加商品";
    }
}

- (void)setIsSee:(BOOL)isSee{
    _isSee = isSee;
    if (isSee) {
        self.title = @"查看商品";
        self.cancelBtn.hidden = YES;
        self.saveBtn.hidden = YES;
    }
}

- (void)requestData{
//    http://xx.com/api/Shopmanage/getGoodsInfo
    [[BogoNetwork shareInstance] GET:@"api/getGoodsInfoUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"gid":self.gid} success:^(BogoNetworkResponseModel * _Nonnull result) {
        self.model = [BogoCommodityDetailModel mj_objectWithKeyValues:result.data];
        
        NSString *free_shipping = [NSString stringWithFormat:@"%@",self.model.free_shipping];
        [self.params setObject:free_shipping forKey:@"free_shipping"];
        [self.mainPicArray setArray:[self.model.images componentsSeparatedByString:@","]];
        if (self.mainPicArray.count < 5) {
            NSInteger count = 5 - self.mainPicArray.count;
            for (NSInteger i = 0; i < count ; i++) {
                [self.mainPicArray addObject:@""];
            }
        }
        [self.modelArray setArray:self.model.attr];
        if (self.modelArray.count > 1) {
            for (NSInteger i = 1; i < self.modelArray.count; i++) {
                //规格
                [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityInfoCell class]),i+1 ,0]];
                [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityInfoCell class]),i+1,1]];
                [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityInfoCell class]),i+1,2]];
                //规格头
                [self->_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityModelEditHeaderView class]) bundle:kShopKitBundle] forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityModelEditHeaderView class]),i+1,0]];
                //规格加
                [self->_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityModelAddCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityModelAddCell class]),i+1 + 1,0]];
                //其他头
                [self->_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoHeaderView class]) bundle:kShopKitBundle] forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoShopFillInfoHeaderView class]),i+1 + 2,0]];
                //快递费
                [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityInfoCell class]),i+1 + 2,0]];
                //详情
                [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityDetailCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityDetailCell class]),i+1 + 2,1]];
            }
        }
        [self.detailPicBtnArray setArray:[self.model.info_images componentsSeparatedByString:@","]];
        if (self.detailPicBtnArray.count < kImgNum) {
            [self.detailPicBtnArray addObject:@""];
        }
        NSArray *urlArray = [self.model.info_images componentsSeparatedByString:@","];
        for (NSInteger i = 0; i < urlArray.count; i++) {
            NSString *url = urlArray[i];
            [self.detailPicArray replaceObjectAtIndex:i withObject:url];
        }
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)saveBtnAction:(UIButton *)sender{
    if (_isSee) {
        return;
    }
//    http://xx.com/api/Shopmanage/goodsAdd
    

    BogoCommodityDetailCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:self.modelArray.count + 2]];
    
    NSLog(@"BogoCommodityDetailCell%@",cell.textView.text);
    
    
    
    
    
//    NSMutableArray *arr = [NSMutableArray array];
//    [self.detailPicArray componentsJoinedByString:@","];
    
   
//    for (NSString *str in [self.detailPicArray reverseObjectEnumerator]) {
//        if (str.length == 0) {
//            [self.detailPicArray removeObject:str];
//        }
//    }
    
    NSString *images =[self.mainPicArray componentsJoinedByString:@","];
    NSString *info_Images = [self.detailPicArray componentsJoinedByString:@","];
    
    for (int i = 0; i < 5; i ++) {
        if (info_Images.length > kImgNum) {
           info_Images = [info_Images stringByReplacingOccurrencesOfString:@",," withString:@","];
        }else{
            info_Images = @"";
        }
        if (images.length > kImgNum) {
            images = [images stringByReplacingOccurrencesOfString:@",," withString:@","];
        }else{
            images = @"";
        }
    }
    
    
    [self.params setObject:images forKey:@"images"];
    [self.params setObject:@"2" forKey:@"model_id"];
    
    
    [self.params setObject:info_Images forKey:@"info_images"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (BogoCommodityDetailAttrModel *model in self.modelArray) {
        [tempArray addObject:model.mj_keyValues];
    }
    NSData *attrData = [NSJSONSerialization dataWithJSONObject:tempArray options:NSJSONWritingPrettyPrinted error:nil];
    [self.params setObject:[attrData mj_JSONString] forKey:@"attr"];
    if (self.gid.length) {
        //http://xx.com/api/Shopmanage/editDoods
        [self.params setObject:self.gid forKey:@"gid"];
        [[BogoNetwork shareInstance] POST:@"api/editGoodsUrl" param:self.params success:^(BogoNetworkResponseModel * _Nonnull result) {
            [[FDHUDManager defaultManager] show:@"修改成功" ToView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
        }];
    }else{
        [[BogoNetwork shareInstance] POST:@"api/goodsAddUrl" param:self.params success:^(BogoNetworkResponseModel * _Nonnull result) {
            [[FDHUDManager defaultManager] show:@"添加成功" ToView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
        }];
    }
}

- (void)cancelBtnAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BogoCommodityInfoCellDelegate,BogoCommodityModelEditHeaderViewDelegate,BogoCommodityDetailCellDelegate,BogoCommodityMainPicCellDelegate
- (void)picCell:(BogoCommodityMainPicCell *)picCell didClickPicBtn:(UIButton *)sender{
    if (_isSee) {
        return;
    }
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
                    [sender setImage:photos.lastObject forState:UIControlStateNormal];
                    [picCell addDeleteBtnToView:sender];
                    [self.mainPicArray replaceObjectAtIndex:sender.tag - kBogoCommodityMainPicCellBaseTag withObject:resultStr];
                    self.model.images = [self.mainPicArray componentsJoinedByString:@","];
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
                [sender setImage:photos.lastObject forState:UIControlStateNormal];
                [picCell addDeleteBtnToView:sender];
                [self.mainPicArray replaceObjectAtIndex:sender.tag - kBogoCommodityMainPicCellBaseTag withObject:url];
                self.model.images = [self.mainPicArray componentsJoinedByString:@","];
            }];
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
        }];
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)picCell:(BogoCommodityMainPicCell *)picCell didClickPicDeleteBtn:(UIButton *)sender{
    if (_isSee) {
        return;
    }
    [self.mainPicArray replaceObjectAtIndex:sender.tag - kBogoCommodityMainPicCellBaseTag withObject:@""];
    self.model.images = [self.mainPicArray componentsJoinedByString:@","];
    
    
}

- (void)infoCell:(BogoCommodityInfoCell *)infoCell didTextFieldChange:(UITextField *)textField{
    if (!textField.text.length) {
        return;
    }
    if (infoCell.type == BogoCommodityInfoCellTypeTitle) {
        [self.params setObject:textField.text forKey:@"title"];
        self.model.title = textField.text;
    }else if (infoCell.type == BogoCommodityInfoCellTypeTransferFee) {
        [self.params setObject:[textField.text substringFromIndex:@"￥".length] forKey:@"free_shipping"];
        self.model.free_shipping = [textField.text substringFromIndex:@"￥".length];
    }else{
        NSIndexPath *indexPath = [self.tableView indexPathForCell:infoCell];
        if (self.modelArray.count == 1) {
            if (indexPath.section == 1) {
                BogoCommodityDetailAttrModel *model = self.modelArray.firstObject;
                switch (infoCell.type) {
                    case BogoCommodityInfoCellTypeModelName:
                        model.name = textField.text;
                        break;
                    case BogoCommodityInfoCellTypeModelPrice:
                        if ([textField.text containsString:@"￥"]) {
                            model.price = [NSString stringWithFormat:@"%f",[textField.text substringFromIndex:@"￥".length].floatValue * 100];
                        }else{
                            model.price = [NSString stringWithFormat:@"%f",textField.text.floatValue * 100];
                        }
                        break;
                    case BogoCommodityInfoCellTypeModelCount:
                        model.stock = textField.text;
                        break;
                    default:
                        break;
                }
                self.model.attr = self.modelArray;
            }
        }else{
            if (indexPath) {
                BogoCommodityDetailAttrModel *model = self.modelArray[indexPath.section - 1];
                switch (infoCell.type) {
                    case BogoCommodityInfoCellTypeModelName:
                        model.name = textField.text;
                        break;
                    case BogoCommodityInfoCellTypeModelPrice:
                        if ([textField.text containsString:@"￥"]) {
                            model.price = [NSString stringWithFormat:@"%f",[textField.text substringFromIndex:@"￥".length].floatValue * 100];
                        }else{
                            model.price = [NSString stringWithFormat:@"%f",textField.text.floatValue * 100];
                        }
                        break;
                    case BogoCommodityInfoCellTypeModelCount:
                        model.stock = textField.text;
                        break;
                    default:
                        break;
                }
                self.model.attr = self.modelArray;
            }
        }
    }
}

- (void)headerView:(BogoCommodityModelEditHeaderView *)headerView didClickDeleteBtn:(UIButton *)sender{
    if (_isSee) {
        return;
    }
    //删除规格
    NSString *title = headerView.titleLabel.text;
    NSInteger index = [title substringFromIndex:@"规格".length].integerValue;
    [self.modelArray removeObjectAtIndex:index - 1];
    self.model.attr = self.modelArray;
    [self.tableView deleteSection:headerView.indexPath.section withRowAnimation:UITableViewRowAnimationFade];
}

- (void)detailCell:(BogoCommodityDetailCell *)detailCell didClickAddBtn:(UIButton *)sender{
    if (_isSee) {
        return;
    }
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
                    //增加cell高度
                    [detailCell addButton];
                    [self.detailPicArray replaceObjectAtIndex:sender.tag - kBogoCommodityDetailCellBaseTag withObject:resultStr];
                    [self.detailPicBtnArray setArray:detailCell.buttonArray];
                    self.model.info_images = [self.detailPicArray componentsJoinedByString:@","];
                    [self.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:self.modelArray.count + 2] withRowAnimation:UITableViewRowAnimationNone];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.tableView scrollToBottom];
                    });
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
                //增加cell高度
                [detailCell addButton];
                [self.detailPicArray replaceObjectAtIndex:sender.tag - kBogoCommodityDetailCellBaseTag withObject:url];
                [self.detailPicBtnArray setArray:detailCell.buttonArray];
                self.model.info_images = [self.detailPicArray componentsJoinedByString:@","];
                [self.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:self.modelArray.count + 2] withRowAnimation:UITableViewRowAnimationNone];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView scrollToBottom];
                });
            }];
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
        }];
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)detailCell:(BogoCommodityDetailCell *)detailCell didClickDelBtn:(UIButton *)sender{
    if (_isSee) {
        return;
    }
    //减少cell高度
    UIButton *button = (UIButton *)sender.superview;
    NSInteger index = button.tag - kBogoCommodityDetailCellBaseTag;
//    [self.detailPicArray replaceObjectAtIndex:index withObject:@""];
    [self.detailPicBtnArray removeObjectAtIndex:index];
    
    NSMutableArray *urlArray = [NSMutableArray arrayWithArray:[self.model.info_images componentsSeparatedByString:@","]];
    
    
    
//    for (int i = 0; i < urlArray.count; i++) {
//
//        NSString *url = [urlArray objectAtIndex:index + i];
//
//        if (url.length && ![url containsString:@","]) {
//            [urlArray replaceObjectAtIndex:index withObject:@""];
//            [self.detailPicArray replaceObjectAtIndex:index withObject:@""];
//            break;
//        }else{
//           if (index + i <= urlArray.count) {
//
//               [urlArray replaceObjectAtIndex:index + 1 withObject:@""];
//               [self.detailPicArray replaceObjectAtIndex:index + 1 withObject:@""];
//           }
//        }
//    }
    
    NSString *url = [urlArray objectAtIndex:index];
    if (url.length && ![url containsString:@","]) {
        [urlArray replaceObjectAtIndex:index withObject:@""];
        
        [self.detailPicArray replaceObjectAtIndex:index withObject:@""];
        [detailCell.imgWHRadioArr removeObjectAtIndex:index];
    }else{
        
       if (index + 1 <= urlArray.count) {
           [urlArray replaceObjectAtIndex:index + 1 withObject:@""];
           [self.detailPicArray replaceObjectAtIndex:index + 1 withObject:@""];
           if (index + 1 <= detailCell.imgWHRadioArr.count) {
               [detailCell.imgWHRadioArr removeObjectAtIndex:index + 1];
           }
       }
    }
    
    self.model.info_images = [urlArray componentsJoinedByString:@","];
    
    [self.tableView reloadSection:self.modelArray.count + 2 withRowAnimation:UITableViewRowAnimationFade];
//    [detailCell resetAllButtonHeight];
}

-(void)detailCell:(BogoCommodityDetailCell *)detailCell contentStr:(UITextView *)sender{
    
    [self.params setObject:sender.text forKey:@"detail"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelArray.count + 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 5;
    }else if (section == self.modelArray.count + 2){
        return 2;
    }else if (section == self.modelArray.count + 1){
        return 1;
    }else{
        if (self.modelArray.count != 1) {
            return 3;
        }else{
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BogoCommodityMainPicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoCommodityMainPicCell class]) forIndexPath:indexPath];
        cell.isSee = _isSee;
        [cell setModel:self.model];
        if (!_isSee) {
            cell.delegate = self;
        }
        return cell;
    }else if (indexPath.section == 1){
        BogoCommodityInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@%ld%ld",NSStringFromClass([BogoCommodityInfoCell class]),indexPath.section,indexPath.row] forIndexPath:indexPath];
        if (!_isSee) {
            cell.delegate = self;
        }
        cell.isSee = _isSee;
        [cell setType:indexPath.row];
        if (indexPath.row > 1) {
            BogoCommodityDetailAttrModel *model = self.model.attr.firstObject;
            switch (indexPath.row) {
                case 2:
                    [cell.textField setText:model.name];
                    break;
                case 3:
                {
                    if (model.price.length) {
                        NSString *price = [NSString stringWithFormat:@"%.2f",model.price.length ? model.price.floatValue / 100 : 0];
                        [cell.textField setText:[NSString stringWithFormat:@"￥%@",price]];
                    }
                }
                    break;
                case 4:
                    [cell.textField setText:model.stock];
                    break;
                default:
                    break;
            }
        }
        [cell setModel:self.model];
        return cell;
    }else if (indexPath.section == self.modelArray.count + 2){
        if (indexPath.row == 0) {
            BogoCommodityInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@%ld%ld",NSStringFromClass([BogoCommodityInfoCell class]),indexPath.section,indexPath.row] forIndexPath:indexPath];
            [cell setType:BogoCommodityInfoCellTypeTransferFee];
            [cell setModel:self.model];
            if (!_isSee) {
                cell.delegate = self;
            }
            cell.isSee = _isSee;
            return cell;
        }else{
            BogoCommodityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@%ld%ld",NSStringFromClass([BogoCommodityDetailCell class]),indexPath.section,indexPath.row] forIndexPath:indexPath];
            if (!_isSee) {
                cell.delegate = self;
            }
            cell.isSee = _isSee;
            [cell setModel:self.model];
            if (!_isSee) {
                [self.detailPicBtnArray setArray:cell.buttonArray];
            }
            return cell;
        }
    }else if (indexPath.section == self.modelArray.count + 1){
        BogoCommodityModelAddCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@%ld%ld",NSStringFromClass([BogoCommodityModelAddCell class]),indexPath.section,indexPath.row] forIndexPath:indexPath];
        return cell;
    }else{
        if (self.modelArray.count != 1) {
            BogoCommodityInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@%ld%ld",NSStringFromClass([BogoCommodityInfoCell class]),indexPath.section,indexPath.row] forIndexPath:indexPath];
            if (!_isSee) {
                cell.delegate = self;
            }
            cell.isSee = _isSee;
            [cell setType:indexPath.row + 2];
            [cell setModel:self.model];
            BogoCommodityDetailAttrModel *model = self.modelArray[indexPath.section - 1];
            switch (indexPath.row) {
                case 0:
                    [cell.textField setText:model.name];
                    break;
                case 1:
                {
                    if (model.price.length) {
                        NSString *price = [NSString stringWithFormat:@"%.2f",model.price.length ? model.price.floatValue / 100 : 0];
                        [cell.textField setText:[NSString stringWithFormat:@"￥%@",price]];
                    }
                }
                    break;
                case 2:
                    [cell.textField setText:model.stock];
                    break;
                default:
                    break;
            }
            return cell;
        }else{
            return nil;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isSee) {
        return;
    }
    if (indexPath.section == self.modelArray.count + 1) {
        //点击了添加规格按钮
        [self.modelArray addObject:[[BogoCommodityDetailAttrModel alloc] init]];
        //规格
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityInfoCell class]),self.modelArray.count ,0]];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityInfoCell class]),self.modelArray.count,1]];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityInfoCell class]),self.modelArray.count,2]];
        //规格头
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityModelEditHeaderView class]) bundle:kShopKitBundle] forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityModelEditHeaderView class]),self.modelArray.count,0]];
        //规格加
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityModelAddCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityModelAddCell class]),self.modelArray.count + 1,0]];
        //其他头
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoHeaderView class]) bundle:kShopKitBundle] forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoShopFillInfoHeaderView class]),self.modelArray.count + 2,0]];
        //快递费
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityInfoCell class]),self.modelArray.count + 2,0]];
        //详情
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityDetailCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityDetailCell class]),self.modelArray.count + 2,1]];
        [self.tableView insertSection:self.modelArray.count withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 140;
    }else if (indexPath.section == 1){
        return 50;
    }else if (indexPath.section == self.modelArray.count + 2){
        switch (indexPath.row) {
            case 0:
                return 50;
                break;
            case 1:
            {
                if (!_isSee) {
                    return 50 + _detailContentViewHeight + 110 + kViewHeight;
//                    (10 + kViewHeight) * self.detailPicBtnArray.count + 110;
                }else{
                    NSMutableArray *tempArray = [NSMutableArray array];
                    for (NSString *url in self.detailPicBtnArray) {
                        if (url.length) {
                            [tempArray addObject:url];
                        }
                    }
                    return 50 + _detailContentViewHeight + 110 + kViewHeight;
//                    (10 + kViewHeight) * tempArray.count + 110;
                }
            }
                break;
            default:
                return 0;
                break;
        }
    }else if (indexPath.section == self.modelArray.count + 1) {
        if (!_isSee) {
            return 79;
        }
        return 0;
    }else{
        if (self.modelArray.count != 1) {
            return 50;
        }else{
            return 0;
        }
    }
}

-(void)detailCell:(BogoCommodityDetailCell *)detailCell resetContentViewHeight:(CGFloat)viewHeight{
    _detailContentViewHeight = viewHeight;
    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 5)];
        view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        return view;
    }else if (section == self.modelArray.count + 2) {
        BogoShopFillInfoHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([BogoShopFillInfoHeaderView class])];
        [headerView.titleLabel setText:@"其他设置"];
        return headerView;
    }else{
        if (self.modelArray.count != 1) {
            if (section != self.modelArray.count + 1) {
                BogoCommodityModelEditHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[NSString stringWithFormat:@"%@%ld%d",NSStringFromClass([BogoCommodityModelEditHeaderView class]),section,0]];
                [headerView.titleLabel setText:[NSString stringWithFormat:@"规格%ld",section]];
                headerView.delegate = self;
                headerView.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                headerView.isSee = _isSee;
                return headerView;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 0;
    }else if (section == 1){
        return 5;
    }else if (section == self.modelArray.count + 2) {
        return 55;
    }else{
        if (self.modelArray.count != 1) {
            if (section != self.modelArray.count + 1) {
                return 55;
            }else{
                return 0;
            }
        }
        return 0;
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight - FD_Bottom_Height - FD_Top_Height) style:UITableViewStylePlain];
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoHeaderView class]) bundle:bundle] forHeaderFooterViewReuseIdentifier:NSStringFromClass([BogoShopFillInfoHeaderView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityMainPicCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoCommodityMainPicCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:bundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%@",NSStringFromClass([BogoCommodityInfoCell class]),@"10"]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:bundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%@",NSStringFromClass([BogoCommodityInfoCell class]),@"11"]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:bundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%@",NSStringFromClass([BogoCommodityInfoCell class]),@"12"]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:bundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%@",NSStringFromClass([BogoCommodityInfoCell class]),@"13"]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:bundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%@",NSStringFromClass([BogoCommodityInfoCell class]),@"14"]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityModelAddCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%@",NSStringFromClass([BogoCommodityModelAddCell class]),@"20"]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityInfoCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%@",NSStringFromClass([BogoCommodityInfoCell class]),@"30"]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityDetailCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:[NSString stringWithFormat:@"%@%@",NSStringFromClass([BogoCommodityDetailCell class]),@"31"]];
    }
    return _tableView;
}

- (NSMutableArray<BogoCommodityDetailAttrModel *> *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#F46628"] forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _cancelBtn.layer.cornerRadius = 20;
        _cancelBtn.clipsToBounds = YES;
        _cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"#F46628"].CGColor;
        _cancelBtn.layer.borderWidth = 1;
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:FD_WhiteColor forState:UIControlStateNormal];
        [_saveBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _saveBtn.layer.cornerRadius = 20;
        _saveBtn.clipsToBounds = YES;
        [_saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,( FD_ScreenWidth - 60 ) / 2,40);
        gl.startPoint = CGPointMake(0, 0.5);
        gl.endPoint = CGPointMake(1, 0.5);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:116/255.0 blue:44/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:222/255.0 green:29/255.0 blue:22/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        [_saveBtn.layer insertSublayer:gl below:_saveBtn.titleLabel.layer];
    }
    return _saveBtn;
}

- (NSMutableDictionary *)params{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

- (NSMutableArray *)detailPicArray{
    if (!_detailPicArray) {
        _detailPicArray = [NSMutableArray array];
        for (NSInteger i = 0; i < kImgNum; i++) {
            [_detailPicArray addObject:@""];
        }
    }
    return _detailPicArray;
}

- (NSMutableArray *)detailPicBtnArray{
    if (!_detailPicBtnArray) {
        _detailPicBtnArray = [NSMutableArray array];
        [_detailPicBtnArray addObject:@""];
    }
    return _detailPicBtnArray;
}

- (NSMutableArray *)mainPicArray{
    if (!_mainPicArray) {
        _mainPicArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 5; i++) {
            [_mainPicArray addObject:@""];
        }
    }
    return _mainPicArray;
}

@end
