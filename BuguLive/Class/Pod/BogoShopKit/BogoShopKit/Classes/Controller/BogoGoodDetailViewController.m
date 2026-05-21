//
//  BogoGoodDetailViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "BogoGoodDetailViewController.h"
#import "FDUIKitObjC.h"
#import "BogoGoodDetailCell.h"
#import "BogoGoodDetailTopCell.h"
#import "BogoGoodDetailShopCell.h"
#import "BogoShopFillInfoCell.h"
#import <YYKit/YYKit.h>
#import "BogoShopKit.h"
#import <MJExtension/MJExtension.h>
#import "BogoCommodityDetailModel.h"
#import "BogoGoodDetailNavView.h"
#import "BogoGoodDetailBottomView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "BogoCartViewController.h"
#import "NSKeyedArchiver+FD.h"
#import "BogoGoodDetailAttrPopView.h"
#import "BogoOrderSubmitViewController.h"
#import "BogoShopDetailViewController.h"
#import "BogoGoodDetailWebCell.h"
#import "BogoOtherShopDetailViewController.h"
//#import <UMCommon/UMCommon.h>
//#import <UMShare/UMShare.h>




#define detailUseWeb   1

@interface BogoGoodDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BogoGoodDetailCellDelegate,BogoGoodDetailTopCellDelegate,BogoGoodDetailNavViewDelegate,BogoGoodDetailBottomViewDelegate,BogoGoodDetailAttrPopViewDelegate,BogoGoodDetailShopCellDelegate,BogoGoodSharePopViewDelegate,BogoGoodDetailWebCellDelegate>

@property(nonatomic, strong) BogoGoodDetailNavView *navView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) BogoCommodityDetailModel *model;
@property(nonatomic, assign) CGFloat detailHeight;
@property(nonatomic, strong) BogoGoodDetailBottomView *bottomView;
@property(nonatomic, strong) BogoGoodDetailAttrPopView *popView;

@property(nonatomic, strong) BogoGoodSharePopView *sharePopView;

@end

@implementation BogoGoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.navView];
    [self.view addSubview:self.bottomView];
//    [self.navView setBackAlpha:0];
    [self performSelector:@selector(updateBottomHeight) afterDelay:0.25];
}

