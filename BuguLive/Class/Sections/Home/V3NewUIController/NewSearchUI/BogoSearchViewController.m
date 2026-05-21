//
//  BogoSearchViewController.m
//  BuguLive
//
//  Created by Mac on 2021/9/27.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSearchViewController.h"
#import "BogoShopKit.h"
#import "BogoSearchSubViewController.h"
#import "BogoSearchHistoryItemCell.h"
#import "BogoSearchHistoryModel.h"
#import "BogoSearchHeaderView.h"
#import "BogoSearchVideoSubViewController.h"

@interface BogoSearchViewController ()<QMUITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BogoSearchSubViewControllerDelegate>
@property (weak, nonatomic) IBOutlet QMUITextField *textField;

@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UICollectionView *historyCollectionView;
@property(nonatomic, strong) NSMutableArray <BogoSearchHistoryModel *>*historyDataArray;

@property(nonatomic, strong) NSMutableArray *vcArray;

@property(nonatomic, strong) MLMSegmentHead *segHead;
@property(nonatomic, strong) MLMSegmentScroll *segScroll;

@property(nonatomic, strong) BogoSearchVideoSubViewController *videoVC;
@end

@implementation BogoSearchViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.textField.delegate = self;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 37, 32)];
    UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bogo_home_top_search"]];
    leftImageView.frame = CGRectMake(14, 7, 18, 18);
    [leftView addSubview:leftImageView];
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 28, 32)];
    UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bogo_home_live_search_clear"]];
    rightImageView.frame = CGRectMake(0, 7, 18, 18);
    rightImageView.userInteractionEnabled = YES;
    [rightImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearTextField)]];
    [rightView addSubview:rightImageView];
    self.textField.rightView = rightView;
    self.textField.rightViewMode = UITextFieldViewModeWhileEditing;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.historyCollectionView.delegate = self;
    self.historyCollectionView.dataSource = self;
    [self.historyCollectionView registerNib:[UINib nibWithNibName:@"BogoSearchHistoryItemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BogoSearchHistoryItemCell"];
    [self addSubController];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestSearchHistoryData];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)requestSearchHistoryData{
//    /mapi/index.php?ctl=index&act=search_log
    [self.httpsManager POSTWithParameters:[NSMutableDictionary dictionaryWithDictionary:@{@"act":@"search_log",@"ctl":@"index"}] SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            [self.historyDataArray removeAllObjects];
            for (NSDictionary *dict in responseJson[@"list"]) {
                BogoSearchHistoryModel *model = [BogoSearchHistoryModel mj_objectWithKeyValues:dict];
                [self.historyDataArray addObject:model];
            }
            [self.historyCollectionView reloadData];
        }else{
            [[BGHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
        }
    } FailureBlock:^(NSError *error) {
        [[BGHUDHelper sharedInstance] tipMessage:error.localizedDescription];
    }];
}

- (void)clearTextField{
    self.textField.text = @"";
}

- (void)addSubController {
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40) titles:@[ASLocalizedString(@"全部"),ASLocalizedString(@"用户"),ASLocalizedString(@"短视频"),ASLocalizedString(@"动态")] headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
    //tab颜色
    _segHead.selectColor = [UIColor colorWithHexString:@"#9152F8"];
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#777777"];
    _segHead.lineColor = [UIColor colorWithHexString:@"#9E64FF"];
    _segHead.lineHeight = 4;
    _segHead.selectFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _segHead.deSelectFont = [UIFont systemFontOfSize:16];
    _segHead.lineScale = .25;
    _segHead.headColor = FD_WhiteColor;
    _segHead.bottomLineHeight = 0;
    _segHead.tag = 1101;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), FD_ScreenWidth, FD_ScreenHeight -  40 - FD_Top_Height) vcOrViews:self.vcArray];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    __weak __typeof(self)weakSelf = self;
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.resultView addSubview:strongSelf.segHead];
        [strongSelf.resultView addSubview:strongSelf.segScroll];
    }];
}

