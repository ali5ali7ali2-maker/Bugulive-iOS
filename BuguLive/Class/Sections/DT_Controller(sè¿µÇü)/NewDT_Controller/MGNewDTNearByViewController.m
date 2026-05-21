//
//  MGNewDTNearByViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGNewDTNearByViewController.h"
#import "ReleaseTopicVC.h"
#import "BGTopicTimeLineListController.h"


@interface MGNewDTNearByViewController ()


@property(nonatomic, strong) NSMutableArray *listArr;
@property(nonatomic, assign) NSInteger pageIndex;


@end

@implementation MGNewDTNearByViewController

- (instancetype)initWithType:(MGNEWDT_TYPE)type{
    MGNewDTNearByViewController *vc = [MGNewDTNearByViewController new];
    vc.type = type;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = self.type == MGNEWDTTYPE_NEAR_PEOPLE ? ASLocalizedString(@"附近的人"): ASLocalizedString(@"全部话题");
    
    if (self.type == MGNEWDTTYPE_TOPIC) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickSearch:) image:@"mg_topic_search" highImage:@"mg_topic_search"];
    }
    
    [self backBtnWithBlock];
    [self setUpView];
    self.pageIndex = 1;
    [self requestPageIndex:self.pageIndex];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    self.navigationController.navigationBar.hidden = NO;
}

- (void)backBtnWithBlock
{
    // 返回按钮
    [self setupBackBtnWithBlock:nil];
}

-(void)clickSearch:(UIBarButtonItem *)sender{
    //进入话题页面
    ReleaseTopicVC *tmpController = [[ReleaseTopicVC alloc]init];
    __weak __typeof(self)weakSelf = self;;
    tmpController.releaseTopicBlock = ^(MGDynamicTopicModel * _Nonnull topic) {
        
    BGTopicTimeLineListController *pushVC = [BGTopicTimeLineListController new];
    pushVC.topic = topic;
        [[AppDelegate sharedAppDelegate]pushViewController:pushVC animated:YES];
        
//        weakSelf.topicTipBtn.hidden = YES;
//        weakSelf.topicBtn.hidden = NO;
//        weakSelf.selectedTopicID = topic.t_id;
//        [weakSelf.topicBtn setTitle:[NSString stringWithFormat:@"#%@#",topic.name] forState:UIControlStateNormal];
//        CGSize btnSize = [self preferredSizeWithMaxWidth:kScreenW-100 view:weakSelf.topicBtn];
//
//        weakSelf.topicBtn.frame = CGRectMake(kScreenW-btnSize.width-10, 15, btnSize.width, 24);
    };
    [self.navigationController pushViewController:tmpController animated:YES];
}

- (void)requestPageIndex:(NSInteger)pageIndex{
    
    if (pageIndex == 1) {
        self.listArr = [NSMutableArray array];
    }
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    
    if (self.type == MGNEWDTTYPE_NEAR_PEOPLE) {
        [parmDict setObject:@"fujin_user" forKey:@"act"];
    }else if (self.type == MGNEWDTTYPE_TOPIC){
        [parmDict setObject:@"dynamic_theme" forKey:@"act"];
        [parmDict setObject:@"" forKey:@"key_word"];
        [parmDict setObject:@"0" forKey:@"all"];//1取全部,0是取分页数据
    }
    
    [parmDict setObject:[NSString stringWithFormat:@"%ld",pageIndex] forKey:@"p"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            
            NSArray *arr = responseJson[@"data"];
            if ([arr isKindOfClass:[NSArray class]])
            {
                if (arr.count > 0)
                {
                    for (NSDictionary *dic in arr)
                    {
                        if (self.type == MGNEWDTTYPE_NEAR_PEOPLE) {
                            MGNewDTNearlistModel *model = [MGNewDTNearlistModel modelWithDictionary:dic];
                            [self.listArr addObject:model];
                        }else if(self.type == MGNEWDTTYPE_TOPIC){
                            MGDynamicTopicModel *model = [MGDynamicTopicModel itemWithDic:dic];
//                        modelWithDictionary:dic];
                            [self.listArr addObject:model];
                        }
                    }
                }
            }
            [self.tableView reloadData];
        }else{
            [BGHUDHelper alert:[responseJson valueForKey:@"error"]];
        }

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } FailureBlock:^(NSError *error) {

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

-(void)setUpView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource =self;
    _tableView.delegate =self;
    _tableView.backgroundColor = kWhiteColor;
    [_tableView registerClass:[MGNewDTNearPeopleCell class] forCellReuseIdentifier:@"MGNewDTNearPeopleCell"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    [BGMJRefreshManager refresh:self.tableView target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];
}

-(void)refreshHeader{
    self.pageIndex = 1;
    [self requestPageIndex:self.pageIndex];
}

-(void)refreshFooter{
    self.pageIndex ++ ;
    [self requestPageIndex:self.pageIndex];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRealValue(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGNewDTNearPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MGNewDTNearPeopleCell"];
    if (self.listArr.count > 0) {
        [cell resetModelWithModel:self.listArr[indexPath.row] type:self.type];
    }
    
    if (self.type == MGNEWDTTYPE_TOPIC) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"com_arrow_right_1"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == MGNEWDTTYPE_TOPIC) {
        MGDynamicTopicModel *topicModel = self.listArr[indexPath.row];
        BGTopicTimeLineListController *pushVC = [BGTopicTimeLineListController new];
        pushVC.topic = topicModel;
        [[AppDelegate sharedAppDelegate]pushViewController:pushVC animated:YES];
    }else if (self.type == MGNEWDTTYPE_NEAR_PEOPLE){
        MGNewDTNearlistModel *nearModel = self.listArr[indexPath.row];
        SHomePageVC *tmpController= [[SHomePageVC alloc]init];
        tmpController.user_id = nearModel.id;
        tmpController.type = 0;
        [[AppDelegate sharedAppDelegate]pushViewController:tmpController animated:YES];
    }
}



@end
