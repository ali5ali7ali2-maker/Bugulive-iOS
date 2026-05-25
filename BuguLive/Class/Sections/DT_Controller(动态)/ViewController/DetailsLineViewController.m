//
//  DetailsLineViewController.m
//  MarryU
//
//  Created by 志刚杨 on 2017/6/26.
//  Copyright © 2017年 voidcat. All rights reserved.
//

#import "DetailsLineViewController.h"
#import "CellForWorkGroup.h"
#import "CellForWorkGroupRepost.h"
//#import "YHUtils.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "YZInputView.h"
#import "CellForReplyTableViewCell.h"
#import "MGGroupUserInfo.h"
//#import "UserHomeController.h"

//#import "MGNewUserinfoViewController.h"
#import "BzoneLogic.h"
#import <YYKit.h>

#import <CLPlayer/CLPlayerView.h>

#import "BGTopicTimeLineListController.h"//话题页
#import "YHPlayerViewController.h"//视频播放页

@interface DetailsLineViewController ()<CellForWorkGroupDelegate,UITableViewDelegate,CellForWorkGroupDelegate,CellForWorkGroupRepostDelegate,BzoneLogicDelegate,UITableViewDataSource,UITableViewDelegate>

//@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITextField *inputView;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) NSArray *dataarray;
@property(nonatomic, strong) UILabel *posttip;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) BzoneLogic *zoneLogic;

@property(nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CellForWorkGroup *c_cell;
@property (nonatomic, strong) CLPlayerView *playerView;


@property (nonatomic,strong) NSMutableDictionary *heightDict;

@end

static CGFloat const kBottomHeight = 44;

@implementation DetailsLineViewController
{
    YYTextKeyboardManager *YYmanager;
}


- (NSMutableDictionary *)heightDict{
    if (!_heightDict) {
        _heightDict = [NSMutableDictionary new];
    }
    return _heightDict;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight - kBottomHeight - MG_BOTTOM_MARGIN) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header.hidden = YES;
    
    [self.tableView registerClass:[CellForWorkGroup class] forCellReuseIdentifier:@"CellForWorkGroup"];
    [self.tableView registerClass:[CellForReplyTableViewCell class] forCellReuseIdentifier:@"CellForReplyTableViewCell"];
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setnav];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    _bottomView = [[UIView alloc] init];
    [self.view addSubview:_bottomView];
    _bottomView.frame = CGRectMake(0, kScreenH - kTopHeight - kBottomHeight - MG_BOTTOM_MARGIN, kScreenW, kBottomHeight);

    _inputView = [[UITextField alloc] init];
    [_bottomView addSubview:_inputView];
    _inputView.frame = CGRectMake(0, 0, _bottomView.width - kRealValue(60 + 5), kBottomHeight);
    _inputView.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kRealValue(10), 0)];
    _inputView.centerY = _bottomView.height / 2;
    _inputView.leftViewMode = UITextFieldViewModeAlways;
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.layer.borderWidth = 1;
    _inputView.layer.borderColor = RGB(250, 250, 250).CGColor;
    _inputView.font = [UIFont systemFontOfSize:14];
//    DEFAULT_FONT(16);
    UIButton *btnpost = [[UIButton alloc] init];
    [btnpost setTitle:ASLocalizedString(@"发送")forState:UIControlStateNormal];
    btnpost.layer.cornerRadius = 12.5;
    btnpost.layer.masksToBounds = YES;
    btnpost.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnpost setBackgroundColor:kAppNewMainColor];
    [btnpost setTitleColor:kWhiteColor forState:UIControlStateNormal];
    btnpost.frame = CGRectMake(kScreenW - kRealValue(60), 0, kRealValue(58), kRealValue(25));
    [btnpost addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    btnpost.centerY = _bottomView.height / 2;
    
    //添加私密评论
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_bottomView addSubview:_posttip];
    
    [_bottomView addSubview:btnpost];
    // 设置文本框占位文字
    _inputView.placeholder =ASLocalizedString(@"说点什么吧...");
    
    //键盘监听
    YYmanager = [YYTextKeyboardManager defaultManager];
    [YYmanager addObserver:self];

    _type = @"1";
    _dataarray = [NSArray array];
    _zoneLogic = [[BzoneLogic alloc] init];
    _zoneLogic.delegagte = self;
//    [_zoneLogic loadReplyListWhidZoneID:SafeStr(self.model.dynamic_id)];
    [self UpdateData];
    
    [self setupBackBtnWithBlock:nil];
}

