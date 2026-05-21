#import "hotViewControllerHJ.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "Classification_view.h"
#import "Classification_Alertview.h"
#import "NewestItemCell.h"
#import "HMHotBannerModel.h"
#import "DistanceModel.h"
#import "AdJumpViewModel.h"
#import "VideoViewController.h"
#import "SocietyHomePageVC.h"
#import "UpgradeTipView.h"

// 广告图默认滚动时间

@interface hotViewControllerHJ ()<ClassificationDelegate,ClassificationDelegate2,UIScrollViewDelegate,PushToLiveControllerDelegate>
{
    UIView *_nothingView;
    int selected;
    UIImageView *NoInternetImageV;
    CGSize collectionSize;
    NSString *stream;
    NSString                        *_oldSocietyListName;   // 公会名称可以修改，修改前的公会名字
    NSString                        *_societyListName;      // 公会名称
}
@property(nonatomic,strong) Classification_view *choose_view;
@property(nonatomic,strong) Classification_Alertview *choose_Alert;

@property (nonatomic, strong) NewestViewController *hotVC;

@property (nonatomic, strong) SocietyHomePageVC     *societyHomePage;           // 公会
@property (nonatomic, strong) UIScrollView          *scrollView;                // ScrollView
@property (nonatomic, strong) NSMutableArray                            *itemTitleMutableArray;         // 完整的分类标题容器
@property (nonatomic, strong) NSMutableArray<VideoClassifiedModel *>    *classifiedModelMutableArray;   // 服务端下发分类的模型容器
@property (nonatomic, strong) NSMutableArray<VideoViewController *>     *videoVCMutableArray;           // 服务端下发分类的对应的控制器容器
@end

@implementation hotViewControllerHJ

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.itemTitleMutableArray = [NSMutableArray array];
    self.classifiedModelMutableArray = [NSMutableArray array];
    self.videoVCMutableArray = [NSMutableArray array];
    
    [self.itemTitleMutableArray setArray:@[ASLocalizedString(@"热门")]];
    [self.view addSubview:self.choose_view];
    [_choose_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, kScreenW, kScreenH - 45-kTabBarHeight - 20 - kNavigationBarHeight)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = kClearColor;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(kScreenW * [self.itemTitleMutableArray count], CGRectGetHeight(self.scrollView.frame));
    [self.scrollView scrollRectToVisible:CGRectMake(0 * kScreenW, 0, kScreenW, CGRectGetHeight(self.scrollView.frame)) animated:NO];
    [self.view addSubview:self.scrollView];
    
    _hotVC = [[NewestViewController alloc]init];
    _hotVC.types = @"1";
    _hotVC.collectionViewFrame = CGRectMake(0, 0, _scrollView.width, _scrollView.bounds.size.height);
    _hotVC.view.frame = CGRectMake(self.scrollView.width * [self.itemTitleMutableArray indexOfObject:ASLocalizedString(@"热门")], 0, self.scrollView.width, _scrollView.bounds.size.height);
    _hotVC.delegate = self;
    [_scrollView addSubview:_hotVC.view];
    
    [self.choose_Alert setClassWithAry:self.itemTitleMutableArray];
    [self.choose_view setClassWithAry:self.itemTitleMutableArray];
    [self.choose_view selectWithIndex:0];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * [self.itemTitleMutableArray count], CGRectGetHeight(self.scrollView.frame));
    
    // 升级提示等
    UpgradeTipView *upgradeTipView = [[UpgradeTipView alloc] init];
    [upgradeTipView initRewards];
    
    //赠送钻石奖励提示
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"app" forKey:@"ctl"];
    [parmDict setObject:@"init" forKey:@"act"];
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            [self loadClassifiedVC];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (Classification_view *)choose_view
{
    if (!_choose_view)
    {
        _choose_view =[[Classification_view alloc]init];
        _choose_view.delegate =self;
    }
    return _choose_view;
}
- (Classification_Alertview *)choose_Alert
{
    if (!_choose_Alert)
    {
        _choose_Alert =[[Classification_Alertview alloc]init];
        [self.view addSubview:_choose_Alert];
        [_choose_Alert mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.width.height.equalTo(self.view);
        }];
        _choose_Alert.alpha =0;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertWillHidden)];
        _choose_Alert.userInteractionEnabled =YES;
        _choose_Alert.delegate =self;
        [_choose_Alert addGestureRecognizer:tap];
    }
    return _choose_Alert;
}
//分类view代理方法
- (void)didSelectWith:(id)obj andxiabiao:(NSInteger)index
{
    [self.choose_Alert selectWithIndex:index];
    [self.scrollView scrollRectToVisible:CGRectMake(index*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) animated:YES];
    if (index == 0) {
        [self.hotVC loadDataFromNet:1];
    }else{
        [self refreshClassifiedVC:index];
    }
}
- (void)showAllClass
{
    [self alertWillHidden];
}
//Alert代理
- (void)didSelectWithAlert:(id)obj
{
    [self.choose_view selectWithIndex:[obj integerValue]];
    [self alertWillHidden];
    [self.scrollView scrollRectToVisible:CGRectMake([obj integerValue]*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) animated:YES];
    if ([obj integerValue] == 0) {
        [self.hotVC loadDataFromNet:1];
    }else{
        [self refreshClassifiedVC:[obj integerValue]];
    }
}
//实例方法
- (void)alertWillHidden
{
    __block typeof(self)blockself =self;
    if (self.choose_Alert.alpha ==0)
    {
        [UIView animateWithDuration:.4 animations:^{
            blockself.choose_Alert.alpha =1.;
            [blockself.view layoutIfNeeded];
        }];
    }else
    {
        [UIView animateWithDuration:.4 animations:^{
            blockself.choose_Alert.alpha =0.;
            [blockself.view layoutIfNeeded];
        }];
    }
}

