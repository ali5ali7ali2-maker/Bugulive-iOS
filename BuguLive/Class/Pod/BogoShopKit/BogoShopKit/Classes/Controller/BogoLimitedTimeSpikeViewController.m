//
//  BogoLimitedTimeSpikeViewController.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/8.
//

#import "BogoLimitedTimeSpikeViewController.h"
#import "BogoLimitedTimeSpikeTopCell.h"
#import "FDUIKitObjC.h"
#import "BogoLimitedTimeSpikeSubViewController.h"
#import "BogoShopKit.h"
#import "BogoLimitedTimeSpikeModel.h"
#import <MJExtension/MJExtension.h>

@interface BogoLimitedTimeSpikeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BogoLimitedTimeSpikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"限时秒杀";
    [self.view addSubview:self.collectionView];
    [self requestData];
}

- (void)requestData{
//    /shopapi/shop/seckillIndexUrl?uid=200676&token=dbb5e1a7327a551baaffac3d83c75775&time=1626163200
    [[BogoNetwork shareInstance] POST:@"shop/seckillIndexUrl" param:@{@"time":@"",@"page":@"1"} success:^(BogoNetworkResponseModel * _Nonnull result) {
        for (NSDictionary *dict in result.data[@"title"]) {
            BogoLimitedTimeSpikeModel *model = [BogoLimitedTimeSpikeModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
        NSString *currentTime = [NSString stringWithFormat:@"%@",result.data[@"time"]];
        NSInteger index = -1;
        for (BogoLimitedTimeSpikeModel *model in self.dataArray) {
            CGFloat time1 = [model.time doubleValue];
            NSDate *date1=[NSDate dateWithTimeIntervalSince1970:time1];
            
            NSTimeInterval time2 =[date1 timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:currentTime.doubleValue]];
            int min=((int)time2)/60;
            
            if (min < 0) {
                index = [self.dataArray indexOfObject:model];
            }
        }
        if (index != -1) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
        }else{
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
        }
        [self.view addSubview:self.scrollView];
        for (NSInteger i = 0; i < self.dataArray.count; i++) {
            BogoLimitedTimeSpikeModel *model = self.dataArray[i];
            model.currentTime = currentTime;
            BogoLimitedTimeSpikeSubViewController *subVC = [[BogoLimitedTimeSpikeSubViewController alloc]init];
            subVC.time = model.time;
            subVC.view.frame = CGRectMake(i * FD_ScreenWidth, 0, self.scrollView.width, self.scrollView.height);
            [self.scrollView addSubview:subVC.view];
            [self addChildViewController:subVC];
            
            
            
            CGFloat time1 = [model.time doubleValue];
            NSDate *date1=[NSDate dateWithTimeIntervalSince1970:time1];
            
            NSTimeInterval time2 =[date1 timeIntervalSinceNow];
            int min=((int)time2)/60;
            
            NSLog(@"minmin%d",min);
            
            if (min < 0) {
                [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
                [self.scrollView setContentOffset:CGPointMake(i * FD_ScreenWidth, 0)];
            }
            
        }
        if (index != -1) {
            [self.scrollView setContentOffset:CGPointMake(index * FD_ScreenWidth, 0)];
        }
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoLimitedTimeSpikeTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BogoLimitedTimeSpikeTopCell" forIndexPath:indexPath];
    if (indexPath.item < self.dataArray.count) {
        BogoLimitedTimeSpikeModel *model = self.dataArray[indexPath.item];
        cell.timeLabel.text = model.name;
        cell.model = model;
        cell.returnTimeBlock = ^(BogoLimitedTimeSpikeModel * _Nonnull model) {
            [self skipForCell:indexPath];
        };
    }
    return cell;
}

-(void)skipForCell:(NSIndexPath *)indexPath{
    
    
    
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(375 / 5, 62);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.item;
    [self.scrollView setContentOffset:CGPointMake(index * FD_ScreenWidth, 0)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x / scrollView.width;
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 62) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = FD_WhiteColor;
        [_collectionView registerNib:[UINib nibWithNibName:@"BogoLimitedTimeSpikeTopCell" bundle:kShopKitBundle] forCellWithReuseIdentifier:@"BogoLimitedTimeSpikeTopCell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _collectionView.fd_bottom, FD_ScreenWidth, FD_ScreenHeight - FD_Top_Height - _collectionView.height)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(FD_ScreenWidth * 5, 0);
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
