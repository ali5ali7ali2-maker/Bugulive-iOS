//
//  CYCarViewController.m
//  FanweApp
//
//  Created by 志刚杨 on 2017/12/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "CYCarViewController.h"
#import "CarCollectionViewCell.h"
#import "CarItem.h"
#import <QMUIKit/QMUIKit.h>
@interface CYCarViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *CollectionView;
@property(nonatomic, strong) NSMutableArray *modearr;
@property(nonatomic, assign) int page;
@property(nonatomic, strong) QMUIFillButton *buybutton;
@property(nonatomic, strong) CarItemModel *select_model;
@end

@implementation CYCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initFWUI
{
    self.title = ASLocalizedString(@"座驾");
    [super initFWUI];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumLineSpacing = 3;
    layout.minimumInteritemSpacing = 3;
    layout.itemSize = CGSizeMake(kScreenW/2 - 10 ,SCREEN_WIDTH/2 + 45);
    self.CollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(2, 10,SCREEN_WIDTH - 4,kScreenH - 64) collectionViewLayout:layout];
    self.CollectionView.delegate = self;
    self.CollectionView.dataSource = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.CollectionView];
    
//    [self.CollectionView registerClass:[CarCollectionViewCell class] forCellWithReuseIdentifier:@"CarCollectionViewCell"];
    [self.CollectionView registerNib:[UINib nibWithNibName:@"CarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CarCollectionViewCell"];
    
    self.CollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.CollectionView reloadData];
    self.modearr = [NSMutableArray array];
//    self.page = 0;
//    self.CollectionView.mj_header = ({
//        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullInternetforNew)];
//        header.lastUpdatedTimeLabel.hidden = YES;
//        header.stateLabel.hidden = YES;
//        header;
//    });
//
//    self.CollectionView.mj_footer = ({
//        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//        [footer setTitle:ASLocalizedString(@"上拉加载更多")forState:MJRefreshStateIdle];
//        [footer setTitle:ASLocalizedString(@"加载中")forState:MJRefreshStateRefreshing];
//        [footer setTitle:ASLocalizedString(@"没有更多了")forState:MJRefreshStateNoMoreData];
//        footer;
//    });
    
    [self LoadDataIsNew:YES];
    
    //购买按钮
    int buywidth = 280;
//    self.buybutton = [[QMUIFillButton alloc] initWithFillColor:KHighlight titleTextColor:[UIColor whiteColor] frame:CGRectFlatMake(SCREEN_WIDTH/2 - buywidth/2, SCREEN_HEIGHT - 140, buywidth, 55)];
    [self.buybutton setTitle:ASLocalizedString(@"立即购买")forState:UIControlStateNormal];
    [self.buybutton addTarget:self action:@selector(doBuy) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buybutton];
    
}

- (void)doBuy {
    if(self.select_model == nil)
    {
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"请先选择座驾")];
        return;
    }
    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:ASLocalizedString(@"温馨提示")message:ASLocalizedString(@"是否要购买此座驾")preferredStyle:QMUIAlertControllerStyleAlert];
    [alert addAction:[QMUIAlertAction actionWithTitle:ASLocalizedString(@"确定购买")style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [[BGHUDHelper sharedInstance] syncLoading];
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"car" forKey:@"ctl"];
        [parmDict setObject:@"buy_car" forKey:@"act"];
        [parmDict setObject:self.select_model.carID forKey:@"car_id"];
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
         {
             [[BGHUDHelper sharedInstance] syncStopLoading];
             if ([responseJson toInt:@"status"] == 1)
             {
                 [BGHUDHelper alert:ASLocalizedString(@"购买成功")];
             }
             else
             {
                 [[BGHUDHelper sharedInstance]tipMessage:[responseJson toString:@"error"]];
             }
         } FailureBlock:^(NSError *error)
         {
             [[BGHUDHelper sharedInstance]tipMessage:[NSString stringWithFormat:@"%@",error]];
         }];
    }]];

    [alert addAction:[QMUIAlertAction actionWithTitle:ASLocalizedString(@"取消")style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        
    }]];
    
    [alert showWithAnimated:YES];
}

