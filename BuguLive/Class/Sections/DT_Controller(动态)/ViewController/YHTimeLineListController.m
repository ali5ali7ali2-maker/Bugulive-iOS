//
//  YHQAListController.m
//  github:  https://github.com/samuelandkevin
//
//  Created by samuelandkevin on 16/8/29.
//  Copyright © 2016年 HKP. All rights reserved.
//

#import "YHTimeLineListController.h"
#import "CellForWorkGroup.h"
#import "CellForWorkGroupRepost.h"
#import "YHRefreshTableView.h"
#import "YHWorkGroup.h"
#import "YHUserInfoManager.h"
//#import "YHUtils.h"
#import "YHSharePresentView.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"



#import "XWPublishController.h"
#import "DetailsLineViewController.h"

#import <CLPlayer/CLPlayerView.h>

#import "YHPlayerViewController.h"


#import "ReleaseDynamicVC.h"
#import "BGTopicTimeLineListController.h"
#import "MGNewDTNearByViewController.h"//附近的人


@interface YHTimeLineListController ()<UITableViewDelegate,UITableViewDataSource,CellForWorkGroupDelegate,CellForWorkGroupRepostDelegate,BzoneLogicDelegate>{
    int _currentRequestPage; //当前请求页面
    BOOL _reCalculate;
}

//@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableDictionary *heightDict;

@property (nonatomic, strong) BzoneLogic *logic;

@property (nonatomic, strong) CellForWorkGroup *c_cell;
@property (nonatomic, strong) CLPlayerView *playerView;

@property(nonatomic, assign) CGFloat scrollOffset;

@property(nonatomic, strong) UIView *tableHeadView;

@end

@implementation YHTimeLineListController

-(instancetype)initWithIndexAct:(MGDTHOMETYPE)act withUID:(NSString *)toUid{
    YHTimeLineListController *vc = [YHTimeLineListController new];
    vc.homeType = act;
    vc.toUid = toUid;
    return vc;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [self initUI];

    self.logic = [BzoneLogic new];

    self.logic.page = 1;
    _logic.delegagte = self;
    _logic.to_uid = self.toUid;
    _logic.isGZ = YES;
    
//    [self requestDataLoadNew:YES];
    //设置UserId
    [YHUserInfoManager sharedInstance].userInfo.uid = @"1";
}



- (void)initUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight - 64 - 49) style:UITableViewStylePlain];
    self.tableView.tag = 1107;
    if (isIPhoneX()) {
        self.tableView.height = kScreenH - 49 - 64 - 20;
    }
    
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
    
    NSLog(@"%f",kTabBarHeight);
    NSLog(@"%f",kNavigationBarHeight);
    
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGBCOLOR(244, 244, 244);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
//    [self.tableView setEnableLoadNew:YES];
//    [self.tableView setEnableLoadMore:YES];
    
    self.view.backgroundColor = RGBCOLOR(244, 244, 244);
    
    [self.tableView registerClass:[CellForWorkGroup class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroup class])];
    [self.tableView registerClass:[CellForWorkGroupRepost class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroupRepost class])];
    
    self.rightBtn = [[UIButton alloc] init];
    self.rightBtn.frame = CGRectMake(kScreenW - 50 - 15, kScreenH - kNavigationBarHeight - kTabBarHeight - 50 - 25, 50, 50);
    //    search.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [self.rightBtn setImage:[UIImage imageNamed:@"mg_dy_publish"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(handleSearchEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [BGMJRefreshManager refresh:self.tableView target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];
    
    [self.view addSubview:self.rightBtn];
}

-(void)refreshHeader{
    [self resetHeadView];
    [self requestDataLoadNew:YES];
}

-(void)refreshFooter{
    [self requestDataLoadNew:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestDataLoadNew:YES];
//    [self.logic loadListDataWithAct:self.homeType];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_playerView destroyPlayer];
    _c_cell =nil;
}

