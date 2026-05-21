//
//  HMVideoView.m
//  BuguLive
//
//  Created by 范东 on 2018/12/27.
//  Copyright © 2018 xfg. All rights reserved.
//

#import "HMVideoView.h"
#import "HMVideoPlayer.h"
#import "HMCommentView.h"
#import "HMShareView.h"
#import "BGReportController.h"
#import "FDUIKitObjC.h"
#import "GiftView.h"
#import "RechargeView.h"
#import <LCActionSheet.h>
#import "SVGAAnimationView.h"
#import "BGVideoGiftAnimationView.h"
#import "GifImageView.h"
#import "MPersonCenterVC.h"
#import "SSearchVC.h"
#import <TXLiteAVSDK_Professional/TXVodPlayer.h>
#import "HMVideoPlayerViewController.h"

@interface HMVideoView ()<UIScrollViewDelegate, HMVideoPlayerDelegate, HMVideoControlViewDelegate,HMShareViewDelegate,GiftViewDelegate,SVGAAnimationViewDelegate,BGVideoGiftAnimationViewDelegate,GifImageViewDelegate>

// 创建三个控制视图，用于滑动切换
@property (nonatomic, strong) HMVideoControlView      *topView;          // 顶部视图
@property (nonatomic, strong) HMVideoControlView      *middleView;     // 中间视图
@property (nonatomic, strong) HMVideoControlView      *bottomView;    // 底部视图

// 控制播放的索引，不完全等于当前播放内容的索引
@property (nonatomic, assign) NSInteger                 index;
// 当前播放内容是索引
@property (nonatomic, assign) NSInteger                 currentPlayIndex;
@property (nonatomic, weak) UIViewController         *vc;
@property (nonatomic, assign) BOOL                      isPushed;
@property (nonatomic, strong) NSMutableArray        *videos;
// 记录播放内容
@property (nonatomic, copy) NSString                    *currentPlayId;
// 记录滑动前的播放状态
@property (nonatomic, assign) BOOL                      isPlaying_beforeScroll;
@property (nonatomic, assign) BOOL                      isRefreshMore;
@property (nonatomic, strong) NSMutableDictionary *shareDict;

@property (nonatomic, strong) HMShareView *shareView;

@property (nonatomic, assign) NSInteger                 currentDiamonds;        // 当前账户钻石数量
@property(nonatomic, assign) CGFloat giftViewHeight;   // GiftView的高度

@property (nonatomic, strong) NSDictionary *dict;

@property(nonatomic, strong) SmallVideoListModel *currentModel;

@property(nonatomic, strong) RechargeView *rechargeView;

@property(nonatomic, strong) NSMutableArray *animationArray;
@property(nonatomic, assign) BOOL isAnimated;
@property(nonatomic, assign) BOOL isBigAnimated;
@property(nonatomic, strong) SVGAAnimationView *animationView;

//
@property(nonatomic, strong) BGVideoGiftAnimationView *tipAnimationView;
@property(nonatomic, strong) NSMutableArray *tipAnimationArray;
//@property(nonatomic, assign) BOOL isTipAnimated;

//
@property(nonatomic, strong) GifImageView *gifImageView;
//@property(nonatomic, strong) NSMutableArray *gifImageViewArray;
//@property(nonatomic, assign) BOOL isGifAnimated;

//我的按钮、搜索按钮
@property(nonatomic, strong) UIButton *mineBtn;
@property(nonatomic, strong) UIButton *searchBtn;


@end

@implementation HMVideoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithVC:(UIViewController *)vc isPushed:(BOOL)isPushed requestDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.vc = vc;
        self.isPushed = isPushed;
        self.dict = dict;
        self.backgroundColor = kClearColor;
        
        self.shareDict = [NSMutableDictionary dictionary];
        
        [self addSubview:self.scrollView];
        [self loadGiftView:[GiftListManager sharedInstance].giftMArray];
        
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.animationView];
        
        [self performBlock:^(id selfPtr) {
            self.tipAnimationView.frame = CGRectMake(kScreenW, kScreenH / 4, 186, 38);
        } afterDelay:0.25];
        
//        self.topView.commentButton.hidden = !isPushed;
//        self.middleView.commentButton.hidden = !isPushed;
//        self.bottomView.commentButton.hidden = !isPushed;
        
        
        
    }
    return self;
}

