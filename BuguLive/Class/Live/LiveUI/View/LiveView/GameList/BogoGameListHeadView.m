//
//  BogoGameListHeadView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoGameListHeadView.h"
#import "BogoGameListHeadCell.h"
#import "BGTopicTimeLineListController.h"
#import "GameBottomListModel.h"
#import "GamePopView.h"
#import "NSString+Common.h"

@implementation BogoGameListHeadView
{
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.backgroundColor = [kBlackColor alpha];

    [self setUpView];
    [self requestGameList];

}

- (void)requestGameList{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"app" forKey:@"ctl"];
    [dict setValue:@"room_game_list" forKey:@"act"];
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            self.listArr = [NSArray modelArrayWithClass:GameBottomListModel.class json:responseJson[@"list"]];
            [self.collectionView reloadData];
            NSLog(@"游戏列表获取成功");
            
        }else{
            //接口请求失败
        }
    } FailureBlock:^(NSError *error) {
        NSLog(ASLocalizedString(@"游戏列表请求数据失败error:%@"),error);
    }];
}


-(void)setUpView{
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BogoGameListHeadCell" bundle:nil] forCellWithReuseIdentifier:@"BogoGameListHeadCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

-(void)resetTopicModel:(NSArray *)arr{
    self.listArr = [NSMutableArray arrayWithArray:arr];
    [self.collectionView reloadData];
//    for (int i = 0; i < 4; i ++) {
//        if (i > 4) return;
//        MGNewDTHeadControl *control = [self.topicView viewWithTag:100 + i];
//
//        if(arr.count > i)
//        {
//            [control resetControlModel:arr[i]];
//            //给有数据的view添加手势
//            [control addTarget:self action:@selector(MGNewDTHeadAction:) forControlEvents:UIControlEventTouchUpInside];
//        }
//    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BogoGameListHeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BogoGameListHeadCell" forIndexPath:indexPath];
//    cell.backgroundColor = kBlueColor;
    [cell resetControlModel:self.listArr[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    BGTopicTimeLineListController *pushVC = [BGTopicTimeLineListController new];
    GameBottomListModel *model = self.listArr[indexPath.row];
//    GamePopView *pop = [[GamePopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [pop setURL:model.url];
////    [pop show:[self getTopMostController].view];
//    [pop show:self.superview];
    self.webView.frame = self.superview.superview.superview.bounds;
    
//    self.webView.navigationDelegate = self; // 重点：设置navigationDelegate

    
    NSString *url = model.url;
    url = [url urlAddCompnentForValue:[IMAPlatform sharedInstance].host.userId key:@"uid"];
    url = [url urlAddCompnentForValue:[BogoNetwork shareInstance].token key:@"token"];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

    [self.superview.superview.superview addSubview:self.webView];
    
}

- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
//        config.backgroundColor = [UIColor clearColor];
//        config.userContentController.backgroundColor = [UIColor clearColor];

        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
        _webView.opaque = NO;
        _webView.navigationDelegate = self;
        _webView.scrollView.backgroundColor = [UIColor clearColor];

        [_webView setBackgroundColor:[UIColor clearColor]];


        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(40, kStatusBarHeight, 30, 30);
        [closeBtn setImage:[UIImage imageNamed:@"com_close_1"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [_webView addSubview:closeBtn];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"BogoNetworkIndexModel"];
        BogoNetworkInitModel *model = [BogoNetworkInitModel mj_objectWithKeyValues:dict];
    }
    return _webView;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    // 判断是否是您希望拦截的 URL，这里的示例是以 "myapp://" 开头的 URL
    if ([url.absoluteString isEqualToString:@"bogogame://exit"]) {
        [self clickCloseBtn];

        // 自己处理逻辑，不加载该 URL
        decisionHandler(WKNavigationActionPolicyCancel);
        
    } else {
        // 允许加载该 URL
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // 判断URL是否为"bogogame://exit"，如果是，则隐藏webView
    if ([webView.URL.absoluteString isEqualToString:@"bogogame://exit"]) {
        [self clickCloseBtn];
    }
}

- (void)clickCloseBtn {
    [_webView removeFromSuperview];
}

//获取当前最上层的控制器
- (UIViewController *)getTopMostController {
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    //循环之前tempVC和topVC是一样的
    UIViewController *tempVC = topVC;
    while (1) {
        if ([topVC isKindOfClass:[UITabBarController class]]) {
            topVC = ((UITabBarController*)topVC).selectedViewController;
        }
        if ([topVC isKindOfClass:[UINavigationController class]]) {
            topVC = ((UINavigationController*)topVC).visibleViewController;
        }
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        //如果两者一样，说明循环结束了
        if ([tempVC isEqual:topVC]) {
            break;
        } else {
        //如果两者不一样，继续循环
            tempVC = topVC;
        }
    }
    return topVC;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return CGSizeMake((kScreenW-30)/2.0f, (kScreenW-30) / 2.0f + kRealValue(30));
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//
//    return 10;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//
//    return 0;
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(10, 10, 0, 10);
//}


@end