-(void)reloadDynamicData{
    BzoneLogic *logic = [BzoneLogic new];
    logic.delegagte = self;
    [logic loadListDataWithAct:self.homeType];
}

//发布动态
- (void)handleSearchEvent
{
//    XWPublishController *pushVC = [XWPublishController new];
    ReleaseDynamicVC *pushVC = [ReleaseDynamicVC new];

    __weak __typeof(self)weakSelf = self;
    pushVC.postFinishBlock = ^(BOOL isFinish) {
        if (isFinish) {
            if (weakSelf.timeLineDelegate &&  [weakSelf.timeLineDelegate respondsToSelector:@selector(reloadDynamicData)]) {
                [weakSelf.timeLineDelegate reloadDynamicData];
            }
//            [weakSelf.logic loadListDataWithAct:self.homeType];
        }
    };
    [[AppDelegate sharedAppDelegate]presentViewController:pushVC animated:YES completion:nil];
//    [self presentViewController:pushVC animated:YES completion:nil];
}

#pragma mark - Lazy Load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)heightDict{
    if (!_heightDict) {
        _heightDict = [NSMutableDictionary new];
    }
    return _heightDict;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _homeType == MGDTHOMETYPE_NEARBY ? kRealValue(80) :0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count < 1) {
        return [UITableViewCell new];
    }
    
    MGGroupUserInfo *model  = self.dataArray[indexPath.row];
        
    //原创cell
    CellForWorkGroup *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CellForWorkGroup class])];
    if (!cell) {
        cell = [[CellForWorkGroup alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CellForWorkGroup class])];
    }
    
    cell.homeType = self.homeType;
    cell.indexPath = indexPath;
    cell.model = model;
    cell.delegate = self;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.dataArray.count) {
        
        CGFloat height = 0.0;
        //原创cell
        Class currentClass  = [CellForWorkGroup class];
        MGGroupUserInfo *model  = self.dataArray[indexPath.row];
        
        //取缓存高度
        NSDictionary *dict =  self.heightDict[model.id];
        if (dict) {
            if (model.isOpening) {
                height = [dict[@"open"] floatValue];
            }else{
                height = [dict[@"normal"] floatValue];
            }
            if (height) {
                return height;
            }
        }
        
        height = [CellForWorkGroup hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
            CellForWorkGroup *cell = (CellForWorkGroup *)sourceCell;
            
            cell.model = model;
            
        }];
        
        if (model.cover_url && ![model.cover_url isEqualToString:@""])
        {
//            height += 74;
        }
//        }
        
        //缓存高度
        if (model.id) {
            NSMutableDictionary *aDict = [NSMutableDictionary new];
            if (model.isOpening) {
                [aDict setObject:@(height) forKey:@"open"];
            }else{
                [aDict setObject:@(height) forKey:@"normal"];
            }
            [self.heightDict setObject:aDict forKey:model.id];
        }
        return height;
    }
    else{
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    
    if (self.dataArray.count > 0) {
        MGGroupUserInfo *model = self.dataArray[indexPath.row];
        DetailsLineViewController *datails = [DetailsLineViewController new];
        datails.title = ASLocalizedString(@"动态详情");
        datails.model = model;
        
        datails.refreshData = ^{
            
            [self refreshHeader];
            
        };
        
        [[AppDelegate sharedAppDelegate] pushViewController:datails animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [AppDelegate sharedAppDelegate].topViewController.hidesBottomBarWhenPushed = YES;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(CellForWorkGroup *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count < 1) {
        return;
    }
    MGGroupUserInfo *model  = self.dataArray[indexPath.row];

    if (model.cover_url && ![model.cover_url isEqualToString:@""] && indexPath.row == 0){
        //原创cell
        [self onTouchActionVideo:cell withFullScreen:NO];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.dataArray.count > 0) {
        NSArray *cellArr = self.tableView.visibleCells;
        
        CellForWorkGroup *cell;
        
        if (self.scrollOffset - scrollView.contentOffset.y > 0) {
            cell = cellArr.firstObject;
        }else{
            cell = cellArr.lastObject;
        }
        
        if (cellArr.count == 3) {//当可见视图有三个cell时，展示中间那个。
            cell = [cellArr objectAtIndex:1];
        }
        
        self.scrollOffset = scrollView.contentOffset.y;
        
        if (self.scrollOffset == 0) cell = cellArr.firstObject;//下拉刷新时展示第一个
        
        if (_c_cell != cell) {
            _c_cell = cell;
            [self onTouchActionVideo:cell withFullScreen:NO];
        }
    }
    
//    MGGroupUserInfo *model  = self.dataArray[indexPath.row];
    
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(didDynamicCollectionViewScrollView:)]) {
        [self.vDelegate didDynamicCollectionViewScrollView:scrollView];
        return;
    }
    
    CGFloat sectionHeaderHeight = self.tableHeadView.height + kTopHeight;

    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
    if(self.timeLineDelegate && [self.timeLineDelegate respondsToSelector:@selector(protocolTimeLineDidScrollView:offset:)])
    {
        [self.timeLineDelegate protocolTimeLineDidScrollView:scrollView offset:scrollView.contentOffset.y];
    }
}

