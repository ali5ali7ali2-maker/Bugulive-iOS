//
//  YYWeiboFeedListController.m
//  YYKitExample
//
//  Created by ibireme on 15/9/4.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "WBStatusTimelineViewController.h"
#import "YYKit.h"
#import "WBModel.h"
#import "WBStatusLayout.h"
#import "WBStatusCell.h"
#import "YYPhotoGroupView.h"
//#import "YYFPSLabel.h"
#import <AVKit/AVKit.h>
//#import "BogoDynamicDetailViewController.h"
//#import "WBStatusComposeViewController.h"
//#import "UserPageViewController.h"
#import "WBUserInfoModel.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <AVFoundation/AVFoundation.h>
#import "WBStatusVideoControlView.h"

#import <AFSoundManager/AFSoundManager.h>

typedef void(^scrollViewDidScrollBlock)(UIScrollView *scrollView);

@interface WBStatusTimelineViewController () <UITableViewDelegate, UITableViewDataSource, WBStatusCellDelegate>
@property (nonatomic, strong) YYTableView *tableView;
@property (nonatomic, strong) NSMutableArray *layouts;
//@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) UIButton *releaseBtn;

@property(nonatomic, strong) QMUIPopupMenuView *popView;

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) WBStatusVideoControlView *controlView;
@property (nonatomic, strong) NSMutableArray *urls;

@property(nonatomic, copy) scrollViewDidScrollBlock scrollViewDidScrollBlock;

@property(nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) AFSoundPlayback *playback;
@property (nonatomic, strong) AFSoundQueue *queue;

@end

@implementation WBStatusTimelineViewController

- (instancetype)init {
    self = [super init];
    _tableView = [YYTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _layouts = [NSMutableArray new];
    _urls = [NSMutableArray array];
    _page = 1;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableView.frame = _tableViewFrame;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [_tableView registerClass:[WBStatusCell class] forCellReuseIdentifier:NSStringFromClass([WBStatusCell class])];
    __weak __typeof(self)weakSelf = self;
    _tableView.zf_scrollViewDidEndScrollingCallback = ^(NSIndexPath * _Nonnull indexPath) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf.player.playingIndexPath) {
//            [strongSelf playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }
    };
    [self.view addSubview:_tableView];
    self.view.backgroundColor = kWhiteColor;
    
//    _fpsLabel = [YYFPSLabel new];
//    [_fpsLabel sizeToFit];
//    _fpsLabel.bottom = _tableView.height - kWBCellPadding;
//    _fpsLabel.left = kWBCellPadding;
//    _fpsLabel.alpha = 0;
//    [self.view addSubview:_fpsLabel];
    
//    if ([_to_user_id isEqualToString:[IMAPlatform sharedInstance].host.userId]) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.releaseBtn];
//    }
    [self.tableView.mj_header beginRefreshing];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    //    KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
    //    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
    /// 0.8是消失80%时候，默认0.5
    self.player.playerDisapperaPercent = 0.8;
    /// 移动网络依然自动播放
    self.player.WWANAutoPlay = YES;
    
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player playTheIndexPath:self.player.playingIndexPath];
    };
    
    /// 停止的时候找出最合适的播放
    self.player.zf_scrollViewDidEndScrollingCallback = ^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        if (self.player.playingIndexPath) return;
        if (indexPath.row == self.layouts.count-1) {
            /// 加载下一页数据
            [self footerRefresh];
        }
        [self playTheVideoAtIndexPath:indexPath];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshParent:) name:@"refreshParentDynamic" object:nil];
}

- (void)refreshParent:(NSNotification *)noti{
    NSNumber *index = noti.object;
    if (index.integerValue == self.type) {
        [self headerRefresh];
    }
}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self.player playTheIndexPath:indexPath];
    [self.controlView resetControlView];
//    WBStatusLayout *data = self.layouts[indexPath.row];
//    [self.controlView showCoverViewWithUrl:data.status.cover_url withImageMode:UIViewContentModeScaleAspectFit];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isFront) {
        [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
//            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }];
    }
//    self.player.viewControllerDisappear = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.player stopCurrentPlayingCell];
//    self.player.viewControllerDisappear = YES;
}

