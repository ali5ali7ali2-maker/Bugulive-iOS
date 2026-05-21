//
//  BogoTimeLineListViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/18.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoTimeLineListViewController.h"

//#import "YHTimeLineListController.h"
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



//new

#import "WBModel.h"
#import "WBStatusLayout.h"
#import "WBStatusCell.h"

#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <AVFoundation/AVFoundation.h>
#import <AFSoundManager/AFSoundManager.h>

#import "YYPhotoGroupView.h"

@interface BogoTimeLineListViewController ()<UITableViewDelegate,UITableViewDataSource,CellForWorkGroupDelegate,CellForWorkGroupRepostDelegate,BzoneLogicDelegate,WBStatusCellDelegate>{
    int _currentRequestPage; //当前请求页面
    BOOL _reCalculate;
}

//@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableDictionary *heightDict;

@property (nonatomic, strong) BzoneLogic *logic;

@property (nonatomic, strong) WBStatusCell *c_cell;
@property (nonatomic, strong) CLPlayerView *playerView;

@property(nonatomic, assign) CGFloat scrollOffset;

@property(nonatomic, strong) UIView *tableHeadView;



//new
@property (nonatomic, strong) NSMutableArray *layouts;
@property (nonatomic, strong) ZFPlayerController *player;
//@property (nonatomic, strong) WBStatusVideoControlView *controlView;
@property (nonatomic, strong) NSMutableArray *urls;
@property(nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) AFSoundPlayback *playback;
@property (nonatomic, strong) AFSoundQueue *queue;

@end

@implementation BogoTimeLineListViewController

-(instancetype)initWithIndexAct:(MGDTHOMETYPE)act withUID:(NSString *)toUid isHomePageFrame:(CGRect)homePageFrame{
    BogoTimeLineListViewController *vc = [BogoTimeLineListViewController new];
    vc.homeType = act;
    vc.toUid = toUid;
    vc.homePageFrame = homePageFrame;
//    _tableView = [YYTableView new];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
    
    
    return vc;
}


- (void)viewDidLoad{
    [super viewDidLoad];

    _layouts = [NSMutableArray new];
    _urls = [NSMutableArray array];
    _currentRequestPage = 1;
    
    [self initUI];

//    self.logic = [BzoneLogic new];
//
//    self.logic.page = 1;
//    _logic.delegagte = self;
//    _logic.to_uid = self.toUid;
//    _logic.isGZ = YES;
    
//    [self requestDataLoadNew:YES];
    //设置UserId
    [YHUserInfoManager sharedInstance].userInfo.uid = @"1";
    
    
//    [self wbStatusInit];
    
    [self requestWBStauts:_currentRequestPage];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshHeader) name:KBogoTimeReloadList object:nil];
    
}


- (void)initUI{
    self.tableView = [[UITableView alloc] initWithFrame:self.homePageFrame style:UITableViewStylePlain];
    self.tableView.tag = 1107;
    
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
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
    [_tableView registerClass:[WBStatusCell class] forCellReuseIdentifier:NSStringFromClass([WBStatusCell class])];
    self.rightBtn.hidden = YES;
    self.rightBtn = [[UIButton alloc] init];
    self.rightBtn.frame = CGRectMake(kScreenW - 50 - 15, kScreenH - kNavigationBarHeight - kTabBarHeight - 50 - 25 - 300, 50, 50);
    //    search.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [self.rightBtn setImage:[UIImage imageNamed:@"mg_dy_publish"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(handleSearchEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [BGMJRefreshManager refresh:self.tableView target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];
    
    [self.view addSubview:self.rightBtn];
}

-(void)refreshHeader{
    [self resetHeadView];
//    [self requestDataLoadNew:YES];
    _currentRequestPage = 1;
    [self requestWBStauts:_currentRequestPage];
    
}

-(void)refreshFooter{
//    [self requestDataLoadNew:NO];
    _currentRequestPage ++;
    [self requestWBStauts:_currentRequestPage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self requestDataLoadNew:YES];
//    [self.logic loadListDataWithAct:self.homeType];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_playerView destroyPlayer];
    _c_cell =nil;
}

