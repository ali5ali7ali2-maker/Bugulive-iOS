//
//  YHTimeLineViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/8/23.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "YHTimeLineViewController.h"

#import "YHTimeLineListController.h"
#import "ReleaseTopicVC.h"//话题搜索
#import "MGNewDTNavView.h"
#import "MGNewDTHeadView.h"
#import "BogoDTHeadView.h"

#import "BzoneLogic.h"
#import "TCUtil.h"
#import "BGTopicTimeLineListController.h"
#import "BGSystemMsgVC.h"
//附近的人
#import "MGNewDTNearByViewController.h"

#import "BogoTimeLineListViewController.h"
#import "GradientImageGenerator.h"

#define YHTimeLineMagrin 20 //

@interface YHTimeLineViewController ()<UIScrollViewDelegate,MGTimeLineDidScrollViewDelegate,BogoTimeLineDidScrollViewDelegate>

@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

//@property(nonatomic, strong) YHTimeLineListController *firstVC;
//@property(nonatomic, strong) YHTimeLineListController *mineVC;
//@property(nonatomic, strong) YHTimeLineListController *recommandVC;
//@property(nonatomic, strong) YHTimeLineListController *nearVC;

@property(nonatomic, strong) BogoTimeLineListViewController *firstVC;
@property(nonatomic, strong) BogoTimeLineListViewController *mineVC;
@property(nonatomic, strong) BogoTimeLineListViewController *recommandVC;
@property(nonatomic, strong) BogoTimeLineListViewController *nearVC;




//view
@property(nonatomic, strong) MGNewDTNavView *navView;
@property(nonatomic, strong) BogoDTHeadView *headView;
@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) NSArray *list;

@property(nonatomic, strong) QMUIButton *postBtn;

@property(nonatomic, strong) BzoneLogic *logic;

@property(nonatomic, strong) UIView *lineView;

@end

@implementation YHTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
    [self segmentStyle1];
    [self requsetModel];
}

-(void)setUpView{
    self.navView.hidden = YES;
    [self.view addSubview:self.navView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.headView];
//    self.scrollView.frame = CGRectMake(0, self.navView.bottom, kScreenW, kScreenH - kTabBarHeight - self.navView.bottom);
    self.scrollView.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight - kTopHeight);
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    [self requsetModel];
    [self requsetUnRead_Msg];
}

-(void)requsetModel{
    
    self.logic = [BzoneLogic new];
    
    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
    {
        return;
    }
    
    [self.logic dynamicGetTopicModelWithUID:[BGIMLoginManager sharedInstance].loginParam.identifier Success:^(NSDictionary * _Nonnull dic) {
        if ([[dic valueForKey:@"status"] integerValue] == 1) {
            
            for (NSDictionary *subDic in [dic valueForKey:@"data"]) {
                MGDynamicTopicModel *model = [MGDynamicTopicModel itemWithDic:subDic];
                [self.logic.topicArr addObject:model];
            }
            [self.headView resetTopicModel:self.logic.topicArr];
        }
    }];
}

-(void)requsetUnRead_Msg{
    
    self.logic = [BzoneLogic new];
    [self.logic fetchUnRead_MsgSuccess:^(NSDictionary * _Nonnull dic) {
        if ([[dic valueForKey:@"status"] integerValue] == 1) {
            if ([dic[@"no_read_msg"] intValue] ==0) {
                self.navView.jsbadge.badgeText = nil;

            }else{
                self.navView.jsbadge.badgeText = [NSString stringWithFormat:@"%@",dic[@"no_read_msg"]];

            }
            [ self.navView.jsbadge setNeedsLayout];
        }
    }];
}

- (void)segmentStyle1 {
    
    self.firstVC = [[BogoTimeLineListViewController alloc]initWithIndexAct:MGDTHOMETYPE_RECOMMAND withUID:@"" isHomePageFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight - kTabBarHeight - MG_BOTTOM_MARGIN)];
