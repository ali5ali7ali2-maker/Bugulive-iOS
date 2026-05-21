//
//  BogoGoodSearchResultViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/8/12.
//

#import "BogoShopCategoryGoodViewController.h"
#import <QMUIKit/QMUIKit.h>
#import "BogoShopKit.h"
#import "BogoGoodSearchListCell.h"
#import "BogoCommodityDetailModel.h"
#import "BogoShopKit.h"
#import <MJRefresh/MJRefresh.h>
#import "FDUIKitObjC.h"
#import "BogoCategoryGoodCell.h"
#import <MJExtension/MJExtension.h>
#import <YYKit/YYKit.h>
#import "BogoNetworkKit.h"
#import "BogoNetworkResponseModel.h"
//#import "FDUIKitObjC.h"
@interface BogoShopCategoryGoodViewController ()<QMUITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,BogoCategoryGoodCellDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet QMUITextField *textField;
@property (unsafe_unretained, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet QMUIButton *priceBtn;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, assign) NSInteger orderno;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *salesBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@property(nonatomic, strong) NSMutableDictionary *param;

@end

@implementation BogoShopCategoryGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"333333"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:imageNamed(@"shop_搜索")];
    imageView.frame = CGRectMake(15, 7.5, 15, 15);
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 30)];
    [leftView addSubview:imageView];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = leftView;
    self.textField.delegate = self;
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoGoodSearchListCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoGoodSearchListCell class])];
    
    [self.param setObject:@"0" forKey:@"type"];
    [self.param setObject:@"1" forKey:@"desc"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCategoryGoodCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoCategoryGoodCell class])];
    self.priceBtn.imagePosition = QMUIButtonImagePositionRight;
    self.priceBtn.spacingBetweenImageAndTitle = 5;
    
    self.salesBtn.imagePosition = QMUIButtonImagePositionRight;
    self.salesBtn.spacingBetweenImageAndTitle = 5;
    self.defaultBtn.selected = YES;
    self.title = self.key;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:imageNamed(@"new返回") style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
    _orderno = 0;
}

- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)setKey:(NSString *)key{
    _key = key;
    self.textField.text = key;
    [self headerRefresh];
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
    _page ++;
    [self requestData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length) {
        _key = textField.text;
        [self headerRefresh];
    }else{
        _key = @"";
        [self headerRefresh];
        return NO;
    }
    return YES;
}

- (void)requestData{
//    http://xx.com/shopapi/api/platformChildrenGoodsUrl
    
    [self.param setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    [self.param setObject:self.cid.length ? self.cid : @"" forKey:@"cid"];
//    [self.param setObject:@"16599" forKey:@"uid"];

    [self.param setObject:@(self.page) forKey:@"page"];
    
    [[BogoNetwork shareInstance] POST:@"shop/cateGoodsUrl" param:self.param success:^(BogoNetworkResponseModel * _Nonnull result) {
        if (self->_page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dict in result.data) {
            BogoCommodityDetailModel *model = [BogoCommodityDetailModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        NSArray *array = result.data;
        if (array.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)defaultBtnAction:(UIButton *)sender {
    
    [self.param setObject:@"0" forKey:@"type"];
    [self.param setObject:@"0" forKey:@"desc"];
    
    sender.selected = YES;
    
    self.lineView.fd_centerX = sender.fd_centerX;
    
    self.salesBtn.selected = NO;
    self.priceBtn.selected = NO;
    
    [self.salesBtn setImage:imageNamed(@"shop_排序") forState:UIControlStateNormal];
    [self.priceBtn setImage:imageNamed(@"shop_排序") forState:UIControlStateNormal];
    
    [sender setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
    
    [self.priceBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
    [self.salesBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
    
    _orderno = 0;
    [self headerRefresh];
}

- (IBAction)searchBtnAction:(id)sender {
    if (self.textField.text.length) {
        _key = self.textField.text;
    }else{
        _key = @"";
    }
    [self headerRefresh];
}

- (IBAction)salesBtnAction:(UIButton *)sender {
    
    [self.param setObject:@"1" forKey:@"type"];
    
    self.lineView.fd_centerX = sender.fd_centerX;
    
    sender.selected = !sender.selected;
    
    if (sender.isSelected) {
        [sender setImage:imageNamed(@"shop_排序- 2") forState:UIControlStateNormal];

        [self.param setObject:@"0" forKey:@"desc"];
    }else{
        [sender setImage:imageNamed(@"shop_排序-1") forState:UIControlStateNormal];
        [self.param setObject:@"1" forKey:@"desc"];
    }
    
    self.defaultBtn.selected = NO;
    self.priceBtn.selected = NO;
    
    [self.priceBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
    
    
    [sender setTitleColor:[UIColor colorWithHexString:@"F42416"] forState:UIControlStateNormal];
    
    _orderno = 3;
    [self headerRefresh];
}

- (IBAction)priceBtnAction:(UIButton *)sender {
    self.lineView.fd_centerX = sender.fd_centerX;
    sender.selected = !sender.selected;
    self.defaultBtn.selected = NO;
    self.salesBtn.selected = NO;
    [self.param setObject:@"2" forKey:@"type"];
    
    
    [self.salesBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
    
    
    [sender setTitleColor:[UIColor colorWithHexString:@"F42416"] forState:UIControlStateNormal];
    
    
//    if (_orderno == 0 || _orderno == 3) {
//        _orderno = 2;
//        [sender setImage:imageNamed(@"shop_排序-1") forState:UIControlStateSelected];
//    }else{
//        _orderno = 1;
//        [sender setImage:imageNamed(@"shop_排序-1") forState:UIControlStateSelected];
//    }
    
    
    
    if (sender.isSelected) {
        [sender setImage:imageNamed(@"shop_排序- 2") forState:UIControlStateNormal];
        [self.param setObject:@"0" forKey:@"desc"];
    }else{
        [sender setImage:imageNamed(@"shop_排序-1") forState:UIControlStateNormal];
        [self.param setObject:@"1" forKey:@"desc"];
    }
    
    
    [self headerRefresh];
}

#pragma mark - BogoCategoryGoodCellDelegate
- (void)goodCell:(BogoCategoryGoodCell *)goodCell didClickBuyBtn:(UIButton *)sender{
    BogoCommodityDetailModel *model = goodCell.model;
    if (model.model_id.integerValue == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link_url]];
    }else{
        BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
        detailVC.gid = model.gid;
        detailVC.distribution_id = model.distribution_uid;
        detailVC.uid = model.uid;
        detailVC.source = BogoShopBuySourceShop;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoCategoryGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoCategoryGoodCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoCommodityDetailModel *model = self.dataArray[indexPath.item];
    if (model.model_id.integerValue == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link_url]];
    }else{
        BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
        
        detailVC.gid = model.gid;
        detailVC.distribution_id = model.distribution_uid;
        detailVC.uid = model.uid;
        detailVC.source = BogoShopBuySourceShop;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)param{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

@end