- (void)setIsRecommend:(BOOL)isRecommend{
    _isRecommend = isRecommend;
    //不是Push来的就添加下拉刷新
    if (!self.isPushed) {
        __weak __typeof(self)weakSelf = self;
        [self.viewModel refreshNewListWithSuccess:^(NSArray * _Nonnull list) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf setModels:list index:0];
            
            if (strongSelf.isRefreshVideoBlock) {
                strongSelf.isRefreshVideoBlock(YES);
            }
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        } WithRequestDict:self.dict];
        
        // 上下拉刷新
        MJRefreshGifHeader *header;
        header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.videos removeAllObjects];
            __weak __typeof(self)weakSelf2 = strongSelf;
            [strongSelf.viewModel refreshNewListWithSuccess:^(NSArray * _Nonnull list) {
                __strong __typeof(weakSelf)strongSelf2 = weakSelf2;
                [strongSelf2 setModels:list index:0];
                [strongSelf2.scrollView.mj_header endRefreshing];
                if (list.count < 20) {
                    [strongSelf2.scrollView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [strongSelf2.scrollView.mj_footer endRefreshing];
                }
                
                
                
            } failure:^(NSError * _Nonnull error) {
                __strong __typeof(weakSelf)strongSelf2 = weakSelf2;
                NSLog(@"%@", error);
                [strongSelf2.scrollView.mj_header endRefreshing];
                [strongSelf2.scrollView.mj_footer endRefreshingWithNoMoreData];
            } WithRequestDict:self.dict];
        }];
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        // 隐藏状态
        header.stateLabel.hidden = YES;
        
        NSMutableArray *pullingImages = [NSMutableArray array];
        
        UIImage *image = [UIImage imageNamed:@"refresh_header_start"];
        [pullingImages addObject:image];
        
        UIImage *image2 = [UIImage imageNamed:@"refresh_header_start"];
        [pullingImages addObject:image2];
        
        NSArray *arrimg = [NSArray arrayWithObject:[pullingImages firstObject]];
        [header setImages:arrimg  forState:MJRefreshStateIdle];
        
        NSArray *arrimg2 = [NSArray arrayWithObject:[pullingImages lastObject]];
        [header setImages:arrimg2  forState:MJRefreshStatePulling];
        
        NSMutableArray *progressImage = [NSMutableArray array];
        for (NSUInteger i = 1; i <= kRefreshImgCount; i++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_header_%ld", i]];
            if (image)
            {
                [progressImage addObject:image];
            }
        }
        [header setImages:progressImage duration:0.04*progressImage.count forState:MJRefreshStateRefreshing];
        self.scrollView.mj_header = header;
    }
    self.scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.player pausePlay];
        // 当播放索引为最后一个时才会触发下拉刷新
        self.currentPlayIndex = self.videos.count - 1;
        
        [self.viewModel refreshMoreListWithSuccess:^(NSArray * _Nonnull list) {
            self.isRefreshMore = NO;
            if (list) {
                // 处理数据不准问题
                [self addModels:list index:self.currentPlayIndex];
                [self.scrollView.mj_footer endRefreshing];
                if (list.count < 20) {
                    [self.scrollView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.scrollView.mj_footer endRefreshing];
                }
            }else {
                [self.scrollView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            self.isRefreshMore = NO;
            [self.scrollView.mj_footer endRefreshingWithNoMoreData];
        } WithRequestDict:self.dict];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat controlW = CGRectGetWidth(self.scrollView.frame);
    CGFloat controlH = CGRectGetHeight(self.scrollView.frame);
    
    self.topView.frame   = CGRectMake(0, 0, controlW, controlH);
    self.middleView.frame   = CGRectMake(0, controlH, controlW, controlH);
    self.bottomView.frame   = CGRectMake(0, 2 * controlH, controlW, controlH);
}

#pragma mark - Public Methods
- (void)setModels:(NSArray *)models index:(NSInteger)index {
    if (models.count < 20) {
        [self.scrollView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.videos removeAllObjects];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in models)
    {
        SmallVideoListModel *model = [SmallVideoListModel mj_objectWithKeyValues:dict];
        [tempArray addObject:model];
    }
    
    [self.videos addObjectsFromArray:tempArray];
    
    self.index = index;
    self.currentPlayIndex = index;
    
    if (models.count == 0) return;
    self.currentModel = [models objectAtIndex:index];
    
    if (models.count == 1) {
        [self.middleView removeFromSuperview];
        [self.bottomView removeFromSuperview];
        
        self.scrollView.contentSize = CGSizeMake(0, kScreenH);
        
        self.topView.model = self.videos.firstObject;
        
        [self playVideoFrom:self.topView];
    }else if (models.count == 2) {
        [self.bottomView removeFromSuperview];
        
        self.scrollView.contentSize = CGSizeMake(0, kScreenH * 2);
        
        self.topView.model = self.videos.firstObject;
        self.middleView.model = self.videos.lastObject;
        
        if (index == 1) {
            self.scrollView.contentOffset = CGPointMake(0, kScreenH);
            
            [self playVideoFrom:self.middleView];
        }else {
            [self playVideoFrom:self.topView];
        }
    }else {
        if (index == 0) {   // 如果是第一个，则显示上视图，且预加载中下视图
            self.topView.model = self.videos[index];
            self.middleView.model = self.videos[index + 1];
            self.bottomView.model = self.videos[index + 2];
            
            // 播放第一个
            [self playVideoFrom:self.topView];
        }else if (index == models.count - 1) { // 如果是最后一个，则显示最后视图，且预加载前两个
            self.bottomView.model = self.videos[index];
            self.middleView.model = self.videos[index - 1];
            self.topView.model = self.videos[index - 2];
            
            // 显示最后一个
            self.scrollView.contentOffset = CGPointMake(0, kScreenH * 2);
            // 播放最后一个
            [self playVideoFrom:self.bottomView];
        }else { // 显示中间，播放中间，预加载上下
            self.middleView.model = self.videos[index];
            self.topView.model = self.videos[index - 1];
            self.bottomView.model = self.videos[index + 1];
            
            // 显示中间
            self.scrollView.contentOffset = CGPointMake(0, kScreenH);
            // 播放中间
            [self playVideoFrom:self.middleView];
        }
    }
}

// 添加播放数据后，重置index，防止出现错位的情况
- (void)addModels:(NSArray *)models index:(NSInteger)index {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in models)
    {
        SmallVideoListModel *model = [SmallVideoListModel mj_objectWithKeyValues:dict];
        [tempArray addObject:model];
    }
    
    [self.videos addObjectsFromArray:tempArray];
    
    self.index = index;
    self.currentPlayIndex = index;
    
    if (self.videos.count == 0) return;
    
    if (self.videos.count == 1) {
        [self.middleView removeFromSuperview];
        [self.bottomView removeFromSuperview];
        
        self.scrollView.contentSize = CGSizeMake(0, kScreenH);
        
        self.topView.model = self.videos.firstObject;
        
        [self playVideoFrom:self.topView];
    }else if (self.videos.count == 2) {
        [self.bottomView removeFromSuperview];
        
        self.scrollView.contentSize = CGSizeMake(0, kScreenH * 2);
        
        self.topView.model = self.videos.firstObject;
        self.middleView.model = self.videos.lastObject;
        
        if (index == 1) {
            self.scrollView.contentOffset = CGPointMake(0, kScreenH);
            
            [self playVideoFrom:self.middleView];
        }else {
            [self playVideoFrom:self.topView];
        }
    }else {
        if (index == 0) {   // 如果是第一个，则显示上视图，且预加载中下视图
            self.topView.model = self.videos[index];
            self.middleView.model = self.videos[index + 1];
            self.bottomView.model = self.videos[index + 2];
            
            // 播放第一个
            [self playVideoFrom:self.topView];
        }else if (index == self.videos.count - 1) { // 如果是最后一个，则显示最后视图，且预加载前两个
            self.bottomView.model = self.videos[index];
            self.middleView.model = self.videos[index - 1];
            self.topView.model = self.videos[index - 2];
            
            // 显示最后一个
            self.scrollView.contentOffset = CGPointMake(0, kScreenH * 2);
            // 播放最后一个
            [self playVideoFrom:self.bottomView];
        }else { // 显示中间，播放中间，预加载上下
            self.middleView.model = self.videos[index];
            self.topView.model = self.videos[index - 1];
            self.bottomView.model = self.videos[index + 1];
            
            // 显示中间
            self.scrollView.contentOffset = CGPointMake(0, kScreenH);
            // 播放中间
            [self playVideoFrom:self.middleView];
        }
    }
}

