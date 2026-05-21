//
//  NewSmallVideoViewController.m
//  BuguLive
//
//  Created by 范东 on 2019/2/20.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "NewSmallVideoViewController.h"
#import "MSmallVideoVC.h"
#import "SSearchVC.h"
#import "LeaderboardViewController.h"

@interface NewSmallVideoViewController (){
    MSmallVideoVC   *_hotVC;  //热门
    MSmallVideoVC  *_latestVC; //最新
    MSmallVideoVC  *_nearVC; //附近
}
@property(nonatomic,strong)NSMutableArray *infoArrays;

@property (nonatomic, strong) NSMutableArray                            *itemTitleMutableArray;         // 完整的分类标题容器
@property (nonatomic, strong) NSMutableArray    *classifiedModelMutableArray;   // 服务端下发分类的模型容器
@property (nonatomic, strong) NSMutableArray    *videoVCMutableArray;           // 服务端下发分类的对应的控制器容器

@property(nonatomic, assign) CGFloat viewHeight;

@property(nonatomic, strong) NSArray *listArr;

@end

@implementation NewSmallVideoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoArrays = [NSMutableArray array];
//arrayWithObjects:ASLocalizedString(@"热门"),ASLocalizedString(@"最新"),ASLocalizedString(@"附近"),nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTableViewStatus) name:@"changeTableViewStatus" object:nil];
    
    self.classifiedModelMutableArray = [NSMutableArray array];
    self.videoVCMutableArray = [NSMutableArray array];
    
    self.classifiedModelMutableArray = [GlobalVariables sharedInstance].appModel.video_cate;
    
    
    
    
    [self setUpSegView];

}


-(void)setUpSegView{
    _listArr = @[ASLocalizedString(@"推荐"),ASLocalizedString(@"最新"),ASLocalizedString(@"附近")];
    [self.infoArrays addObjectsFromArray:_listArr];
    // 动态添加视频分类
    for (VideoClassifiedModel *model in [GlobalVariables sharedInstance].appModel.video_cate)
    {
        [self.infoArrays addObject:model.name];
    }
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(kRealValue(12), 0, kScreenW - kRealValue(12), kRealValue(50)) titles:self.infoArrays headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutLeft];
    //tab颜色
    _segHead.selectColor = [UIColor colorWithHexString:@"#9152F8"];
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#777777"];
    _segHead.delegate = self;
    
    _segHead.fontScale = 1;
//    _segHead.lineHeight = 0;
//    _segHead.lineColor = kClearColor;
    _segHead.fontSize = 16;
    //滑块设置
    _segHead.slideHeight = kRealValue(32);
    _segHead.slideCorner = 4;
    _segHead.moreButton_width = kRealValue(20);
    _segHead.singleW_Add = kRealValue(20);
    _segHead.slideColor = nil;
    
    _segHead.lineScale = 0.6;
    _segHead.lineHeight = 3.5;
    _segHead.lineColor = [UIColor colorWithHexString:@"#9152F8"];
    _segHead.bottomLineHeight = 0;
//    bottomLineHeight
//    _segHead.slideScale = 1.5;
    
    

    _segHead.headColor = kClearColor;
    self.view.backgroundColor = kClearColor;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT - self.segHead.bottom - kTabBarHeight) vcOrViews:[self vcArr:_listArr.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
        
        [self setHeadBottomLineView];
        
    }];
    
    
    self.itemTitleMutableArray = [NSMutableArray array];
    self.videoVCMutableArray = [NSMutableArray array];
//    [self updateClassiFiedVC];
}

-(void)setHeadBottomLineView{
    UIView *line = [_segHead getScrollLineView];
    
    line.layer.cornerRadius = 2;
    line.layer.masksToBounds = YES;
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = line.bounds;
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#9E64FF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#EF60F6"].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [line.layer insertSublayer:gl atIndex:0];
}


