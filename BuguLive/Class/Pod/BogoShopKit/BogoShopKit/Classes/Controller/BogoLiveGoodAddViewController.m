//
//  BogoLiveGoodAddViewController.m
//  BuGuDY
//
//  Created by bogokj on 2020/3/27.
//  Copyright © 2020 宋晨光. All rights reserved.
//

#import "BogoLiveGoodAddViewController.h"
#import "BogoLiveStartGoodListCell.h"
#import "BogoLiveStartCartViewController.h"
#import "FDUIKitObjC.h"
#import "UIButton+Badge.h"
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import "BogoShopKit.h"
#import "BogoShopKit.h"
#import <MJExtension/MJExtension.h>

@interface BogoLiveGoodAddViewController ()<BogoLiveStartGoodListCellDelegate>

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger badge;
@property(nonatomic, copy) changeCartCallBack changeCartCallBack;
@property(nonatomic, copy) selectVideoGoodCallBack selectVideoGoodCallBack;

@property(nonatomic, strong) UIButton *cartBtn;

@property(nonatomic, assign) NSInteger page;

@end

@implementation BogoLiveGoodAddViewController

- (instancetype)initGoodViewControllerWithType:(NSInteger)type{
    BogoLiveGoodAddViewController *vc = [BogoLiveGoodAddViewController new];
    vc.vcType = type;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加直播商品";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:imageNamed(@"shop_back") style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoLiveStartGoodListCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoLiveStartGoodListCell class])];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cartBtn];
    _badge = 0;
    self.cartBtn.badgeBGColor = [UIColor colorWithHexString:@"#F11E32"];
    self.cartBtn.badgeOriginX = self.cartBtn.imageView.right;
    self.cartBtn.badgeOriginY = self.cartBtn.imageView.top - 10;
    self.cartBtn.badgeValue = [NSString stringWithFormat:@"%ld",_badge];
    
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [self headerRefresh];
}

- (void)backBtnAction{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)headerRefresh{
    _page = 1;
    [self requestData];
}

-(void)footerRefresh{
    _page ++;
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setLid:(NSString *)lid{
    _lid = lid;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:imageNamed(@"new返回") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    [self headerRefresh];
}

- (void)leftBarButtonItemAction{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setKey:(NSString *)key{
    _key = key;
    [self headerRefresh];
}

- (void)requestData{
    __weak __typeof(self)weakSelf = self;
    [[BogoNetwork shareInstance] GET:@"api/getGoodsListOldUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"page":@(_page),@"key":self.key.length ? self.key : @"",@"type":self.vcType == 1 ? @"2" : @"1",@"lid":self.lid.length ? self.lid : @""} success:^(BogoNetworkResponseModel * _Nonnull result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.page == 1) {
            [strongSelf.dataArray removeAllObjects];
        }
        for (NSDictionary *dict in result.data[@"data"]) {
            BogoCommodityDetailModel *model = [BogoCommodityDetailModel mj_objectWithKeyValues:dict];
            [strongSelf.dataArray addObject:model];
        }
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.mj_header endRefreshing];
        NSArray *array = result.data[@"data"];
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

#pragma mark - BogoLiveStartGoodListCellDelegate
- (void)listCell:(BogoLiveStartGoodListCell *)listCell didClickOperateBtn:(UIButton *)sender{
    if (_isVideoSelect) {
        if (_selectVideoGoodCallBack) {
            _selectVideoGoodCallBack(listCell.model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        NSIndexPath *indexPath = [self.tableView indexPathForCell:listCell];
        if (!listCell.model.is_live_shop) {
            //        http://xx.com/api/Shoplive/addGoods
            [[BogoNetwork shareInstance] POST:@"api/liveAddGoodsUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"gid":listCell.model.gid,@"lid":self.lid.length ? self.lid : @""} success:^(BogoNetworkResponseModel * _Nonnull result) {
                _badge++;
                self.cartBtn.badgeOriginX = self.cartBtn.imageView.right;
                self.cartBtn.badgeOriginY = self.cartBtn.imageView.top - 10;
                self.cartBtn.badgeValue = [NSString stringWithFormat:@"%ld",_badge];
                if (_changeCartCallBack) {
                    _changeCartCallBack(_badge);
                }
                listCell.model.is_live_shop = 1;
                [self requestData];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }else{
            //        http://xx.com/api/Shoplive/delLiveGoods
            [[BogoNetwork shareInstance] POST:@"api/liveDelGoodsUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"gid":listCell.model.gid,@"lid":self.lid.length ? self.lid : @""} success:^(BogoNetworkResponseModel * _Nonnull result) {
                listCell.model.is_live_shop = 0;
                _badge--;
                self.cartBtn.badgeOriginX = self.cartBtn.imageView.right;
                self.cartBtn.badgeOriginY = self.cartBtn.imageView.top - 10;
                self.cartBtn.badgeValue = [NSString stringWithFormat:@"%ld",_badge];
                if (_changeCartCallBack) {
                    _changeCartCallBack(_badge);
                }
                [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
            } failure:^(NSString * _Nonnull error) {
                [[FDHUDManager defaultManager] show:error ToView:self.view];
            }];
        }
    }
}

- (void)cartBtnAction{
    BogoLiveStartCartViewController *cartVC = [[BogoLiveStartCartViewController alloc]init];
    [cartVC setChangeCartCallBack:^(NSInteger badge) {
        _badge = badge;
        self.cartBtn.badgeOriginX = self.cartBtn.imageView.right;
        self.cartBtn.badgeOriginY = self.cartBtn.imageView.top - 10;
        self.cartBtn.badgeValue = [NSString stringWithFormat:@"%ld",_badge];
    }];
    if (self.lid.length) {
        cartVC.lid = self.lid;
        [self.navigationController pushViewController:cartVC animated:YES];
    }else{
        [self.navigationController pushViewController:cartVC animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoLiveStartGoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoLiveStartGoodListCell class]) forIndexPath:indexPath];
    [cell setType:BogoLiveStartGoodListCellTypeAdd];
    [cell setModel:self.dataArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setChangeCartCallBack:(changeCartCallBack)changeCartCallBack{
    _changeCartCallBack = changeCartCallBack;
}

- (UIButton *)cartBtn{
    if (!_cartBtn) {
        _cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cartBtn.frame = CGRectMake(0, 0, 44, 44);
        [_cartBtn setImage:[UIImage imageNamed:@"购物车-1"] forState:UIControlStateNormal];
        [_cartBtn addTarget:self action:@selector(cartBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cartBtn;
}


@end