- (void)pause {
    if (self.player.isPlaying) {
        self.isPlaying_beforeScroll = YES;
    }else {
        self.isPlaying_beforeScroll = NO;
    }
    
    [self.player pausePlay];
}

- (void)resume {
    if (self.isPlaying_beforeScroll) {
        [self.player resumePlay];
    }
}

- (void)destoryPlayer {
    self.scrollView.delegate = nil;
    [self.player removeVideo];
    [self hiddenGiftView];
}

#pragma mark - Private Methods
- (void)playVideoFrom:(HMVideoControlView *)fromView {
    
    [fromView loadNetDataWithPage:1];
    
    // 移除原来的播放
    [self.player removeVideo];
    [self.commentView.dataArray removeAllObjects];
    [self.commentView.tableView reloadData];
    
    // 取消原来视图的代理
    self.currentPlayView.delegate = nil;
    
    // 切换播放视图
    self.currentPlayId    = fromView.model.video_url;
    self.currentPlayView  = fromView;
    self.currentPlayIndex = [self indexOfModel:fromView.model];
    // 设置新视图的代理
    self.currentPlayView.delegate = self;
    self.commentView.model = self.currentPlayView.model;
    
    // 重新播放
    FWWeakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FWStrongify(self)
        if (fromView.model.video_direction.integerValue == 1) {
            //横屏
            [self.player.player setRenderMode:RENDER_MODE_FILL_EDGE];
        }else{
            //竖屏
            [self.player.player setRenderMode:RENDER_MODE_FILL_SCREEN];
        }
        [self.player playVideoWithView:fromView.coverImgView url:fromView.model.video_url];
    });
}