- (void)updateBottomHeight{
    self.bottomView.height = FD_Bottom_Height;
    if (FD_StatusBar_Height > 20) {
        self.bottomView.bottom = kScreenHeight - FD_Bottom_Height;
    }else{
        self.bottomView.bottom = kScreenHeight - FD_Bottom_Height - FD_StatusBar_Height;
    }
    
    
//    self.bottomView.backgroundColor = [UIColor redColor];
    NSLog(@"%@",self.bottomView);
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setGid:(NSString *)gid{
    _gid = gid;
    if (gid.length) {
        [self requestData];
    }
}

- (void)requestData{
    [[BogoNetwork shareInstance] GET:@"shop/goodsInfoUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"gid":self.gid} success:^(BogoNetworkResponseModel * _Nonnull result) {
        self.model = [BogoCommodityDetailModel mj_objectWithKeyValues:result.data];
        if (self.model.status.integerValue == 22 || self.model.status.integerValue == 33) {
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            [[FDHUDManager defaultManager] show:self.model.status.integerValue == 22 ? @"该商品已下架" : @"该商品已删除" ToView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        self.model.count = 1;
        self.model.selectAttrIndex = -1;
        [self.tableView reloadData];
        [self.bottomView setModel:self.model];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

#pragma mark - BogoGoodDetailShopCellDelegate
- (void)shopCell:(BogoGoodDetailShopCell *)shopCell didClickGood:(BogoCommodityDetailModel *)model{
    if (model.model_id.integerValue == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link_url]];
    }else{
        BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
        detailVC.gid = model.gid;
        detailVC.source = self.source;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (void)shopCell:(BogoGoodDetailShopCell *)shopCell didClickShopBtn:(UIButton *)sender{
    BOOL ret = NO;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[BogoShopDetailViewController class]]) {
            ret = YES;
            break;
        }
    }
    if (ret) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        BogoShopDetailViewController *detaiVC = [[BogoShopDetailViewController alloc]init];
        detaiVC.sid = shopCell.model.sid;
        [self.navigationController pushViewController:detaiVC animated:YES];
    }
}

#pragma mark - BogoGoodDetailCellDelegate,BogoGoodDetailWebCellDelegate

#if detailUseWeb
- (void)detailCell:(BogoGoodDetailWebCell *)detailCell didFinishLoad:(CGFloat)height{
    self.detailHeight = height;
    [self.tableView reloadRow:0 inSection:2 withRowAnimation:UITableViewRowAnimationFade];
}

#else
- (void)detailCell:(BogoGoodDetailCell *)detailCell didFinishLoad:(CGFloat)height{
    self.detailHeight = height;
    [self.tableView reloadRow:0 inSection:2 withRowAnimation:UITableViewRowAnimationFade];
}

- (void)detailCell:(BogoGoodDetailCell *)detailCell didClickInfoImage:(NSInteger)index{
    NSArray *imageUrlArray = [self.model.info_images componentsSeparatedByString:@","];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *url in imageUrlArray) {
        FDPhotoGroupItem *item = [[FDPhotoGroupItem alloc]init];
        item.largeImageURL = [NSURL URLWithString:url];
        item.thumbView = detailCell.imageViewArray[index];
        [tempArray addObject:item];
    }
    FDPhotoGroupView *groupView = [[FDPhotoGroupView alloc]initWithGroupItems:tempArray];
    [groupView presentFromImageView:detailCell.imageViewArray[index] toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}
#endif
#pragma mark - BogoGoodDetailTopCellDelegate
- (void)topCell:(BogoGoodDetailTopCell *)topCell didClickImage:(NSString *)imageUrl{
    NSArray *imageUrlArray = [self.model.images componentsSeparatedByString:@","];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *url in imageUrlArray) {
        FDPhotoGroupItem *item = [[FDPhotoGroupItem alloc]init];
        item.largeImageURL = [NSURL URLWithString:url];
        item.thumbView = topCell.cycleScrollView;
        [tempArray addObject:item];
    }
    FDPhotoGroupView *groupView = [[FDPhotoGroupView alloc]initWithGroupItems:tempArray];
    [groupView presentFromImageView:topCell.cycleScrollView toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}

#pragma mark - BogoGoodDetailNavViewDelegate
- (void)navView:(BogoGoodDetailNavView *)navView didClickBackBtn:(nonnull UIButton *)sender{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)navView:(BogoGoodDetailNavView *)navView didClickShareBtn:(nonnull UIButton *)sender{
    [self.sharePopView setDistribution_id:_distribution_id];
    [self.sharePopView setDetailModel:self.model];
    [self.sharePopView show:self.view type:FDPopTypeBottom];
}

- (void)navView:(BogoGoodDetailNavView *)navView didClickGoodBtn:(UIButton *)sender{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)navView:(BogoGoodDetailNavView *)navView didClickDetailBtn:(UIButton *)sender{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - BogoGoodSharePopViewDelegate
- (void)popView:(BogoGoodSharePopView *)popView didClickBtn:(UIButton *)sender{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    NSString *url = [NSString stringWithFormat:@"%@&gid=%@&invite_code=%@",[BogoNetwork shareInstance].indexModel.h5_url.share_shop_url,self.gid,[BogoNetwork shareInstance].uid];
//    NSString *image = self.model.icon;
//    NSString *title = self.model.title;
//    UMSocialPlatformType type;
//    switch (sender.tag) {
//        case 100:
//            type = UMSocialPlatformType_WechatSession;
//            break;
//        case 101:
//            type = UMSocialPlatformType_WechatTimeLine;
//            break;
//        case 102:
//            type = UMSocialPlatformType_QQ;
//            break;
//        case 103:
//            type = UMSocialPlatformType_Qzone;
//            break;
//        default:
//            break;
//    }
//    UMShareWebpageObject *webObject = [UMShareWebpageObject shareObjectWithTitle:self.model.title descr:self.model.title thumImage:[self.model.images componentsSeparatedByString:@","].firstObject];
//    UMSocialMessageObject *messageObject = [[UMSocialMessageObject alloc]init];
//    messageObject.shareObject = webObject;
//    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
//        if (error) {
//            [[FDHUDManager defaultManager] show:error.localizedDescription ToView:self.view];
//        }
//    }];
}

#pragma mark - BogoGoodDetailBottomViewDelegate
- (void)bottomView:(BogoGoodDetailBottomView *)bottomView didClickShopBtn:(UIButton *)sender{
    BOOL ret = NO;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[BogoShopDetailViewController class]]) {
            ret = YES;
            break;
        }
    }
    if (ret) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
