//
//  BGTopicTimeLineListController.m
//  BuguLive
//
//  Created by bugu on 2019/12/13.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGTopicTimeLineListController.h"
#import "BzoneLogic.h"
#import "CellForWorkGroup.h"
#import "CellForWorkGroupRepost.h"
#import "YHRefreshTableView.h"
#import "YHWorkGroup.h"
#import "YHUserInfoManager.h"
//#import "YHUtils.h"
#import "YHSharePresentView.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"



#import "DetailsLineViewController.h"

#import <CLPlayer/CLPlayerView.h>

#import "YHPlayerViewController.h"


#import "ReleaseDynamicVC.h"

@interface BGTopicTimeLineListController ()<UITableViewDelegate,UITableViewDataSource,CellForWorkGroupDelegate,CellForWorkGroupRepostDelegate,BzoneLogicDelegate>{
    int _currentRequestPage; //当前请求页面
    BOOL _reCalculate;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableDictionary *heightDict;

@property (nonatomic, strong) BzoneLogic *logic;

@property (nonatomic, strong) CellForWorkGroup *c_cell;
@property (nonatomic, strong) CLPlayerView *playerView;

@property(nonatomic, strong) UIButton *releaseBtn;

@end

@implementation BGTopicTimeLineListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //话题
    
    self.title = self.topic.name;
    [self backBtnWithBlock];
    [self initUI];
    self.logic = [BzoneLogic new];
    
    self.logic.page = 1;
    _logic.delegagte = self;
    //    _logic.to_uid = self.to_uid;
    _logic.isGZ = YES;
    [_logic loadListDataWiththeme:self.topic.t_id];
    
    [self requestDataLoadNew:YES];
    
    // Do any additional setup after loading the view.
}

- (void)backBtnWithBlock
{
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onReturnBtnPress) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
}

- (void)onReturnBtnPress
{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)initUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight) style:UITableViewStylePlain];
  
    
    NSLog(@"%f",kTabBarHeight);
    NSLog(@"%f",kNavigationBarHeight);
    
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tag = 1107;
    self.tableView.backgroundColor = RGBCOLOR(244, 244, 244);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
//    [self.tableView setEnableLoadNew:YES];
//    [self.tableView setEnableLoadMore:YES];
    
    self.view.backgroundColor = RGBCOLOR(244, 244, 244);
    
    [self.tableView registerClass:[CellForWorkGroup class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroup class])];
    [self.tableView registerClass:[CellForWorkGroupRepost class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroupRepost class])];
    [BGMJRefreshManager refresh:self.tableView target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];

    [self.view addSubview:self.releaseBtn];
    
    [self.releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-92-(isIPhoneX()?34:0));
        make.right.mas_equalTo(-8);
        make.size.mas_equalTo(kRealValue(64));
    }];
    
    [self.view bringSubviewToFront:self.releaseBtn];
}

//发布话题动态
- (void)releaseeButtonClick{
    
    ReleaseDynamicVC *pushVC = [ReleaseDynamicVC new];
    pushVC.topic = self.topic;
    //指定话题
    FWWeakify(self)
    pushVC.postFinishBlock = ^(BOOL isFinish) {
        if (isFinish) {
            FWStrongify(self)

            //刷新 话题动态的数据
             [self.logic loadListDataWiththeme:self.topic.t_id];
        }
    };
    [[AppDelegate sharedAppDelegate]presentViewController:pushVC animated:YES completion:nil];
}

#pragma mark - 网络请求
- (void)requestDataLoadNew:(BOOL)loadNew{
    YHRefreshType refreshType;
    if (loadNew) {
        _currentRequestPage = 1;
        refreshType = YHRefreshType_LoadNew;
//        [self.tableView setNoMoreData:NO];
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
 
    [_logic loadListDataWiththeme:self.topic.t_id];
}

-(void)requestZoneListDataCompleted
{
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
    
    self.dataArray = _logic.dataArray;
    if(_logic.noHasMore == YES)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    if (self.dataArray.count > 0) {
        [self hideNoContentView];
    }else{
        [self showNoContentView];
    }
    
    [BGMJRefreshManager endRefresh:self.tableView];
}

-(void)refreshHeader{
    [self requestDataLoadNew:YES];
}

-(void)refreshFooter{
    [self requestDataLoadNew:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_playerView destroyPlayer];
    _c_cell =nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MGGroupUserInfo *model  = self.dataArray[indexPath.row];

    //原创cell
    CellForWorkGroup *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CellForWorkGroup class])];
    if (!cell) {
        cell = [[CellForWorkGroup alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CellForWorkGroup class])];
    }
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
        
