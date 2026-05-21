//
//  FocusOnViewController.m
//  BuguLive
//
//  Created by GuoMs on 16/7/4.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FocusOnViewController.h"
#import "HMHotItemModel.h"
#import "HMHotTableViewCell.h"
#import "cuserModel.h"
#import "LivingModel.h"
#import "HMHotModel.h"
#import "OneSectionCell.h"
#import "WebModels.h"
#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>
#import "DistanceModel.h"
#import "NewestItemCell.h"
#import "SDCycleScrollView.h"
#import "AdJumpViewModel.h"
#import "PlayBackCell.h"
#import "NewestViewController.h"


#import "FocusHeaderCollectReusView.h"
#import "FocusOnCollectCell.h"


NS_ENUM(NSInteger ,FocusOnViewTableView)
{
    FWFocusOnZeroSection,                 //广告图
    FWFocusOnFirstSection,                //热门定位
    FWFocusOnTab_Count,
};

static NSString *const cellReuseIdentifier0 = @"cellReuseIdentifie0";
static NSString *const cellReuseIdentifier1 = @"cellReuseIdentifier1";
static NSString *const cellReuseIdentifier2 = @"cellReuseIdentifier2";

@interface FocusOnViewController ()<HMHotTableViewCellDelegate,playToMainDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSString                       *_sexString;
    NSString                       *_areaString;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *recommendArray;/**<目前推荐array假数据*/

@property (nonatomic, assign) CGFloat          heigth;
@property ( nonatomic,strong) UICollectionView                *collectionView;      //CollectionView
@property ( nonatomic,strong) UICollectionViewFlowLayout      *layout;

@end

@implementation FocusOnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kClearColor;
    [self creatView];
    
    
}

- (void)creatView
{
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    
    CGRect tmpFrame;
    if (_collectionViewFrame.size.height)
    {
        tmpFrame = _collectionViewFrame;
    }
    else
    {
        tmpFrame = CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-kTabBarHeight - 22 - 50);
    }
    
    _collectionView = [[UICollectionView alloc]initWithFrame:tmpFrame collectionViewLayout:_layout];
    [_collectionView registerClass:[FocusHeaderCollectReusView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
    withReuseIdentifier:NSStringFromClass([FocusHeaderCollectReusView class])];
        [_collectionView registerClass:[FocusOnCollectCell class] forCellWithReuseIdentifier:NSStringFromClass([FocusOnCollectCell class])];
    [_collectionView registerNib:[UINib nibWithNibName:@"NewestItemCell" bundle:nil] forCellWithReuseIdentifier:@"NewestItemCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"PlayBackCell" bundle:nil] forCellWithReuseIdentifier:@"PlayBackCell"];
    _collectionView.backgroundColor = kClearColor;
    _collectionView.dataSource =self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    [BGMJRefreshManager refresh:_collectionView target:self headerRereshAction:@selector(refresherOfFocusOn) footerRereshAction:nil];
    
    // 刷新该页面（主要为了删除最新页已经退出的直播间）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHome:) name:kRefreshHomeItem object:nil];
  
    [self requestRandomRecommend];

}

#pragma mark 刷新
- (void)refresherOfFocusOn
{
    [self requestNetWorking];
    [self requestRandomRecommend];
}

#pragma mark ========================通知=========================
- (void)willViewApprer:(NSNotification *)not
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict = [not valueForKey:@"userInfo"];
    NSString *str = dict[@"refresh"];
    if ( [str isEqualToString:@"yes"])
    {
        [self requestNetWorking];
    }
}

- (void)refreshHome:(NSNotification *)noti{
    if (noti)
    {
        NSDictionary *tmpDict = (NSDictionary *)noti.object;
        NSString *room_id = [tmpDict toString:@"room_id"];
        
        @synchronized (self.dataArray)
        {
            NSMutableArray *tmpArray = self.dataArray;
            for (HMHotItemModel *model in tmpArray)
            {
                if ([[NSString stringWithFormat:@"%d",model.room_id] isEqualToString:room_id])
                {
                    [tmpArray removeObject:model];
                    self.dataArray = tmpArray;
                    [_collectionView reloadData];
                    return;
                }
            }
        }
    }
}