#pragma mark -  上下滑动隐藏/显示导航栏

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 动态加载初始化接口下发的分类、公会等
- (void)loadClassifiedVC
{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    // 动态添加、删除公会
    if ([GlobalVariables sharedInstance].appModel.open_society_module.intValue == 1 && ![BGUtils isBlankString:[GlobalVariables sharedInstance].appModel.society_list_name])
    {
        _societyListName = [GlobalVariables sharedInstance].appModel.society_list_name;
        if (![_societyListName isEqualToString:_oldSocietyListName] && [self.itemTitleMutableArray containsObject:_oldSocietyListName])//修改了公会名字并且原来有公会就替换
        {
            NSInteger index = [self.itemTitleMutableArray indexOfObject:_oldSocietyListName];
            [self.itemTitleMutableArray replaceObjectAtIndex:index withObject:_societyListName];
            _oldSocietyListName = _societyListName;
        }else if(![_societyListName isEqualToString:_oldSocietyListName] && ![self.itemTitleMutableArray containsObject:_oldSocietyListName])//修改了公会名字并且原来没有公会加上去
        {
            [self.itemTitleMutableArray addObject:_societyListName];
            _oldSocietyListName = _societyListName;
        }else
        {
            if (![self.itemTitleMutableArray containsObject:_societyListName])
            {
                [self.itemTitleMutableArray addObject:_societyListName];
            }
        }
        
        if (!self.societyHomePage.view.superview)
        {
            self.societyHomePage.view.frame = CGRectMake(viewWidth * [self.itemTitleMutableArray indexOfObject:_societyListName], 0, viewWidth, _scrollView.bounds.size.height);
            [self.scrollView addSubview:self.societyHomePage.view];
        }
    }
    
    else if ([GlobalVariables sharedInstance].appModel.open_society_module.intValue == 0 && [self.itemTitleMutableArray containsObject:_societyListName])
    {
        [self.itemTitleMutableArray removeObject:_societyListName];
        
        [self.societyHomePage.view removeFromSuperview];
    }
    if (![[GlobalVariables sharedInstance].appModel.video_classified isEqual:self.classifiedModelMutableArray])
    {
        [self updateClassiFiedVC];
    }
}

- (void)updateClassiFiedVC
{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    @synchronized (self)
    {
        if (self.classifiedModelMutableArray.count > 0)
        {
            // 获取到本地暂存的服务端下发的分类的在完整的分类容器中的起点与终点，进行移除视频分类相关视图和视图控制器的操作
            VideoClassifiedModel *tmpModel = [self.classifiedModelMutableArray firstObject];
            NSInteger tmpIndex = [self.itemTitleMutableArray indexOfObject:tmpModel.title];
            VideoClassifiedModel *lastVideoModel = [self.classifiedModelMutableArray lastObject];
            NSInteger lastIndex = [self.itemTitleMutableArray indexOfObject:lastVideoModel.title];
            [self.videoVCMutableArray removeAllObjects];
            for (NSInteger i = tmpIndex; i <= lastIndex; i++)
            {
                if (self.scrollView.subviews.count > i)
                {
                    [self.scrollView.subviews[i] removeFromSuperview];
                }
            }
            
            // 动态删除视频分类
            for (VideoClassifiedModel *tmpModel in self.classifiedModelMutableArray)
            {
                [self.itemTitleMutableArray removeObject:tmpModel.title];
            }
        }
        
        // 动态添加视频分类
        for (VideoClassifiedModel *model in [GlobalVariables sharedInstance].appModel.video_classified)
        {
            [self.itemTitleMutableArray addObject:model.title];
        }
        
        self.classifiedModelMutableArray = [GlobalVariables sharedInstance].appModel.video_classified;
        
        [self.choose_Alert setClassWithAry:self.itemTitleMutableArray];
        [self.choose_view setClassWithAry:self.itemTitleMutableArray];
        [self.choose_view selectWithIndex:0];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width * [self.itemTitleMutableArray count], CGRectGetHeight(self.scrollView.frame));
        
        for (NSInteger i = 0; i < self.classifiedModelMutableArray.count; ++i)
        {
            // 服务端下发的分类的在完整的分类容器中的起点
            VideoClassifiedModel *tmpModel = [self.classifiedModelMutableArray firstObject];
            NSUInteger tmpIndex = [self.itemTitleMutableArray indexOfObject:tmpModel.title];
            
            VideoViewController *videoVC = [[VideoViewController alloc] init];
            VideoClassifiedModel * model = [[GlobalVariables sharedInstance].appModel.video_classified objectAtIndex:i];
            videoVC.viewFrame = CGRectMake(0, 0, viewWidth, self.scrollView.bounds.size.height);
            videoVC.view.frame = CGRectMake(viewWidth * (i+tmpIndex), 0, viewWidth, self.scrollView.bounds.size.height);
            videoVC.classified_id = model.classified_id;
            [self.scrollView addSubview:videoVC.view];
            
            [self.videoVCMutableArray addObject:videoVC];
        }
    }
}