//        //转发cell
//        if (model.type == DynType_Forward) {
//            currentClass = [CellForWorkGroupRepost class];//第一版没有转发,因此这样稍该一下
//
//            height = [CellForWorkGroupRepost hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
//                CellForWorkGroupRepost *cell = (CellForWorkGroupRepost *)sourceCell;
//
//                cell.model = model;
//
//            }];
//
//        }
//        else{
        
        height = [CellForWorkGroup hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
            CellForWorkGroup *cell = (CellForWorkGroup *)sourceCell;
            
            cell.model = model;
            
        }];
        
        if (model.cover_url && ![model.cover_url isEqualToString:@""])
        {
//            height += 94;
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
//    self.hidesBottomBarWhenPushed = YES;
    
    MGGroupUserInfo *model = self.dataArray[indexPath.row];
    DetailsLineViewController *datails = [DetailsLineViewController new];
    datails.topic = 1;
    datails.title = ASLocalizedString(@"动态详情");
    datails.model = model;
    datails.refreshData = ^{
          _currentRequestPage = 1;
           
           self.logic.page = _currentRequestPage;
           
           [self.logic loadListDataWiththeme:self.topic.t_id];
       };
    [[AppDelegate sharedAppDelegate] pushViewController:datails animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [AppDelegate sharedAppDelegate].topViewController.hidesBottomBarWhenPushed = YES;
//    self.hidesBottomBarWhenPushed = YES;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(CellForWorkGroup *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MGGroupUserInfo *model  = self.dataArray[indexPath.row];
    
    if (model.cover_url && ![model.cover_url isEqualToString:@""]){
        //原创cell
        [self onTouchActionVideo:cell withFullScreen:NO];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([_c_cell isEqual:cell])
//    {
//        //区分是否是播放器所在的cell，销毁时将指针置空
//        [_playerView destroyPlayer];
//        _c_cell =nil;
//    }
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    if(self.timeLineDelegate && [self.timeLineDelegate respondsToSelector:@selector(protocolTimeLineDidScrollView:offset:)])
//    {
//        [self.timeLineDelegate protocolTimeLineDidScrollView:scrollView offset:scrollView.contentOffset.y];
//    }
//}


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
    datails.title = ASLocalizedString(@"评论");
    datails.topic = 1;
    datails.model = model;
    datails.refreshData = ^{
        _currentRequestPage = 1;
        
        self.logic.page = _currentRequestPage;
        
        [self.logic loadListDataWiththeme:self.topic.t_id];
    };
    [self.navigationController pushViewController:datails animated:YES];
    
//    self.hidesBottomBarWhenPushed = NO;
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
    
//    CLPlayerViewConfigure *config = [CLPlayerViewConfigure defaultConfigure];
//    config.mute = YES;
    _playerView.configure.mute = YES;
    _playerView.isFullScreen = fullScreen;
    _playerView.configure.mute = !fullScreen;
    _playerView.configure.isLandscape = YES;
    _playerView.configure.videoFillMode = VideoFillModeResizeAspectFill;
    
    [_playerView updateWithConfigure:^(CLPlayerViewConfigure *configure) {
        if (fullScreen) {
            _playerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
            [self.tabBarController.view addSubview:_playerView];
            UITapGestureRecognizer *tapPlayerView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPlayerView:)];
            [_playerView.maskView addGestureRecognizer:tapPlayerView];
        }else{
            [cell.ClVideoview addSubview:_playerView];
            UITapGestureRecognizer *tapPlayerView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBigScreen:)];
            [_playerView.maskView addGestureRecognizer:tapPlayerView];
        }
        _playerView.url = [NSURL URLWithString:cell.model.video];
        //播放
        [_playerView playVideo];
    }];
    
//    [cell.ClVideoview addSubview:_playerView];
//    _playerView.url =[NSURL URLWithString:cell.model.video];
//    //播放
//    [_playerView playVideo];
    
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(ASLocalizedString(@"返回按钮被点击"));
    }];
    
    //播放完成回调
    [_playerView endPlay:^{
        //销毁播放器
        [_playerView destroyPlayer];
        _playerView = nil;
        NSLog(ASLocalizedString(@"播放完成"));
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

- (void)onFollowInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        
        FWWeakify(self)

        [self.logic addFollowUID:cell.model.uid Success:^(NSDictionary * _Nonnull dic) {
            
            NSInteger _has_focus = [dic toInt:@"has_focus"];
            if (_has_focus == 1) {
                [FanweMessage alert:ASLocalizedString(@"关注成功")];

            }
            
          //刷新数据
            FWStrongify(self)
            _currentRequestPage = 1;
            
            self.logic.page = _currentRequestPage;
      
            [self.logic loadListDataWiththeme:self.topic.t_id];

            
        }];
    
       }
}

#pragma mark - private
- (void)_deleteDynAtIndexPath:(NSIndexPath *)indexPath dynamicId:(NSString *)dynamicId cell:(CellForWorkGroup *)cell{
    
    FWWeakify(self)
    
    __weak __typeof(self)weakSelf = self;
    [self.logic delZone:dynamicId Success:^{
        [FanweMessage alertHUD:ASLocalizedString(@"删除动态成功")];
//        [FanweMessage alert:ASLocalizedString(@"删除动态成功")];
//        [weakSelf.navigationController popViewControllerAnimated:YES];
        [self requestDataLoadNew:YES];
    }];

//    [FanweMessage alert:ASLocalizedString(@"提示")message:ASLocalizedString(@"确定删除该动态?")destructiveAction:^{
//        FWStrongify(self)
//        [self.logic loadListDataWiththeme:self.topic.t_id];
//        [FanweMessage alert:ASLocalizedString(@"删除动态成功")];
//    } cancelAction:^{
//
//    }];
}

- (void)_shareWithCell:(CellForWorkGroup *)cell{

    FWWeakify(self)
    [_logic dynamicForwardWithDynamic_id:cell.model.id Success:^{
        FWStrongify(self)

        cell.model.bottomViewSelect = YES;
        cell.bottomView.hidden = YES;
        [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"转发成功")];
        [self.logic loadListDataWiththeme:self.topic.t_id];
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - setter

-(UIButton *)releaseBtn{
    if (!_releaseBtn) {
        _releaseBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitle:ASLocalizedString(@"立即\n参与")forState:UIControlStateNormal];
            btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [btn addTarget:self action:@selector(releaseeButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"立即参与按钮"] forState:UIControlStateNormal];
            btn;
        });
        
    }
    
    return _releaseBtn;
}
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
@end
