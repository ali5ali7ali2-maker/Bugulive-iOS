//
//  SSearchVC.m
//  BuguLive
//
//  Created by 丁凯 on 2017/6/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SSearchVC.h"
#import "FollowerTableViewCell.h"
#import "SenderModel.h"
#import "BogoSearchListView.h"

#import "BogoSearchNavTopView.h"


@interface SSearchVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,loadAgainDelegate>

@property (nonatomic, strong) UITextField           *myTextFiled;             //搜索TextField
@property (nonatomic, strong) NSMutableArray        *userDataArray;
@property (nonatomic, strong) UITableView           *displayTabel;
@property (nonatomic, assign) int                   has_next;
@property (nonatomic, assign) int                   currentPage;


@property(nonatomic, strong) BogoSearchListView *searchListView;
@property(nonatomic, strong) BogoSearchNavTopView *navView;

@end

@implementation SSearchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
}

- (void)initFWUI
{
    [super initFWUI];
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.searchListView];
    
    
    _displayTabel = [[UITableView alloc]init];
    _displayTabel.frame = CGRectMake(0,self.navView.bottom,kScreenW, kScreenH-self.navView.bottom);
    _displayTabel.delegate =self;
    _displayTabel.dataSource =self;
    _displayTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    _displayTabel.backgroundColor = kWhiteColor;
    
    
//    [self showMyHud];
    [_displayTabel registerNib:[UINib nibWithNibName:@"FollowerTableViewCell" bundle:nil] forCellReuseIdentifier:@"FollowerTableViewCell"];
    
    [BGMJRefreshManager refresh:_displayTabel target:self headerRereshAction:@selector(headerReresh) footerRereshAction:@selector(footerReresh)];

    _displayTabel.hidden = YES;
    [self.view addSubview:_displayTabel];
    
    
//    [self searchbarDisplay];
}

- (void)initFWData
{
    [super initFWData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.myTextFiled.hidden = NO;
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.myTextFiled.hidden = YES;
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

#pragma mark 搜索栏
- (void)searchbarDisplay
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    
    // 右上角按钮
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, kNavigationBarHeight)];
    [rightButton setImage:[UIImage imageNamed:@"hm_search"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchBtn) image:@"hm_search" highImage:@"hm_search"];
    
    [self.navigationController.navigationBar addSubview:self.myTextFiled];
    
    
    
}

- (void)searchBtn
{
    if (!self.myTextFiled.text.length)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"请输入用户名或用户ID")];
        return;
    }else
    {
        [self.myTextFiled resignFirstResponder];
        [self loadNetDataWithPage:1 andTextFiledStr:self.myTextFiled.text];
    }
}

#pragma mark 头部刷新
- (void)headerReresh
{
    [self loadNetDataWithPage:1 andTextFiledStr:self.myTextFiled.text];
}

#pragma mark 尾部刷新
- (void)footerReresh
{
    if (_has_next == 1)
    {
        _currentPage ++;
        [self loadNetDataWithPage:_currentPage andTextFiledStr:self.myTextFiled.text];
    }
    else
    {
        [BGMJRefreshManager endRefresh:_displayTabel];
    }
}

#pragma mark 监听改变按钮
- (void)textFieldDidChange:(UITextField *) sender
{
    [self loadNetDataWithPage:_currentPage andTextFiledStr:sender.text];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.searchListView.hidden = YES;
    _displayTabel.hidden = NO;
    
    if (self.searchListView.listArr.count > 0) {
        [self hideNoContentView];
    }else{
        [self showNoContentView];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length < 1) {
        _displayTabel.hidden = YES;
        self.searchListView.hidden = NO;
        [self hideNoContentView];
    }
}

#pragma mark 返回
- (void)comeBack
{
    [self.myTextFiled resignFirstResponder];
    [[AppDelegate sharedAppDelegate]popViewController];
}