-(void)reloadDynamicData{
//    BzoneLogic *logic = [BzoneLogic new];
//    logic.delegagte = self;
//    [logic loadListDataWithAct:self.homeType];
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

#pragma mark - UIScrollViewDelegate 列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _layouts.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _homeType == MGDTHOMETYPE_NEARBY ? kRealValue(80) :0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.layouts.count < 1) {
        return [UITableViewCell new];
    }
    
    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WBStatusCell class])];
    cell.delegate = self;
    cell.isShowMore = [self.title isEqualToString:NSLocalizedString(@"我的动态",nil)];
    cell.indexRows = indexPath.row;
    if (_layouts.count > 0) {
        [cell setLayout:_layouts[indexPath.row]];
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return ((WBStatusLayout *)_layouts[indexPath.row]).height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    
    if (self.layouts.count > 0) {
        MGGroupUserInfo *model = self.layouts[indexPath.row];
        DetailsLineViewController *datails = [DetailsLineViewController new];
        datails.title = ASLocalizedString(@"动态详情");
        datails.model = model;

        datails.refreshData = ^{
            _currentRequestPage = 1;
//            self.logic.page = _currentRequestPage;
//            [self.logic loadListDataWithAct:self.homeType];
        };

        [[AppDelegate sharedAppDelegate] pushViewController:datails animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        [AppDelegate sharedAppDelegate].topViewController.hidesBottomBarWhenPushed = YES;
    }
}

/// 点击了 Cell
- (void)cellDidClick:(WBStatusCell *)cell {
    if (self.layouts.count > 0) {
        MGGroupUserInfo *model = (MGGroupUserInfo *)cell.layout.status;
        DetailsLineViewController *datails = [DetailsLineViewController new];
        datails.title = ASLocalizedString(@"动态详情");
        datails.model = model;

        datails.refreshData = ^{
            _currentRequestPage = 1;
//            self.logic.page = _currentRequestPage;
//            [self.logic loadListDataWithAct:self.homeType];
        };

        [[AppDelegate sharedAppDelegate] pushViewController:datails animated:YES];
//        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

        [AppDelegate sharedAppDelegate].topViewController.hidesBottomBarWhenPushed = YES;
    }
}

/// 点击了用户
- (void)cell:(WBStatusCell *)cell didClickUser:(WBUserInfoModel *)user {
    
    if (cell.layout.status.no_name.intValue == 1 && ![cell.layout.status.uid isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
        
        return;
    }
    
    SHomePageVC *tmpController= [[SHomePageVC alloc]init];
    tmpController.user_id = cell.statusView.layout.status.uid;
    tmpController.type = 0;
    [[AppDelegate sharedAppDelegate]pushViewController:tmpController animated:YES];
}

//点击了关注
- (void)cell:(WBStatusCell *)cell didClickMore:(UIButton *)sender{
    
    WBModel *model = cell.layout.status;
    
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
      [parmDict setObject:@"user" forKey:@"ctl"];
      [parmDict setObject:@"follow" forKey:@"act"];
      [parmDict setObject:SafeStr(model.uid) forKey:@"to_user_id"];
          
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            
            model.is_focus = @"1";
            cell.statusView.layout.status = model;
            
            [self.layouts replaceObjectAtIndex:cell.indexRows withObject:cell.statusView.layout];
            sender.hidden = YES;
       }else{
           [BGHUDHelper alert:[responseJson valueForKey:@"error"]];
       }
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
    
}
/// 点击了评论
- (void)cellDidClickComment:(WBStatusCell *)cell {
    
    WBModel *model = cell.statusView.layout.status;
    
    DetailsLineViewController *datails = [DetailsLineViewController new];
    datails.hidesBottomBarWhenPushed = YES;
    datails.title = ASLocalizedString(@"动态详情");
    datails.model = (MGGroupUserInfo *)model;
    
    datails.refreshData = ^{
        _currentRequestPage = 1;
        
        
        
        
    };
    
    [[AppDelegate sharedAppDelegate] pushViewController:datails animated:YES];
//    [self.navigationController pushViewController:datails animated:YES];
}

-(void)cell:(WBStatusCell *)cell didClickDeleteBtn:(UIButton *)sender{
    __weak __typeof(self)weakSelf = self;

    
    [FanweMessage alert:ASLocalizedString(@"提示")message:ASLocalizedString(@"确定删除该动态?")destructiveAction:^{
           
        
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"dynamic" forKey:@"ctl"];
        [parmDict setObject:@"del_dynamic" forKey:@"act"];
        
        [parmDict setObject:cell.layout.status.id forKey:@"dynamic_id"];
        
        FWWeakify(self)
        
        [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
                
                [FanweMessage alertHUD:ASLocalizedString(@"删除动态成功")];
            }else{
                
                [FanweMessage alertHUD:[responseJson valueForKey:@"error"]];
            }
            
            [self requestWBStauts:_currentRequestPage];
            
        } FailureBlock:^(NSError *error) {
            
        }];
           
    } cancelAction:^{

    }];
    
    

}

