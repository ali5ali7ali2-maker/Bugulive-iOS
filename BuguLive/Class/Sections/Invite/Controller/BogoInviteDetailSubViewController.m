//
//  BogoInviteDetailSubViewController.m
//  UniversalApp
//
//  Created by Mac on 2021/6/10.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoInviteDetailSubViewController.h"
#import "BogoInviteListCell.h"
#import "BogoInviteResponseModel.h"
#import "BogoNetworkKit.h"

@interface BogoInviteDetailSubViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger page;

@end

@implementation BogoInviteDetailSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self headerRefresh];
}

- (void)headerRefresh{
    self.page = 1;
    [self requestData];
}

- (void)footerRefresh{
    self.page ++;
    [self requestData];
}

- (void)requestData{
//    /mapi/index.php?ctl=invite_vue&act=invite_info_new&uid=2
    [[BogoNetwork shareInstance] POSTV4:@"" param:@{@"ctl":@"invite_vue",@"act":@"invite_info_new",@"page":@(self.page),@"type":@(self.type)} success:^(id _Nonnull result) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSString *money = [NSString stringWithFormat:@"%@",result[@"data"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"upldateTopViewMoney" object:money];
        NSArray *list = result[@"lists"];
        for (NSDictionary *dict in list) {
            BogoInviteResponseModelLists *model = [BogoInviteResponseModelLists mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (list.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString * _Nonnull error) {
        [[BGHUDHelper sharedInstance] tipMessage:error];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
    BogoInviteListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoInviteListCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120) style:UITableViewStylePlain];
        _tableView.backgroundColor = kWhiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"BogoInviteListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BogoInviteListCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
