//
//  BGRoomBGImageViewController.m
//  UniversalApp
//
//  Created by bugu on 2020/3/24.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BGRoomBGImageViewController.h"
#import "BGRoomBGImageCollectCell.h"
#import "RoomModel.h"
#import "RoomBGImageModel.h"
#import "UIViewController+Bogo.h"
@interface BGRoomBGImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIButton *confirmBtn;

@end

@implementation BGRoomBGImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ASLocalizedString(@"背景选择");
    [self setUpView];
    [self requestData];
    
}

- (void)backBtnClicked
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)setUpView {
    
    //返回按钮
    [self addBackButton];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(0, 0, kScreenW, kScreenH  - kStatusBarHeight - kNavigationBarHeight);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.mj_header = nil;
    self.collectionView.mj_footer = nil;
    self.collectionView.backgroundColor = kWhiteColor;
    
    [self.collectionView registerClass:[BGRoomBGImageCollectCell class] forCellWithReuseIdentifier:NSStringFromClass([BGRoomBGImageCollectCell class])];
    
    [self.view addSubview:self.confirmBtn];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];

}

- (void)btnAction {
    
    if (!StrValid(self.selectModel.image)) {
        [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"请选择房间背景")];
           return;
       }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"selected_voice_bg" forKey:@"act"];
    [dict setValue:self.room_id forKey:@"room_id"];
    [dict setValue:self.selectModel.id forKey:@"voice_bg"];
//    [dict setValue:wheat_id forKey:@"wheat_id"];
    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"104responseJson%@",responseJson);
     

        [[BGHUDHelper sharedInstance] syncStopLoading];
        
        self.editRoomBGChangedCallBack(self.selectModel);
        [self dismissViewControllerAnimated:NO completion:nil];
        [self.navigationController popViewControllerAnimated:NO];
        
    } FailureBlock:^(NSError *error) {
        [[BGHUDHelper sharedInstance] syncStopLoading];
    }];
    

    

}


- (void)requestData{
    __weak __typeof(self)weakSelf = self;
    //http://www.bogo.voice.broadcast/mapi/public/index.php/api/Voice_api/get_voice_bg
    
    [[BGHUDHelper sharedInstance] syncLoading];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"get_voice_bg_list" forKey:@"act"];
//    [dict setValue:self.live_info.room_id forKey:@"room_id"];
//    [dict setValue:wheat_id forKey:@"wheat_id"];
    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"104responseJson%@",responseJson);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        for (NSDictionary *dict in responseJson[@"data"]) {
            RoomBGImageModel *model = [RoomBGImageModel mj_objectWithKeyValues:dict];
            if ([model.image isEqualToString:self.selectModel.image]) {
                model.selected = YES;
            }
            [strongSelf.dataArray addObject:model];
        }
        [strongSelf.collectionView reloadData];

        [[BGHUDHelper sharedInstance] syncStopLoading];
        
    } FailureBlock:^(NSError *error) {
        [[BGHUDHelper sharedInstance] syncStopLoading];
    }];
    
//    NSString *url = [[CYURLUtils sharedCYURLUtils] makeVoiceURLWithC:@"Voice_api" A:@"get_voice_bg"];
//    [CYNET POSTv2:url parameters:@{@"id":StrValid(self.model.voice.id)?self.model.voice.id : [IMAPlatform sharedInstance].host.userId} responseCache:^(id responseObject) {
//        //do nothing
//    } success:^(id responseObject) {
//        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            for (NSDictionary *dict in responseObject[@"voice_bg_list"]) {
//                RoomBGImageModel *model = [RoomBGImageModel mj_objectWithKeyValues:dict];
//                if ([model.image isEqualToString:self.selectModel.image]) {
//                    model.selected = YES;
//                }
//                [strongSelf.dataArray addObject:model];
//            }
//            [strongSelf.collectionView reloadData];
//        }
//    } failure:^(NSString *error) {
//        [[HUDHelper sharedInstance] tipMessage:error];
//    } hasCache:NO];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BGRoomBGImageCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BGRoomBGImageCollectCell class]) forIndexPath:indexPath];
    RoomBGImageModel *model = self.dataArray[indexPath.item];
    [cell setModel:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenW - 40-15) / 2, kRealValue(260)+ 40);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BGRoomBGImageCollectCell *cell = (BGRoomBGImageCollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.selected = YES;
    
    self.selectModel = self.dataArray[indexPath.item];
    
    for (RoomBGImageModel *model in self.dataArray) {
        model.selected = model == self.selectModel;
    }

    [collectionView reloadData];
    
//    RoomBGPreviewViewController *previewVC = [[RoomBGPreviewViewController alloc]init];
//    previewVC.imageModel = self.dataArray[indexPath.item];
//    previewVC.model = self.model;
//    [self.navigationController pushViewController:previewVC animated:NO];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenW-150)/2, kScreenH - 84 - kTabBarHeight - kTopHeight , 150, 40)];
        [_confirmBtn setTitle:ASLocalizedString(@"选择") forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = kBlueColor;
        [_confirmBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        ViewRadius(_confirmBtn, 20);
    }
    return _confirmBtn;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW , kScreenH - kTopHeight - kTabBarHeight) collectionViewLayout:flow];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = NO;
        _collectionView.mj_header = header;
        
        //底部刷新
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];

//#ifdef kiOS11Before
//
//#else
//        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        _collectionView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
//        _collectionView.scrollIndicatorInsets = _collectionView.contentInset;
//#endif
        
        _collectionView.backgroundColor=kWhiteColor;
        _collectionView.scrollsToTop = YES;
    }
    return _collectionView;
}
-(void)headerRefreshing{
    
}

-(void)footerRefreshing{
//    [_tableView.mj_footer endRefreshing];
}


@end