#pragma mark 请求数据
- (void)loadNetDataWithPage:(int)page andTextFiledStr:(NSString *)TextFiledStr
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user" forKey:@"ctl"];
    [parmDict setObject:@"search" forKey:@"act"];
    if(TextFiledStr.length > 0)
    {
        [parmDict setObject:TextFiledStr forKey:@"keyword"];
    }
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"p"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if (responseJson)
         {
             if (responseJson.count)
             {
                 if ([responseJson toInt:@"status"] == 1)
                 {
                     _currentPage = [responseJson toInt:@"page"];
                     if (_currentPage == 1 || _currentPage == 0)
                     {
                         [self.userDataArray removeAllObjects];
                     }
                     _has_next = [responseJson toInt:@"has_next"];
                     
                     NSArray *listArray = [responseJson objectForKey:@"list"];
                     if (listArray && [listArray isKindOfClass:[NSArray class]])
                     {
                         if (listArray.count)
                         {
                             for (NSDictionary *dict in listArray)
                             {
                                 SenderModel *sModel = [SenderModel mj_objectWithKeyValues:dict];
                                 [_userDataArray addObject:sModel];
                             }
                         }
                     }
                     [_displayTabel reloadData];
                     
                     if (!self.displayTabel.hidden) {
                         if (_userDataArray.count > 0)
                         {
                             [self hideNoContentView];
                         }else
                         {
                             [self showNoContentView];
                         }
                     }
                 }
             }
         }
         [BGMJRefreshManager endRefresh:_displayTabel];
         
     } FailureBlock:^(NSError *error){
         
         FWStrongify(self)
         [self hideMyHud];
         [BGMJRefreshManager endRefresh:self.displayTabel];
         
     }];
}

#pragma mark ----tabelView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _userDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65*kAppRowHScale;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (_userDataArray.count > 0 && indexPath.section < _userDataArray.count)
    {
        cell.hidden = NO;
        SenderModel *model = _userDataArray[indexPath.section];
        [cell creatCellWithModel:model WithRow:(int)indexPath.section];
    }else
    {
        cell.hidden = YES;
    }
    return cell;
}

#pragma mark 点击头像重新加载某一段
- (void)loadAgainSection:(int)section withHasFonce:(int)hasFonce
{
    SenderModel *model = _userDataArray[section];
    if (hasFonce == 1)
    {
        model.follow_id = @"1";
    }
    else
    {
        model.follow_id = @"0";
    }
    _userDataArray[section] = model;
    [_displayTabel reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_userDataArray.count > 0 && indexPath.section < _userDataArray.count)
    {
        SenderModel *sModel = _userDataArray[indexPath.section];
        SHomePageVC *homeVC = [[SHomePageVC alloc]init];
        homeVC.user_id = sModel.user_id;
        homeVC.type = 0;
        [[AppDelegate sharedAppDelegate]pushViewController:homeVC animated:YES];
    }
}

#pragma mark ------------------------------------getter方法------------------------------------
- (UITextField *)myTextFiled
{
    if (!_myTextFiled)
    {
        _myTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(50*kScaleWidth, (44-25*kScaleWidth)/2, kScreenW -100*kScaleWidth, 25*kScaleWidth)];
        _myTextFiled.backgroundColor = kBackGroundColor;
        _myTextFiled.layer.cornerRadius = 25*kScaleWidth/2;
        _myTextFiled.textAlignment = NSTextAlignmentCenter;
        _myTextFiled.font = [UIFont systemFontOfSize:12];
        _myTextFiled.delegate = self;
        [_myTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _myTextFiled.clearsOnBeginEditing = NO;
//        _myTextFiled.clearsContextBeforeDrawing = YES;
        _myTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _myTextFiled.leftViewMode =   UITextFieldViewModeAlways;//设置左边距显示的时机，这个表示一直显示
        _myTextFiled.placeholder = ASLocalizedString(@"请搜索用户名或用户ID");
    }
    return _myTextFiled;
}

- (NSMutableArray *)userDataArray
{
    if (!_userDataArray)
    {
        _userDataArray = [[NSMutableArray alloc]init];
    }
    return _userDataArray;
}

-(BogoSearchListView *)searchListView{
    if (!_searchListView) {
        _searchListView = [[BogoSearchListView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, kScreenW, kScreenH - self.navView.bottom - MG_BOTTOM_MARGIN)];
        _searchListView.backgroundColor = kWhiteColor;
    }
    return _searchListView;
}

-(BogoSearchNavTopView *)navView{
    if (!_navView) {
        _navView = [[BogoSearchNavTopView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW, kRealValue(40))];
        _navView.searchField.delegate = self;
        
        [_navView.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _navView;
}

@end