// 获取当前播放内容的索引
- (NSInteger)indexOfModel:(SmallVideoListModel *)model {
    __block NSInteger index = 0;
    [self.videos enumerateObjectsUsingBlock:^(SmallVideoListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.video_url isEqualToString:obj.video_url]) {
            index = idx;
        }
    }];
    return index;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //通知主页面不进行滑动
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HMHomeDoNotScroll" object:nil];
    
    if (self.giftView.hidden == NO) {
        self.scrollView.scrollEnabled = NO;
        return;
    }
    
    
    
    // 小于等于三个，不用处理
    if (self.videos.count <= 3) return;
    
    // 上滑到第一个
    if (self.index == 0 && scrollView.contentOffset.y <= kScreenH) {
        return;
    }
    // 下滑到最后一个
    if (self.index == self.videos.count - 1 && scrollView.contentOffset.y > kScreenH) {
        return;
    }
    
    // 判断是从中间视图上滑还是下滑
    if (scrollView.contentOffset.y >= 2 * kScreenH) {  // 上滑
        [self.player removeVideo];  // 在这里移除播放，解决闪动的bug
        if (self.index == 0) {
            self.index += 2;
            
            scrollView.contentOffset = CGPointMake(0, kScreenH);
            
            self.topView.model = self.middleView.model;
            self.middleView.model = self.bottomView.model;
            
        }else {
            self.index += 1;
            
            if (self.index == self.videos.count - 1) {
                self.middleView.model = self.videos[self.index - 1];
            }else {
                scrollView.contentOffset = CGPointMake(0, kScreenH);
                
                self.topView.model = self.middleView.model;
                self.middleView.model = self.bottomView.model;
            }
        }
        if (self.index < self.videos.count - 1) {
            self.bottomView.model = self.videos[self.index + 1];
        }
    }else if (scrollView.contentOffset.y <= 0) { // 下滑
        [self.player removeVideo];  // 在这里移除播放，解决闪动的bug
        if (self.index == 1) {
            self.topView.model = self.videos[self.index - 1];
            self.middleView.model = self.videos[self.index];
            self.bottomView.model = self.videos[self.index + 1];
            self.index -= 1;
        }else {
            if (self.index == self.videos.count - 1) {
                self.index -= 2;
            }else {
                self.index -= 1;
            }
            scrollView.contentOffset = CGPointMake(0, kScreenH);
            
            self.bottomView.model = self.middleView.model;
            self.middleView.model = self.topView.model;
            
            if (self.index > 0) {
                self.topView.model = self.videos[self.index - 1];
            }
        }
    }
    
    if (self.isPushed) return;
    
    // 自动刷新，如果想要去掉自动刷新功能，去掉下面代码即可
    if (scrollView.contentOffset.y == kScreenH) {
        if (self.isRefreshMore) return;
        
        // 播放到倒数第二个时，请求更多内容
        if (self.currentPlayIndex == self.videos.count - 2) {
            self.isRefreshMore = YES;
            [self refreshMore];
        }
    }
    
    if (self.isRefreshMore) return;
    
    if (scrollView.contentOffset.y == 2 * kScreenH) {
        [self refreshMore];
    }
}

// 结束滚动后开始播放
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == 0) {
        if ([self.currentPlayId isEqualToString:self.topView.model.video_url]) return;
        [self playVideoFrom:self.topView];
        self.currentModel = self.topView.model;
    }else if (scrollView.contentOffset.y == kScreenH) {
        if ([self.currentPlayId isEqualToString:self.middleView.model.video_url]) return;
        [self playVideoFrom:self.middleView];
        self.currentModel = self.middleView.model;
    }else if (scrollView.contentOffset.y == 2 * (kScreenH)) {
        if ([self.currentPlayId isEqualToString:self.bottomView.model.video_url]) return;
        [self playVideoFrom:self.bottomView];
        self.currentModel = self.bottomView.model;
    }
}

- (void)refreshMore {
    [self.viewModel refreshMoreListWithSuccess:^(NSArray * _Nonnull list) {
        self.isRefreshMore = NO;
        if (list) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dict in list)
            {
                SmallVideoListModel *model = [SmallVideoListModel mj_objectWithKeyValues:dict];
                [tempArray addObject:model];
            }
            [self.videos addObjectsFromArray:tempArray];
            
            if (list.count < 20) {
                [self.scrollView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.scrollView.mj_footer endRefreshing];
            }
        }else {
            [self.scrollView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        self.isRefreshMore = NO;
        [self.scrollView.mj_footer endRefreshingWithNoMoreData];
    } WithRequestDict:self.dict];
}

#pragma mark - HMVideoPlayerDelegate
- (void)player:(HMVideoPlayer *)player statusChanged:(HMVideoPlayerStatus)status {
    switch (status) {
        case HMVideoPlayerStatusUnload:   // 未加载
            
            break;
        case HMVideoPlayerStatusPrepared:   // 准备播放
            
            break;
        case HMVideoPlayerStatusLoading: {     // 加载中
            [self.currentPlayView startLoading];
            [self.currentPlayView hidePlayBtn];
        }
            break;
        case HMVideoPlayerStatusPlaying: {    // 播放中
            [self.currentPlayView stopLoading];
            [self.currentPlayView hidePlayBtn];
        }
            break;
        case HMVideoPlayerStatusPaused: {     // 暂停
            [self.currentPlayView stopLoading];
            [self.currentPlayView showPlayBtn];
        }
            break;
        case HMVideoPlayerStatusEnded: {   // 播放结束
            // 重新开始播放
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                HMVideoPlayerViewController *newVC = (HMVideoPlayerViewController *)self.vc;
                if (newVC.isViewAppear) {
                    [self.player resetPlay];
                }else{
                    [self.player pausePlay];
                }
            });
        }
            break;
        case HMVideoPlayerStatusError:   // 错误
            
            break;
        default:
            break;
    }
}

#pragma mark - HMVideoPlayerDelegate
- (void)player:(HMVideoPlayer *)player currentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.currentPlayView setProgress:progress];
    });
}

#pragma mark - HMVideoControlViewDelegate
- (void)controlViewDidClickSelf:(HMVideoControlView *)controlView {
    
    
    self.scrollView.scrollEnabled = YES;
    
    if (self.giftView.hidden) {
        if (self.player.isPlaying) {
            [self.player pausePlay];
        }else {
            [self.player resumePlay];
        }
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewDidClickSelf:)]) {
        [self.delegate controlViewDidClickSelf:self];
    }
    