#pragma mark NetWorking
- (void)requestNetWorking{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"focus_video" forKey:@"act"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         //关注好友的直播
         if ([responseJson toInt:@"status"] == 1)
         {
             NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
             [self.dataArray removeAllObjects];
             arr = responseJson[@"data"];
             if ([arr isKindOfClass:[NSArray class]])
             {
                 if (arr.count > 0)
                 {
                     for (NSDictionary *dic in arr)
                     {
                         HMHotItemModel *model = [HMHotItemModel mj_objectWithKeyValues:dic];
                         model.isPlayBack = NO;
                         [self.dataArray addObject:model];
                     }
                 }
             }
             //精彩回放
             NSMutableArray *sourcearr = [NSMutableArray arrayWithCapacity:0];
             sourcearr = responseJson[@"playback"];
             if ([sourcearr isKindOfClass:[NSArray class]])
             {
                 if (sourcearr.count > 0)
                 {
                     for (NSDictionary *dic in sourcearr)
                     {
                         HMHotItemModel *model = [HMHotItemModel mj_objectWithKeyValues:dic];
                         model.isPlayBack = YES;
                         [self.dataArray addObject:model];
                     }
                 }
             }
             [self.collectionView reloadData];
             [self judgeNoContentView];
             
         }
         
         [BGMJRefreshManager endRefresh:self.collectionView];
         
     } FailureBlock:^(NSError *error){
         FWStrongify(self)
         [BGMJRefreshManager endRefresh:self.collectionView];
     }];
}
- (void)judgeNoContentView{
    
    if ((self.dataArray.count == 0) && (self.recommendArray.count == 0))
    {
        [self showNoContentView];
    }
    else
    {
        [self hideNoContentView];
    }
}

- (void)requestRandomRecommend{
    [self.recommendArray removeAllObjects];
    NSString * uid = [BGIMLoginManager sharedInstance].loginParam.identifier;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"recomme_user" forKey:@"act"];
    [parmDict setObject:@"1" forKey:@"first"];//0获取所有的 1是获取没有关注的
    [parmDict setObject:uid forKey:@"uid"];

    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        NSArray * array = [responseJson[@"data"]valueForKey:@"list"];
        for (id obj in array)
        {
            HMHotItemModel *model =[HMHotItemModel mj_objectWithKeyValues:obj];
            [self.recommendArray addObject:model];
        }


        [self.collectionView reloadData];
        [self judgeNoContentView];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}


- (void)requestFollowAction:(NSInteger)index{
    
        HMHotItemModel *model = self.recommendArray[index];
    
        NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
        [dictM setObject:@"user" forKey:@"ctl"];
        [dictM setObject:@"follow" forKey:@"act"];
        [dictM setObject:[NSString stringWithFormat:@"%@",model.id] forKey:@"to_user_id"];
//    [[BGHUDHelper sharedInstance]syncLoading];
        
       [self.httpsManager POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
        {

           [[BGHUDHelper sharedInstance]syncStopLoading];
            if ([responseJson toInt:@"status"] == 1)
            {
//                NSMutableDictionary *mDict = [[NSMutableDictionary alloc]init];
                NSInteger _has_focus = [responseJson toInt:@"has_focus"];
                
                [FanweMessage alertHUD:ASLocalizedString(@"关注成功")];

                if ([responseJson toInt:@"status"] == 1)
                {
                    if (_has_focus == 1)//已关注
                    {
                        [self.recommendArray removeObject:model];
                        //如果都关注了，就要重新请求推荐主播
                        if (self.recommendArray.count == 0) {
                            [self requestRandomRecommend];
                        }else{
                            [self.collectionView reloadData];
                        }
//                        //刷新下面关注主播列表
//                        [self requestNetWorking];
                    }
                }
            }
        } FailureBlock:^(NSError *error)
        {
            [[BGHUDHelper sharedInstance]syncStopLoading];
        }];
    
    
}




#pragma mark - ----------------------- 代理 -----------------------
#pragma mark - 点击跳转到话题
- (void)pushToTopic:(NSInteger)rowIndex{
    if ([self.dataArray count] > rowIndex)
    {
        HMHotItemModel *tmpModel = [self.dataArray objectAtIndex:rowIndex];
        NewestViewController *tmpController = [[NewestViewController alloc]init];
        tmpController.topicName = tmpModel.title;
        tmpController.cate_id = tmpModel.cate_id;
        tmpController.types = @"1";
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }
}

#pragma mark 点击用户头像
- (void)clickUserIcon:(NSInteger)rowIndex{
    if ([self.delegate respondsToSelector:@selector(goToMainPage:)])
    {
        if ([self.dataArray count] > rowIndex)
        {
            HMHotItemModel *tmpModel = [self.dataArray objectAtIndex:rowIndex];
            [self.delegate goToMainPage:tmpModel.user_id];
        }
    }
}

#pragma mark 回放点击头像进入主页
- (void)handleWithPlayBackMainPage:(UITapGestureRecognizer *)sender index:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(goToMainPage:)])
    {
        HMHotItemModel *tmpModel = [self.dataArray objectAtIndex:tag];
        [self.delegate goToMainPage:tmpModel.user_id];
    }
}

