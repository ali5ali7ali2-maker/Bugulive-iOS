//
//  BogoNewsLikesViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/7.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoNewsLikesViewController.h"
#import "BogoNewsLikesCell.h"
#import "BogoNewsHeadTypeModel.h"

#import "DetailsLineViewController.h"
#import "HMVideoPlayerViewController.h"

@interface BogoNewsLikesViewController ()

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *listArr;

@property(nonatomic, assign) NSInteger page;

@end

@implementation BogoNewsLikesViewController

- (instancetype)initWithNewsType:(BOGONEWS_TYPE)newType{
    BogoNewsLikesViewController *vc = [BogoNewsLikesViewController new];
    vc.newType = newType;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.newType == BOGONEWS_TYPE_LIKES) {
        self.title = ASLocalizedString(@"点赞");
    }else{
        self.title = ASLocalizedString(@"评论");
    }
    
    
    self.view.backgroundColor = kWhiteColor;
}

- (void)initFWData{
    [super initFWData];
    self.listArr = [NSMutableArray array];
    self.page = 1;
    
    [self loadDataWithPage:self.page];
}

-(void)loadDataWithPage:(NSInteger)index{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    [mDict setObject:@"dynamic" forKey:@"ctl"];
    
    if (self.newType == BOGONEWS_TYPE_LIKES) {
        [mDict setObject:@"bzone_like_list" forKey:@"act"];
    }else{
        [mDict setObject:@"get_comments_list" forKey:@"act"];
    }
    
    
    [mDict setObject:[NSString stringWithFormat:@"%ld",index] forKey:@"p"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            if (index == 1) {
                [self.listArr removeAllObjects];
            }
            NSArray *list = [NSArray modelArrayWithClass:[BogoNewsHeadTypeModel class] json:responseJson[@"list"]];
//            [NSArray modelWithDictionary:responseJson[@"list"]];
          
            [self.listArr addObjectsFromArray:list];
            
            if (self.listArr.count > 0) {
                [self hideNoContentView];
            }else{
//                if (!self.noContentView) {
                    [self showNoContentView];
//                }
            }
            [self.tableView reloadData];
        }
        else
        {
            if (self.page == 1) {
                [self.listArr removeAllObjects];
                [self.tableView reloadData];
                [self showNoContentView];
            }
        }
        
        [BGMJRefreshManager endRefresh:_tableView];
        
    } FailureBlock:^(NSError *error) {
        
        [BGMJRefreshManager endRefresh:_tableView];
        
    }];
}

#pragma mark 头部刷新
- (void)headerReresh
{
    [self loadDataWithPage:1];
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
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRealValue(104);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BogoNewsLikesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoNewsLikesCell"];
    [cell resetContentWithModel:self.listArr[indexPath.row] type:self.newType];
//    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BogoNewsHeadTypeModel *oriModel = self.listArr[indexPath.row];
    oriModel.video_url = oriModel.info.video_url;
    oriModel.user_id = oriModel.uid;
    MGGroupUserInfo *model = [MGGroupUserInfo mj_objectWithKeyValues:oriModel.mj_keyValues];
    if (model.type == DynType_Original) {
        DetailsLineViewController *datails = [DetailsLineViewController new];
        datails.title = ASLocalizedString(@"动态详情");
        model.content = model.msg_content;

        model.nick_name = [GlobalVariables sharedInstance].userModel.nick_name;
        model.head_image = [GlobalVariables sharedInstance].userModel.head_image;
        model.timing = oriModel.addtime;
        datails.model = model;
        datails.model.id = model.dynamic_id;
        datails.dynamic_id = model.dynamic_id;
    //    datails.refreshData = ^{
    //        _currentRequestPage = 1;
    //        self.logic.page = _currentRequestPage;
    //        [self.logic loadListDataWithAct:self.homeType];
    //    };
        
        [[AppDelegate sharedAppDelegate] pushViewController:datails animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [AppDelegate sharedAppDelegate].topViewController.hidesBottomBarWhenPushed = YES;
    }else{
        SmallVideoListModel *videoModel = [SmallVideoListModel mj_objectWithKeyValues:model.mj_keyValues];
        videoModel.weibo_id = oriModel.dynamic_id;
        videoModel.user_id = [BGIMLoginManager sharedInstance].loginParam.identifier;
        videoModel.head_image = [GlobalVariables sharedInstance].userModel.head_image;
        
        videoModel.nick_name = [GlobalVariables sharedInstance].userModel.nick_name;
        
        HMVideoPlayerViewController *vc = [[HMVideoPlayerViewController alloc]initWithVideos:@[videoModel] index:0 IsPushed:YES requestDict:nil];
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"BogoNewsLikesCell" bundle:nil] forCellReuseIdentifier:@"BogoNewsLikesCell"];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.tag = 1107;
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