//    if (!self.giftView.hidden) {
//        [self hiddenGiftView];
//        return;
//    }
    
    
}

- (void)controlViewDidClickIcon:(HMVideoControlView *)controlView {
    
    if (![IMAPlatform isAutoLogin]) {
        [[AppDelegate sharedAppDelegate] enterLoginUI];
        return;
    }
    NSString *userId = controlView.model.user_id;
    
    if (self.clickHeadBlock) {
        self.clickHeadBlock(userId);
    }
    

}

-(void)controlViewDidClickMoreBtn:(HMVideoControlView *)controlView{
    if (![IMAPlatform isAutoLogin]) {
        [[AppDelegate sharedAppDelegate] enterLoginUI];
        return;
    }
    if (![controlView.model.user_id isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoViewDidClickReport:)]) {
            [self.delegate videoViewDidClickReport:self];
        }
    }else{
        [self deleteTap];
    }
    
//    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:ASLocalizedString(@"选择")cancelButtonTitle:ASLocalizedString(@"取消")clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
//        if (buttonIndex == 1) {
//            [self deleteTap];
//        }
//    } otherButtonTitles:ASLocalizedString(@"删除动态"), nil];
//
//    [sheet show];
}

- (void)deleteTap{
    [FanweMessage alert:ASLocalizedString(@"提示")message:ASLocalizedString(@"是否删除此条视频")destructiveAction:^{
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:@"del_weibo" forKey:@"act"];
            [dict setValue:@"publish" forKey:@"ctl"];
        NSString *weibo_id = @"";
        if ([self.currentModel isKindOfClass:[NSDictionary class]]) {
            NSDictionary *nDic = (NSDictionary *)self.currentModel;
            weibo_id = nDic[@"weibo_id"];
        }else{
            weibo_id = self.currentModel.weibo_id;
        }
            [dict setValue:weibo_id forKey:@"weibo_id"];
            [dict setValue:@"xr" forKey:@"itype"];
            [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
                if ([responseJson toInt:@"status"] == 1) {
                    
                    [FanweMessage alertHUD:[responseJson valueForKeyPath:@"error"]];
//                    [FanweMessage alert:ASLocalizedString(@"提示")message:[responseJson valueForKeyPath:@"error"] isHideTitle:NO destructiveAction:^{
                        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteVideoWithView:)]) {
                            [self.delegate deleteVideoWithView:self];
                        }
                       
//                    }];
                }else{
                    
                }
            } FailureBlock:^(NSError *error) {
                [FanweMessage alert:ASLocalizedString(@"删除失败")];
            }];
        } cancelAction:^{
            
        }];
}

- (void)controlViewDidClickPriase:(HMVideoControlView *)controlView {
    if (![IMAPlatform isAutoLogin]) {
        [[AppDelegate sharedAppDelegate] enterLoginUI];
        return;
    }
    //点击点赞按钮
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"publish_comment" forKey:@"act"];
    if (controlView.model.weibo_id.length)
    {
        [MDict setObject:controlView.model.weibo_id forKey:@"weibo_id"];
    }
    [MDict setObject:@"xr" forKey:@"itype"];
    [MDict setObject:@"2" forKey:@"type"];
    [MDict setObject:controlView.model.user_id forKey:@"user_id"];
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"]== 1)
         {
             NSString *digg_count = [responseJson toString:@"digg_count"];
             int has_digg = [responseJson toInt:@"has_digg"];
             NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
             
             [postDict setObject:@"dianZan" forKey:@"type"];
             [postDict setObject:[NSString stringWithFormat:@"%@",digg_count] forKey:@"count"];
             [postDict setObject:[NSString stringWithFormat:@"%d",has_digg] forKey:@"has_digg"];
//             [postDict setObject:[NSString stringWithFormat:@"%d",self.lastView] forKey:@"reloadView"];
//             [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTableViewStatus" object:postDict];
              [controlView setiIsPraise:has_digg diggcount:digg_count];
         }
//         NSIndexPath *te = [NSIndexPath indexPathForRow:0 inSection:FWPCDetailOneSection];//刷新某段某行
         [[BGHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

- (void)controlViewDidClickComment:(HMVideoControlView *)controlView DataArray:(NSMutableArray *)dataArray {
    
    if (![IMAPlatform isAutoLogin]) {
        [[AppDelegate sharedAppDelegate] enterLoginUI];
        return;
    }
    
    //点击评论按钮
    [self.commentView show:[UIApplication sharedApplication].keyWindow];
}

- (void)controlViewDidClickShare:(HMVideoControlView *)controlView ShareDict:(NSMutableDictionary *)shareDict {
    if (![IMAPlatform isAutoLogin]) {
        [[AppDelegate sharedAppDelegate] enterLoginUI];
        return;
    }
    // 点击分享
    _shareDict = shareDict;
    [self.shareView show:[UIApplication sharedApplication].keyWindow isNeedReport:![controlView.model.user_id isEqualToString:[[IMAPlatform sharedInstance].host imUserId]]];
}

-(void)controlViewDidClickGift:(HMVideoControlView *)controlView{
    if (![IMAPlatform isAutoLogin]) {
        [[AppDelegate sharedAppDelegate] enterLoginUI];
        return;
    }
    self.currentModel = controlView.model;
    self.giftView.hidden = NO;
//    self.giftView.topView.hidden = YES;
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.giftView.frame = CGRectMake(0, kScreenH-_giftViewHeight - (IPHONE_X ? 34 : 0) - (self.isPushed ? 0 : 0), _giftView.frame.size.width, _giftView.frame.size.height);
        [[[UIApplication sharedApplication].delegate window].rootViewController.view bringSubviewToFront:_giftView];
    }completion:^(BOOL finished) {
        
    }];
}

