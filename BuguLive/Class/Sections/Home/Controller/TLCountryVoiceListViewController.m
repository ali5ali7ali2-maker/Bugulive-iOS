//
//  VideoViewController.m
//  BuguLive
//
//  Created by 王珂 on 17/5/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "TLCountryVoiceListViewController.h"
#import "VideoCollectionViewCell.h"
#import "HMHotModel.h"

#import "NewestItemCell.h"
#import "LeaderboardViewController.h"
#import "BogoSearchViewController.h"
#import "CountryView.h"
#import "TLVoiceListSectionHeaderView.h"
#import "CountryPopupView.h"
@interface TLCountryVoiceListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CountryPopupViewDelegate>

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int has_next;
@property (nonatomic, assign) BOOL canClickItem;
@property (nonatomic, strong) HMHotModel * videoModel;
@property (nonatomic, weak) UIScrollView *currentScrollView;
@property (nonatomic, strong) UIView           *headerView;
@property(nonatomic, strong) CountryView *countryView;

@end

@implementation TLCountryVoiceListViewController

- (void)addHeaderRefresh {
    __weak __typeof(self) weakSelf = self;
    self.currentScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf) self = weakSelf;
        [self.currentScrollView.mj_header endRefreshing];
    }];
    
    self.currentScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载");
        [self.currentScrollView.mj_footer endRefreshing];
        [self footerRereshing];

    }];
    
}
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
    [self setupBackBtnWithBlock:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];


    self.navigationController.navigationBar.hidden = NO;
    
//    [self setNetworing:1];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)createView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8F8"];
    [self.view addSubview:self.headerView];
    
    //价格背景避免下拉是白色
    
    
    UIImageView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kScreenW-20, 73)];
    ViewRadius(navView, 13);
//    navView.backgroundColor = [UIColor colorWithHexString:@"#FBE2FF"];
    navView.userInteractionEnabled = YES;
    navView.backgroundColor = [UIColor colorWithHexString:@"#AAD2F0"];
    navView.image = [UIImage imageNamed:@""];

    //navView左面添加国旗，和一个国家名称
    UIImageView *flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, navView.height/2-15, 30, 30)];
    [flagImageView sd_setImageWithURL:[NSURL URLWithString:self.country[@"img"]]];
    [navView addSubview:flagImageView];
    UILabel *countryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(flagImageView.right + 10, 15, 100, 30)];
    countryNameLabel.centerY = flagImageView.centerY;
    countryNameLabel.text = self.country[@"name"];
    countryNameLabel.textColor = [UIColor colorWithHexString:@"#6280BF"];
    countryNameLabel.font = [UIFont systemFontOfSize:15];
    [navView addSubview:countryNameLabel];
    
    [self.view addSubview:navView];
    


    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init] ;
    flow.sectionHeadersPinToVisibleBounds = YES;
//    CGFloat itemW = (self.viewFrame.size.width-3)/2.0;
//    CGFloat itemH = (self.viewFrame.size.width-3)/2.0;
//    //设置cell的大小
//    flow.itemSize = CGSizeMake(itemW, itemH) ;
//    flow.minimumLineSpacing = 3;
//    flow.minimumInteritemSpacing = 3;
//    flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10) ;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44+StatusBarHeight+200, kScreenW, kScreenHeight) collectionViewLayout:flow];
    self.currentScrollView = self.collectionView;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = kWhiteColor;
//    _collectionView.tag = 1107;
    [_collectionView registerNib:[UINib nibWithNibName:@"NewestItemCell" bundle:nil] forCellWithReuseIdentifier:@"NewestItemCell"];
//    [_collectionView registerClass:[NewestItemCell class] forCellWithReuseIdentifier:@"NewestItemCell"];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TLVoiceListSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TLVoiceListSectionHeaderView"];

    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView.mas_bottom).offset(8);
        make.bottom.equalTo(self.view).offset(0.);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
    }];
    
    [BGMJRefreshManager refresh:self.self.collectionView target:self headerRereshAction:@selector(headerReresh) footerRereshAction:@selector(refreshFooter)];

    [BGMJRefreshManager refresh:_collectionView target:self headerRereshAction:@selector(headerReresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerRereshing)];
    _canClickItem = YES;
    
    [self headerReresh];
}



- (void)refreshFooter {
    
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
//        [BGMJRefreshManager endRefresh:_collectionView];
    }
}

-(void)setTypes:(NSString *)types
{
    _types = types;
    [self headerReresh];
}