- (void)releaseBtnAction{
//    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
//    vc.type = WBStatusComposeViewTypeStatus;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    nav.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tableView.frame = _tableViewFrame;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
    if (_queue.status == AFSoundStatusPlaying) {
        [_queue pause];
        _queue.status = AFSoundStatusPaused;
//        [cell.audioBtn.imgView stopAnimating];
    }
}

- (void)refreshData{
    [self.player stopCurrentPlayingCell];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshDataNew{
    [self.player stopCurrentPlayingCell];
    [self.layouts removeAllObjects];
    [self.tableView reloadData];
    [self headerRefresh];
}

- (void)headerRefresh{
    _page = 1;
    [self requestData];
}

-(void)headerRefreshToTop:(BOOL)toTop{
    _page = 1;
    if (toTop) {
        [self.tableView scrollToTop];
    }
    [self requestData];
}

- (void)footerRefresh{
    _page ++;
    [self requestData];
}

- (void)requestData{
    self.navigationController.view.userInteractionEnabled = NO;
//    http://videoline.2019.bogokj.com/mapi/public/index.php/api/bzone_api/get_list_3x
    NSString *action = @"";
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    paramDic = [NSMutableDictionary dictionaryWithDictionary:@{@"page":@(_page),@"to_user_id":_type == WBStatusTimelineViewControllerTypeUser ? _to_user_id : @"",@"topic":_topic.length ? _topic : @""}];
    
    switch (_type) {
        case WBStatusTimelineViewControllerTypeFriend:
            action = @"friends";
            break;
        case WBStatusTimelineViewControllerTypeUser:
            action = @"ou";
            break;
        case WBStatusTimelineViewControllerTypeFocus:
            action = @"att";
            break;
        case WBStatusTimelineViewControllerTypeNear:
            action = @"near";
            
//            if(StrValid(kAppDelegate.currentCity))
//            {
//                [paramDic setObject:SafeStr(kAppDelegate.strlatitude) forKey:@"lat"];
//                [paramDic setObject:SafeStr(kAppDelegate.strlongitude) forKey:@"lng"];
//            }
//            else
//            {
                [paramDic setObject:@"" forKey:@"lat"];
                [paramDic setObject:@"" forKey:@"lng"];
//            }
            break;
        default:
            break;
    }
    
    [paramDic setObject:action forKey:@"action"];
    
    [self.player stopCurrentPlayingCell];
//    [CYNET POSTDynamic:@"bzone_api" a:@"get_list_3x" parameters:paramDic success:^(id responseObject) {
//        if (_page == 1) {
//            [_layouts removeAllObjects];
//            [self.urls removeAllObjects];
//            self.player.assetURLs = nil;
//            [self.items removeAllObjects];
//            _queue = nil;
//        }
//        for (NSDictionary *dict in responseObject) {
//            WBModel *model = [WBModel mj_objectWithKeyValues:dict];
//            WBStatusLayout *layout = [[WBStatusLayout alloc] initWithStatus:model style:WBLayoutStyleTimeline];
//            if (layout) {
//                [_layouts addObject:layout];
//            }
//            NSURL *url = [NSURL URLWithString:model.video_url.length ? model.video_url : @""];
//            [self.urls addObject:url];
//            self.player.assetURLs = self.urls;
//
//            AFSoundItem *item = [[AFSoundItem alloc] initWithStreamingURL:[NSURL URLWithString:model.audio_file]];
//            [self.items addObject:item];
//        }
//
//        _queue = [[AFSoundQueue alloc] initWithItems:_items];
//
//        self.navigationController.view.userInteractionEnabled = YES;
//        [_tableView reloadData];
//        if ([(NSArray *)responseObject count]) {
//            [_tableView.mj_footer endRefreshing];
//        }else{
//            [_tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//        [_tableView.mj_header endRefreshing];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshParentEnd" object:nil];
//    } failure:^(NSString *error) {
//        [[HUDHelper sharedInstance] tipMessage:error];
//        [_tableView.mj_header endRefreshing];
//        [_tableView.mj_footer endRefreshing];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshParentEnd" object:nil];
//    }];
}
//
//#pragma mark - UIScrollViewDelegate 列表播放必须实现
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [scrollView zf_scrollViewDidEndDecelerating];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
//}
//
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
//    [scrollView zf_scrollViewDidScrollToTop];
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [scrollView zf_scrollViewDidScroll];
//    if (self.scrollViewDidScrollBlock) {
//        self.scrollViewDidScrollBlock(scrollView);
//    }
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [scrollView zf_scrollViewWillBeginDragging];
//}
//
//#pragma mark - UITableViewDelegate UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _layouts.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WBStatusCell class])];
//    cell.delegate = self;
//    cell.isShowMore = [self.title isEqualToString:NSLocalizedString(@"我的动态",nil)];
//    [cell setLayout:_layouts[indexPath.row]];
//    if(self.type==WBStatusTimelineViewControllerTypeUser){
//        cell.isfollow=YES;
//    }
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return ((WBStatusLayout *)_layouts[indexPath.row]).height;
//}
//
//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
////    WBStatusCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////    BogoDynamicDetailViewController *detailVC = [[BogoDynamicDetailViewController alloc]init];
////    detailVC.status = cell.statusView.layout.status;
////    [self.navigationController pushViewController:detailVC animated:YES];
//}
//
//#pragma mark - WBStatusCellDelegate
//// 此处应该用 Router 之类的东西。。。这里只是个Demo，直接全跳网页吧～
//
///// 点击了 Cell
//- (void)cellDidClick:(WBStatusCell *)cell {
////    BogoDynamicDetailViewController *detailVC = [[BogoDynamicDetailViewController alloc]init];
////    detailVC.status = cell.statusView.layout.status;
////    [self.navigationController pushViewController:detailVC animated:YES];
//}
//
///// 点击了 Card
//- (void)cellDidClickCard:(WBStatusCell *)cell {
////    WBPageInfo *pageInfo = cell.statusView.layout.status.pageInfo;
////    NSString *url = pageInfo.pageURL; // sinaweibo://... 会跳到 Weibo.app 的。。
////    RootWebViewController *vc = [[RootWebViewController alloc] initWithUrl:url];
////    vc.title = pageInfo.pageTitle;
////    [self.navigationController pushViewController:vc animated:YES];
//}
//
///// 点击了转发内容
//- (void)cellDidClickRetweet:(WBStatusCell *)cell {
//
//}
//
///// 点击了 Cell 菜单
//- (void)cellDidClickMenu:(WBStatusCell *)cell {
//
//}
//
///// 点击了下方 Tag
//- (void)cellDidClickTag:(WBStatusCell *)cell {
////    WBTag *tag = cell.statusView.layout.status.tagStruct.firstObject;
////    NSString *url = tag.tagScheme; // sinaweibo://... 会跳到 Weibo.app 的。。
////    RootWebViewController *vc = [[RootWebViewController alloc] initWithUrl:url];
////    vc.title = tag.tagName;
////    [self.navigationController pushViewController:vc animated:YES];
//}
//
///// 点击了关注
//- (void)cellDidClickFollow:(WBStatusCell *)cell {
//
//}
//
///// 点击了转发
//- (void)cellDidClickRepost:(WBStatusCell *)cell {
//
//}
//
//-(void)cell:(WBStatusCell *)cell didClickDeleteBtn:(UIButton *)sender{
//    __weak __typeof(self)weakSelf = self;
//
//
//    BogoLiveAlertView *alert = [[BogoLiveAlertView alloc]initWithTitle:@"提示" message:@"是否删除此条动态？"];
//    [alert addAction:[BogoLiveAlertAction actionWithTitle:@"取消" type:BogoLiveAlertActionTypeCancel CallBack:nil]];
//    [alert addAction:[BogoLiveAlertAction actionWithTitle:@"确定" type:BogoLiveAlertActionTypeDefault CallBack:^{
//        [CYNET POSTDynamic:@"bzone_api" a:@"del_dynamic" parameters:@{@"zone_id":cell.layout.status.id} success:^(id responseObject) {
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//
//            if ([[responseObject valueForKey:@"code"] integerValue] == 1) {
//                [MBProgressHUD showInfoMessage:@"删除成功"];
//                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//                [self.layouts removeObject:cell.statusView.layout];
//                [self.tableView deleteRow:indexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
//            }
//
//            [strongSelf.tableView reloadData];
//
//        } failure:^(NSString *error) {
//            [[HUDHelper sharedInstance] tipMessage:error];
//        }];
//    }]];
//
//    [alert show:[AppDelegate shareAppDelegate].window];
//
//}
//
//
///// 点击了评论
//- (void)cellDidClickComment:(WBStatusCell *)cell {
////    BogoDynamicDetailViewController *detailVC = [[BogoDynamicDetailViewController alloc]init];
////    detailVC.status = cell.statusView.layout.status;
////    [self.navigationController pushViewController:detailVC animated:YES];
//}
//
///// 点击了赞
//- (void)cellDidClickLike:(WBStatusCell *)cell {
//    WBModel *status = cell.statusView.layout.status;
//
////    http://test0813.anbig.com/mapi/public/index.php/api/bzone_api/request_like
//    [CYNET POSTDynamic:@"bzone_api" a:@"request_like" parameters:@{@"zone_id":cell.statusView.layout.status.id} success:^(id responseObject) {
//
//        [cell.statusView.toolbarView setLiked:!status.is_like.intValue withAnimation:YES];
//
//        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:cell.statusView.layout.status.like_list];
//
//        if (status.is_like.intValue) {
//            //点赞加一
//            WBLikeListModel *model = [[WBLikeListModel alloc]init];
//            model.avatar = curUser.avatar;
//            model.id = [IMAPlatform sharedInstance].host.userId;
//            [tempArray addObject:model];
//        }else{
//            //取消点赞减一
//            NSInteger index = -1;
//            for (NSInteger i = 0; i < tempArray.count ; i++) {
//                WBLikeListModel *model = tempArray[i];
//                if ([model.id isEqualToString:[IMAPlatform sharedInstance].host.userId]) {
//                    index = i;
//                    continue;
//                }
//            }
//            if (index != -1) {
//                [tempArray removeObjectAtIndex:index];
//            }
//        }
//        cell.statusView.layout.status.like_list = tempArray;
////        [self.tableView reloadRowAtIndexPath:[self.tableView indexPathForCell:cell] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView reloadData];
//
//
//    } failure:^(NSString *error) {
//        [[HUDHelper sharedInstance] tipMessage:error];
//    }];
//}
//
///// 点击了用户
- (void)cell:(WBStatusCell *)cell didClickUser:(WBModel *)user {
//    BogoVoiceUserPageViewController *pageVC = [[BogoVoiceUserPageViewController alloc]init];
//    pageVC.uid = user.id;
//    pageVC.type = BogoVoiceUserPageViewControllerTypeDynamicP;
//    pageVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:pageVC animated:YES];
}
//
///// 点击了图片
//- (void)cell:(WBStatusCell *)cell didClickImageAtIndex:(NSUInteger)index {
//    UIView *fromView = nil;
//    NSMutableArray *items = [NSMutableArray new];
//    WBModel *status = cell.statusView.layout.status;
//    NSArray<NSString *> *pics = status.thumbnailPicUrls;
//    NSArray<NSString *> *originPics = status.thumbnailPicUrls;
//
//    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
//        UIView *imgView = cell.statusView.picViews[i];
//        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
//        item.thumbView = imgView;
//        item.largeImageURL = [NSURL URLWithString:originPics[i]];
//        item.largeImageSize = CGSizeMake(kScreenW, KScreenHeight);
//        [items addObject:item];
//        if (i == index) {
//            fromView = imgView;
//        }
//    }
//
////    UIImageView *tempImageView = [[UIImageView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
////    [tempImageView sd_setImageWithURL:[NSURL URLWithString:pics[0]]];
////    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
//
//    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
//    [v presentFromImageView:fromView toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
//}
//
///// 点击了 Label 的链接
//- (void)cell:(WBStatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
//    NSAttributedString *text = label.textLayout.text;
//    if (textRange.location >= text.length) return;
//    YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
//    NSDictionary *info = highlight.userInfo;
//    if (info.count == 0) return;
//
//    if (info[kWBLinkTopicName]) {
//        NSString *topic = info[kWBLinkTopicName];
//        if (topic.length) {
//            //话题
//            WBStatusTimelineViewController *statusVC = [[WBStatusTimelineViewController alloc]init];
//            statusVC.hidesBottomBarWhenPushed = YES;
//            statusVC.title = topic;
//            statusVC.topic = topic;
//            statusVC.type = WBStatusTimelineViewControllerTypeTopic;
//            statusVC.tableViewFrame = CGRectMake(0, 0, kScreenW, KScreenHeight - kTopHeight - kTabBarHeight1);
//            [self.navigationController pushViewController:statusVC animated:YES];
//        }
//        return;
//    }
//}
//
//- (void)cell:(WBStatusCell *)cell didClickTopic:(NSString *)topic{
//    //话题
//    WBStatusTimelineViewController *statusVC = [[WBStatusTimelineViewController alloc]init];
//    statusVC.hidesBottomBarWhenPushed = YES;
//    statusVC.title = topic;
//    statusVC.topic = topic;
//    statusVC.type = WBStatusTimelineViewControllerTypeTopic;
//    statusVC.tableViewFrame = CGRectMake(0, 0, kScreenW, KScreenHeight - kTopHeight - kTabBarHeight1);
//    [self.navigationController pushViewController:statusVC animated:YES];
//}
//
//- (void)cell:(WBStatusCell *)cell didClickVideo:(NSString *)url{
//    /// 如果正在播放的index和当前点击的index不同，则停止当前播放的index
//    if (self.player.playingIndexPath != [self.tableView indexPathForCell:cell]) {
//        [self.player stopCurrentPlayingCell];
//    }
//    AVPlayer *player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:url]];
//    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
//    playerVC.player = player;
//    [playerVC.player play];
//    [self presentViewController:playerVC animated:YES completion:nil];
//}
//
//- (void)cell:(WBStatusCell *)cell didClickMore:(UIButton *)sender{
//
//    NSString *url = [[CYURLUtils sharedCYURLUtils] makeURLWithC:@"personal_api" A:@"click_attention"];
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:cell.layout.status.userInfo.id forKey:@"id"];
//    [CYNET POST:url parameters:param responseCache:^(id responseObject) {
//
//    } success:^(id responseObject) {
//        if ([[responseObject valueForKey:@"code"]integerValue] == 1) {
////            sender.hidden = YES;
//
//            for (int i = 0; i < _layouts.count; i ++) {
//                WBStatusLayout *layout = _layouts[i];
//                if ([layout.status.userInfo.id isEqualToString:cell.layout.status.userInfo.id]) {
//                    layout.status.is_focus = @"1";
//                    [_layouts replaceObjectAtIndex:i withObject:layout];
//                }
//            }
//            [self.tableView reloadData];
//        }
//    } failure:^(NSString *error) {
//
//    } hasCache:NO];
//
//
//}
//
//- (void)cell:(WBStatusView *)cell didClickAudio:(UIButton *)sender{
//    NSInteger index = [self.layouts indexOfObject:cell.layout];
//    AFSoundItem *item = [self.items objectAtIndex:index];
//    NSLog(@"_queue.status:%ld",_queue.status);
//    if (item == [_queue getCurrentItem]) {
//        //是原来的item
//        if (_queue.status == AFSoundStatusPlaying) {
//            [_queue pause];
//            _queue.status = AFSoundStatusPaused;
//            [cell.audioBtn.imgView stopAnimating];
//        }else if (_queue.status == AFSoundStatusPaused){
//            [cell.audioBtn.imgView startAnimating];
//            [_queue playCurrentItem];
//            _queue.status = AFSoundStatusPlaying;
//        }else{
//            [cell.audioBtn.imgView startAnimating];
//            [_queue playItem:item];
//            _queue.status = AFSoundStatusPlaying;
//        }
//        [_queue listenFeedbackUpdatesWithBlock:nil andFinishedBlock:^(AFSoundItem *nextItem) {
//            [cell.audioBtn.imgView stopAnimating];
//            _queue.status = AFSoundStatusFinished;
//        }];
//    }else{
//        NSInteger currentIndex = [self.items indexOfObject:[_queue getCurrentItem]];
//        WBStatusCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
//        [currentCell.statusView.audioBtn.imgView stopAnimating];
//        //播放的不是之前的那首
//        [_queue playItem:(AFSoundItem *)_items[index]];
//        _queue.status = AFSoundStatusPlaying;
//        [cell.audioBtn.imgView startAnimating];
//        [_queue listenFeedbackUpdatesWithBlock:nil andFinishedBlock:^(AFSoundItem *nextItem) {
//            [cell.audioBtn.imgView stopAnimating];
//        }];
//    }
//}
//
//#pragma mark - private method
//
///// play the video
//- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
//    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
//    [self.controlView showTitle:@""
//    coverURLString:@""
//    fullScreenMode:ZFFullScreenModePortrait];
//}
//
//#pragma mark - Lazy Load
//- (UIButton *)releaseBtn{
//    if (!_releaseBtn) {
//        _releaseBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 44, kStatusBarHeight, 44, 44)];
//        [_releaseBtn setImage:[UIImage imageNamed:@"发布_icon"] forState:UIControlStateNormal];
//        [_releaseBtn addTarget:self action:@selector(releaseBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _releaseBtn;
//}
//
//- (UIImage *)xy_noDataViewImage {
//    if (self.tableView.height) {
//        return [UIImage imageNamed:@"暂无数据_New"];
//    }
//    return nil;
//}
//
//- (NSString *)xy_noDataViewMessage {
//    if (self.tableView.height) {
//        return NSLocalizedString(@"亲，暂时没有任何内容哦~",nil);
//    }
//    return @"";
//}
//
//- (QMUIPopupMenuView *)popViewWithCell:(WBStatusCell *)cell{
//    if (!_popView) {
//        // 使用方法 2，以 UIWindow 的形式显示到界面上，这种无需默认隐藏，也无需 add 到某个 UIView 上
//        _popView = [[QMUIPopupMenuView alloc] init];
//        _popView.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
//        _popView.maskViewBackgroundColor = [kBlackColor colorWithAlphaComponent:0.3];// 使用方法 2 并且打开了 automaticallyHidesWhenUserTap 的情况下，可以修改背景遮罩的颜色
//        _popView.shouldShowItemSeparator = YES;
//        _popView.itemTitleColor = [UIColor colorWithHexString:@"333333"];
//        _popView.itemSeparatorColor = [UIColor colorWithHexString:@"F2F2F2"];
//        _popView.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
//            // 利用 itemConfigurationHandler 批量设置所有 item 的样式
//
//        };
//        __weak __typeof(self)weakSelf = self;
//        _popView.items = @[[QMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_component") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:NSLocalizedString(@"删除",nil) handler:^(QMUIPopupMenuButtonItem *aItem) {
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            [aItem.menuView hideWithAnimated:YES];
////            http://test0813.anbig.com/mapi/public/index.php/api/bzone_api/del_dynamic
//            [CYNET POSTDynamic:@"bzone_api" a:@"del_dynamic" parameters:@{@"zone_id":cell.statusView.layout.status.id} success:^(id responseObject) {
//                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//                [self.layouts removeObject:cell.statusView.layout];
//                [self.tableView deleteRow:indexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
//            } failure:^(NSString *error) {
//                [[HUDHelper sharedInstance] tipMessage:error];
//            }];
//        }]];
//        _popView.didHideBlock = ^(BOOL hidesByUserTap) {
//
//        };
//    }
//    return _popView;
//}
//
//- (WBStatusVideoControlView *)controlView {
//    if (!_controlView) {
//        _controlView = [WBStatusVideoControlView new];
//        _controlView.fastViewAnimated = YES;
//        _controlView.horizontalPanShowControlView = NO;
//        _controlView.prepareShowLoading = YES;
//    }
//    return _controlView;
//}
//
//#pragma mark - JXPagingViewListViewDelegate
//- (UIView *)listView{
//    return  self.view;
//}
//
//- (UIScrollView *)listScrollView{
//    return self.tableView;
//}
//
//- (void)listViewDidScrollCallbackWithCallback:(void (^)(UIScrollView * _Nonnull))callback{
//    self.scrollViewDidScrollBlock = callback;
//}
//
//- (NSMutableArray *)items{
//    if (!_items) {
//        _items = [NSMutableArray array];
//    }
//    return _items;
//}

@end