/// 点击了赞
- (void)cellDidClickLike:(WBStatusCell *)cell {
    __weak __typeof(self)weakSelf = self;
    WBModel *status = cell.statusView.layout.status;
    
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"praise" forKey:@"act"];
    
    [parmDict setObject:SafeStr(status.id) forKey:@"dynamic_id"];
    NSString *like = !status.is_like.integerValue ? @"1" : @"2";
    [parmDict setObject:like forKey:@"is_praise"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        NSInteger  praise = [status.praise integerValue];
        
        if ([[responseJson valueForKey:@"status"]integerValue] == 1) {
            
            [cell.statusView.toolbarView setLiked:[[responseJson valueForKey:@"is_like"]intValue] withAnimation:YES];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma 视频相关

- (void)cell:(WBStatusCell *)cell didClickVideo:(NSString *)url{
    
    YHPlayerViewController *vc = [[YHPlayerViewController alloc]initWithPlayerURL:cell.layout.status.video];
    [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
    
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

/// 点击了图片
- (void)cell:(WBStatusCell *)cell didClickImageAtIndex:(NSUInteger)index {
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    WBModel *status = cell.statusView.layout.status;
    NSArray<NSString *> *pics = status.picUrls;
    NSArray<NSString *> *originPics = status.picUrls;
    
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        UIView *imgView = cell.statusView.picViews[i];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = [NSURL URLWithString:originPics[i]];
        item.largeImageSize = CGSizeMake(kScreenW, kScreenH);
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}




-(void)tableView:(UITableView *)tableView willDisplayCell:(WBStatusCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.layouts.count < 1) {
        return;
    }
    WBStatusLayout *layout = self.layouts[indexPath.row];

    if (StrValid(layout.status.video) && indexPath.row == 0){
        //原创cell
        cell.statusView.cardView.button.hidden = YES;
        [cell.statusView.cardView.playerView.player play];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (self.layouts.count > 0) {
        NSArray *cellArr = self.tableView.visibleCells;
        
        WBStatusCell *cell;
        
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
            
            if (cell.statusView.cardView.hidden == NO) {
                _c_cell = cell;
                [_c_cell.statusView.cardView.playerView pausePlay];
                [cell.statusView.cardView.playerView playVideo];
                
                cell.statusView.cardView.button.hidden = NO;
                cell.statusView.cardView.button.hidden = YES;
                
            }
            
        }
    }
    
    if(self.timeLineDelegate && [self.timeLineDelegate respondsToSelector:@selector(protocolTimeLineDidScrollView:offset:)])
    {
        [self.timeLineDelegate protocolTimeLineDidScrollView:scrollView offset:scrollView.contentOffset.y];
    }
}



-(void)requestWBStauts:(NSInteger)pageIndex{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    
    NSString *actStr = @"";
    if (self.homeType == MGDTHOMETYPE_CONCERT) {
        actStr = @"follow_index";
    }else if (self.homeType == MGDTHOMETYPE_NEARBY) {
        actStr = @"index";
        [parmDict setObject:@"fujin" forKey:@"list_type"];
    }else if (self.homeType == MGDTHOMETYPE_RECOMMAND) {
        actStr = @"index";
        [parmDict setObject:@"" forKey:@"list_type"];
    }else if (self.homeType == MGDTHOMETYPE_MY) {
        actStr = @"my_index";
        [parmDict setObject:self.toUid forKey:@"touid"];
    }else if (self.homeType == MGDTHOMETYPE_VIDEO){
        actStr = @"index";
        [parmDict setObject:@"video" forKey:@"list_type"];
    }
    [parmDict setObject:actStr forKey:@"act"];
    
    [parmDict setObject:[NSString stringWithFormat:@"%ld",pageIndex] forKey:@"p"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
             
        FWStrongify(self)

        
        if (_currentRequestPage == 1) {
            [_layouts removeAllObjects];
            [self.urls removeAllObjects];
            self.player.assetURLs = nil;
            [self.items removeAllObjects];
            _queue = nil;
        }
        for (NSDictionary *dict in responseJson[@"list"]) {
            WBModel *model = [WBModel mj_objectWithKeyValues:dict];
            
            if (StrValid(self.toUid)) {
                model.is_focus = @"1";
            }
            
            WBStatusLayout *layout = [[WBStatusLayout alloc] initWithStatus:model style:WBLayoutStyleTimeline];
            if (layout) {
                [_layouts addObject:layout];
            }
            NSURL *url = [NSURL URLWithString:model.audio.length ? model.audio : @""];
            [self.urls addObject:url];
            self.player.assetURLs = self.urls;
            
        }

        _queue = [[AFSoundQueue alloc] initWithItems:_items];

        self.navigationController.view.userInteractionEnabled = YES;
        
        if ([(NSArray *)responseJson[@"list"] count]) {
            [_tableView.mj_footer endRefreshing];
            [_tableView reloadData];
        }else{
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [_tableView.mj_header endRefreshing];
        
    } FailureBlock:^(NSError *error) {
        
    }];
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

- (void)onTouchActionVideo:(WBStatusCell *)cell withFullScreen:(BOOL)fullScreen
{
    if (fullScreen) {
        
        YHPlayerViewController *vc = [[YHPlayerViewController alloc]initWithPlayerURL:cell.layout.status.video];
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
        return;
    }
    
    _c_cell = cell;

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

