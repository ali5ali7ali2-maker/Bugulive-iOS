//
//  BogoNewsViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/12.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoNewsViewController.h"
#import "ChatFriendCell.h"
#import "ChatTradeCell.h"
#import "BGBaseChatController.h"
#import "BGConversationServiceController.h"
#import "IMModel.h"
#import "JSBadgeView.h"
#import "M80AttributedLabel.h"
#import "BogoNewsHeadView.h"
#import "BogoNewsLikesViewController.h"
#import "FollowerViewController.h"



#import "BogoNewsTabNumModel.h"

#import "BGSystemMsgVC.h"
#import "BogoNewsSystemViewController.h"

@interface BogoNewsViewController ()<UITableViewDelegate, UITableViewDataSource,BogoNewsHeadViewDelegate>

@property(nonatomic, strong) BogoNewsHeadView *headView;

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) BogoNewsTabNumModel *unReadModel;

@end

@implementation BogoNewsViewController
{
    int _select; //1.交易  2.好友  3.未关注
    int _page;   //页数
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,
                                                             NSFontAttributeName:[UIFont systemFontOfSize:15]
    } forState:UIControlStateNormal];
    
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"unread_messages" forKey:@"act"];
    
    [[NetHttpsManager manager]POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
        if ([[responseJson valueForKey:@"status"]integerValue] == 1) {
            
            BogoNewsTabNumModel *model = [BogoNewsTabNumModel modelWithDictionary:[responseJson valueForKey:@"data"]];
//            [responseJson objectForKey:[responseJson valueForKey:@"data"]];
            _unReadModel = model;
            
            [self headerStartRefresh];
            
            [SFriendObj getAllUnReadCountComplete:^(int num) {
                if ((model.bzone_reply + model.bzone_like + num) == 0) {
                    self.tabBarItem.badgeValue = nil;
                }else{
                    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",model.bzone_reply + model.bzone_like + num + model.msg.count];
                }
            }];
            
            self.headView.model = model;
            
        }
        
    } FailureBlock:^(NSError *error) {
            
    }];
    
    
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = CGRectMake(0, 0, kScreenW, 250);
//    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FBE2FF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFFFFF"].CGColor];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0, 1);
//    //把gradientLayer加到_collectionView最底部

//    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 250)];
//    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
////    view.backgroundColor = kYellowColor;
//    [self.view addSubview:view];
    
    UIImageView *topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 64+kStatusBarHeight)];
    topImgView.image = [UIImage imageNamed:@"顶部渐变"];
    [self.view addSubview:topImgView];
    
    _select = 0;
    _conversationArr = NSMutableArray.new;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IMChatMsgNotficationInList:) name:g_notif_chatmsg object:nil];
    
    
    self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW, kTopHeight - kStatusBarHeight)];
    self.titleL.text = ASLocalizedString(@"Information");
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.font = [UIFont boldSystemFontOfSize:22];
    self.titleL.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    [self.view addSubview:self.titleL];
        
    self.headView.top = self.titleL.bottom + 22;
    [self.view addSubview:self.headView];
    
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headView.bottom, kScreenW, kScreenH - self.headView.bottom - kTabBarHeight)];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.backgroundColor = kClearColor;
//    self.mTableView.tableHeaderView = self.headView;
    [self.view addSubview:self.mTableView];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mTableView registerNib:[UINib nibWithNibName:@"ChatFriendCell" bundle:nil] forCellReuseIdentifier:@"ChatFriendCell"];
    [BGMJRefreshManager refresh:self.mTableView target:self headerRereshAction:@selector(headerStartRefresh) footerRereshAction:nil];
    
    [self.view addSubview:self.mTableView];
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
//    [self.mTableView reloadData];
    SFriendObj *xxx = nil;
    [SFriendObj getMyFriendMsgList:_select
                           lastObj:xxx
                             block:^(SResBase *resb, NSArray *all, int unReadNum) {
        
        
        NSLog(@"-=-=-=-=-=-=-==-=");
        
        if (_unReadModel) {
            NSInteger count = _unReadModel.bzone_reply + _unReadModel.bzone_like + _unReadModel.msg.count + unReadNum;
            if (count == 0) {
                self.tabBarItem.badgeValue = nil;
            }else{
                self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",count];
            }
        }
        
        
    [self updateItem:_unReadModel.bzone_reply + _unReadModel.bzone_like + _unReadModel.msg.count + unReadNum];
    [BGMJRefreshManager endRefresh:self.mTableView];
     [_conversationArr removeAllObjects];
     if (all.count)
                                 {
//                                     [self hideNoContentView];
                                     [_conversationArr addObjectsFromArray:all];
                                 }
                                 else
                                 {
//                                     [self showNoContentView];
//                                     if (_isHaveLive)
//                                     {
//                                         self.noContentView.center = CGPointMake(self.view.frame.size.width/2, 87.5+40);
//                                     }
                                 }
                                 [self.mTableView reloadData];
                                 
                             }];
}

