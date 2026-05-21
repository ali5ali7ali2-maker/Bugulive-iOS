//
//  VideoViewController.m
//  BuguLive
//
//  Created by 王珂 on 17/5/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoCollectionViewCell.h"
#import "HMHotModel.h"

#import "NewestItemCell.h"

@interface VideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int has_next;
@property (nonatomic, assign) BOOL canClickItem;
@property (nonatomic, strong) HMHotModel * videoModel;

@end

@implementation VideoViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
    [self setNetworing:1];
}

- (void)createView
{
    self.view.backgroundColor = kWhiteColor;
    
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init] ;
//    CGFloat itemW = (self.viewFrame.size.width-3)/2.0;
//    CGFloat itemH = (self.viewFrame.size.width-3)/2.0;
//    //设置cell的大小
//    flow.itemSize = CGSizeMake(itemW, itemH) ;
//    flow.minimumLineSpacing = 3;
//    flow.minimumInteritemSpacing = 3;
//    flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10) ;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.viewFrame collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = kClearColor;
    _collectionView.tag = 1107;
    [_collectionView registerNib:[UINib nibWithNibName:@"NewestItemCell" bundle:nil] forCellWithReuseIdentifier:@"NewestItemCell"];
//    [_collectionView registerClass:[NewestItemCell class] forCellWithReuseIdentifier:@"NewestItemCell"];
    [self.view addSubview:_collectionView];
    [BGMJRefreshManager refresh:_collectionView target:self headerRereshAction:@selector(headerReresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerRereshing)];
    _canClickItem = YES;
    
    [self setNetworing:1];
}

#pragma mark -- 头部刷新
- (void)headerReresh
{
    [self setNetworing:1];
}
//尾部刷新
- (void)footerRereshing
{
    if (_has_next == 1)
    {
        _page ++;
        [self setNetworing:_page];
    }
    else
    {
        [BGMJRefreshManager endRefresh:_collectionView];
    }
}

- (void)setNetworing:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"classify" forKey:@"act"];
    [parmDict setObject:@(_classified_id) forKey:@"classified_id"];
    [parmDict setObject:@(page) forKey:@"p"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            self.has_next = [responseJson toInt:@"has_next"];
            self.page = [responseJson toInt:@"page"];
            if (self.page == 1)
            {
                [self.dataArray removeAllObjects];
            }
            self.videoModel = [HMHotModel mj_objectWithKeyValues:responseJson];
            [self.dataArray addObjectsFromArray:self.videoModel.list];
            [self.collectionView reloadData];
        }
        
        [BGMJRefreshManager endRefresh:self.collectionView];
        
        if (!self.dataArray.count)
        {
            [self showNoContentView];
        }
        else
        {
            [self hideNoContentView];
        }
        
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        [BGMJRefreshManager endRefresh:self.collectionView];
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    VideoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCollectionViewCell" forIndexPath:indexPath] ;
//    cell.model = self.dataArray[indexPath.item];
//    return cell ;
    
    NewestItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewestItemCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    LivingModel *LModel = _dataArray[indexPath.row];
    [cell setCellContent:LModel Type:1];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self joinLivingRoom:self.dataArray[indexPath.item]];
}

#pragma mark 加入直播间
- (void)joinLivingRoom:(HMHotItemModel *)model
{
    // 防止重复点击
    if (self.canClickItem)
    {
        self.canClickItem = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.canClickItem = YES;
            
        });
    }
    else
    {
        return;
    }
    
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
    
    
//    // model  转为 dic
//    NSDictionary *dic = model.mj_keyValues;
//
//
//
//    // 直播管理中心开启观众直播
//    BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
//    [[LiveCenterManager sharedInstance] showLiveOfAudienceLiveofPramaDic:dic.mutableCopy isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL finished) {
//    }];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenW-30)/2.0f, (kScreenW-30) / 2.0f + kRealValue(32));
//    return CGSizeMake((kScreenW-30)/2.0f, (kScreenW-30)/2.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
 
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
   
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

@end