//                     alloc]initWithIndexAct:MGDTHOMETYPE_RECOMMAND withUID:@""];
    
    _list = @[ ASLocalizedString(@"推荐"),ASLocalizedString(@"关注"),/*ASLocalizedString(@"附近"),*/ASLocalizedString(@"我的")];
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(15, self.headView.bottom, SCREEN_WIDTH - 30 , 40) titles:_list headStyle:SegmentHeadStyleSlide layoutStyle:MLMSegmentLayoutLeft];
    _segHead.selectColor = kWhiteColor;
    _segHead.delegate = self;
    
    _segHead.fontScale = 1;
//    _segHead.lineHeight = 0;
//    _segHead.lineColor = kClearColor;
    _segHead.fontSize = 14;
    //滑块设置
    _segHead.slideHeight = kRealValue(32);
//    _segHead.slideCorner = 4;
    _segHead.moreButton_width = kRealValue(64);
    _segHead.singleW_Add = kRealValue(64);
    _segHead.slideColor = nil;
//    _segHead.slideScale = 1.5;
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#808080"];
    
    _segHead.btnBgImg = @"按钮gradient";
    _segHead.btnBeforeBgImg = @"按钮白gradient";
    
    _segHead.bottomLineHeight = 0;
    
    _segHead.headColor = kClearColor;
    _segHead.deSelectColor = kBlackColor;
    
    //    CF6;
    _segHead.bottomLineHeight = 0;
    
    //    _segHead.deSelectColor = [UIColor colorWithRed:0.91 green:0.47 blue:0.62 alpha:1.00];
    self.view.backgroundColor = kClearColor;
    //    CF6;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, _segHead.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-self.headView.height-self.navView.height - kTabBarHeight) vcOrViews:[self vcArr:_list.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    _segScroll.backgroundColor = kWhiteColor;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.scrollView addSubview:_segHead];
        self.lineView.top = _segHead.bottom + 8;
        [self.scrollView addSubview:self.lineView];
        [self.scrollView addSubview:_segScroll];
        [self setHeadBottomLineView];
    }];
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


-(void)handleSearchEvent{
//    [self.firstVC handleSearchEvent];
////    [self.mineVC handleSearchEvent];
////    [self.nearVC handleSearchEvent];
}

-(void)reloadDynamicData{
//    [self.firstVC reloadDynamicData];
//    [self.mineVC reloadDynamicData];
//    [self.nearVC reloadDynamicData];
}

-(void)protocolTimeLineDidScrollView:(UIScrollView *)scrollView offset:(CGFloat)offset{
    
    NSLog(@"offset%f",offset);
    NSLog(@"offset%f",offset);
    NSLog(@"%@",scrollView);
    NSLog(@"View.contentSize.height:%f",scrollView.contentSize.height);
    NSLog(@"%f",kScreenH - self.headView.height - kTabBarHeight - MG_TOP_MARGIN - MG_BOTTOM_MARGIN)
    
    if (scrollView.contentSize.height < kScreenH - kTopHeight - kTabBarHeight) {
        [self.scrollView setContentOffset:CGPointMake(0, offset < 0 ? 0 : offset)];
        self.segScroll.height = scrollView.height =  kScreenH - kTopHeight - kTabBarHeight - YHTimeLineMagrin;
        return;
    }
    
    if (offset > self.headView.height) {
        [self.scrollView setContentOffset:CGPointMake(0, self.headView.height)];
        self.segScroll.height = scrollView.height = kScreenH - kTopHeight - 49 - MG_BOTTOM_MARGIN - self.headView.height;
//        kScreenH - self.navView.height - kTabBarHeight - self.headView.height;
//
        
        NSLog(@"%f",kStatusBarHeight);
        NSLog(@"%f",kTopHeight);
        NSLog(@"%f",MG_BOTTOM_SAFE_HEIGHT);
        NSLog(@"%f",self.headView.height);
        
//        self.segScroll.height = scrollView.height =  kScreenH - self.navView.height - kTabBarHeight - self.headView.height;
        return;
    }
    
    if (scrollView.height < kScreenH - self.navView.height - self.segHead.height - kTabBarHeight && offset > 0) {
        return;
    }
    
    self.segScroll.height = scrollView.height =  kScreenH - self.navView.height - self.segHead.height - kTabBarHeight - YHTimeLineMagrin;


    [self.scrollView setContentOffset:CGPointMake(0, offset < 0 ? 0 : offset)];

}