- (void)setupBackBtnWithBlock:(BackBlock)backBlock
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onReturnBtnPress) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
}

#pragma mark - 返回上一级
- (void)onReturnBtnPress
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 过滤掉UIButton，也可以是其他类型
    if ( [touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

-(void)save
{
    if(_inputView.text.length == 0)
    {
//        [[HUDHelper sharedInstance] tipMessage:ASLocalizedString(@"请输入评论内容")];
        [SVProgressHUD showInfoWithStatus:ASLocalizedString(@"请输入评论内容")];
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    
    [self.zoneLogic addDynamicReplyID:self.model.id WihtiContent:_inputView.text adnAudio:@"" Success:^{
        [weakSelf.inputView resignFirstResponder];
        weakSelf.inputView.text = @"";
//        [BGHUDHelper alert:ASLocalizedString(@"评论成功")];
        if (weakSelf.refreshData) {
            weakSelf.refreshData();
        }
        [weakSelf UpdateData];
    }];

}

//get_dynamic_info
- (void)setDynamic_id:(NSString *)dynamic_id{
    
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    [mDict setObject:@"dynamic" forKey:@"ctl"];
    
    [mDict setObject:@"get_dynamic_info" forKey:@"act"];
    [mDict setObject:dynamic_id forKey:@"dynamic_id"];
    
    
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        
        if ([responseJson toInt:@"status"] == 1)
        {
            MGGroupUserInfo *model = [MGGroupUserInfo mj_objectWithKeyValues:responseJson[@"data"]];
            self.model = model;
            [self.tableView reloadData];
            
            [BGMJRefreshManager endRefresh:_tableView];
        }
       
        
    } FailureBlock:^(NSError *error) {
        
        [BGMJRefreshManager endRefresh:_tableView];
        
    }];
    
}

-(void)UpdateData
{
    [_zoneLogic loadReplyListWhidZoneID:self.model.id];

//    [ODTDynamic getreplyWithdid:_model.dynamicId :^(NSMutableArray *data) {
//        _dataarray = [NSMutableArray array];
//        for (NSDictionary *dic in data) {
//            MGGroupUserInfo *model = [MGGroupUserInfo modelWithDictionary:dic];
//            [_dataarray addObject:model];
//            [_tableView reloadData];
//        }
//    } :^(NSString *error) {
////        [MBProgressHUD showError:error];
//    }];
}

-(void)requestZoneReplyListDataCompletedWhih:(NSArray<MGGroupUserInfo *> *)list
{
    _dataarray = list;
    _model.comments = [NSString stringWithFormat:@"%ld",list.count];
    NSLog(@"当前动态评论数量:%ld",_dataarray.count);
    [self.tableView reloadData];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_inputView resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return _dataarray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   if(indexPath.section == 0)
   {
       CellForWorkGroup *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CellForWorkGroup class])];
       if (!cell) {
           cell = [[CellForWorkGroup alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CellForWorkGroup class])];
       }
       cell.indexPath = indexPath;
       cell.model = _model;
       cell.delegate = self;
       return cell;
   }
   else
   {
       CellForReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CellForReplyTableViewCell class])];
       if (!cell) {
           cell = [[CellForReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CellForReplyTableViewCell class])];
       }
       __weak __typeof(self)weakSelf = self;
       cell.clickDeleteBlock = ^(BOOL isDelete) {
           [weakSelf deleteCommentCell:indexPath.row];
       };
       
       MGGroupUserInfo *model = _dataarray[indexPath.row];
       
       [cell setModel:model];
       return cell;
    }
}

-(void)deleteCommentCell:(NSInteger)indexPathRow{
    
    [FanweMessage alert:ASLocalizedString(@"提示")message:ASLocalizedString(@"是否删除评论")destructiveAction:^{
        MGGroupUserInfo *model = _dataarray[indexPathRow];
        
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"dynamic" forKey:@"ctl"];
        [parmDict setObject:@"del_comments" forKey:@"act"];
        
        [parmDict setObject:model.id forKey:@"comment_id"];
        
        
        __weak __typeof(self)weakSelf = self;
        
        [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {

            if ([responseJson toInt:@"status"] == 1) {
//                [BGHUDHelper alert:[responseJson valueForKey:@"error"]];
                [FanweMessage alertHUD:[responseJson valueForKey:@"error"]];
//                [FanweMessage alert:[responseJson valueForKey:@"error"]];
                [_zoneLogic loadReplyListWhidZoneID:self.model.id];
            }
        } FailureBlock:^(NSError *error) {
            
        }];
    } cancelAction:^{
        
    }];
    
        
    
    
    
}

