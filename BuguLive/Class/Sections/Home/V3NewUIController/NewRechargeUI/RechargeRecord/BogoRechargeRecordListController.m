//
//  BogoRechargeRecordListController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/21.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoRechargeRecordListController.h"
#import "BogoRechargeRecordHeadView.h"
#import "BogoRechageListCell.h"
#import "BogoRechargeRecordModel.h"


#import <BRPickerView.h>

@interface BogoRechargeRecordListController ()<UITableViewDelegate,UITableViewDataSource,BogoRecargeRecordHeadDelegate>

@property(nonatomic, strong) BogoRechargeRecordHeadView *headView;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *listArr;

@property(nonatomic, assign) NSInteger pageIndex;

@property(nonatomic, strong) NSString *timeStr;

@end

@implementation BogoRechargeRecordListController

-(instancetype)initRecordTypeWith:(BOGO_RECORD_TYPE)type{
    BogoRechargeRecordListController *vc = [[BogoRechargeRecordListController alloc]init];
    vc.type = type;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.listArr = [NSMutableArray array];
    
    [self setUpView];
    self.pageIndex = 1;
    
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //获取当前时间日期展示字符串 如：2019-05-23-13:58:59
    NSString *str = [formatter stringFromDate:date];
    
    self.timeStr = [str substringToIndex:7];
    [self requestModelWithIndex:self.pageIndex];
    
}


//ctl=user&act=recharge_log
-(void)requestModelWithIndex:(NSInteger)pageIndex{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    NSString *type = self.type == BOGO_RECORD_TYPE_RECHARGE ? @"1" : @"2";
    
    [parmDict setObject:type forKey:@"type"];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"coin_recode" forKey:@"act"];
    [parmDict setObject:self.timeStr forKey:@"time"];
    [parmDict setObject:[NSString stringWithFormat:@"%ld",pageIndex] forKey:@"page"];
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            
            if (pageIndex == 1) {
                [self.listArr removeAllObjects];
            }
            
            NSArray *arr = [NSArray modelArrayWithClass:[BogoRechargeRecordModel class] json:[responseJson objectForKey:@"list"]];
            
            [self.listArr addObjectsFromArray:arr];
            
            
            NSArray *timeArr = [self.timeStr componentsSeparatedByString:@"-"];
            
            NSString *timeStr = [NSString stringWithFormat:ASLocalizedString(@"%@年%@月"),timeArr.firstObject,timeArr.lastObject];
            
            [self.headView.timeBtn setTitle:timeStr forState:UIControlStateNormal];
            [self.tableView reloadData];
            
        }else{
            
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } FailureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [FanweMessage alertHUD:ASLocalizedString(@"加载失败")];
    }];
}

-(void)setUpView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight - MG_BOTTOM_MARGIN - kRealValue(50)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"BogoRechageListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BogoRechageListCell"];
//    [self.tableView registerClass:[BogoRechageListCell class] forCellReuseIdentifier:@"BogoRechageListCell"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.height = kScreenH - kTopHeight - MG_BOTTOM_MARGIN - kRealValue(50);
    
    [BGMJRefreshManager refresh:self.tableView target:self headerRereshAction:@selector(headerReresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerReresh)];
    [self.view addSubview:self.tableView];
}

-(void)headerReresh{
    self.pageIndex = 1;
    [self requestModelWithIndex:self.pageIndex];
}

-(void)footerReresh{
    self.pageIndex ++;
    [self requestModelWithIndex:self.pageIndex];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    return self.headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return kRealValue(29);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRealValue(68);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BogoRechageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoRechageListCell"];
    BogoRechargeRecordModel *model = self.listArr[indexPath.row];
    
    //判断类型
    if (self.type == BOGO_RECORD_TYPE_RECHARGE) {
        model.isRecharge = YES;
    }else{
        model.isRecharge = NO;
    }
    
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)protocolRecordHead:(BogoRechargeRecordHeadView *)view{
    
    [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYM title:ASLocalizedString(@"选择时间") selectValue:nil resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        
        NSArray *arr = [selectValue componentsSeparatedByString:@"-"];
        
        NSString *time = [NSString stringWithFormat:ASLocalizedString(@"%@年%@月"),arr.firstObject,arr.lastObject];
        
        [view.timeBtn setTitle:time forState:UIControlStateNormal];
        self.timeStr = selectValue;
        self.pageIndex = 1;
        [self requestModelWithIndex:self.pageIndex];
        
    }];
    
}

-(BogoRechargeRecordHeadView *)headView{
    if (!_headView) {
        _headView = [[BogoRechargeRecordHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(28))];
        _headView.delegate = self;
    }
    return _headView;
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
