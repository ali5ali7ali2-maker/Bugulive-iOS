//
//  BogoNewsSystemViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/14.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoNewsSystemViewController.h"
#import "ChatFriendCell.h"
#import "ChatTradeCell.h"
#import "BGBaseChatController.h"
#import "BGConversationServiceController.h"
#import "IMModel.h"
#import "JSBadgeView.h"
#import "M80AttributedLabel.h"

#import "BGSystemMsgModel.h"

#import "MsgCellRight.h"
#import "MsgTimeCell.h"

@interface BogoNewsSystemViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UILabel *titleL;
@property(nonatomic, strong) UIButton *backBtn;

@end

@implementation BogoNewsSystemViewController{
//    int _select; //1.交易  2.好友  3.未关注
    int _page;   //页数
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    
//    self.title = @"系统消息";
    
    _conversationArr = NSMutableArray.new;
    _page = 1;

    self.mTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.backgroundColor = kBackGroundColor;
    [self.view addSubview:self.mTableView];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:@"MsgCellLeft" bundle:nil];
    [self.mTableView registerNib:nib forCellReuseIdentifier:@"leftcell"];
    nib = [UINib nibWithNibName:@"MsgCellRight" bundle:nil];
//    [self.mtableview registerNib:nib forCellReuseIdentifier:@"rightcell"];
    nib = [UINib nibWithNibName:@"MsgTimeCell" bundle:nil];
    [self.mTableView registerNib:nib forCellReuseIdentifier:@"timecell"];
    
    [BGMJRefreshManager refresh:self.mTableView target:self headerRereshAction:@selector(headerStartRefresh) footerRereshAction:nil];
    
    
    self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW, kTopHeight - kStatusBarHeight)];
    self.titleL.text =ASLocalizedString( @"系统消息");
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:self.titleL];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImage:[UIImage imageNamed:@"com_arrow_vc_back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    self.titleL.centerX = kScreenW / 2;
    self.backBtn.frame = CGRectMake(kRealValue(10), kStatusBarHeight, kRealValue(40), kRealValue(40));
    
    [self requestPageWithIndex:_page];
    [self.view addSubview:self.mTableView];
    [self.mTableView setFrame:CGRectMake(0, kTopHeight, kScreenW, kScreenHeight - kTopHeight - MG_BOTTOM_MARGIN)];
    
    self.mTableView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

-(void)clickBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestPageWithIndex:(NSInteger)pageIndex{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"msg_list" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%ld",pageIndex] forKey:@"p"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if (_page == 1) {
            [_conversationArr removeAllObjects];
            
        }
        
        NSArray *arr = [NSArray modelArrayWithClass:[BGSystemMsgModel class] json:responseJson[@"list"]];

        for (int i = 0; i < arr.count ; i ++) {
            
            BGSystemMsgModel *timemodel = [BGSystemMsgModel new];
            
            
            
            BGSystemMsgModel *model = arr[i];
            model.mMsgType = 1;
            
            timemodel.mMsgType = 0;
            timemodel.addtime = model.addtime;
            
            [_conversationArr addObject:timemodel];
            [_conversationArr addObject:model];
        }
        
//        [_conversationArr addObjectsFromArray:arr];
        
        [BGMJRefreshManager endRefresh:self.mTableView];
        
        [_mTableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [BGMJRefreshManager endRefresh:self.mTableView];
        });
    }];
}

- (void)updateTableViewFrame
{
    CGFloat tableViewHeight;
    if (!self.isHaveLive)
    {
        tableViewHeight = kScreenH - 64;
    }
    else
    {
        tableViewHeight = kScreenH / 2 - 44;
    }
    [self.mTableView setFrame:CGRectMake(0, 0, kScreenW, tableViewHeight)];
}

#pragma mrak-- ------------------------消息通知-- ------------------------

