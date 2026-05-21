//
//  GuildListViewController.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import "GuildListViewController.h"
#import <QMUIKit/QMUIKit.h>
#import "BogoGuildKit.h"
#import "GuildListCell.h"
#import "FDUIKitObjC.h"
#import "GuildDetailViewController2.h"
#import "GuildDetailModel.h"
#import "BogoNetworkKit.h"
#import <MJRefresh/MJRefresh.h>

@interface GuildListViewController ()<QMUITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray <GuildDetailModelFamily_info *>*dataArray;
@property(nonatomic, copy) NSString *keyword;
@property(nonatomic, assign) NSInteger page;

@end

@implementation GuildListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = ASLocalizedString(@"公会");
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 36, 32)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 8, 16, 16)];
    imageView.image = kBogoGuildKitBundleImageNamed(@"guild_搜索");
    [leftView addSubview:imageView];
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"GuildListCell" bundle:kBogoGuildKitBundle] forCellWithReuseIdentifier:@"GuildListCell"];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.keyword = @"";
    [self headerRefresh];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.textField.placeholder = ASLocalizedString(@"请输入您要搜索的公会昵称");
}

- (void)headerRefresh{
    self.page = 1;
    [self requestData];
}

- (void)footerRefresh{
    self.page = self.page + 1;
    [self requestData];
}

- (void)requestData{
//    /mapi/index.php?ctl=family&act=guild_list&family_name=公会
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"ctl":@"family",@"act":@"guild_list",@"family_name":self.keyword,@"page":@(self.page)} success:^(BogoNetworkResponseModel * _Nonnull result) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *array = (NSArray *)result.data;
        for (NSDictionary *dict in array) {
            GuildDetailModelFamily_info *model = [GuildDetailModelFamily_info mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        if (array.count < 20) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer endRefreshing];
        }
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

#pragma mark - QMUITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.keyword = textField.text;
    [self requestData];
    if (textField.text.length) {
        return YES;
    }
    return NO;
}

- (void)textFieldDidChange:(UITextField *)textfield{
    if (textfield.text.length == 0) {
        self.keyword = @"";
        [self requestData];
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GuildListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GuildListCell" forIndexPath:indexPath];
    if (indexPath.item < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.item];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(FD_ScreenWidth - 20, 70);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 10, 15, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    UIViewController *vc = [[UIViewController alloc] init];
    
    GuildDetailViewController2 *detailVC = [[GuildDetailViewController2 alloc]init];
    detailVC.family_id = self.dataArray[indexPath.item].family_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSMutableArray<GuildDetailModelFamily_info *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
