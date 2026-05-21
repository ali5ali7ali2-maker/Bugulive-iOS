//
//  BogoCategoryDetailSubViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/14.
//

#import "BogoCategoryDetailSubViewController.h"
#import "BogoShopKit.h"
#import <MJRefresh/MJRefresh.h>
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import "BogoCategoryGoodCell.h"
#import <YYKit/YYKit.h>
#import <MJExtension/MJExtension.h>

@interface BogoCategoryDetailSubViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BogoCategoryDetailSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.top = self.view.top;
}

- (void)setPid:(NSString *)pid{
    _pid = pid;
    [self headerRefresh];
}

- (void)headerRefresh{
    _page = 1;
    [self requestData];
}

- (void)footerRefresh{
    _page++;
    [self requestData];
}

- (void)requestData{
//    http://xx.com/api/shop/platform_children_goods
    __weak __typeof(self)weakSelf = self;
    [[BogoNetwork shareInstance] GET:@"api/platformChildrenGoodsUrl" param:@{@"pid":self.pid,@"page":@(_page)} success:^(BogoNetworkResponseModel * _Nonnull result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.page == 1) {
            [strongSelf.dataArray removeAllObjects];
        }
        NSArray *array = result.data;
        if (array.count) {
            for (NSDictionary *dict in array) {
                BogoCommodityDetailModel *model = [BogoCommodityDetailModel mj_objectWithKeyValues:dict];
                [strongSelf.dataArray addObject:model];
            }
            [strongSelf.tableView reloadData];
        }
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
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoCategoryGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoCategoryGoodCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCategoryGoodCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoCategoryGoodCell class])];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
