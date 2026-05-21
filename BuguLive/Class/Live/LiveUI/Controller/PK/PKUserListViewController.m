//
//  PKUserListViewController.m
//  FanweApp
//
//  Created by 志刚杨 on 2018/7/18.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "PKUserListViewController.h"
#import "PKUser.h"
#import "PKUserTableViewCell.h"
#import "PKPopView.h"
@interface PKUserListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableview;
@property(nonatomic, strong) NSMutableArray *userlist;
@end

@implementation PKUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview = [[UITableView alloc] init];
    self.tableview.frame = self.view.bounds;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = kWhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"PKUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"PKUserTableViewCell"];
    [self.tableview reloadData];
    [self.view addSubview:self.tableview];
    //2020-1-2 加圆角
    self.tableview.layer.cornerRadius=6;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.userlist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PKUserTableViewCell";
    PKUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PKUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    UserModel *user = self.userlist[indexPath.row];
    [cell setUser:user];
    //    cell.backgroundColor = kRandomFlatColor;
    [cell setClickPkBlock:^(UserModel *user) {
        NSInteger index = [self.userlist indexOfObject:user];
        [self selectIndex:index];
    }];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    headerView.backgroundColor = kWhiteColor;
    UILabel *onlineListLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenW - 10, 50)];
    onlineListLabel.text = ASLocalizedString(@"在线主播列表");
    onlineListLabel.font = [UIFont systemFontOfSize:17];
    onlineListLabel.textColor = kBlackColor;
    onlineListLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(kScreenW - kRealValue(44) - kRealValue(10), 0, kRealValue(44),  50);
    [closeBtn setImage:[UIImage imageNamed:@"pl_publishlive_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clockCloes:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, kScreenW, 0.5)];
    lineView.backgroundColor = kClearColor;
    //    [kBlackColor colorWithAlphaComponent:0.3];
    [headerView addSubview:closeBtn];
    [headerView addSubview:onlineListLabel];
    [headerView addSubview:lineView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(void)reloadData
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    if(![GlobalVariables sharedInstance].openAgora)
    {
        [mDict setObject:@"pk_tencent" forKey:@"ctl"];
    }
    else
    {
        [mDict setObject:@"pk_agora" forKey:@"ctl"];
    }
    
    [mDict setObject:@"get_emcee_list" forKey:@"act"];
    self.userlist = [NSMutableArray array];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            NSArray *list = responseJson[@"list"];
            [self.userlist removeAllObjects];
            for (NSDictionary * bankerDic in list)
            {
                UserModel * model = [UserModel mj_objectWithKeyValues:bankerDic];
                [self.userlist addObject:model];
            }
            [self.tableview reloadData];
        }
        else
        {
            [[BGHUDHelper sharedInstance] tipMessage:responseJson[@"msg"]];
        }
        
    } FailureBlock:^(NSError *error) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectIndex:indexPath.row];
}

-(void)clockCloes:(UIButton *)sender{
    
    if(self.pDelegate && [self.pDelegate respondsToSelector:@selector(closeUserListView)])
    {
        [self.pDelegate closeUserListView];
    }
    
}

- (void)selectIndex:(NSInteger)index{
    //弹出时间选择框
    PKPopView *invicationPopView = [[PKPopView alloc]initWithType:PKPopViewTypeInvication];
    invicationPopView.frame = CGRectMake(0, kScreenH, kScreenW, 268);
    [invicationPopView show:self.view.superview];
   // [invicationPopView show:[UIApplication sharedApplication].keyWindow];
    //2020-1-4 最上方
    //[[UIApplication sharedApplication].keyWindow.viewController.view bringSubviewToFront:invicationPopView];
    FWWeakify(self)
    [invicationPopView setClickSetTimeBlcok:^{
        FWStrongify(self)
//        invicationPopView.top = kScreenH;
        PKPopView *timePopView = [[PKPopView alloc]initWithType:PKPopViewSelectTime];
        timePopView.frame = CGRectMake(0, kScreenH, kScreenW, 268);
        [timePopView setClickTimeCellBlock:^(PKTimeModel *model) {
            [invicationPopView setPkTimeModel:model];
        }];
        [timePopView show: self.view.superview];
       // [timePopView show:[UIApplication sharedApplication].keyWindow];
        //2020-1-4 最上方
        //[[UIApplication sharedApplication].keyWindow.viewController.view bringSubviewToFront:timePopView];
    }];
    
    
    [invicationPopView setClickPkBtnBlock:^(NSString * _Nonnull pk_list_id) {    
        UserModel *user = self.userlist[index];
//        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
//        [mDict setObject:@"pk_tencent" forKey:@"ctl"];
//        [mDict setObject:@"request_pk" forKey:@"act"];
//        [mDict setObject:user.user_id forKey:@"pk_emcee_id"];
//        [mDict setObject:pk_list_id forKey:@"pk_list_id"];
//        
        __weak __typeof(self)weakSelf = self;
//        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
//            
//            if ([responseJson toInt:@"status"] == 1)
//            {
//                NSNumber *pk_id = [responseJson objectForKey:@"pk_id"];
//                user.pk_id = pk_id.stringValue;
                if([self.pDelegate respondsToSelector:@selector(PKUserClickItem:pk_id:)])
                {
                    [weakSelf.pDelegate PKUserClickItem:user pk_id:pk_list_id];
                }
//            }
//            else
//            {
//                [[BGHUDHelper sharedInstance] tipMessage:responseJson[@"msg"]];
//            }
//            
//        } FailureBlock:^(NSError *error) {
//        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSNumber *)xy_noDataViewCenterYOffset{
    return [NSNumber numberWithInt: - kScreenH/4 + 50 + 20];
}

@end