-(void)setnav
{
   
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1)
    {
//        MGGroupUserInfo *model = _dataarray[indexPath.row];
//        MGNewUserinfoViewController *userhome = [MGNewUserinfoViewController new];
//        userhome.uid = model.uid;
//        [self.navigationController pushViewController:userhome animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_c_cell isEqual:cell])
    {
        //区分是否是播放器所在的cell，销毁时将指针置空
        [_playerView destroyPlayer];
        _c_cell =nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        CGFloat height = 0.0;
        //原创cell
        MGGroupUserInfo *model  = _model;
        
        height = [CellForWorkGroup hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
            CellForWorkGroup *cell = (CellForWorkGroup *)sourceCell;
            
            cell.model = model;
            
        }];
    
        return height;
    }
    else{
        
        
        kRealValue(100);
        CGFloat height = 0.0;
//        //原创cell
        MGGroupUserInfo *model = _dataarray[indexPath.row];
//
//        //取缓存高度
//        NSDictionary *dict =  self.heightDict[model.id];
//        if (dict) {
//            if (model.isOpening) {
//                height = [dict[@"open"] floatValue];
//            }else{
//                height = [dict[@"normal"] floatValue];
//            }
//            if (height) {
//                return height;
//            }
//        }
//
        height = [CellForReplyTableViewCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
            CellForReplyTableViewCell *cell = (CellForReplyTableViewCell *)sourceCell;
            cell.model = model;
        }];
        return height;
//
//        //缓存高度
//        if (model.id) {
//            NSMutableDictionary *aDict = [NSMutableDictionary new];
//            if (model.isOpening) {
//                [aDict setObject:@(height) forKey:@"open"];
//            }else{
//                [aDict setObject:@(height) forKey:@"normal"];
//            }
//            [self.heightDict setObject:aDict forKey:model.id];
//        }
//        return height;
    }
    return kRealValue(44);
}

#pragma mark - CellForWorkGroupDelegate
- (void)onAvatarInCell:(CellForWorkGroup *)cell{
//    MGNewUserinfoViewController *user = [[MGNewUserinfoViewController alloc] init];
//    user.uid = cell.model.userInfo.id;
//    [self.navigationController pushViewController:user animated:NO];
}

- (void)onMoreInCell:(CellForWorkGroup *)cell{
    
}

- (void)onCommentInCell:(CellForWorkGroup *)cell{
    
}

- (void)onLikeInCell:(CellForWorkGroup *)cell{
    __weak __typeof(self)weakSelf = self;

    NSLog(@"%@",cell.model.is_like);
    
    BOOL isLike = ![cell.model.is_like isEqualToString:@"1"];
    
    [_zoneLogic addDolikeID:cell.model.id isLike:isLike Success:^(id  _Nonnull selfPtr, BOOL isFinished) {
        MGGroupUserInfo *model = weakSelf.model;
            BOOL isLike = !model.is_like;
            
            NSInteger  praise = [selfPtr integerValue];
            
            if ([cell.model.is_like isEqualToString:@"1"]) {//此处取反
//                praise += 1;
                weakSelf.model.is_like = @"0";
            }else{
//                praise -= 1;
                weakSelf.model.is_like = @"1";
            }
        
        model.praise = [NSString stringWithFormat:@"%ld",praise];
//        [NSString stringWithFormat:@"%ld",(long)selfPtr];
            cell.model = weakSelf.model;
        
        [cell.liksBtn setImage:[UIImage imageNamed:[_model.is_like isEqualToString:@"1"] ? @"mg_dy_likes_select" : @"mg_dy_likes"] forState:UIControlStateNormal];
        [cell.liksBtn setTitleColor:[UIColor colorWithHexString:[_model.is_like isEqualToString:@"1"] ? @"#FF268E" : @"#999999"] forState:UIControlStateNormal];
        
        
        [weakSelf.tableView reloadData];
    }];
}

- (void)onShareInCell:(CellForWorkGroup *)cell{
    
}

- (void)onDeleteInCell:(CellForWorkGroup *)cell{
    
    __weak __typeof(self)weakSelf = self;
    [self.zoneLogic delZone:self.model.id Success:^{
        [FanweMessage alert:ASLocalizedString(@"删除动态成功")];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        if (weakSelf.refreshData) {
            weakSelf.refreshData();
        }
    }];
//     loadListDataWithAct:@"2"];
    
    
//    self _deleteDynAtIndexPath:<#(NSIndexPath *)#> dynamicId:<#(NSString *)#> cell:<#(CellForWorkGroup *)#>
}