- (void)changeTableViewStatus{
    [_hotVC refreshHeader];
    [_latestVC refreshHeader];
    [_nearVC refreshHeader];
}


- (void)toChatListVC{
    BGConversationSegmentController *chatListVC = [[BGConversationSegmentController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:chatListVC animated:YES];
}

//进入贡献榜
- (void)Incontribution
{
    LeaderboardViewController *vc = [[LeaderboardViewController alloc]init];
//    vc.isHiddenTabbar = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
}

-(void)search{
    SSearchVC *searchVC = [[SSearchVC alloc]init];
    searchVC.searchType = @"0";
    [[AppDelegate sharedAppDelegate] pushViewController:searchVC animated:YES];
}


#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count
{
    
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableDictionary *hotDic = [NSMutableDictionary dictionary];
    
    [hotDic setObject:@"1" forKey:@"order"];
    [hotDic setObject:@"0" forKey:@"cate"];
    
    NSMutableDictionary *latestDic = [NSMutableDictionary dictionary];
    [latestDic setObject:@"2" forKey:@"order"];
    [latestDic setObject:@"0" forKey:@"cate"];
    
    NSMutableDictionary *nearDic = [NSMutableDictionary dictionary];
    [nearDic setObject:@"3" forKey:@"order"];
    [nearDic setObject:@"0" forKey:@"cate"];
    
    
    
    _hotVC = [[MSmallVideoVC alloc]init];
    _hotVC.isHaveNavBar = NO;
    _hotVC.paramDict = hotDic;
//dictionaryWithObjectsAndKeys:@{@"order":@"1",@"cate":@"0"},nil];
//    [NSDictionary dictionaryWithObject:@"1" forKey:@"order"];
    
    _latestVC = [[MSmallVideoVC alloc]init];
    _latestVC.isHaveNavBar = NO;
    _latestVC.paramDict = latestDic;
    //附近
    _nearVC = [[MSmallVideoVC alloc]init];
    _nearVC.isHaveNavBar = NO;
    _nearVC.paramDict = nearDic;
    

    self.viewHeight = kScreenH - self.segHead.bottom - kTabBarHeight - kRealValue(5);
//    kScreenH - kStatusBarHeight - kRealValue(44) - kTabBarHeight - MG_BOTTOM_MARGIN - kRealValue(10);

    
    
//    [self reSizeContentViewWithFrame:CGRectMake(0, 0, kScreenW, self.viewHeight)];
    
    
    _hotVC.view.height = self.viewHeight;
    _hotVC.view.top = 0;
    _hotVC.videoCollectionV.height = self.viewHeight;
    
    _latestVC.view.height = self.viewHeight;
    _latestVC.videoCollectionV.height = self.viewHeight;
    
    _nearVC.view.height = self.viewHeight;
    _nearVC.videoCollectionV.height = self.viewHeight;
    
    [arr addObject:_hotVC];
    [arr addObject:_latestVC];
    [arr addObject:_nearVC];
    
    if (self.classifiedModelMutableArray.count > 0)
    {

    }
    
//        self.classifiedModelMutableArray = [GlobalVariables sharedInstance].appModel.video_classified;

    for (NSInteger i = 0; i < self.classifiedModelMutableArray.count; ++i)
    {
        // 服务端下发的分类的在完整的分类容器中的起点

        MSmallVideoVC *videoVC = [[MSmallVideoVC alloc]init];
        videoVC.isHaveNavBar = NO;
        videoVC.view.height = self.viewHeight;
        videoVC.videoCollectionV.height = self.viewHeight;
        
        VideoClassifiedModel * model = [[GlobalVariables sharedInstance].appModel.video_cate objectAtIndex:i];
//            videoVC.view.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight - kNavigationBarHeight - kRealValue(44));
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:model.id forKey:@"order"];
        [dic setObject:model.id forKey:@"cate"];
        videoVC.paramDict = dic;
        [arr addObject:videoVC];
    }
    
    return arr;
}

- (void)updateClassiFiedVC
{
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
