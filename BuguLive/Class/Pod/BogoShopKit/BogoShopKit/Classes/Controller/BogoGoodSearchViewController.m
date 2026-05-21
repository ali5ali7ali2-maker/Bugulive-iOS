//
//  BogoGoodSearchViewController.m
//  AFNetworking
//
//  Created by bogokj on 2020/8/11.
//

#import "BogoGoodSearchViewController.h"
#import "BogoSearchLogCell.h"
#import <QMUIKit/QMUIKit.h>
#import "BogoShopKit.h"
#import "BogoGoodSearchResultViewController.h"
#import "BogoCategoryGoodCell.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"

@interface BogoGoodSearchViewController ()<QMUITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property (weak, nonatomic) IBOutlet UICollectionView *historyCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *tableView;

@property(nonatomic, strong) NSMutableArray *historyDataArray;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BogoGoodSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *imageView = [[UIImageView alloc]initWithImage:imageNamed(@"shop_搜索")];
    imageView.frame = CGRectMake(15, 7.5, 15, 15);
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 30)];
    [leftView addSubview:imageView];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = leftView;
    self.textField.delegate = self;
    
    self.historyCollectionView.delegate = self;
    self.historyCollectionView.dataSource = self;
    [self.historyCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoSearchLogCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoSearchLogCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCategoryGoodCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoCategoryGoodCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self requestData];
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)requestData{
//    shopapi/shop/searchIndexUrl?uid=165999&token=dbb5e1a7327a551baaffac3d83c75775
    [[BogoNetwork shareInstance] POST:@"shop/searchIndexUrl" param:nil success:^(BogoNetworkResponseModel * _Nonnull result) {
        [self.historyDataArray removeAllObjects];
        for (NSDictionary *dict in result.data) {
            [self.historyDataArray addObject:dict];
        }
        [self.historyCollectionView reloadData];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

#pragma mark - QMUITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (!textField.text.length) {
        return NO;
    }
    BogoGoodSearchResultViewController *searchVC = [[BogoGoodSearchResultViewController alloc]initWithNibName:NSStringFromClass([BogoGoodSearchResultViewController class]) bundle:kShopKitBundle];
    searchVC.key = textField.text;
    [self.navigationController pushViewController:searchVC animated:YES];
    return YES;
}

- (IBAction)cancelBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearBtnAction:(id)sender {
    BogoAlertView *alert = [[BogoAlertView alloc]initWithTitle:@"确定删除全部历史搜索记录" message:nil];
    [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:nil]];
    [alert addAction:[FDAction actionWithTitle:@"确定" type:FDActionTypeDefault CallBack:^{
//        /shopapi/shop/delsearchUrl?uid=165999&token=dbb5e1a7327a551baaffac3d83c75775
        [[BogoNetwork shareInstance] POST:@"shop/delsearchUrl" param:nil success:^(BogoNetworkResponseModel * _Nonnull result) {
            [self.historyDataArray removeAllObjects];
            [self.historyCollectionView reloadData];
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
        }];
    }]];
    [alert show:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.historyDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoSearchLogCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BogoSearchLogCell class]) forIndexPath:indexPath];
    if (indexPath.item < self.historyDataArray.count) {
        cell.titleLabel.text = self.historyDataArray[indexPath.item][@"title"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.historyDataArray[indexPath.item][@"title"];
    CGSize tempSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    return CGSizeMake(tempSize.width + 26, 26);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.historyDataArray[indexPath.item][@"title"];
    BogoGoodSearchResultViewController *searchVC = [[BogoGoodSearchResultViewController alloc]initWithNibName:NSStringFromClass([BogoGoodSearchResultViewController class]) bundle:kShopKitBundle];
    searchVC.key = title;
    [self.navigationController pushViewController:searchVC animated:YES];
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (NSMutableArray *)historyDataArray{
    if (!_historyDataArray) {
        _historyDataArray = [NSMutableArray array];
    }
    return _historyDataArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