#pragma mark - CellForWorkGroupRepostDelegate

- (void)onAvatarInRepostCell:(CellForWorkGroupRepost *)cell{
    
}


- (void)onTapRepostViewInCell:(CellForWorkGroupRepost *)cell{
}

- (void)onCommentInRepostCell:(CellForWorkGroupRepost *)cell{
}

- (void)onLikeInRepostCell:(CellForWorkGroupRepost *)cell{
    
}

- (void)onShareInRepostCell:(CellForWorkGroupRepost *)cell{
    
}

- (void)onDeleteInRepostCell:(CellForWorkGroupRepost *)cell{

}

- (void)onMoreInRespostCell:(CellForWorkGroupRepost *)cell{

}

- (void)onTouchActionVideo:(CellForWorkGroup *)cell withFullScreen:(BOOL)fullScreen
{
    if (fullScreen) {
        
        YHPlayerViewController *vc = [[YHPlayerViewController alloc]initWithPlayerURL:cell.model.video];
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
        return;
    }

    _c_cell =cell;
    [_playerView destroyPlayer];
    _playerView =nil;
    _playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, cell.ClVideoview.width, cell.ClVideoview.height)];
    [cell.ClVideoview addSubview:_playerView];
    _playerView.url =[NSURL URLWithString:cell.model.video];
    //播放
    [_playerView playVideo];

    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(ASLocalizedString(@"返回按钮被点击"));
    }];

    //播放完成回调
    [_playerView endPlay:^{
        //销毁播放器
        [_playerView destroyPlayer];
        _playerView = nil;
        NSLog(ASLocalizedString(@"播放完成"));
    }];
}

- (void)onTopicInCell:(CellForWorkGroup *)cell{
        
//    if (self.topic) {
//        [self.navigationController popViewControllerAnimated:YES];
//    } else {
        
        BGTopicTimeLineListController *pushVC = [BGTopicTimeLineListController new];
        MGDynamicTopicModel *topic = [MGDynamicTopicModel new];
        topic.t_id = self.model.theme_id;
        topic.name = self.model.theme;
        
        pushVC.topic = topic;
        [self.navigationController pushViewController:pushVC animated:YES];
//        [[AppDelegate sharedAppDelegate]pushViewController:pushVC];
}

- (void)onFollowInCell:(CellForWorkGroup *)cell{
   
    FWWeakify(self)
    
    [self.zoneLogic addFollowUID:cell.model.uid Success:^(NSDictionary * _Nonnull dic) {
        //刷新数据
        FWStrongify(self)
        NSInteger _has_focus = [dic toInt:@"has_focus"];
        if (_has_focus == 1) {
            [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"关注成功")];
            //[FanweMessage alert:ASLocalizedString(@"关注成功")];
            self.model.is_focus = @(1);
            [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
            
            if (self.refreshData) {
                self.refreshData();
            }
        }
    }];
}

#pragma mark - private
- (void)_deleteDynAtIndexPath:(NSIndexPath *)indexPath dynamicId:(NSString *)dynamicId cell:(CellForWorkGroup *)cell{
    
    __weak __typeof(self)weakSelf = self;
    
    [FanweMessage alert:ASLocalizedString(@"提示")message:ASLocalizedString(@"确定删除该动态?")destructiveAction:^{
           [weakSelf.zoneLogic loadListDataWithAct:@"2"];
           [FanweMessage alert:ASLocalizedString(@"删除动态成功")];
           if (weakSelf.refreshData) {
               weakSelf.refreshData();
           }
    } cancelAction:^{

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame =  [YYmanager convertRect:transition.toFrame toView:self.view];
    BOOL toVisible = transition.toVisible;
    if(toVisible == YES)
    {
        _bottomView.frame = CGRectMake(0, toFrame.origin.y - kBottomHeight , kScreenW, kBottomHeight);
        
    }
    else
    {
         _bottomView.frame = CGRectMake(0, kScreenH - kTopHeight - kBottomHeight - MG_BOTTOM_MARGIN, kScreenW, kBottomHeight);
//        _bottomView.frame = CGRectMake(0, kScreenHeight - 60 - 10 - kTopHeight, kScreenW, kTabBarHeight);
    }
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