#pragma mark 点击发送礼物
- (void)senGift:(GiftView *)giftView AndGiftModel:(GiftModel *)giftModel
{
    _currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
    if (_currentDiamonds < giftModel.diamonds)
    {
        _giftView.sendBtn.hidden = NO;
        _giftView.continueContainerView.hidden = YES;
        
        [self showRechargeAlert:ASLocalizedString(@"当前余额不足，充值才能继续送礼，是否去充值？")];
        
        return;
    }
    
   
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    [mDict setObject:@"svideo" forKey:@"ctl"];
    [mDict setObject:@"send_gift" forKey:@"act"];
    [mDict setObject:self.currentModel.user_id forKey:@"to_uid"];
    [mDict setObject:self.currentModel.weibo_id forKey:@"w_id"];
    [mDict setObject:@"1" forKey:@"num"];
//    [NSString stringWithFormat:@"%ld",giftModel.diamonds]
    [mDict setObject:@"" forKey:@"price_type"];
    [mDict setObject:[NSString stringWithFormat:@"%ld",giftModel.ID] forKey:@"g_id"];
    
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            self.currentDiamonds -= giftModel.diamonds;
            if (self.currentDiamonds >= 0)
            {
                [self.giftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds]];
                
//                [[IMAPlatform sharedInstance].host setDiamonds:[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds]];
            }
            GiftModel *newModel = [GiftModel mj_objectWithKeyValues:responseJson[@"data"]];
            [self showSendGiftSuccessWithModel:newModel];
            
            
            [self changeMoney];
        }
        
        
    } FailureBlock:^(NSError *error) {
        
    }];
}



- (void)showSendGiftSuccessWithModel:(GiftModel *)giftModel
{
//    if (giftModel.is_much == 0)
//    {
//    [FanweMessage alertHUD:ASLocalizedString(@"发送成功")];
//        [FanweMessage alert:[NSString stringWithFormat:ASLocalizedString(@"%@ 已发送"),giftModel.name]];
//    }
    [self.animationArray addObject:giftModel];
    [self.tipAnimationArray addObject:giftModel];
    if (!self.isAnimated) {
        [self startTipGiftAnimation];
        self.isAnimated = YES;
    }
    if (giftModel.is_animated == 2) {
        if (!self.isBigAnimated) {
            GiftModel *model = self.animationArray.lastObject;
            [self.animationView setGiftModel:model];
            self.isBigAnimated = YES;
        }
    }else if (giftModel.is_animated == 1){
        if (!self.isBigAnimated) {
            for (AnimateConfigModel *configModel in giftModel.anim_cfg) {
                GifImageView *gifImageView = [[GifImageView alloc]initWithModel:configModel inView:self andSenderName:[IMAPlatform sharedInstance].host.imUserName];
                gifImageView.delegate = self;
            }
            self.isBigAnimated = YES;
        }
    }
}

- (void)showRechargeAlert:(NSString *)message
{
    FWWeakify(self)
    [FanweMessage alert:ASLocalizedString(@"余额不足")message:message destructiveAction:^{
        
//        FWStrongify(self)
//        if (_liveInputView.barrageBtn.isSelected &&!_liveInputView.isHost)
//        { // 打开了 弹幕
            [self showRechargeView:_giftView];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                [self.liveInputView.textField resignFirstResponder];
//
//            });
//        }
//        else
//        {
//            [self showRechargeView:_giftView];
//        }
        
    } cancelAction:^{
        
//        if (_liveInputView.barrageBtn.isSelected && !_liveInputView.isHost)
//        {// 打开了 弹幕
//            _liveInputView.hidden = NO;
//            _bottomView.hidden = YES;
//            [_liveInputView becomeFirstResponder];
//        }
        
    }];
}

- (void)showRechargeView:(GiftView *)giftView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoViewDidClickRecharge:)]) {
        [self.delegate videoViewDidClickRecharge:self];
    }
}


- (void)controlViewDidClickBottomComment:(HMVideoControlView *)controlView{
    [self.currentPlayView commentBtnClick:self.currentPlayView.commentBtn];
}

- (void)controlViewDidClickFocus:(HMVideoControlView *)controlView{
    //点击了关注按钮
}

- (void)controlViewDidClickOneOnOne:(HMVideoControlView *)controlView{
    [self.player pausePlay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoViewDidClickOneOnOne:)]) {
        [self.delegate videoViewDidClickOneOnOne:self];
    }
}