-(void)initFWData
{
    [super initFWData];
    [[BGHUDHelper sharedInstance] syncLoading];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"car" forKey:@"ctl"];
    [parmDict setObject:@"get_car_list" forKey:@"act"];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         [[BGHUDHelper sharedInstance] syncStopLoading];
         if ([responseJson toInt:@"status"] == 1)
         {
             self.modearr = [CarItemModel mj_objectArrayWithKeyValuesArray:[responseJson valueForKey:@"list"]];
             [self.CollectionView reloadData];
         }
         else
         {
             [[BGHUDHelper sharedInstance]tipMessage:[responseJson toString:@"error"]];
         }
     } FailureBlock:^(NSError *error)
     {
         [[BGHUDHelper sharedInstance]tipMessage:[NSString stringWithFormat:@"%@",error]];
     }];
    
}

-(void)initFWVariables
{
    [super initFWVariables];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


-(void)pullInternetforNew
{
    [self LoadDataIsNew:YES];
}

-(void)loadMoreData
{
    [self LoadDataIsNew:NO];
}

-(void)LoadDataIsNew:(BOOL)isnew
{
    if(isnew)
    {
        self.page = 1;
    }
    else
    {
        self.page++;
    }
    
//    NSString *url = [Utils makeUrlWithM:@"ShortVideo" andA:@"requestGetShortVideoList"];
//    NSDictionary *params = @{
//                             @"uid":[Config getOwnID],
//                             @"token":[Config getOwnToken],
//                             @"touid":[Config getOwnID],
//                             @"p":[NSString stringWithFormat:@"%d",self.page]
//                             };
//    [WZXNetworking getDicWithUrl:url params:params success:^(NSArray *data) {
//        [self.myVideoCollection.mj_header endRefreshing];
//
//        if(!isnew)
//        {
//            if(data.count < 1)
//            {
//                [self.myVideoCollection.mj_footer setState:MJRefreshStateNoMoreData];
//            }
//            else
//            {
//                NSMutableArray *tmpmodearr = [NSMutableArray array];
//                for (int i= 0 ;i<data.count;i++) {
//                    [tmpmodearr addObject:[videoListModel modelWithDictionary:data[i]]];
//                }
//
//                [self.modearr addObjectsFromArray:tmpmodearr];
//                [self.myVideoCollection.mj_footer setState:MJRefreshStateIdle];
//
//            }
//        }
//        else
//        {
//            self.modearr = [NSMutableArray array];
//            NSMutableArray *tmpmodearr = [NSMutableArray array];
//            for (int i= 0 ;i<data.count;i++) {
//                [tmpmodearr addObject:[videoListModel modelWithDictionary:data[i]]];
//            }
//
//            [self.myVideoCollection.mj_footer setState:MJRefreshStateIdle];
//
//            [self.modearr addObjectsFromArray:tmpmodearr];
//        }
//
//        [self.myVideoCollection reloadData];
//
//    } fail:^(NSString *error) {
//        [self.myVideoCollection.mj_header endRefreshing];
//        [SVProgressHUD showErrorWithStatus:error];
//    }];
//
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.modearr.count;
    return self.modearr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CarCollectionViewCell" forIndexPath:indexPath];
    [cell setModel:self.modearr[indexPath.row]];
//    cell.backgroundColor = [UIColor grayColor];
//    videoListModel *model = [[videoListModel alloc] init];
//    model.cover_url = @"http://1254455514.vod2.myqcloud.com/7b133ca3vodgzp1254455514/b0c76f219031868223370470229/9031868223370470230.jpg";
    
//    cell.model = model;
//    cell.selectedBackgroundView.backgroundColor = KHighlight;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CarModel *model = self.modearr[indexPath.row];
    self.select_model = model;
    
//    UIView *contentView = [[UIView alloc]init];
//    contentView.frame = CGRectMake(0, 0, 200, 180);
//    UIImageView *carimg = [[UIImageView alloc] init];
    
//    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
//    [collectionView reloadData];
}
#pragma mark ---- UICollectionViewDelegateFlowLayout


- (BOOL)preferredNavigationBarHidden {
    return NO;
}

- (BOOL)shouldSetStatusBarStyleLight {
    return NO;
}


@end
