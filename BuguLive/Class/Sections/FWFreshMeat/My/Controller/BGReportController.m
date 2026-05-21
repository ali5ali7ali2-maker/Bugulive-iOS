//
//  BGReportController.m
//  BuguLive
//
//  Created by fanwe2014 on 2017/3/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGReportController.h"
#import "NetHttpsManager.h"
#import "reportModel.h"
#import "BGReportView.h"
#import "MGReportCommentController.h"

@interface BGReportController ()<UITableViewDelegate,UITableViewDataSource,reportDeleGate>
{
    NSMutableArray   *_dataArray;
    NSUInteger       _paymentTag;       //举报的类型
    NSString         *_reportId;
    UILabel          *_reportlabel;     //举报原因
    UIButton         *_reportBtn;       //举报的btn
    UIView           *_headView;        //tableView头部的view
    BGReportView     *_FWReportiew;
    
}

@end

@implementation BGReportController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    _paymentTag = -1;
    _dataArray = [[NSMutableArray alloc]init];
    _reportlabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2-120,5 ,240,30)];
    _reportlabel.backgroundColor = kBackGroundColor;
    _reportlabel.text = ASLocalizedString(@"举报原因");
    _reportlabel.textAlignment = NSTextAlignmentCenter;
    _reportlabel.textColor = kAppGrayColor1;
    
    _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reportBtn setTitle:ASLocalizedString(@"举报")forState:UIControlStateNormal];
    [_reportBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    _reportBtn.frame = CGRectMake(0, kScreenH-50 - kTopHeight - MG_BOTTOM_MARGIN - kRealValue(44),kScreenW, 50);
    _reportBtn.backgroundColor = kBackGroundColor;
    [_reportBtn addTarget:self action:@selector(reportClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.reportTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64-50)];
    self.reportTableView.dataSource = self;
    self.reportTableView.delegate = self;
    self.reportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [BGMJRefreshManager refresh:self.reportTableView target:self headerRereshAction:@selector(loadData) footerRereshAction:nil];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    if (self.reportType == 1)
    {
        self.navigationItem.title = ASLocalizedString(@"举报小视频");
    }else if (self.reportType == 2)
    {
        self.navigationItem.title = ASLocalizedString(@"举报小视频");
    }else if (self.reportType == 3)
    {
        self.navigationItem.title = ASLocalizedString(@"评论举报");
    }
    
    [self.view addSubview:self.reportTableView];
    [self.view addSubview:_reportBtn];
    
    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"app" forKey:@"ctl"];
    [parmDict setObject:@"tipoff_type" forKey:@"act"];
    [parmDict setObject:@"xr" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             
             [_dataArray removeAllObjects];
             NSArray *array = [responseJson objectForKey:@"list"];
             if (array.count > 0)
             {
                 for (NSDictionary *dict in array)
                 {
                     reportModel *model = [[reportModel alloc]init];
                     model.ID = [dict toInt:@"id"];
                     model.name = [dict toString:@"name"];
                     [_dataArray addObject:model];
                 }
             }
             [self.reportTableView reloadData];
         }else
         {
             [[BGHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         }
         [BGMJRefreshManager endRefresh:self.reportTableView];
         
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [BGMJRefreshManager endRefresh:self.reportTableView];
     }];
}

//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count > 0)
    {
        return _dataArray.count;
    }else
    {
        return 0;
    }
}

//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"CellIdentifier1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = kGrayTransparentColor5;
    }
    if (_dataArray.count > 0)
    {
        reportModel *model = [_dataArray objectAtIndex:indexPath.row];
        if (model.name.length > 0)
        {
            cell.textLabel.text = model.name;
        }else
        {
            cell.textLabel.text = ASLocalizedString(@"其他原因");
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"com_radio_selected_2"]];
    imageView.tag = indexPath.row;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];
    cell.accessoryView = imageView;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"com_arrow_right_1"]];
    
    if(indexPath.row == _paymentTag)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"com_radio_selected_2"]];
        imageView.tag = indexPath.row;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        cell.accessoryView = imageView;
    }else
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"com_radio_normal_2"]];
        imageView.tag = indexPath.row;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        cell.accessoryView = imageView;
    }
    return cell;
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    _paymentTag = sender.view.tag;
    reportModel *model = _dataArray[_paymentTag];
    _reportId = [NSString stringWithFormat:@"%d",model.ID];
    [_reportTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.reportType == 3) {
        reportModel *model = _dataArray[indexPath.row];
        model.weibo_id = self.commentID;
        MGReportCommentController *vc = [[MGReportCommentController alloc]initWithReportModel:model];
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }else{
        _paymentTag = indexPath.row;
        reportModel *model = _dataArray[indexPath.row];
        _reportId = [NSString stringWithFormat:@"%d",model.ID];
        [_reportTableView reloadData];
//        [self reportClick];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_headView)
    {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        [_headView addSubview:_reportlabel];
    }
    return _headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark 返回
- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reportClick
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user" forKey:@"ctl"];
    [parmDict setObject:@"tipoff_weibo" forKey:@"act"];
    [parmDict setObject:@"xr" forKey:@"itype"];
    if (_reportId.length < 1)
    {
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"请选择举报类型")];
        return;
    }
    [parmDict setObject:_reportId forKey:@"type"];
    if (self.to_user_id.length > 0)
    {
        [parmDict setObject:self.to_user_id forKey:@"to_user_id"];
    }
    
    if (self.reportType == 1)
    {
        if (self.weibo_id.length > 0)
        {
            [parmDict setObject:self.weibo_id forKey:@"weibo_id"];
        }
    }
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             if (!_FWReportiew)
             {
                 _FWReportiew = [self loadReportVC];
             }
             _FWReportiew.commentLabel.text = [responseJson toString:@"error"];
         }else
         {
             [[BGHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         }
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

- (BGReportView *)loadReportVC
{
    _FWReportiew = [[[NSBundle mainBundle] loadNibNamed:@"BGReportView" owner:self options:nil] lastObject];
    _FWReportiew.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    _FWReportiew.RDeleGate = self;
    [[[UIApplication sharedApplication]keyWindow]addSubview:_FWReportiew];
    return _FWReportiew;
}

- (void)reportComeBack
{
    [_FWReportiew removeFromSuperview];
    _FWReportiew = nil;
    [self.navigationController popViewControllerAnimated:YES];
}



@end