#pragma mark - HMShareViewDelegate
- (void)clickShareViewBtn:(UMSocialPlatformType)type{
    if (![[UMSocialManager defaultManager] isSupport:type]){
        switch (type) {
            case UMSocialPlatformType_Sina:
                [FanweMessage alert:ASLocalizedString(@"新浪微博未安装")];
                break;
            case UMSocialPlatformType_WechatSession:
                [FanweMessage alert:ASLocalizedString(@"微信未安装")];
                break;
            case UMSocialPlatformType_WechatTimeLine:
                [FanweMessage alert:ASLocalizedString(@"微信未安装")];
                break;
            case UMSocialPlatformType_QQ:
                [FanweMessage alert:ASLocalizedString(@"QQ未安装")];
                break;
            case UMSocialPlatformType_Qzone:
                [FanweMessage alert:ASLocalizedString(@"QQ未安装")];
                break;
            default:
                break;
        }
        return;
    }
    
    ShareModel *model = [[ShareModel alloc]init];
    model.share_content = _shareDict[@"share_content"];
    model.share_title = _shareDict[@"share_title"];
    model.share_url = _shareDict[@"share_url"];
    model.share_imageUrl = _shareDict[@"share_imageUrl"];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  _shareDict[@"share_imageUrl"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_shareDict[@"share_title"] descr:_shareDict[@"share_content"] thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = _shareDict[@"share_url"];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:[self viewController] completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            [[BGHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",error.userInfo[@"share error"]]];
        }else{
            [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"分享成功")];
            
            
            
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                [[BGHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:ASLocalizedString(@"分享失败: %@"),resp.message]];
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//                [[BGHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:ASLocalizedString(@"分享失败: %@"),data]];
//            }
        }
    }];
}

- (void)clickShareViewReportBtn{
    
    [self.player pausePlay];
    
    BGReportController *reportVC = [[BGReportController alloc]init];
    reportVC.weibo_id = self.currentPlayView.model.weibo_id;
    reportVC.to_user_id = self.currentPlayView.model.user_id;
    reportVC.reportType = 1;
    [[AppDelegate sharedAppDelegate] pushViewController:reportVC animated:YES];
}

#pragma mark 创建礼物视图及礼物动画视图
- (void)loadGiftView:(NSArray *)list
{
    NSMutableArray *giftMArray = [NSMutableArray array];
    if (list && [list isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *key in list)
        {
            GiftModel *giftModel = [GiftModel mj_objectWithKeyValues:key];
            [giftMArray addObject:giftModel];
        }
    }
    
    BOOL ret = NO;
    for (GiftModel *giftModel in giftMArray) {
        if (giftModel.list.count > 4) {
            ret = YES;
            break;
        }
    }
//    if (ret) {
//    _giftViewHeight = kRealValue(358) + MG_BOTTOM_MARGIN;
//    kScreenW*0.56+kSendGiftContrainerHeight+4*kDefaultMargin + MG_BOTTOM_MARGIN;
//    }else{
//        _giftViewHeight = kScreenW*0.28+kSendGiftContrainerHeight+4*kDefaultMargin;
//    }
    
    
    _giftViewHeight = KGiftViewHeight;
    // 礼物视图
    _giftView = [[GiftView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, _giftViewHeight)];
    _giftView.delegate = self;
    _giftView.hidden = YES;
    [_giftView setGiftView:giftMArray];
//    [self.superview.superview.superview.superview addSubview:_giftView];
    
    [[[UIApplication sharedApplication].delegate window].rootViewController.view addSubview:_giftView];
    
    
    
    NSLog(@"_giftView_giftView%@",[[UIApplication sharedApplication].delegate window].rootViewController);
    
//    [[UIApplication sharedApplication].keyWindow addSubview:_giftView];
    
    [self changeMoney];
}

#pragma mark 钻石值的改变,刷新用户信息

- (void)changeMoney
{
    FWWeakify(self)
    [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {
        FWStrongify(self)
        NSInteger currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
        [self.giftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",(long)currentDiamonds]];
        
    }];
}

#pragma mark   隐藏giftView
- (void)hiddenGiftView
{
    
    FWWeakify(self)
    [UIView animateWithDuration:0.1 animations:^{
        
        FWStrongify(self)
        self.giftView.frame = CGRectMake(0, self.frame.size.height, _giftView.frame.size.width, _giftView.frame.size.height);
        
    }completion:^(BOOL finished) {
        
        FWStrongify(self)
        self.giftView.hidden = YES;
        
    }];
}



- (UIViewController *)viewController{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponser = [next nextResponder];
        if ([nextResponser isKindOfClass:[UITableViewController class]]) {
            return (UIViewController *)nextResponser;
        }
    }
    return nil;
}

#pragma mark -------------- Lazy Load -------------------
- (HMVideoViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [HMVideoViewModel new];
        _viewModel.isPushed = self.isPushed;
    }
    return _viewModel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = kBlackColor;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        
        [_scrollView addSubview:self.topView];
        [_scrollView addSubview:self.middleView];
        [_scrollView addSubview:self.bottomView];
        _scrollView.contentSize = CGSizeMake(0, kScreenH * 3);
        
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _scrollView;
}

- (HMVideoControlView *)topView {
    if (!_topView) {
        _topView = [[HMVideoControlView alloc] initWithIsPushed:self.isPushed];
    }
    return _topView;
}

- (HMVideoControlView *)middleView {
    if (!_middleView) {
        _middleView = [[HMVideoControlView alloc] initWithIsPushed:self.isPushed];
    }
    return _middleView;
}

