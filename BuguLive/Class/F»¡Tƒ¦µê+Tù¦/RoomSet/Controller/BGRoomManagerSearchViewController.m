//
//  BGRoomManagerSearchViewController.m
//  UniversalApp
//
//  Created by bugu on 2020/5/6.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BGRoomManagerSearchViewController.h"
#import "RoomModel.h"
#import "BGRoomManagerCell.h"
#import "RoomModel.h"
#import "RoomUserInfo.h"
//#import "RoomViewController.h"
//#import "BogoRoomViewController.h"

@interface BGRoomManagerSearchViewController ()

@property(nonatomic, strong) NSMutableArray *dataAllArray;

@property(nonatomic, strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property(nonatomic, strong) UIButton *backBtn;

@property ( nonatomic,assign) int                              has_next;
@property ( nonatomic,assign) int                              currentPage;
@end

@implementation BGRoomManagerSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.isHidenNaviBar = YES;
    _currentPage = 1;
    _textField.placeholder = ASLocalizedString(@"搜索用户ID/昵称");
    [self.view addSubview:self.backBtn];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    imageView.image = [UIImage imageNamed:@"seach_s"];
    imageView.center = leftView.center;
    [leftView addSubview:imageView];
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.delegate = self;
    [self refreshHeader];
   
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self setUpView];
}
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)setUpView{
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, kStatusBarHeight+64, kScaleW,  kScaleH  - 64 - kStatusBarHeight);
//    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[BGRoomManagerCell class] forCellReuseIdentifier:NSStringFromClass([BGRoomManagerCell class])];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [BGMJRefreshManager refresh:self.self.tableView target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];

}


- (void)refreshHeader
{
    _currentPage = 1;
    [self requestData];
}

- (void)refreshFooter
{
    [self requestData];
}



- (void)requestData {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"search_audience_list_2405" forKey:@"act"];
    [dict setValue:SafeStr(self.model.room_id) forKey:@"room_id"];
    [dict setValue:SafeStr(self.textField.text) forKey:@"search_keys"];
    [dict setValue:@(_currentPage) forKey:@"page"];
    
    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        //搜索页面返回 应刷新数据源
        if(self.currentPage == 1)
        {
            [self.dataArray removeAllObjects];
        }
        
        NSArray *list = responseJson[@"data"][@"list"];
        if(list.count)
        {
            for (NSDictionary *dict in list) {
                RoomUserInfo *info = [RoomUserInfo mj_objectWithKeyValues:dict];
                if(info.is_room_administrator.intValue == 2)
                {
                    //不需要添加房主
                }
                else
                {
                    [self.dataArray addObject:info];
                }
            }
            [BGMJRefreshManager endRefresh:self.tableView];
            
            self.currentPage++;
        }
        else
        {
            [BGMJRefreshManager endRefresh:self.tableView];
        }

        

        [self.tableView reloadData];
    } FailureBlock:^(NSError *error) {
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    self.view.height = kScreenH;
//    self.tableView.height = kScreenH  - 64 - kStatusBarHeight;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (IBAction)cancelBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backBtnAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (IBAction)clearTextFieldBtnAction:(id)sender {
    self.textField.text = @"";
//    self.historyCollectionView.hidden = NO;
//    _segHead.hidden = YES;
//    _segScroll.hidden = YES;
//    [self requestData];
}

#pragma mark - QMUITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //开始检索
//    [self searchID:textField.text];
           
    return YES;
}

- (void)textFieldDidChange:(QMUITextField *)textField{
    if (textField.text.length) {
 
        //开始检索
        _currentPage = 1;
        [self searchID:textField.text];
        
    }else{
    
    }
}

- (void)searchID:(NSString *)ID {
    
    [self.dataArray removeAllObjects];
    
    for (RoomUserInfo *model in self.dataAllArray) {
        if ([model.user_id containsString:ID] || [model.nick_name containsString:ID]) {

            [self.dataArray addObject:model];
            [self.tableView reloadData];
            
        }
    }
    [self requestData];
//    [self.dataAllArray removeObjectsInArray:self.dataArray];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BGRoomManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BGRoomManagerCell class]) forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    RoomUserInfo *info = self.dataArray[indexPath.row];
    
    if(info.is_room_administrator.intValue == 1)
    {
        cell.cellType = RoomManagerCellTypeCancel;

    }
    else
    {
        cell.cellType = RoomManagerCellTypeAdd;
    }
    cell.info = info;
    
    __weak __typeof(self)weakSelf = self;
    cell.addActionBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        [strongSelf addManagerWithInfo:info];

    };
    
    cell.cancelActionBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        [strongSelf addManagerWithInfo:info];

    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)addManagerWithInfo:(RoomUserInfo *)info {
    
      __weak __typeof(self)weakSelf = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"user" forKey:@"ctl"];
    [dict setValue:@"set_admin" forKey:@"act"];
    [dict setValue:SafeStr(info.user_id) forKey:@"to_user_id"];
    //0用户,1管理员,2主播
    if(info.is_room_administrator.intValue == 1)
    {
        [dict setValue:@"2" forKey:@"status"];
    }
    else if(info.is_room_administrator.intValue == 0)
    {
        [dict setValue:@"1" forKey:@"status"];
    }
    else
    {
        return;
    }
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1)
        {
            [self refreshHeader];
        }
        else
        {
            [[BGHUDHelper sharedInstance] tipMessage:responseJson[@"error"]];
        }
    } FailureBlock:^(NSError *error) {
    }];
    

}




- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)dataAllArray{
    if (!_dataAllArray) {
        _dataAllArray = [NSMutableArray array];
    }
    return _dataAllArray;
}


- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, 44, 64)];
        [_backBtn setImage:[UIImage imageNamed:@"back_b"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

@end