//        #import "BogoOtherShopDetailViewController.h"
        BogoOtherShopDetailViewController *detailVC = [[BogoOtherShopDetailViewController alloc]initWithNibName:NSStringFromClass([BogoOtherShopDetailViewController class]) bundle:kShopKitBundle];
        detailVC.user_id = self.model.uid;
        [self.navigationController pushViewController:detailVC animated:YES];
//        BogoShopDetailViewController *detaiVC = [[BogoShopDetailViewController alloc]init];
//        detaiVC.sid = self.model.sid;
//        [self.navigationController pushViewController:detaiVC animated:YES];
    }
}

- (void)bottomView:(BogoGoodDetailBottomView *)bottomView didClickCartBtn:(UIButton *)sender{
    //进入购物车
    BogoCartViewController *cartVC = [[BogoCartViewController alloc]init];
    cartVC.source = self.source;
    [self.navigationController pushViewController:cartVC animated:YES];
}

#pragma mark 私信
- (void)bottomView:(BogoGoodDetailBottomView *)bottomView didClickServiceBtn:(UIButton *)sender{
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GoToUserMsgVCShopKit object:self.model];
}

- (void)bottomView:(BogoGoodDetailBottomView *)bottomView didClickCollectBtn:(UIButton *)sender{
    
    
//    //收藏
////    http://xx.com/api/Shopuser/addFavorite
//    NSString *url = @"Shopuser/addFavorite";
//    if (sender.isSelected) {
//        url = @"Shopuser/addFavorite";
//    }
//    __weak __typeof(self)weakSelf = self;
//    [[BogoNetwork shareInstance] POST:@"Shopuser/addFavorite" param:@{@"gid":self.model.gid,@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
//        sender.selected = !sender.isSelected;
//        NSString *str = sender.selected ? @"收藏成功" : @"取消收藏";
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//         [[FDHUDManager defaultManager] show:str ToView:strongSelf.view];
//    } failure:^(NSString * _Nonnull error) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [[FDHUDManager defaultManager] show:error ToView:strongSelf.view];
//    }];
}

- (void)bottomView:(BogoGoodDetailBottomView *)bottomView didClickAddCartBtn:(UIButton *)sender{
    self.model.selectAttrIndex = 0;
    [self.popView setModel:self.model];
    [self.popView show:self.view type:FDPopTypeBottom];
}

- (void)bottomView:(BogoGoodDetailBottomView *)bottomView didClickBuyBtn:(UIButton *)sender{
    self.model.selectAttrIndex = 0;
    [self.popView setModel:self.model];
    [self.popView show:self.view type:FDPopTypeBottom];
}

#pragma mark - BogoGoodDetailAttrPopViewDelegate
- (void)popView:(BogoGoodDetailAttrPopView *)popView didClickBuyBtn:(UIButton *)sender{
    if ([self.model.uid isEqualToString:[BogoNetwork shareInstance].uid]) {
        [[FDHUDManager defaultManager] show:@"不能购买自己的商品" ToView:self.view];
        return;
    }
    if (self.model.selectAttrIndex == -1) {
        [[FDHUDManager defaultManager] show:@"还未选择规格" ToView:self.view];
        return;
    }
    BogoOrderSubmitViewController *buyVC = [[BogoOrderSubmitViewController alloc]init];
    buyVC.uid = _uid;
    buyVC.model = self.model;
    buyVC.distribution_id = _distribution_id;
    buyVC.source = self.source;
    [self.navigationController pushViewController:buyVC animated:YES];
}