-(NSMutableArray *)vcArray{
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            BogoSearchSubViewController *listVC = [[BogoSearchSubViewController alloc]init];
            listVC.type = i;
            listVC.delegate = self;
            if (i == 2) {
                BogoSearchVideoSubViewController *hotVC = [[BogoSearchVideoSubViewController alloc]init];
                hotVC.isHaveNavBar = NO;
                [_vcArray addObject:hotVC];
                self.videoVC = hotVC;
            }else{
                [_vcArray addObject:listVC];
            }
            
        }
    }
    return _vcArray;
}

#pragma mark - Action
- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearBtnAction:(UIButton *)sender {
    FDAlertView *alertView = [[FDAlertView alloc]initWithTitle:@"" message:ASLocalizedString(@"确认删除全部历史搜索记录？")];
    [alertView addAction:[FDAction actionWithTitle:ASLocalizedString(@"取消") type:FDActionTypeCancel CallBack:nil]];
    [alertView addAction:[FDAction actionWithTitle:ASLocalizedString(@"确定") type:FDActionTypeDefault CallBack:^{
//        /mapi/index.php?ctl=index&act=del_search
        [self.httpsManager POSTWithParameters:[NSMutableDictionary dictionaryWithDictionary:@{@"act":@"del_search",@"ctl":@"index"}] SuccessBlock:^(NSDictionary *responseJson) {
            if ([responseJson toInt:@"status"] == 1) {
                [self.historyDataArray removeAllObjects];
                [self.historyCollectionView reloadData];
            }else{
                [[BGHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
            }
        } FailureBlock:^(NSError *error) {
            [[BGHUDHelper sharedInstance] tipMessage:error.localizedDescription];
        }];
    }]];
    [alertView show:self.view];
}

#pragma mark - BogoSearchSubViewControllerDelegate
- (void)subVC:(BogoSearchSubViewController *)subVC headerView:(BogoSearchHeaderView *)headerView didClickAllBtn:(UIButton *)sender{
    switch (headerView.type) {
        case BogoSearchHeaderViewTypeUser:
            [self.segHead setSelectIndex:1];
            [self.segScroll setContentOffset:CGPointMake(kScreenW, 0) animated:YES];
            break;
        case BogoSearchHeaderViewTypeVideo:
            [self.segHead setSelectIndex:2];
            [self.segScroll setContentOffset:CGPointMake(kScreenW * 2, 0) animated:YES];
            break;
        case BogoSearchHeaderViewTypeDynamic:
            [self.segHead setSelectIndex:3];
            [self.segScroll setContentOffset:CGPointMake(kScreenW * 3, 0) animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark - QMUITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length) {
        [self searchText:self.textField.text];
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

- (void)textFieldDidChange:(QMUITextField *)textField{
    if (!textField.text.length) {
        self.historyView.hidden = NO;
        self.resultView.hidden = YES;
    }
}

- (void)searchText:(NSString *)text{
    self.historyView.hidden = YES;
    self.resultView.hidden = NO;
    for (UIViewController *subVC in self.vcArray) {
        if ([subVC isKindOfClass:[BogoSearchVideoSubViewController class]]) {
            BogoSearchVideoSubViewController *videoVC = subVC;
            videoVC.keyword = text;
        }else{
            BogoSearchSubViewController *listVC = subVC;
            listVC.keyword = text;
        }
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.historyDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoSearchHistoryItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BogoSearchHistoryItemCell" forIndexPath:indexPath];
    if (indexPath.row < self.historyDataArray.count) {
        cell.model = self.historyDataArray[indexPath.item];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.historyDataArray[indexPath.item].title;
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    return CGSizeMake(size.width + 20 + 10, 25);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 10, 15, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *keyword = self.historyDataArray[indexPath.item].title;
    self.textField.text = keyword;
    [self searchText:keyword];
}

#pragma mark - Lazy Load
- (NSMutableArray<BogoSearchHistoryModel *> *)historyDataArray{
    if (!_historyDataArray) {
        _historyDataArray = [NSMutableArray array];
    }
    return _historyDataArray;
}

@end