- (void)setNetworing:(int)page
{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    

    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"voice_index" forKey:@"act"];
    
    [parmDict setObject:@"1" forKey:@"is_voice"];
    [parmDict setObject:[NSString stringWithFormat:@"%@",self.country[@"num_code"]] forKey:@"country_code"];

    [parmDict setObject:@(page) forKey:@"p"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            self.has_next = [responseJson toInt:@"has_next"];
//            self.page = [responseJson toInt:@"page"];
            if (page == 1)
            {
                [self.dataArray removeAllObjects];
            }
            
            if([self.types isEqualToString:@"0"])
            {
                NSMutableArray *array = [NSMutableArray array];
                for (int i=0; i<((NSArray *)responseJson[@"data"]).count; i++) {
                    [array addObject:[HMHotItemModel modelWithJSON:((NSArray *)responseJson[@"data"])[i]]];
                    
                    [array addObject:[HMHotItemModel modelWithJSON:((NSArray *)responseJson[@"data"])[i]]];

                    [array addObject:[HMHotItemModel modelWithJSON:((NSArray *)responseJson[@"data"])[i]]];
                    [array addObject:[HMHotItemModel modelWithJSON:((NSArray *)responseJson[@"data"])[i]]];
                    [array addObject:[HMHotItemModel modelWithJSON:((NSArray *)responseJson[@"data"])[i]]];
                    [array addObject:[HMHotItemModel modelWithJSON:((NSArray *)responseJson[@"data"])[i]]];
                    [array addObject:[HMHotItemModel modelWithJSON:((NSArray *)responseJson[@"data"])[i]]];
                    [array addObject:[HMHotItemModel modelWithJSON:((NSArray *)responseJson[@"data"])[i]]];
                    [array addObject:[HMHotItemModel modelWithJSON:((NSArray *)responseJson[@"data"])[i]]];

                }
//                self.videoModel = [HMHotModel mj_objectWithKeyValues:responseJson[@"data"]];
                [self.dataArray addObjectsFromArray:array];
                [self.collectionView reloadData];
            }
            else
            {
                self.videoModel = [HMHotModel mj_objectWithKeyValues:responseJson];
                [self.dataArray addObjectsFromArray:self.videoModel.list];
                [self.collectionView reloadData];
            }
            
            
        }
        
        [BGMJRefreshManager endRefresh:self.collectionView];
        
//        if (!self.dataArray.count)
//        {
//            [self showNoContentView];
//        }
//        else
//        {
//            [self hideNoContentView];
//        }
        
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        [BGMJRefreshManager endRefresh:self.collectionView];
        
    }];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   
    return UIEdgeInsetsMake(0, 10, 0, 10);
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
    HMHotItemModel *model = self.dataArray[indexPath.item];
    if(model.password.length > 0)
    {
        
    }
    else
    {
        [self joinLivingRoom:self.dataArray[indexPath.item]];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"请输入房间密码")preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = ASLocalizedString(@"请输入密码");
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:ASLocalizedString(@"取消")style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:actionCacel];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:ASLocalizedString(@"确定")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *password = alertController.textFields.firstObject.text;
        NSString *md5Str = [[NSString md5String:model.password] uppercaseString];
        //转化为大写
        
        if ([password isEqualToString:model.password]) {
            [self joinLivingRoom:self.dataArray[indexPath.item]];
        }else{
            [FanweMessage alertHUD:ASLocalizedString(@"密码不正确")];
        }
    }];
    [alertController addAction:actionConfirm];
    [self presentViewController:alertController animated:YES completion:nil];
    
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
        liveRoom.is_voice = model.is_voice;
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

#pragma mark - GKPageSmoothListViewDelegate
- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (UIView *)listView {
    return self.view;
}


- (void)reloadData {
    [self.collectionView reloadData];
}

- (UIView *)headerView {
    if (!_headerView) {
       
        UIView *view = [[UIView alloc] initWithFrame:self.collectionView.bounds];
    //    view.backgroundColor = kYellowColor;
        [view addSubview:self.collectionView];
//        [view.layer insertSublayer:gradientLayer atIndex:0];
        _headerView = view;
        
    }
    return _headerView;
}

- (void)handleLiveEvent {
    if(self.topViewdelegate && [self.topViewdelegate respondsToSelector:@selector(clickLiveBtn)]){
        [self.topViewdelegate clickLiveBtn];
    }
}

-(void)clickSearch:(UITapGestureRecognizer *)sender{
//    SSearchVC *searchVC = [[SSearchVC alloc]init];
//    searchVC.searchType = @"0";
//    [[AppDelegate sharedAppDelegate] pushViewController:searchVC animated:YES];
    BogoSearchViewController *searchVC = [[BogoSearchViewController alloc]initWithNibName:@"BogoSearchViewController" bundle:[NSBundle mainBundle]];
    [[AppDelegate sharedAppDelegate] pushViewController:searchVC animated:YES];
}

- (void)clickPaihang {
    
    LeaderboardViewController *lbVCtr = [[LeaderboardViewController alloc] init];
    lbVCtr.isHiddenTabbar = YES;
    [[AppDelegate sharedAppDelegate]pushViewController:lbVCtr animated:YES];

}

 // 在collectionView:layout:referenceSizeForHeaderInSection:方法中添加以下代码
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
     return CGSizeMake(kScreenW, 44);
 }

- (void)showCountryPopup {

}

#pragma mark - CountryPopupViewDelegate

- (void)countryPopupView:(CountryPopupView *)popupView didSelectCountry:(NSDictionary *)country {
    NSLog(@"Selected country: %@", country[@"name"]);
    // 处理选择的国家
}
@end