#pragma mark - 网络请求
- (void)requestDataLoadNew:(BOOL)loadNew{
    YHRefreshType refreshType;
    if (loadNew) {
        _currentRequestPage = 1;
        refreshType = YHRefreshType_LoadNew;
    }
    else{
        _currentRequestPage ++;
        refreshType = YHRefreshType_LoadMore;
    }
    

    if (loadNew) {
        [self.dataArray removeAllObjects];
        [self.heightDict removeAllObjects];
    }
    
    _logic.page = _currentRequestPage;
    
    int totalCount = 10;
    
    NSUInteger lastDynamicID = 0;
    if (!loadNew && self.dataArray.count) {
        MGGroupUserInfo *model = self.dataArray.lastObject;
        lastDynamicID = [model.id integerValue];
    }
    
    
    
    [_logic loadListDataWithAct:self.homeType];
    
//    [BGMJRefreshManager endRefresh:self.tableView];
    
//    [self.tableView reloadData];
}


-(void)requestZoneListDataCompleted
{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
    
    self.dataArray = _logic.dataArray;
    if(_logic.noHasMore == YES)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    if (self.dataArray.count < 1)
    {
        [self showNoContentView];
        self.noContentView.top = kRealValue(120);
    }else
    {
        [self hideNoContentView];
    }
    
    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
    {
        [self.dataArray removeAllObjects];
    }
    
    [self.tableView reloadData];
    
//    [BGMJRefreshManager endRefresh:self.tableView];
}

#pragma mark - 模拟产生数据源
- (void)randomModel:(MGGroupUserInfo *)model totalCount:(int)totalCount{
    
    model.type = arc4random()%totalCount %2? DynType_Forward:DynType_Original;//动态类型
    if (model.type == DynType_Forward) {
        model.forwardModel = [MGGroupUserInfo new];
        [self creatOriModel:model.forwardModel totalCount:totalCount];
    }
    [self creatOriModel:model totalCount:totalCount];
    
}

- (void)creatOriModel:(MGGroupUserInfo *)model totalCount:(int)totalCount{

}

#pragma mark - YHRefreshTableViewDelegate
- (void)refreshTableViewLoadNew:(YHRefreshTableView*)view{
//    [self requestDataLoadNew:YES];
}

- (void)refreshTableViewLoadmore:(YHRefreshTableView*)view{
//    [self requestDataLoadNew:NO];
}

#pragma mark - CellForWorkGroupDelegate
- (void)onAvatarInCell:(CellForWorkGroup *)cell{
    SHomePageVC *tmpController= [[SHomePageVC alloc]init];
    tmpController.user_id = cell.model.uid;
    tmpController.type = 0;
    [[AppDelegate sharedAppDelegate]pushViewController:tmpController animated:YES];
}

