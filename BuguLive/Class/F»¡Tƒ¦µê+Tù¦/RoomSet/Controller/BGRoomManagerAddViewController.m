//
//  BGRoomManagerAddViewController.m
//  UniversalApp
//
//  Created by bugu on 2020/3/24.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BGRoomManagerAddViewController.h"
#import "BGRoomManagerCell.h"
#import "RoomModel.h"
#import "RoomUserInfo.h"
//#import "RoomViewController.h"
//#import "BogoRoomViewController.h"

#import "BGRoomManagerSearchViewController.h"
@interface BGRoomManagerAddViewController ()
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) QMUIButton *searchBtn;
@property ( nonatomic,assign) int                              has_next;
@property ( nonatomic,assign) int                              currentPage;

@end

@implementation BGRoomManagerAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.has_next = 1;
    self.title = ASLocalizedString(@"添加管理员");
//    self.title = [NSString stringWithFormat:ASLocalizedString(@"添加%@"),self.name];

//    [self addNavigationItemWithImageNames:@[@"seach_b"] isLeft:NO target:self action:@selector(rightBtnAction) tags:@[@(1001)]];
    [self setUpView];

}
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestDataWidthPage:_currentPage];

}


- (void)refreshHeader
{
    _currentPage = 1;
    [self requestDataWidthPage:_currentPage];
}

- (void)refreshFooter
{
    [self requestDataWidthPage:_currentPage];
}


- (void)rightBtnAction {
    
    BGRoomManagerSearchViewController * vc = [[BGRoomManagerSearchViewController alloc]init];
    vc.name = self.name;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)searchBtnAction:(QMUIButton *)sender{
    [self rightBtnAction];
}
-(void)setUpView{
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.tableView.height = kScreenH - kTopHeight;
    self.tableView.backgroundColor = [UIColor clearColor];
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
  
    [self.tableView registerClass:[BGRoomManagerCell class] forCellReuseIdentifier:NSStringFromClass([BGRoomManagerCell class])];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
    self.tableView.tableHeaderView = view;
    
    [BGMJRefreshManager refresh:self.self.tableView target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];

    
    
    UILabel * titleLabel = ({
           UILabel * label = [[UILabel alloc]init];
           label.textColor = kAppGrayColor2;
           label.font = [UIFont systemFontOfSize:15];
           //        label.text = @"Title";
           label.textAlignment = NSTextAlignmentCenter;
           label;
       });
    
    [view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
    }];
    
    self.titleLabel = titleLabel;
    
    
    [self.view addSubview:self.searchBtn];
    
    [self.searchBtn setTitle:ASLocalizedString(@"搜索用户ID/昵称") forState:UIControlStateNormal];
    [self.searchBtn setTitleColor:[UIColor colorWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
    self.searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(20);
           make.centerX.mas_equalTo(0);
           make.top.equalTo(titleLabel.mas_bottom).offset(18);
           make.height.mas_equalTo(33);
       }];
    
    
}

- (void)requestDataWidthPage:(int)page {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"audience_list_2405" forKey:@"act"];
    [dict setValue:SafeStr(self.model.room_id) forKey:@"room_id"];
    [dict setValue:@(page) forKey:@"page"];
    
    
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
- (void)requestDataHost {
    __weak __typeof(self)weakSelf = self;
    //http://www.bogo.voice.broadcast/mapi/public/index.php/api/Voice_api/sel_voice_administrator
//    NSString *url = [[CYURLUtils sharedCYURLUtils] makeVoiceURLWithC:@"voice_additional_api" A:@"voice_user_list"];
//
//    [CYNET POSTv2:url parameters:@{@"voice_id":self.model.voice.user_id} responseCache:^(id responseObject) {
//        //do nothing
//    } success:^(id responseObject) {
//        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            //搜索页面返回 应刷新数据源
//            [strongSelf.dataArray removeAllObjects];
//            for (NSDictionary *dict in responseObject[@"userlist"]) {
//                RoomUserInfo *info = [RoomUserInfo mj_objectWithKeyValues:dict];
//                [strongSelf.dataArray addObject:info];
//            }
//            [strongSelf.titleLabel setText:[NSString stringWithFormat:ASLocalizedString(@"当前房间在线用户（%ld人）"),strongSelf.dataArray.count]];
//
//            [strongSelf.tableView reloadData];
//        }
//    } failure:^(NSString *error) {
//        [[BGHUDHelper sharedInstance] tipMessage:error];
//    } hasCache:NO];
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

- (QMUIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[QMUIButton alloc]initWithFrame:CGRectZero];
        _searchBtn.imagePosition = QMUIButtonImagePositionLeft;
        _searchBtn.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        _searchBtn.spacingBetweenImageAndTitle = 30;
        [_searchBtn setImage:[UIImage imageNamed:@"seach_s"] forState:UIControlStateNormal];
        [_searchBtn setTitle:@"" forState:UIControlStateNormal];
        _searchBtn.layer.cornerRadius = 16.5;
        _searchBtn.clipsToBounds = YES;
        [_searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
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