#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count
{
    NSMutableArray *arr = [NSMutableArray array];
    
    CGRect frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight - kTabBarHeight - MG_BOTTOM_MARGIN);
    
    BogoTimeLineListViewController *vc2 = [[BogoTimeLineListViewController alloc]initWithIndexAct:MGDTHOMETYPE_CONCERT withUID:@"" isHomePageFrame:frame];
    BogoTimeLineListViewController *vc3 = [[BogoTimeLineListViewController alloc]initWithIndexAct:MGDTHOMETYPE_NEARBY withUID:@"" isHomePageFrame:frame];
    //    YHTimeLineListController *vc4 = [[YHTimeLineListController alloc]initWithIndexAct:MGDTHOMETYPE_VIDEO withUID:@""];
    BogoTimeLineListViewController *vc5 = [[BogoTimeLineListViewController alloc]initWithIndexAct:MGDTHOMETYPE_MY withUID:[BGIMLoginManager sharedInstance].loginParam.identifier isHomePageFrame:frame];;
        
    
    self.firstVC.timeLineDelegate = self;
    vc2.timeLineDelegate = self;
    vc3.timeLineDelegate = self;
//    vc4.timeLineDelegate = self;
    vc5.timeLineDelegate = self;
    
    [arr addObject:self.firstVC];
    [arr addObject:vc2];
//    [arr addObject:vc3];
//    [arr addObject:vc4];
    [arr addObject:vc5];
    
    return arr;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = kClearColor;
    }
    return _scrollView;
}

//放在当前view上
-(MGNewDTNavView *)navView{
    if (!_navView) {
        _navView = [[MGNewDTNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kTopHeight)];
        __weak __typeof(self)weakSelf = self;
        _navView.clickPostBlock = ^(NSInteger i) {
            if (i == 0) {
                ReleaseTopicVC *pushVC = [ReleaseTopicVC new];
                pushVC.releaseTopicBlock = ^(MGDynamicTopicModel * _Nonnull topic) {
                    BGTopicTimeLineListController *pushVC = [BGTopicTimeLineListController new];
                    pushVC.topic = topic;
                    [[AppDelegate sharedAppDelegate]pushViewController:pushVC animated:YES];
                };
                [[AppDelegate sharedAppDelegate]pushViewController:pushVC animated:YES];
//                 presentViewController:pushVC animated:YES completion:nil];
            }else if (i == 1){
                [weakSelf handleSearchEvent];
            }else if (i == 2){
                BGSystemMsgVC *pushVC = [BGSystemMsgVC new];
                [[AppDelegate sharedAppDelegate]pushViewController:pushVC animated:YES];
            }
        };
    }
    return _navView;
}

//放在scrollview上的
-(BogoDTHeadView *)headView{
    if (!_headView) {
        
        _headView = [[NSBundle mainBundle]loadNibNamed:@"BogoDTHeadView" owner:self options:nil].firstObject;
        _headView.backgroundColor = kClearColor;
        
        if (isIPhone6()) {
            _headView.frame = CGRectMake(0, 0, kScreenW, kRealValue(116 + 15 + 15 ));
        }else{
            _headView.frame = CGRectMake(0, 0, kScreenW, kRealValue(116 + 15 + 15 + 20));
        }
        
        
//        _headView = [[MGNewDTHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(130))];
//        FWWeakify(self)
//        _headView.MGNewDTHeadViewTopicBlock = ^(NSInteger index) {
//            FWStrongify(self)
//
//            if (index == 1000) {//全部话题
//                MGNewDTNearByViewController *pushVC = [[MGNewDTNearByViewController alloc]initWithType:MGNEWDTTYPE_TOPIC];
//                [[AppDelegate sharedAppDelegate]pushViewController:pushVC animated:YES];
//            }else{
//                BGTopicTimeLineListController *pushVC = [BGTopicTimeLineListController new];
////                if (self.logic.topicArr.count > index - 1) {
//                    pushVC.topic = _headView.topicArr[index];
////                    self.logic.topicArr[index];
//                [[AppDelegate sharedAppDelegate]pushViewController:pushVC animated:YES];
////                }
//            }
//        };
    }
    return _headView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 3)];
        _lineView.backgroundColor = kClearColor;
        
    }
    return _lineView;
}


@end