- (void)onMoreInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        model.isOpening = !model.isOpening;
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)onCommentInCell:(CellForWorkGroup *)cell{
    MGGroupUserInfo *model = self.dataArray[cell.indexPath.row];
    
//    self.hidesBottomBarWhenPushed = YES;
    
    DetailsLineViewController *datails = [DetailsLineViewController new];
    datails.hidesBottomBarWhenPushed = YES;
    datails.title = ASLocalizedString(@"动态详情");
    datails.model = model;
    
    datails.refreshData = ^{
        [self refreshHeader];
    };
    [self.navigationController pushViewController:datails animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

- (void)onLikeInCell:(CellForWorkGroup *)cell{
    
    __weak __typeof(self)weakSelf = self;
    MGGroupUserInfo *model = self.dataArray[cell.indexPath.row];
    
    BOOL isLike = ![model.is_like isEqualToString:@"1"];
    
    [self.logic addDolikeID:cell.model.id isLike:isLike Success:^(id  _Nonnull selfPtr, BOOL isFinished) {
        if (cell.indexPath.row < [self.dataArray count]) {
            MGGroupUserInfo *model = weakSelf.dataArray[cell.indexPath.row];
            
//            BOOL isLike = [model.is_like isEqualToString:@"1"];
            
            NSInteger  praise = [model.praise integerValue];
            
            if (isFinished) {//此处取反
                praise += 1;
                model.is_like = @"1";
            }else{
                praise -= 1;
                model.is_like = @"0";
            }
            //
            model.praise = [NSString stringWithFormat:@"%ld",praise];
            cell.model = model;
            [weakSelf.dataArray replaceObjectAtIndex:cell.indexPath.row withObject:model];
            
//            [cell.liksBtn setImage:[UIImage imageNamed:[model.is_like isEqualToString:@"1"] ? @"mg_dy_likes_select" : @"mg_dy_like"] forState:UIControlStateNormal];
//            [cell.liksBtn setTitleColor:[UIColor colorWithHexString:[model.is_like isEqualToString:@"1"] ? @"#FF268E" : @"#999999"] forState:UIControlStateNormal];

//            [weakSelf.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)onShareInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]){
        [self _shareWithCell:cell];
    }
}

- (void)onDeleteInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        [self _deleteDynAtIndexPath:cell.indexPath dynamicId:cell.model.id cell:cell];
    }
}

- (void)onTopicInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        BGTopicTimeLineListController *pushVC = [BGTopicTimeLineListController new];
        MGDynamicTopicModel *topic = [MGDynamicTopicModel new];
        topic.t_id = cell.model.theme_id;
        topic.name = cell.model.theme;
        pushVC.topic = topic;
        [[AppDelegate sharedAppDelegate]pushViewController:pushVC animated:YES];
   }
}

- (void)onFollowInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        FWWeakify(self)
        [self.logic addFollowUID:cell.model.uid Success:^(NSDictionary * _Nonnull dic) {
            
            NSInteger _has_focus = [dic toInt:@"has_focus"];
            if (_has_focus == 1) {
//                [FanweMessage alertHUD:@""]
//                [FanweMessage alert:ASLocalizedString(@"关注成功")];
            }
            
          //刷新数据
            FWStrongify(self)
            _currentRequestPage = 1;
            
            self.logic.page = _currentRequestPage;
      
            [self.logic loadListDataWithAct:self.homeType];

            
        }];
    
       }
}