- (void)popView:(BogoGoodDetailAttrPopView *)popView didClickAddCartBtn:(UIButton *)sender{
    if ([self.model.uid isEqualToString:[BogoNetwork shareInstance].uid]) {
        [[FDHUDManager defaultManager] show:@"自己不能购买自己的商品" ToView:self.view];
        return;
    }
    if (self.model.selectAttrIndex == -1) {
        [[FDHUDManager defaultManager] show:@"还未选择规格" ToView:self.view];
        return;
    }
    //    http://xx.com/api/shopuser/addCart
    [[BogoNetwork shareInstance] POST:@"api/addCartUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"gid":self.model.gid,@"sa_id":self.model.attr[self.model.selectAttrIndex].sa_id,@"num":@(self.model.count),@"share_uid":_uid.length ? _uid : @"",@"distribution_uid":_distribution_id.length ? _distribution_id : @""} success:^(BogoNetworkResponseModel * _Nonnull result) {
        [[FDHUDManager defaultManager] show:@"加入购物车成功" ToView:self.view];
        [popView hide];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.navView setBackAlpha:(scrollView.contentOffset.y / ([BogoGoodDetailTopCell cellHeightWithModel:self.model] + 70 + 95))];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            {
                BogoGoodDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoGoodDetailTopCell class]) forIndexPath:indexPath];
                [cell setModel:self.model];
                cell.delegate = self;
                return cell;
            }
            break;
        case 1:
        {
            BogoShopFillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoShopFillInfoCell class]) forIndexPath:indexPath];
            [cell setType:BogoShopFillInfoCellTypeGoodDetailAttr];
            [cell setRightTitle:@"请选择"];
            return cell;
        }
        break;
        case 2:
        {
            if (indexPath.row == 1) {
                BogoGoodDetailShopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoGoodDetailShopCell class]) forIndexPath:indexPath];
                cell.delegate = self;
                [cell setModel:self.model];
                return cell;
            }else{
                if (detailUseWeb) {
                    BogoGoodDetailWebCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoGoodDetailWebCell class]) forIndexPath:indexPath];
                    cell.delegate = self;
                    [cell setModel:self.model];
                    return cell;
                }else{
                    BogoGoodDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoGoodDetailCell class]) forIndexPath:indexPath];
                    cell.delegate = self;
//                    self.model.info_images = @"http://douyin.qiniu.bugukj.com/headpic/1587023948859.png,http://douyin.qiniu.bugukj.com/headpic/1587023948859.png";
                    [cell setModel:self.model];
                    return cell;
                }
            }
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
        {
            return [BogoGoodDetailTopCell cellHeightWithModel:self.model];
        }
            break;
        case 1:
            return 50;
            break;
        case 2:
            if (indexPath.row == 1) {
                if (self.model.shop_goods_list.count) {
                    return 95 + self.model.shop_goods_list.count > 3 ? ((FD_ScreenWidth - 40 ) / 3 + 40 ) * 2 + 40 : (FD_ScreenWidth - 40 ) / 3 + 40 + 30;
                }
                return 95;
            }
            return self.detailHeight + 44;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 4)];
    view.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 4;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        self.model.selectAttrIndex = 0;
        [self.popView setModel:self.model];
        [self.popView show:self.view type:FDPopTypeBottom];
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        if (@available(iOS 11.0, *)) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight - 50 - FD_Bottom_SafeArea_Height - FD_Top_Height) style:UITableViewStylePlain];
        } else {
            // Fallback on earlier versions
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight - 50 - FD_Top_Height) style:UITableViewStylePlain];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        NSBundle *bundle = kShopKitBundle;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (detailUseWeb) {
            [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoGoodDetailWebCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoGoodDetailWebCell class])];
        }else{
            [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoGoodDetailCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoGoodDetailCell class])];
        }
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoGoodDetailTopCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoGoodDetailTopCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoGoodDetailShopCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoGoodDetailShopCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopFillInfoCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([BogoShopFillInfoCell class])];
    }
    return _tableView;
}

- (BogoGoodDetailNavView *)navView{
    if (!_navView) {
        _navView = [kShopKitBundle loadNibNamed:NSStringFromClass([BogoGoodDetailNavView class]) owner:nil options:nil].lastObject;
        _navView.delegate = self;
    }
    return _navView;
}

- (BogoGoodDetailBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [kShopKitBundle loadNibNamed:NSStringFromClass([BogoGoodDetailBottomView class]) owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (BogoGoodDetailAttrPopView *)popView{
    if (!_popView) {
        _popView = [kShopKitBundle loadNibNamed:NSStringFromClass([BogoGoodDetailAttrPopView class]) owner:nil options:nil].lastObject;
        _popView.delegate = self;
    }
    return _popView;
}

- (BogoGoodSharePopView *)sharePopView{
    if (!_sharePopView) {
        _sharePopView = [kShopKitBundle loadNibNamed:NSStringFromClass([BogoGoodSharePopView class]) owner:nil options:nil].lastObject;
        _sharePopView.delegate = self;
    }
    return _sharePopView;
}
@end
