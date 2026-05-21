//
//  BogoVideoShopAddViewController.m
//  AFNetworking
//
//  Created by 宋晨光 on 2021/8/23.
//

#import "BogoVideoShopAddViewController.h"
#import "BogoLiveStartGoodListCell.h"
#import "BogoLiveStartCartViewController.h"
#import "FDUIKitObjC.h"
#import "UIButton+Badge.h"
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import "BogoShopKit.h"
#import "BogoShopKit.h"
#import <MJExtension/MJExtension.h>
#import "BogoNetworkKit.h"
#import "BogoNetworkResponseModel.h"
@interface BogoVideoShopAddViewController ()<BogoLiveStartGoodListCellDelegate,UITextFieldDelegate,BogoShopVideoGoodEditViewControllerDelegate>

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger badge;
@property(nonatomic, copy) changeCartCallBack changeCartCallBack;
@property(nonatomic, copy) selectVideoGoodCallBack selectVideoGoodCallBack;

@property(nonatomic, strong) UIButton *cartBtn;

@property(nonatomic, assign) NSInteger page;

@property(nonatomic, strong) UITextField *searchField;

@property(nonatomic, strong) UIView *navView;

@end

@implementation BogoVideoShopAddViewController


- (instancetype)initGoodViewControllerWithType:(NSInteger)type{
    BogoLiveGoodAddViewController *vc = [BogoLiveGoodAddViewController new];
    vc.vcType = type;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加短视频商品";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:imageNamed(@"shop_back") style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoLiveStartGoodListCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoLiveStartGoodListCell class])];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cartBtn];
    _badge = 0;
    self.cartBtn.badgeBGColor = [UIColor colorWithHexString:@"#F11E32"];
    self.cartBtn.badgeOriginX = self.cartBtn.imageView.right;
    self.cartBtn.badgeOriginY = self.cartBtn.imageView.top - 10;
    self.cartBtn.badgeValue = [NSString stringWithFormat:@"%ld",_badge];
    
    
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
//    [self headerRefresh];
    
    _page = 1;
    [self requestData];
    
    [self setNavView];
    
    
//    self.tableView.style = UITableViewStylePlain;
    self.tableView.frame = CGRectMake(0, 0, kScreenW, kScreenHeight - FD_Bottom_SafeArea_Height - FD_Top_Height);
//    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = self.navView;
}


-(void)setNavView{
    
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,FD_Navigation_Height)];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"com_arrow_vc_back"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(kScreenW - 60, 0, 60, 40);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchBtn setTitleColor:[UIColor colorWithHexString:@"#9F64FF"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    
    self.searchField.frame = CGRectMake(backBtn.right + 10, 0, kScreenW - searchBtn.width - backBtn.right - 10, 32);
    
    self.searchField.centerY = searchBtn.centerY = backBtn.centerY;
    
    [self.navView addSubview:backBtn];
    [self.navView addSubview:self.searchField];
    [self.navView addSubview:searchBtn];
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
    self.navigationController.navigationBarHidden = YES;
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
    [[BogoNetwork shareInstance] GET:@"api/getGoodsListOldUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"page":@(_page),@"key":self.key.length ? self.key : self.searchField.text,@"type":self.vcType == 1 ? @"2" : @"1",@"lid":self.lid.length ? self.lid : @""} success:^(BogoNetworkResponseModel * _Nonnull result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.page == 1) {
            [strongSelf.dataArray removeAllObjects];
        }
        for (NSDictionary *dict in result.data[@"data"]) {
            BogoCommodityDetailModel *model = [BogoCommodityDetailModel mj_objectWithKeyValues:dict];
            [strongSelf.dataArray addObject:model];
        }
        [strongSelf.tableView reloadData];
//        [strongSelf.tableView.mj_header endRefreshing];
        NSArray *array = result.data[@"data"];
        if (array.count < 20) {
            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [strongSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [[FDHUDManager defaultManager] show:error ToView:strongSelf.view];
    }];
}

#pragma mark - BogoLiveStartGoodListCellDelegate
- (void)listCell:(BogoLiveStartGoodListCell *)listCell didClickOperateBtn:(UIButton *)sender{
    if (_isVideoSelect) {
        if (_selectVideoGoodCallBack) {
            BogoShopVideoGoodEditViewController *editVC = [[BogoShopVideoGoodEditViewController alloc] initWithNibName:@"BogoShopVideoGoodEditViewController" bundle:kShopKitBundle];
            editVC.delegate = self;
            editVC.model = listCell.model;
            [self.navigationController pushViewController:editVC animated:YES];
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

-(UITextField *)searchField{
    if (!_searchField) {
        _searchField = [[UITextField alloc]initWithFrame:CGRectMake(12, 0, kScreenW - 39 - 22 - 0,32)];
        _searchField.placeholder = @"搜索商品名称";
        _searchField.font = [UIFont systemFontOfSize:14];
        _searchField.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
        _searchField.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        _searchField.layer.cornerRadius = 32 / 2;
        _searchField.layer.masksToBounds = YES;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        imageView.image = [UIImage imageNamed:@"bogo_home_top_search"];
        imageView.center = leftView.center;
        [leftView addSubview:imageView];
        _searchField.leftView = leftView;
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        _searchField.delegate = self;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(requestData)];
//        [_searchField addGestureRecognizer:tap];
    }
    return _searchField;
}

#pragma mark - BogoShopVideoGoodEditViewControllerDelegate
- (void)editVC:(BogoShopVideoGoodEditViewController *)editVC didFinishEdit:(NSString *)text{
    editVC.model.shop_title = text;
    _selectVideoGoodCallBack(editVC.model);
    for (UIViewController *subC in self.navigationController.viewControllers) {
        if ([subC isKindOfClass:NSClassFromString(@"VideoDynamicViewC")]) {
            [self.navigationController popToViewController:subC animated:YES];
            break;
        }
    }
}

@end