#pragma mark 刷新分类VC的数据
- (void)refreshClassifiedVC:(NSInteger)page
{
    if (self.classifiedModelMutableArray.count > 0)
    {
        // 服务端下发的分类的在完整的分类容器中的起点
        VideoClassifiedModel *tmpModel = [self.classifiedModelMutableArray firstObject];
        NSUInteger tmpIndex = [self.itemTitleMutableArray indexOfObject:tmpModel.title];
        
        // 服务端下发的分类的在完整的分类容器中的终点
        VideoClassifiedModel *tmpModel2 = [self.classifiedModelMutableArray lastObject];
        NSUInteger tmpIndex2 = [self.itemTitleMutableArray indexOfObject:tmpModel2.title];
        
        if (page >= tmpIndex && page <= tmpIndex2)
        {
            VideoViewController *videoVC = self.videoVCMutableArray[page-tmpIndex];
            [videoVC setNetworing:1];
        }
    }
}

#pragma mark 解决Segmented的滑块快速滑动时的延迟，同时把点击滑块的情况排除在外
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger tmpPage = scrollView.contentOffset.x / pageWidth;
    float tmpPage2 = scrollView.contentOffset.x / pageWidth;
    NSInteger page = tmpPage2-tmpPage>=0.5 ? tmpPage+1 : tmpPage;
//    [self.choose_view selectWithIndex:page];
//    [self.choose_Alert selectWithIndex:page];
}

#pragma mark 页面滚动，同时调起Segmented的滑块滑动起来等
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.choose_view selectWithIndex:page];
    [self.choose_Alert selectWithIndex:page];
}

#pragma mark 跳转到话题页面和hotTopicViewController二级页面
- (void)pushToNextControllerWithModel:(cuserModel *)model
{
    if ([model.cate_id isEqualToString:@"0"])
    {
        // 暂时不能跳转
    }
    else
    {
        NewestViewController *tmpController = [[NewestViewController alloc]init];
        tmpController.topicName = model.title;
        tmpController.cate_id = model.cate_id;
        tmpController.types = @"1";
        [[AppDelegate sharedAppDelegate]pushViewController:tmpController animated:YES];
    }
}

#pragma mark NewestViewController跳转到直播

- (void)pushToLiveController:(LivingModel *)model modelArr:(NSArray *)modelArr isFirstJump:(BOOL)isFirstJump{

    if (![BGUtils isNetConnected])
    {
        return;
    }
    
    [[GlobalVariables sharedInstance].newestLivingMArray removeAllObjects];
    [[GlobalVariables sharedInstance].newestLivingMArray addObject:model];
    
    if ([self checkUser:[IMAPlatform sharedInstance].host])
    {
        TCShowLiveListItem *item = [[TCShowLiveListItem alloc]init];
        item.chatRoomId = model.group_id;
        item.avRoomId = model.room_id;
        item.title = StringFromInt(model.room_id);
        item.vagueImgUrl = model.head_image;
        
        TCShowUser *showUser = [[TCShowUser alloc]init];
        showUser.uid = model.user_id;
        showUser.avatar = model.head_image;
        item.host = showUser;
        item.is_voice = model.is_voice;

        if (model.live_in == FW_LIVE_STATE_ING)
        {
            item.liveType = FW_LIVE_TYPE_AUDIENCE;
        }
        else if (model.live_in == FW_LIVE_STATE_RELIVE)
        {
            //
            item.liveType = FW_LIVE_TYPE_RELIVE;
            [GlobalVariables sharedInstance].appModel.spear_live = @"0";
//            SHomePageVC *tmpController= [[SHomePageVC alloc]init];
//            tmpController.user_id = model.user_id;
//            tmpController.type = 0;
//            [[AppDelegate sharedAppDelegate]pushViewController:tmpController];
//
//
//            return;
        }
        //2020-1-7 小直播变大
        [LiveCenterManager sharedInstance].itemModel=item;
        BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
        
        [[LiveCenterManager sharedInstance]  showLiveOfAudienceLiveofTCShowLiveListItem:item modelArr:modelArr isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL isFinished) {
            
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

- (BOOL)checkUser:(id<IMHostAble>)user
{
    if (![user conformsToProtocol:@protocol(AVUserAble)])
    {
        return NO;
    }
    return YES;
}
    
@end