#pragma mark push到最新直播的点击事件
- (void)clickToNewsAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(goToNewestView)])
    {
        [_delegate goToNewestView];
    }
}

#pragma mark - UICollectionViewDataSource UICollectionViewDelegate


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
   
    return CGSizeMake(kScreenW, kRealValue(55));

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    FocusHeaderCollectReusView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([FocusHeaderCollectReusView class]) forIndexPath:indexPath];
    headerView.section = indexPath.section;
    FWWeakify(self)
    headerView.backgroundColor = kClearColor;
    headerView.randomBlock = ^{
        FWStrongify(self)
        [self requestRandomRecommend];
    };
    return headerView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        
        NSLog(@"recommendArray%@",self.recommendArray);
        if (self.recommendArray.count > 3) {
            return 3;
        }
        return self.recommendArray.count;
    }
    
    if (self.dataArray.count)
    {
        return self.dataArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FocusOnCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FocusOnCollectCell class]) forIndexPath:indexPath];
        cell.user = self.recommendArray[indexPath.item];
        FWWeakify(self)
        cell.followBlock = ^{
            FWStrongify(self)
            [self requestFollowAction:indexPath.item];
        };
        
        cell.clickImgBlock = ^(NSString * _Nonnull str) {
            SHomePageVC *tmpController= [[SHomePageVC alloc]init];
            tmpController.user_id = str;
            tmpController.type = 0;
            [[AppDelegate sharedAppDelegate]pushViewController:tmpController animated:YES];
        };
        return cell;
    }
    
    HMHotItemModel *tmpModel = [self.dataArray objectAtIndex:indexPath.row];
    if (!tmpModel.isPlayBack) {
        NewestItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewestItemCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setModel:tmpModel];
        return cell;
    }else{
        PlayBackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayBackCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setModel:tmpModel];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake((kScreenW-4)/3.0f, kRealValue(131));
    }
    return CGSizeMake((kScreenW-30)/2.0f,(kScreenW-30)/2.0f + kRealValue(30));
//                      (kScreenW-30)/2.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 2, 0, 2);
    }
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

#pragma mark - 跳转到在线直播
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
    //暂时没做跳转

    }else{

        HMHotItemModel *model = self.dataArray[indexPath.row];
        if (model.isPlayBack) {
            model.live_in = FW_LIVE_STATE_RELIVE;
        }
        
//        LivingModel *model = _dataArray[indexPath.row];
//        if (self.delegate)
//        {
//            if ([self.delegate respondsToSelector:@selector(pushToLiveController:modelArr:)])
//            {
//                [self.delegate pushToLiveController:model modelArr:self.dataArray];
//            }
//        }
        
        [self joinOtherLivingRoom:model];
    }
}

#pragma mark - 加入直播间
- (void)joinOtherLivingRoom:(HMHotItemModel *)model{
    if (![BGUtils isNetConnected])
    {
        return;
    }
    if ([IMAPlatform sharedInstance].host)
    {
        TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc]init];
        liveRoom.chatRoomId = model.group_id;
        liveRoom.avRoomId = model.room_id;
        liveRoom.title = [NSString stringWithFormat:@"%d",model.room_id];
        liveRoom.vagueImgUrl = model.head_image;
        
        TCShowUser *showUser = [[TCShowUser alloc]init];
        showUser.uid = model.user_id;
        showUser.avatar = model.head_image;
        showUser.username = model.nick_name;
        liveRoom.host = showUser;
        
        if (model.live_in == FW_LIVE_STATE_ING)
        {
            liveRoom.liveType = FW_LIVE_TYPE_AUDIENCE;
        }
        else if (model.live_in == FW_LIVE_STATE_RELIVE)
        {
            liveRoom.liveType = FW_LIVE_TYPE_RELIVE;
            [GlobalVariables sharedInstance].appModel.spear_live = @"0";
        }
        
        if ([LiveCenterManager sharedInstance].itemModel) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"clickLiveRoomNotification" object:nil];
        }
        
        //2020-1-7 小直播变大
        [LiveCenterManager sharedInstance].itemModel=liveRoom;
        BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
        [[LiveCenterManager sharedInstance]  showLiveOfAudienceLiveofTCShowLiveListItem:liveRoom modelArr:self.dataArray  isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL finished) {
        }];
    }
    else
    {
        [[BGHUDHelper sharedInstance] loading:@"" delay:2 execute:^{
            [[BGIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
        } completion:^{
            
        }];
    }
}


#pragma mark - Lazy Load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (NSMutableArray *)recommendArray{
    if (!_recommendArray) {
        _recommendArray = [[NSMutableArray alloc]init];
    }
    return _recommendArray;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    if (@available(iOS 13, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}

@end