#pragma mark----------------------tableView的协议方法------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _conversationArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFriendObj *oneobj = nil;
    
    
    
    ChatFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatFriendCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        [cell.mheadimg setImage:[UIImage imageNamed:@"bogo_news_top_system"]];
        cell.mname.text = ASLocalizedString(@"系统消息");
        if (_unReadModel.msg.content.length) {
            cell.mmsg.text = _unReadModel.msg.content;
            cell.mtime.text = [NSDate fd_getTimeSimpleFromTimestamp:_unReadModel.msg.addtime.doubleValue];
        }else{
            cell.mmsg.text = ASLocalizedString(@"暂无消息");
        }
        cell.msex.hidden = YES;
        [cell setUnReadCount:_unReadModel.msg.count];
    }else{
        if ((indexPath.row - 1) < _conversationArr.count)
        {
            oneobj = [_conversationArr objectAtIndex:indexPath.row - 1];
        }

        if (!oneobj)
        {
            return [UITableViewCell new];
        }
        
        [cell.mheadimg sd_setImageWithURL:[NSURL URLWithString:oneobj.mHead_image] placeholderImage:kDefaultPreloadHeadImg];
        cell.viconImageView.hidden = YES;
        if (oneobj.mNick_name.length > 11)
        {
            cell.mname.text = [NSString stringWithFormat:@"%@...", [oneobj.mNick_name substringToIndex:11]];
        }
        else
        {
            cell.mname.text = oneobj.mNick_name;
        }
        [cell.mmsg dealFace:oneobj.mLastMsg];
        
        cell.mtime.text = [oneobj getTimeStr];
        if (oneobj.mSex == 0)
        {
            cell.msex.image = [UIImage imageNamed:@"com_male_selected"];
        }
        else if (oneobj.mSex == 1)
        {
            cell.msex.image = [UIImage imageNamed:@"com_male_selected"];
        }
        else
        {
            cell.msex.image = [UIImage imageNamed:@"com_female_selected"];
        }
        NSString *ss = [NSString stringWithFormat:@"level%d", oneobj.mUser_level];
        
        cell.mlevel.image = [UIImage imageNamed:ss];
        NSLog(@"未读数量-----%@",oneobj.unread_count);
        [cell setUnReadCount:oneobj.unread_count.intValue];
        
    }
    cell.backgroundColor = kClearColor;
    return cell;
}

