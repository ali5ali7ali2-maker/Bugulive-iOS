//
//  BGSystemMsgVC.m
//  BuguLive
//
//  Created by bugu on 2019/12/16.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGSystemMsgVC.h"
#import "BGSystemMsgContentCell.h"
#import "BGSystemMsgImageCell.h"
#import "BzoneLogic.h"
#import "YHRefreshTableView.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

@interface BGSystemMsgVC ()<UITableViewDelegate,UITableViewDataSource,BzoneLogicDelegate>{
    int _currentRequestPage; //当前请求页面
    BOOL _reCalculate;
}

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BzoneLogic *logic;

@end

@implementation BGSystemMsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = ASLocalizedString(@"系统消息");
    self.logic = [BzoneLogic new];
     
    self.logic.page = 1;
    _logic.delegagte = self;
    _logic.isGZ = YES;
    [_logic loadMsg_ListData];
     
    [self requestDataLoadNew:YES];
     
    [self backBtnWithBlock];
    
    
}

- (void)backBtnWithBlock
{
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onReturnBtnPress) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
}
- (void)onReturnBtnPress
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark 初始化变量
- (void)initFWVariables
{
    [super initFWVariables];

}

#pragma mark UI创建
- (void)initFWUI
{
    [super initFWUI];
    [self.view addSubview:self.tableView];
    
    [BGMJRefreshManager refresh:self.tableView target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];

}
#pragma mark - 网络请求
- (void)requestDataLoadNew:(BOOL)loadNew{
    YHRefreshType refreshType;
    if (loadNew) {
        _currentRequestPage = 1;
        refreshType = YHRefreshType_LoadNew;
//        [self.tableView setNoMoreData:NO];
    }
    else{
        _currentRequestPage ++;
        refreshType = YHRefreshType_LoadMore;
    }
    
    if (loadNew) {
        [self.dataArray removeAllObjects];
    }
    
    _logic.page = _currentRequestPage;
 
    [_logic loadMsg_ListData];
}

-(void)requestZoneListDataCompleted
{
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
    
    self.dataArray = _logic.dataArray;
    if(_logic.noHasMore == YES)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [BGMJRefreshManager endRefresh:self.tableView];
}

-(void)refreshHeader{
    [self requestDataLoadNew:YES];
}

-(void)refreshFooter{
    [self requestDataLoadNew:NO];
}
#pragma mark 加载数据
- (void)initFWData
{
    [super initFWData];

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
    BGSystemMsgModel *model  = self.dataArray[indexPath.row];
    if (model.type.intValue == 1) {
      CGFloat  height = [BGSystemMsgContentCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                      BGSystemMsgContentCell *cell = (BGSystemMsgContentCell *)sourceCell;
                      
                      cell.model = model;
                      
                  }];
        return height;
           
    }
    
    CGFloat  height = [BGSystemMsgImageCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                     BGSystemMsgImageCell *cell = (BGSystemMsgImageCell *)sourceCell;
                     
                     cell.model = model;
                     
                 }];
       return height;
   
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BGSystemMsgModel *model  = self.dataArray[indexPath.row];
    if (model.type.intValue == 1) {
        BGSystemMsgContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BGSystemMsgContentCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }
    BGSystemMsgImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BGSystemMsgImageCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   //有链接的跳转
    BGSystemMsgModel *model  = self.dataArray[indexPath.row];
    NSString * url = model.link_url;
    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:url isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
    tmpController.navTitleStr = model.title;
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
       
    self.navigationController.navigationBarHidden = YES;

}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[BGSystemMsgContentCell class] forCellReuseIdentifier:NSStringFromClass([BGSystemMsgContentCell class])];
        [_tableView registerClass:[BGSystemMsgImageCell class] forCellReuseIdentifier:NSStringFromClass([BGSystemMsgImageCell class])];

        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
