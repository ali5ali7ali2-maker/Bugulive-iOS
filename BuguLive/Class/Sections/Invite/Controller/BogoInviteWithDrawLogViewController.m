//
//  BogoVirsualDetailViewController.m
//  BuguLive
//
//  Created by Mac on 2021/1/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoInviteWithDrawLogViewController.h"
#import "BogoVirsualDetailListCell.h"
#import "BogoWithDrawBindAlipayPopView.h"
#import "BogoNetworkKit.h"
#import "BogoShopKit.h"
#import "BogoShopWithDrawListModel.h"
@interface BogoInviteWithDrawLogViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, copy) NSString *time;//输入要查询的时间【格式：2021-04】

@end

@implementation BogoInviteWithDrawLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =ASLocalizedString( @"提现记录");
    [self.tableView registerNib:[UINib nibWithNibName:@"BogoVirsualDetailListCell" bundle:kShopKitBundle] forCellReuseIdentifier:@"BogoVirsualDetailListCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = @"yyyy-MM";
    self.time = [formater stringFromDate:currentDate];
    
    self.tableView.frame = CGRectMake(0, 0, kScreenW, kScreenHeight - kTopHeight);
    
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

- (void)comeBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData{
//    /mapi/index.php?ctl=invite_vue&act=recode_new&uid=165999&page=1
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"act":@"recode_new",@"ctl":@"invite_vue",@"":@(self.page)} success:^(BogoNetworkResponseModel * _Nonnull responseObject) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *dataArray = (NSArray *)responseObject.data;
        for (NSDictionary *dict in responseObject.data) {
            BogoShopWithDrawListModel *model = [BogoShopWithDrawListModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (dataArray.count < 20) {
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoVirsualDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoVirsualDetailListCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
//        cell.type = self.type;
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
