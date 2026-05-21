//
//  BogoClassicsViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/25.
//

#import "BogoClassicsViewController.h"
#import "BogoCartViewController.h"
#import "BogoShopKit.h"
#import "BogoClassicsListCell.h"
#import "BogoCommodityDetailModel.h"
#import <MJRefresh/MJRefresh.h>
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import "BogoClassicsHeaderView.h"
#import <MJRefresh/MJRefresh.h>
#import "BogoCategoryViewController.h"
#import <QMUIKit/QMUIKit.h>
#import "BogoGoodSharePopView.h"
#import <MJExtension/MJExtension.h>


@interface BogoClassicsViewController ()<UITableViewDelegate,UITableViewDataSource,BogoClassicsListCellDelegate,QMUITextFieldDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UIView *backView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property(nonatomic, strong) NSMutableArray <BogoCommodityDetailModel *>*dataArray;
@property(nonatomic, strong) BogoGoodSharePopView *sharePopView;

@end

@implementation BogoClassicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.backView.bounds;
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:250/255.0 green:119/255.0 blue:53/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:233/255.0 green:65/255.0 blue:31/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.backView.layer insertSublayer:gl atIndex:0];
    [self.view addSubview:self.tableView];
    [self headerRefresh];
}

- (void)headerRefresh{
    _page = 1;
    [self requestData];
}

- (void)footerRefresh{
    _page ++;
    [self requestData];
}

- (void)requestData{
    //http://xx.com/api/shop/platform_goods_list
    __weak __typeof(self)weakSelf = self;
    [[BogoNetwork shareInstance] GET:@"shop/platform_goods_list" param:@{@"token":[BogoNetwork shareInstance].token,@"page":@(_page),@"key":self.textField.text} success:^(BogoNetworkResponseModel * _Nonnull result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.page == 1) {
            [strongSelf.dataArray removeAllObjects];
        }
        NSMutableArray *tempArray = [NSMutableArray array];
        NSArray *array = result.data[@"data"];
        for (NSDictionary *dict in array) {
            BogoCommodityDetailModel *model = [BogoCommodityDetailModel mj_objectWithKeyValues:dict];
            [tempArray addObject:model];
        }
        if (tempArray.count) {
            [strongSelf.dataArray addObjectsFromArray:tempArray];
        }
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.mj_header endRefreshing];
        if (array.count < 20) {
            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [strongSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [[FDHUDManager defaultManager] show:error ToView:strongSelf.view];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - QMUITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self headerRefresh];
    return YES;
}

- (IBAction)messageBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(classicsVC:didClickMessageBtn:)]) {
        [self.delegate classicsVC:self didClickMessageBtn:sender];
    }
}

- (IBAction)categoryBtnAction:(id)sender {
    //暂时隐藏
    return;
    BogoCategoryViewController *categoryVC = [[BogoCategoryViewController alloc] initWithNibName:NSStringFromClass([BogoCategoryViewController class]) bundle:kShopKitBundle];
    [self.navigationController pushViewController:categoryVC animated:YES];
}

- (IBAction)cartBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(classicsVC:didNeedLogin:)]) {
        [self.delegate classicsVC:self didNeedLogin:sender];
    }
    BogoCartViewController *cartVC = [[BogoCartViewController alloc]init];
    cartVC.source = BogoShopBuySourceShop;
    [self.navigationController pushViewController:cartVC animated:YES];
}

#pragma mark - BogoClassicsListCellDelegate
- (void)listCell:(BogoClassicsListCell *)listCell didClickOnlineBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(classicsVC:didNeedLogin:)]) {
        [self.delegate classicsVC:self didNeedLogin:sender];
    }
//    http://xx.com/api/Shopmanage/goodsDistribution
    [[BogoNetwork shareInstance] POST:@"Shopmanage/goodsDistribution" param:@{@"token":[BogoNetwork shareInstance].token,@"gid":listCell.model.gid} success:^(BogoNetworkResponseModel * _Nonnull result) {
        [[FDHUDManager defaultManager] show:@"上架成功" ToView:self.view];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (void)listCell:(BogoClassicsListCell *)listCell didClickShareBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(classicsVC:didNeedLogin:)]) {
        [self.delegate classicsVC:self didNeedLogin:sender];
    }
    if ([sender.titleLabel.text isEqualToString:@"立即购买"]) {
        if (listCell.model.model_id.integerValue == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:listCell.model.link_url]];
        }else{
            BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
            detailVC.gid = listCell.model.gid;
            detailVC.source = BogoShopBuySourceShop;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    }else{
        [self.sharePopView setDetailModel:listCell.model];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoClassicsListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoClassicsListCell class]) forIndexPath:indexPath];
    [cell setMarketing_type:self.marketing_type];
    [cell setModel:self.dataArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(classicsVC:didNeedLogin:)]) {
        [self.delegate classicsVC:self didNeedLogin:nil];
    }
    BogoCommodityDetailModel *model = self.dataArray[indexPath.row];
    if (model.model_id.integerValue == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link_url]];
    }else{
        BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
        detailVC.gid = model.gid;
        detailVC.source = BogoShopBuySourceShop;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BogoClassicsHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([BogoClassicsHeaderView class])];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 260;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        if (@available(iOS 11.0, *)) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, FD_Top_Height, FD_ScreenWidth, FD_ScreenHeight - FD_Navigation_Height - FD_StatusBar_Height - 49 - FD_Bottom_SafeArea_Height) style:UITableViewStylePlain];
        } else {
            // Fallback on earlier versions
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, FD_Top_Height, FD_ScreenWidth, FD_ScreenHeight - FD_Navigation_Height - FD_StatusBar_Height - 49) style:UITableViewStylePlain];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoClassicsListCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoClassicsListCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoClassicsHeaderView class]) bundle:kShopKitBundle] forHeaderFooterViewReuseIdentifier:NSStringFromClass([BogoClassicsHeaderView class])];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
    return _tableView;
}

- (BogoGoodSharePopView *)sharePopView{
    if (!_sharePopView) {
        _sharePopView = [kShopKitBundle loadNibNamed:NSStringFromClass([BogoGoodSharePopView class]) owner:nil options:nil].lastObject;
        _sharePopView.delegate = self;
    }
    return _sharePopView;
}

@end
