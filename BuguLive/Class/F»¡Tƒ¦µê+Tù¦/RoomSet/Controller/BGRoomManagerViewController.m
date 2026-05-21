//
//  BGRoomManagerViewController.m
//  UniversalApp
//
//  Created by bugu on 2020/3/24.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BGRoomManagerViewController.h"
#import "BGRoomManagerCell.h"
#import "RoomModel.h"
#import "RoomUserInfo.h"
#import "BGRoomManagerAddViewController.h"
#import "UIViewController+Bogo.h"
//#import "BogoRoomViewController.h"

@interface BGRoomManagerViewController ()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BGRoomManagerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestData];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ASLocalizedString(@"管理员");
    //返回按钮
    [self addBackButton];
    
    //添加添加按钮
    [self addRightButton];
    

    [self setUpView];
}

- (void)addRightButton {
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add1 (1)"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBtnAction {
    BGRoomManagerAddViewController * vc = [[BGRoomManagerAddViewController alloc]init];
    vc.name = self.name;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}




-(void)setUpView{
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.tableView.height = kScreenH - kTopHeight;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[BGRoomManagerCell class] forCellReuseIdentifier:NSStringFromClass([BGRoomManagerCell class])];
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
  
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
//    self.tableView.tableHeaderView = view;
    
    
    
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
        make.centerY.mas_equalTo(0);
    }];
    
    self.titleLabel = titleLabel;
}



- (void)requestData{
    __weak __typeof(self)weakSelf = self;
    

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"user" forKey:@"ctl"];
    [dict setValue:@"user_admin" forKey:@"act"];
    [dict setValue:SafeStr(self.model.room_id) forKey:@"room_id"];
    
    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1)
        {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [self.dataArray removeAllObjects];

            for (NSDictionary *dict in responseJson[@"list"]) {
                RoomUserInfo *info = [RoomUserInfo mj_objectWithKeyValues:dict];
                [strongSelf.dataArray addObject:info];
            }


//            [strongSelf.titleLabel setText:[NSString stringWithFormat:ASLocalizedString(@"%@（%ld人）"),strongSelf.name,strongSelf.dataArray.count ]];

            [strongSelf.tableView reloadData];
        }
        else
        {
            [[BGHUDHelper sharedInstance] tipMessage:responseJson[@"error"]];
        }
    } FailureBlock:^(NSError *error) {
    }];
    //http://www.bogo.voice.broadcast/mapi/public/index.php/api/Voice_api/voice_administrator
//    NSString *url = [[CYURLUtils sharedCYURLUtils] makeVoiceURLWithC:@"Voice_api" A:@"voice_administrator"];
//    
//    if ([self.name isEqualToString:@"主持人"]) {
//        url = [[CYURLUtils sharedCYURLUtils] makeVoiceURLWithC:@"voice_additional_api" A:@"voice_host_list"];
//        
//    }
    
//    [CYNET POSTv2:url parameters:@{@"voice_id":self.model.voice.user_id} responseCache:^(id responseObject) {
//        //do nothing
//    } success:^(id responseObject) {
//        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            [strongSelf.dataArray removeAllObjects];
//
//            for (NSDictionary *dict in responseObject[@"list"]) {
//                RoomUserInfo *info = [RoomUserInfo mj_objectWithKeyValues:dict];
//                [strongSelf.dataArray addObject:info];
//            }
////            RoomUserInfo *addInfo = [[RoomUserInfo alloc]init];
////            addInfo.avatar = @"http://temp.fandong.me/add@2x.png";
////            addInfo.user_nickname = @"添加管理员";
////            addInfo.user_id = @"0";
////            [strongSelf.dataArray addObject:addInfo];
//            
//            [strongSelf.titleLabel setText:[NSString stringWithFormat:ASLocalizedString(@"%@（%ld人）"),strongSelf.name,strongSelf.dataArray.count ]];
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
    
    cell.cellType = RoomManagerCellTypeCancel;
    RoomUserInfo *info = self.dataArray[indexPath.row];
    cell.info = info;
    __weak __typeof(self)weakSelf = self;

    cell.cancelActionBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        [strongSelf deleteManagerWithInfo:info];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)deleteManagerWithInfo:(RoomUserInfo *)info {

    __weak __typeof(self)weakSelf = self;
  
  NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
  [dict setValue:@"user" forKey:@"ctl"];
  [dict setValue:@"set_admin" forKey:@"act"];
  [dict setValue:SafeStr(info.user_id) forKey:@"to_user_id"];
    [dict setValue:@"2" forKey:@"status"];


  [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
      if ([responseJson toInt:@"status"] == 1)
      {
          [self requestData];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