#pragma mark 点击单元格的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        BogoNewsSystemViewController *vc = [BogoNewsSystemViewController new];
        [[AppDelegate sharedAppDelegate]pushViewController:vc animated:YES];
        return;
    }
    
    SFriendObj *oneobj = nil;
    
    if (indexPath.row > 0 && (indexPath.row - 1) < _conversationArr.count)
    {
        oneobj = [_conversationArr objectAtIndex:indexPath.row - 1];
    }

    if (!oneobj)
    {
        return;
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = ASLocalizedString(@"返回");
    self.navigationController.topViewController.navigationItem.backBarButtonItem = backItem;
    IMAUser *user = [[IMAUser alloc] initWith:[NSString stringWithFormat:@"%d", oneobj.mUser_id]];
    user.icon = oneobj.mHead_image;
    user.nickName = oneobj.mNick_name;
    user.remark = @"";
    if (self.isHaveLive == NO)
    {
        BGConversationServiceController *chatvc = [BGConversationServiceController makeChatVCWith:oneobj isHalf:NO];
        chatvc.dic = @{
                       @"mHead_image": oneobj.mHead_image,
                       @"mUser_id": @(oneobj.mUser_id)
                       };
        [[AppDelegate sharedAppDelegate] pushViewController:chatvc animated:YES];
    }
    if (self.isHaveLive == YES)
    {
        //跳转 2去下界面
        [self itemBtnClick:oneobj];
    }
    [oneobj ignoreThisUnReadCount];
    [self.mTableView reloadData];
    [self reloadItem:_select];
}

#pragma mark-----------------------删除单元格方法------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row > 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ASLocalizedString(@"删除");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.row == 0)
        {
            return;
        }
        NSInteger dataIndex = indexPath.row - 1;
        if (dataIndex < 0 || dataIndex >= _conversationArr.count)
        {
            return;
        }

        SFriendObj *oneobj = nil;
        oneobj = [_conversationArr objectAtIndex:dataIndex];
        [SVProgressHUD showWithStatus:ASLocalizedString(@"操作中...")];
        
        [oneobj delThis:^(SResBase *resb) {
            
            if (resb.msuccess)
            {
                [SVProgressHUD dismiss];
                [_conversationArr removeObjectAtIndex:dataIndex];
                
                [self.mTableView beginUpdates];
                [self.mTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.mTableView endUpdates];
                //获取角标
                [self reloadItem:_select];
                
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            
        }];
        if (_conversationArr.count == 0) {
//            [self showNoContentView];
//            if (_isHaveLive)
//            {
//                self.noContentView.center = CGPointMake(self.view.frame.size.width/2, 87.5+40);
//            }
        }
    }
}

- (void)reloadItem:(int)selectItem
{
    if ([self.delegate respondsToSelector:@selector(reloadChatBadge:)])
    {
        [self.delegate reloadChatBadge:selectItem];
    }
}

- (void)updateItem:(int)unReadNum
{
    if ([self.delegate respondsToSelector:@selector(updateChatFriendBadge:)])
    {
        [self.delegate updateChatFriendBadge:unReadNum];
    }
}

- (void)itemBtnClick:(SFriendObj *)obj
{
    if ([self.delegate respondsToSelector:@selector(clickFriendItem:)])
    {
        [self.delegate clickFriendItem:obj];
    }
}

-(void)clickHeadControl:(NSInteger)index{
    if (index == 0) {
        BogoNewsLikesViewController *vc = [[BogoNewsLikesViewController alloc]initWithNewsType:BOGONEWS_TYPE_LIKES];
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }else if(index == 1){
        BogoNewsLikesViewController *vc = [[BogoNewsLikesViewController alloc]initWithNewsType:BOGONEWS_TYPE_COMMENT];
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }else if (index == 2){
        FollowerViewController *FollowVC = [[FollowerViewController alloc]init];
        FollowVC.user_id = [GlobalVariables sharedInstance].userModel.user_id;
        FollowVC.type = [NSString stringWithFormat:@"%d",2];
        [[AppDelegate sharedAppDelegate] pushViewController:FollowVC animated:YES];
    }else if(index == 3){
        FollowerViewController *FollowVC = [[FollowerViewController alloc]init];
        FollowVC.user_id = [GlobalVariables sharedInstance].userModel.user_id;
        FollowVC.type = [NSString stringWithFormat:@"%d",1];
        [[AppDelegate sharedAppDelegate] pushViewController:FollowVC animated:YES];
    }
    
    
    
    
}


-(BogoNewsHeadView *)headView{
    if (!_headView) {
        _headView = [[BogoNewsHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(100))];
        _headView.delegate = self;
    }
    return _headView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