- (void)onTouchActionVideo:(CellForWorkGroup *)cell withFullScreen:(BOOL)fullScreen
{
    if (fullScreen) {
        
        YHPlayerViewController *vc = [[YHPlayerViewController alloc]initWithPlayerURL:cell.model.video];
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
        return;
    }
    
    _c_cell =cell;
    [_playerView destroyPlayer];
    _playerView =nil;
    _playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, cell.ClVideoview.width, cell.ClVideoview.height)];
    _playerView.backgroundColor = kClearColor;
    _playerView.layer.cornerRadius = 4;
    _playerView.layer.masksToBounds = YES;

    if ([_playerView.maskView respondsToSelector:NSSelectorFromString(@"playButton")]) {
        UIButton *playButton = [_playerView.maskView valueForKey:@"playButton"];
        playButton.hidden = YES;
    }
    
    __weak __typeof(self)weakSelf = self;
    [_playerView updateWithConfigure:^(CLPlayerViewConfigure *configure) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        configure.repeatPlay = YES;
        configure.mute = !fullScreen;
        configure.isLandscape = YES;
        configure.videoFillMode = VideoFillModeResizeAspectFill;
        if (fullScreen) {
            _playerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
            [strongSelf.tabBarController.view addSubview:_playerView];
            UITapGestureRecognizer *tapPlayerView = [[UITapGestureRecognizer alloc]initWithTarget:strongSelf action:@selector(tapPlayerView:)];
            [_playerView.maskView addGestureRecognizer:tapPlayerView];
        }else{
            [cell.ClVideoview addSubview:_playerView];
            UITapGestureRecognizer *tapPlayerView = [[UITapGestureRecognizer alloc]initWithTarget:strongSelf action:@selector(tapBigScreen:)];
            [_playerView.maskView addGestureRecognizer:tapPlayerView];
        }
        _playerView.url =[NSURL URLWithString:cell.model.video];
        //播放
        [_playerView playVideo];
    }];
    
    
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(ASLocalizedString(@"返回按钮被点击"));
    }];
    
    //播放完成回调
    [_playerView endPlay:^{
//        //销毁播放器
//        [_playerView destroyPlayer];
//        _playerView = nil;
//        NSLog(ASLocalizedString(@"播放完成"));
    }];
}

-(void)tapPlayerView:(UITapGestureRecognizer *)sender{
    [self onTouchActionVideo:_c_cell withFullScreen:NO];
}

-(void)tapBigScreen:(UITapGestureRecognizer *)sender{
    [self onTouchActionVideo:_c_cell withFullScreen:YES];
}

#pragma mark - CellForWorkGroupRepostDelegate

- (void)onAvatarInRepostCell:(CellForWorkGroupRepost *)cell{
    
}

- (void)onTapRepostViewInCell:(CellForWorkGroupRepost *)cell{
    
}

- (void)onCommentInRepostCell:(CellForWorkGroupRepost *)cell{
    
}

//附近--点击去看看
-(void)cliclSeeBtn:(UIButton *)sender{
    
    
    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
    {
        return;
    }
    MGNewDTNearByViewController *pushVC = [[MGNewDTNearByViewController alloc]initWithType:MGNEWDTTYPE_NEAR_PEOPLE];
    [[AppDelegate sharedAppDelegate]pushViewController:pushVC animated:YES];
}

- (void)onLikeInRepostCell:(CellForWorkGroupRepost *)cell{
    
    if (cell.indexPath.row < [self.dataArray count]) {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        
        BOOL isLike = !model.isLike;
        //更新本地数据源
        model.isLike = isLike;
        if (isLike) {
            model.likeCount += 1;
        }else{
            model.likeCount -= 1;
        }
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

- (void)onShareInRepostCell:(CellForWorkGroupRepost *)cell{
    
//    if (cell.indexPath.row < [self.dataArray count]){
//        [self _shareWithCell:cell];
//    }
}

- (void)onDeleteInRepostCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        [self _deleteDynAtIndexPath:cell.indexPath dynamicId:cell.model.id cell:cell];
    }
}