- (void)IMChatMsgNotficationInList:(NSNotification *)notfication
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(IMChatMsgNotficationInList:) withObject:notfication waitUntilDone:NO];
        return;
    }
    SFriendObj *bfindone = nil;
    SIMMsgObj *thatmsg = notfication.object;
    for (SFriendObj *one in _conversationArr)
    {
        if (one.mUser_id == thatmsg.mSenderId)
        {
            bfindone = one;
            break;
        }
    }
    if (bfindone)
    {
        [bfindone setLMsg:thatmsg.mCoreTMsg];
        [self.mTableView reloadData];
    }
}

- (void)headerStartRefresh
{
    [self requestPageWithIndex:1];
    
}

#pragma mark----------------------tableView的协议方法------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_conversationArr.count > 0) {
        return _conversationArr.count;
//    }
//    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    BGSystemMsgModel *msgobj = nil;
    if (_conversationArr.count > 0) {
        msgobj = _conversationArr[indexPath.row];
    }

    MsgCellRight *retcell = [MsgCellRight new];
    
    if (msgobj.mMsgType == 1)
    { //文字消息
        retcell = [tableView dequeueReusableCellWithIdentifier:@"leftcell"];
           
        retcell.mheadimg.image = [UIImage imageNamed:@"bogo_news_top_system"];
        [retcell.mmsglabel dealFace:msgobj.content];

        CGSize ss = [retcell.mmsglabel sizeThatFits:CGSizeMake(tableView.bounds.size.width - 73 - 50, CGFLOAT_MAX)];
        retcell.mlabelconstH.constant = ss.height;
        retcell.mlabelconstW.constant = ss.width;
        retcell.backgroundColor = kClearColor;
        retcell.selectionStyle = UITableViewCellSelectionStyleNone;
        return retcell;
    }
    else
    { //其他什么鬼...其他所有消息都当真时间消息处理了....

        MsgTimeCell *timecell = [tableView dequeueReusableCellWithIdentifier:@"timecell"];
        timecell.mbgview.layer.borderWidth = 0.0f;
        timecell.mbgview.backgroundColor = kClearColor;
        timecell.mtimelabel.text = msgobj.addtime;
        timecell.mtimelabel.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
        timecell.mtimelabel.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
//        [msgobj getTimeStr];
        timecell.selectionStyle = UITableViewCellSelectionStyleNone;
        return timecell;
    }


    
    retcell.selectionStyle = UITableViewCellSelectionStyleNone;
    retcell.backgroundColor = [UIColor clearColor];
    return retcell;
    
}

#pragma mark 点击单元格的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark-----------------------删除单元格方法------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ASLocalizedString(@"删除");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        SFriendObj *oneobj = nil;
//        oneobj = [_conversationArr objectAtIndex:indexPath.row];
//        [SVProgressHUD showWithStatus:ASLocalizedString(@"操作中...")];
//
//        [oneobj delThis:^(SResBase *resb) {
//
//            if (resb.msuccess)
//            {
//                [SVProgressHUD dismiss];
//                [_conversationArr removeObjectAtIndex:indexPath.row];
//
//                [self.mTableView beginUpdates];
//                [self.mTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                [self.mTableView endUpdates];
//                //获取角标
//                [self reloadItem:_select];
//
//            }
//            else
//            {
//                [SVProgressHUD showErrorWithStatus:resb.mmsg];
//            }
//
//        }];
//        if (_conversationArr.count == 0) {
//            [self showNoContentView];
//            if (_isHaveLive)
//            {
//                self.noContentView.center = CGPointMake(self.view.frame.size.width/2, 87.5+40);
//            }
//        }
//    }
}

- (void)reloadItem:(int)selectItem
{
//    if ([self.delegate respondsToSelector:@selector(reloadChatBadge:)])
//    {
//        [self.delegate reloadChatBadge:selectItem];
//    }
}

- (void)updateItem:(int)unReadNum
{
//    if ([self.delegate respondsToSelector:@selector(updateChatFriendBadge:)])
//    {
//        [self.delegate updateChatFriendBadge:unReadNum];
//    }
}

- (void)itemBtnClick:(SFriendObj *)obj
{
//    if ([self.delegate respondsToSelector:@selector(clickFriendItem:)])
//    {
//        [self.delegate clickFriendItem:obj];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