- (HMVideoControlView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[HMVideoControlView alloc] initWithIsPushed:self.isPushed];
    }
    return _bottomView;
}

- (NSMutableArray *)videos {
    if (!_videos) {
        _videos = [NSMutableArray new];
    }
    return _videos;
}

- (HMVideoPlayer *)player {
    if (!_player) {
        _player = [HMVideoPlayer new];
        _player.delegate = self;
    }
    return _player;
}

- (HMCommentView *)commentView{
    if (!_commentView) {
        _commentView = [[HMCommentView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, kScreenH)];
        FWWeakify(self)
        [_commentView setOperateCommentSuccessBlock:^(NSString * _Nonnull commentCount) {
            FWStrongify(self)
            [self.currentPlayView.commentBtn setTitle:commentCount forState:UIControlStateNormal];
        }];
    }
    return _commentView;
}

- (HMShareView *)shareView{
    if (!_shareView) {
        _shareView = [[HMShareView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, kScreenH)];
        _shareView.delegate = self;
    }
    return _shareView;
}

- (void)startGiftAnimation{
    GiftModel *model = self.animationArray.lastObject;
    if (self.animationArray.count) {
        if (model.is_animated == 2) {
            [self.animationView setGiftModel:model];
        }else if (model.is_animated == 1){
            for (AnimateConfigModel *configModel in model.anim_cfg) {
                GifImageView *gifImageView = [[GifImageView alloc]initWithModel:configModel inView:self andSenderName:[IMAPlatform sharedInstance].host.imUserName];
                gifImageView.delegate = self;
            }
        }
    }
}

- (void)startTipGiftAnimation{
    if (self.tipAnimationArray.count) {
        GiftModel *model = self.tipAnimationArray.lastObject;
        [self addSubview:self.tipAnimationView];
        [self.tipAnimationView setGiftModel:model];
    }
}

#pragma mark - SVGAAnimationViewDelegate
- (void)svgaAnimationView:(SVGAAnimationView *)svgaAnimationView didFinishAnimation:(GiftModel *)msgModel{
    [self.animationArray removeObject:msgModel];
    self.isBigAnimated = self.animationArray.count;
    [self startGiftAnimation];
}

#pragma mark - BGVideoGiftAnimationViewDelegate
- (void)animationView:(BGVideoGiftAnimationView *)animationView didFinishAnimation:(GiftModel *)model{
    self.isAnimated = NO;
    [animationView removeFromSuperview];
    [self.tipAnimationArray removeLastObject];
    [self startTipGiftAnimation];
}

#pragma mark GifImageViewDelegate
- (void)gifImageViewFinish:(AnimateConfigModel *)animateConfigModel andSenderName:(NSString *)senderName{
    [self.animationArray removeLastObject];
    self.isBigAnimated = self.animationArray.count;
    [self startGiftAnimation];
}

- (NSMutableArray *)animationArray{
    if (!_animationArray) {
        _animationArray = [NSMutableArray array];
    }
    return _animationArray;
}

- (SVGAAnimationView *)animationView{
    if (!_animationView) {
        _animationView = [[SVGAAnimationView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _animationView.delegate = self;
    }
    return _animationView;
}

- (NSMutableArray *)tipAnimationArray{
    if (!_tipAnimationArray) {
        _tipAnimationArray = [NSMutableArray array];
    }
    return _tipAnimationArray;
}

- (BGVideoGiftAnimationView *)tipAnimationView{
    if (!_tipAnimationView) {
        _tipAnimationView = [[NSBundle mainBundle] loadNibNamed:@"BGVideoGiftAnimationView" owner:nil options:nil].lastObject;
        _tipAnimationView.delegate = self;
    }
    return _tipAnimationView;
}

//- (NSMutableArray *)gifImageViewArray{
//    if (!_gifImageViewArray) {
//        _gifImageViewArray = [NSMutableArray array];
//    }
//    return _gifImageViewArray;
//}

- (void)mineBtnAction:(UIButton *)sender{
    if ([IMAPlatform isAutoLogin]) {
        MPersonCenterVC *vc = [[MPersonCenterVC alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }else{
        [[AppDelegate sharedAppDelegate] enterLoginUI];
    }
    
}

- (void)searchBtnAction:(UIButton *)sender{
    if ([IMAPlatform isAutoLogin]) {
        SSearchVC *searchVC = [[SSearchVC alloc]init];
        searchVC.searchType = @"0";
        [[AppDelegate sharedAppDelegate] pushViewController:searchVC animated:YES];
    } else {
        [[AppDelegate sharedAppDelegate] enterLoginUI];
    }
}

- (UIButton *)mineBtn{
    if (!_mineBtn) {
        _mineBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15 + kStatusBarHeight, 44, 44)];
        [_mineBtn setImage:[UIImage imageNamed:@"hm_new_admin"] forState:UIControlStateNormal];
        [_mineBtn addTarget:self action:@selector(mineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mineBtn;
}

- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 15 - 44, 15 + kStatusBarHeight, 44, 44)];
        [_searchBtn setImage:[UIImage imageNamed:@"hm_new_search"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (void)dealloc{
    [self hiddenGiftView];
    [_giftView removeFromSuperview];
}

@end