- (void)onMoreInRespostCell:(CellForWorkGroupRepost *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        model.isOpening = !model.isOpening;
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - private
- (void)_deleteDynAtIndexPath:(NSIndexPath *)indexPath dynamicId:(NSString *)dynamicId cell:(CellForWorkGroup *)cell{
    
    __weak __typeof(self)weakSelf = self;
    
//    [FanweMessage alert:ASLocalizedString(@"提示")message:ASLocalizedString(@"确定删除该动态?")destructiveAction:^{
           [weakSelf.logic delZone:dynamicId Success:^{
               [weakSelf.logic loadListDataWithAct:self.homeType];
               [FanweMessage alertHUD:ASLocalizedString(@"删除成功")];
           }];
//    } cancelAction:^{
//
//    }];
}

- (void)_shareWithCell:(CellForWorkGroup *)cell{

    __weak __typeof(self)weakSelf = self;
    [_logic dynamicForwardWithDynamic_id:cell.model.id Success:^{
        cell.model.bottomViewSelect = YES;
        cell.bottomView.hidden = YES;
        [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"转发成功")];
        [weakSelf.logic loadListDataWithAct:self.homeType];
    }];
}


#pragma mark - UIScrollViewDelegate

-(UIView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(80))];
        _tableHeadView.backgroundColor = kWhiteColor;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kRealValue(10), 0, kScreenW - kRealValue(10 * 2), kRealValue(80))];
        imgView.image = [UIImage imageNamed:@"dy_newby_people_bgimg"];
        imgView.userInteractionEnabled = YES;
        
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(kRealValue(28), kRealValue(12), kRealValue(100), kRealValue(20))];
        titleL.text = ASLocalizedString(@"附近的人");
        titleL.font = [UIFont systemFontOfSize:15];
        titleL.textColor = kBlackColor;
        
        UIButton *toSeeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        toSeeBtn.frame = CGRectMake(kRealValue(25), titleL.bottom + kRealValue(5), kRealValue(64), kRealValue(29));
        [toSeeBtn setBackgroundImage:[UIImage imageNamed:@"dy_newby_people_tosee"] forState:UIControlStateNormal];
        [toSeeBtn setTitle:ASLocalizedString(@"去看看")forState:UIControlStateNormal];
        [toSeeBtn addTarget:self action:@selector(cliclSeeBtn:) forControlEvents:UIControlEventTouchUpInside];
        toSeeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        
        
        [imgView addSubview:titleL];
        [imgView addSubview:toSeeBtn];
        [_tableHeadView addSubview:imgView];
        for (int i = 0; i < 3; i ++ ) {
            UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kRealValue(240) + kRealValue(30) * i, 0, kRealValue(40), kRealValue(40))];
            headImgView.tag = 100 + i;
            headImgView.centerY = imgView.height / 2;
            headImgView.layer.masksToBounds = YES;
            headImgView.layer.cornerRadius = kRealValue(40 / 2);
            headImgView.backgroundColor = kClearColor;
            [_tableHeadView addSubview:headImgView];
        }
        
        

        
    }
    return _tableHeadView;
}

-(void)resetHeadView{
    //附近的人
    if (self.homeType == MGDTHOMETYPE_NEARBY) {
        
        if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
        {
            return;
        }
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
            [parmDict setObject:@"dynamic" forKey:@"ctl"];
            [parmDict setObject:@"fujin_user" forKey:@"act"];
            
            [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
                if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
                    NSArray *arr = responseJson[@"data"];
                    [self resetTableHeadViewWithArr:arr];
                }else{
                    
                }
            } FailureBlock:^(NSError *error) {

            }];
    }
}

-(void)resetTableHeadViewWithArr:(NSArray *)arr{
    if (arr.count > 0)
    {
        for ( int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            MGNewDTNearlistModel *model = [MGNewDTNearlistModel modelWithDictionary:dic];
            UIImageView *imgView = [_tableHeadView viewWithTag:100 + i];
            [imgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:nil];
            
        }
    }
    
}


@end
