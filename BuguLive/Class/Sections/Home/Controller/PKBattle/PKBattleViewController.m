//
//  PKBattleViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/30.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "PKBattleViewController.h"

#import "PKBattleListCell.h"
#import "PKBattleListModel.h"



@interface PKBattleViewController ()<PKBattleDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *listArr;

@property(nonatomic, assign) NSInteger page;

@end

@implementation PKBattleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ASLocalizedString(@"PK对战");
    
    self.view.backgroundColor = kWhiteColor;
}

- (void)initFWData{
    [super initFWData];
    self.listArr = [NSMutableArray array];
    self.page = 0;
    
    [self loadDataWithPage:self.page];
}

-(void)loadDataWithPage:(NSInteger)index{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];

    if(![GlobalVariables sharedInstance].openAgora)
    {
        [mDict setObject:@"pk_tencent" forKey:@"ctl"];
    }
    else
    {
        [mDict setObject:@"pk_agora" forKey:@"ctl"];
    }

    [mDict setObject:@"get_pk_lists" forKey:@"act"];
    [mDict setObject:[BGIMLoginManager sharedInstance].loginParam.identifier forKey:@"user_id"];
    [mDict setObject:[NSString stringWithFormat:@"%ld",index] forKey:@"page"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            NSArray *list = responseJson[@"data"];
            [self.listArr removeAllObjects];
            for (NSDictionary * bankerDic in list)
            {
                PKBattleListModel * model = [PKBattleListModel mj_objectWithKeyValues:bankerDic];
                [self.listArr addObject:model];
            }
            
            if (self.listArr.count > 0) {
                [self hideNoContentView];
            }else{
                
                [self showNoContentView];
//                }
            }
            [self.tableView reloadData];
        }
        else
        {
            if (self.page == 0) {
                [self.listArr removeAllObjects];
                [self.tableView reloadData];
                [self showNoContentView];
            }
            
            
            
//            [[BGHUDHelper sharedInstance] tipMessage:responseJson[@"msg"]];
        }
        
        [BGMJRefreshManager endRefresh:_tableView];
        
    } FailureBlock:^(NSError *error) {
        
        [BGMJRefreshManager endRefresh:_tableView];
        
    }];
}


#pragma mark 头部刷新
- (void)headerReresh
{
    [self loadDataWithPage:0];
}

#pragma mark 尾部刷新
- (void)footerReresh
{
    _page ++;
    [self loadDataWithPage:_page];
}

- (void)initFWUI
{
    [super initFWUI];
    
    [self setupBackBtnWithBlock:nil];
    self.title = ASLocalizedString(@"PK对战");
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRealValue(230);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PKBattleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PKBattleListCell"];
    
    cell.model = self.listArr[indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark NewestViewController跳转到直播

-(void)clickBattleModel:(PKBattleListModel *)model LeftOrRight:(BOOL)isLeft{
    

    if (![BGUtils isNetConnected])
    {
        return;
    }
    
    [self.BuguLive.newestLivingMArray removeAllObjects];
    [self.BuguLive.newestLivingMArray addObject:model];
    
    if ([self checkUser:[IMAPlatform sharedInstance].host])
    {
        TCShowLiveListItem *item = [[TCShowLiveListItem alloc]init];
        //点击左边主播
        if (isLeft) {
            item.chatRoomId = model.group_id1;
            item.avRoomId = model.room_id1.intValue;
            item.title = model.room_id1;
            item.vagueImgUrl = model.head_image1;
//            item.is_voice = model.is_voice;

            TCShowUser *showUser = [[TCShowUser alloc]init];
            showUser.uid = model.emcee_user_id1;
            showUser.avatar = model.head_image1;
            item.host = showUser;

            item.liveType = FW_LIVE_TYPE_AUDIENCE;
        }else{
            item.chatRoomId = model.group_id2;
            item.avRoomId = model.room_id2.intValue;
            item.title = model.room_id2;
            item.vagueImgUrl = model.head_image2;
//            item.is_voice = model.is_voice;

            TCShowUser *showUser = [[TCShowUser alloc]init];
            showUser.uid = model.emcee_user_id2;
            showUser.avatar = model.head_image2;
            item.host = showUser;

            item.liveType = FW_LIVE_TYPE_AUDIENCE;
        }
        
        
        if ([LiveCenterManager sharedInstance].itemModel) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"clickLiveRoomNotification" object:nil];
        }
        
        [LiveCenterManager sharedInstance].itemModel=item;
        
        //2020-1-7 小直播变大
        [LiveCenterManager sharedInstance].itemModel=item;
        BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
        [[LiveCenterManager sharedInstance]  showLiveOfAudienceLiveofTCShowLiveListItem:item modelArr:nil isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL isFinished) {

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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = 1107;
        [_tableView registerNib:[UINib nibWithNibName:@"PKBattleListCell" bundle:nil] forCellReuseIdentifier:@"PKBattleListCell"];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [BGMJRefreshManager refresh:_tableView target:self headerRereshAction:@selector(headerReresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerReresh)];
        
    }
    return _tableView;
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
