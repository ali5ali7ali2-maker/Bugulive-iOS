//
//  BogoCommodityPlatformAddViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/8/15.
//

#import "BogoCommodityPlatformAddViewController.h"
#import "BogoShopKit.h"
#import "BogoCommodityAddCell.h"
#import "BogoShopKit.h"
#import <MJRefresh/MJRefresh.h>
#import "FDUIKitObjC.h"
#import <MJExtension/MJExtension.h>

@interface BogoCommodityPlatformAddViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,BogoCommodityAddCellDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *textField;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger page;

@end

@implementation BogoCommodityPlatformAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *imageView = [[UIImageView alloc]initWithImage:imageNamed(@"new搜索")];
    imageView.frame = CGRectMake(15, 7.5, 15, 15);
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 30)];
    [leftView addSubview:imageView];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = leftView;
    self.textField.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCommodityAddCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoCommodityAddCell class])];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [self headerRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
    
    
    __weak __typeof(self)weakSelf = self;
    [[BogoNetwork shareInstance] GET:@"api/platformGoodsListUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"page":@(_page),@"key":self.textField.text} success:^(BogoNetworkResponseModel * _Nonnull result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //            if (strongSelf.page == 1) {
        [strongSelf.dataArray removeAllObjects];
        //            }
        NSMutableArray *tempArray = [NSMutableArray array];
        NSArray *array = result.data[@"data"];
        for (NSDictionary *dict in result.data[@"data"]) {
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (!textField.text.length) {
        return NO;
    }
    [self searchBtnAction:nil];
    return YES;
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchBtnAction:(id)sender {
    [self headerRefresh];
}

#pragma mark - BogoCommodityAddCellDelegate
- (void)addCell:(BogoCommodityAddCell *)addCell didClickOperateBtn:(UIButton *)sender{
    [[BogoNetwork shareInstance] POST:@"api/goodsDistributionUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"gid":addCell.model.gid} success:^(BogoNetworkResponseModel * _Nonnull result) {
        [[FDHUDManager defaultManager] show:@"上架成功" ToView:self.view];
        [self headerRefresh];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
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
    BogoCommodityAddCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoCommodityAddCell class]) forIndexPath:indexPath];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
