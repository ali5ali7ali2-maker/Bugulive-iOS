//
//  HMCommentView.m
//  BuguLive
//
//  Created by 范东 on 2019/1/2.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "HMCommentView.h"
#import "BGReplyCell.h"
#import "CommentModel.h"
#import "PersonCenterModel.h"
#import "BGReportController.h"

#define kCommentCellID @"HMCommentViewCommentCellID"
#define kCommentViewHeight  400

@interface HMCommentView ()<UITableViewDelegate,UITableViewDataSource,commentDeleGate,UIActionSheetDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, assign) int currentPage; //当前页数
@property (nonatomic, assign) int has_next; //是否还有下一页1代表有
@property (nonatomic, strong) PersonCenterModel *detailModel;
@property (nonatomic, strong) UITextField *commentTextField; //发表评论的输入框
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, assign) int rowCount;
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, assign) BOOL isShowKeyBoard;
@property (nonatomic, strong) UIImageView *bottomView;
@property (nonatomic, strong) UIView *commentShadowView;

@property (nonatomic, copy) operateCommentSuccessBlock operateCommentSuccessBlock;

@end

@implementation HMCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kWhiteColor;
        self.userInteractionEnabled = YES;
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        swipe.direction = UISwipeGestureRecognizerDirectionDown;
        swipe.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:swipe];
        [self initSubview];
        [self keyboardMonitor];//通知
    }
    return self;
}

- (void)initSubview{
    
    //全部评论
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.text = ASLocalizedString(@"全部评论");
    [self addSubview:titleLabel];
    [self addSubview:self.tableView];
    [self addSubview:self.bottomView];
    self.bottomView.hidden = NO;
    
    UIImageView *pencilImg = [UIImageView new];
    [pencilImg setImage:[UIImage imageNamed:@"mg_video_pencil"]];
    [self.bottomView addSubview:pencilImg];
    
    //想撩TA,先评论
    [self.bottomView addSubview:self.commentTextField];
    //发送按钮
    [self.bottomView addSubview:self.sendBtn];
    //tableView上的细线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = kLightGrayColor;
    [self.tableView addSubview:lineView];
    
    //约束
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.tableView.mas_top).offset(0);
        make.height.mas_equalTo(@(0.5));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(@(kCommentViewHeight - [ASLocalizedString(@"全部评论")textSizeIn:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:16]].height - 20 - 50));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(19);
        make.top.equalTo(self.tableView.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(kScreenW - 19 * 2, 50));
//        make.bottom.mas_equalTo(-55);
    }];
    
    [pencilImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(10);
        make.size.mas_equalTo(CGSizeMake(23, 21));
        make.centerY.equalTo(self.bottomView);
    }];
    
    [self.commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pencilImg.mas_right).offset(10);
        make.bottom.equalTo(self.bottomView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(kRealValue(210), 40));
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right).offset(-10);
        make.centerY.equalTo(self.commentTextField.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
}

#pragma mark - Data
- (void)setModel:(SmallVideoListModel *)model{
    _model = model;
    [self loadNetDataWithPage:1];
}

#pragma mark - Show And Hide
- (void)show:(UIView *)superView{
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha  = 1;
        self.y = kScreenH - kCommentViewHeight;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha  = 0;
        self.y = kScreenH;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - Refresh
- (void)headerReresh
{
    [self loadNetDataWithPage:1];
}

- (void)refresherOfNew
{
    if (_has_next == 1)
    {
        _currentPage ++;
        [self loadNetDataWithPage:_currentPage];
    }
    else
    {
        [BGMJRefreshManager endRefresh:self.tableView];
    }
}

#pragma mark - Data
-(void)loadNetDataWithPage:(int)page
{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"weibo" forKey:@"ctl"];
    [MDict setObject:@"index" forKey:@"act"];
    [MDict setObject:@"xr" forKey:@"itype"];
    if (self.model.weibo_id.length)
    {
        [MDict setObject:self.model.weibo_id forKey:@"weibo_id"];
    }
    if (self.model.id.length)
    {
        [MDict setObject:self.model.id forKey:@"weibo_id"];
    }
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         _has_next = [responseJson toInt:@"has_next"];
         _currentPage = [responseJson toInt:@"page"];
         if (_currentPage == 1)
         {
             [_dataArray removeAllObjects];
         }
         if ([responseJson toInt:@"status"]== 1)
         {
             _detailModel = [PersonCenterModel mj_objectWithKeyValues:responseJson];
             //动态
             NSArray *comment_listArray = [responseJson objectForKey:@"comment_list"];
             if (comment_listArray && [comment_listArray isKindOfClass:[NSArray class]])
             {
                 if (comment_listArray.count)
                 {
                     for (NSDictionary *dict in comment_listArray)
                     {
                         CommentModel *CModel = [CommentModel mj_objectWithKeyValues:dict];
                         [self.dataArray addObject:CModel];
                     }
                 }
                 [self.tableView reloadData];
                 [BGMJRefreshManager endRefresh:self.tableView];
             }
         }else
         {
             [[BGHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         }
     } FailureBlock:^(NSError *error)
     {
         [BGMJRefreshManager endRefresh:self.tableView];
         FWStrongify(self)
         NSLog(@"error==%@",error);
     }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BGReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentCellID];
    if (_dataArray.count) {
        [cell creatCellWithModel:_dataArray[indexPath.row] andRow:indexPath.row];
    }
    cell.CDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BGReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentCellID];
    return  [cell creatCellWithModel:_dataArray[indexPath.row] andRow:(int)indexPath.row];
}

#pragma mark - Keyboard
- (void)keyboardMonitor{
    //键盘显示时发出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘隐藏时发出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    _isShowKeyBoard = YES;
    // 键盘弹出需要的时间
    CGFloat animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 取出键盘高度
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self insertSubview:self.commentShadowView belowSubview:self.bottomView];
    [self.commentShadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenW, kCommentViewHeight));
    }];
    // 执行动画
    [UIView animateWithDuration:animationDuration animations:^{
        self.commentShadowView.alpha = 1;
        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kCommentViewHeight - keyboardF.size.height - 50);
            make.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kScreenW, 50));
        }];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    // 键盘弹出需要的时间
    CGFloat animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        [_sendBtn setTitle:ASLocalizedString(@"发表评论")forState:UIControlStateNormal];
        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.tableView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(kScreenW, 50));
        }];
        [self.commentShadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.bottomView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(kScreenW, kCommentViewHeight));
        }];
        self.commentShadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.commentShadowView removeFromSuperview];
    }];
}

#pragma mark - commentDeleGate
- (void)commentNewsWithTag:(int)tag{
    
    
//
    if (!_dataArray.count) {
        return;
    }
    _rowCount = tag;
    CommentModel *CModel = _dataArray[tag];
    if (_detailModel.user_id >0)
    {
        if (_detailModel.is_admin)
        {
            if ([CModel.user_id intValue] == _detailModel.user_id)//如果是自己的评论，且是自己的回复就只有删除取消
            {
                UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                [headImgSheet addButtonWithTitle:ASLocalizedString(@"删除")];
                [headImgSheet addButtonWithTitle:ASLocalizedString(@"取消")];
                [headImgSheet setTintColor:kAppGrayColor1];
                headImgSheet.tag = 0;
                headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
                headImgSheet.delegate = self;
                [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
                
            }else//如果是自己的评论，但是是别人的评论就有删除回复取消
            {
                UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                [headImgSheet addButtonWithTitle:ASLocalizedString(@"回复")];
                [headImgSheet addButtonWithTitle:ASLocalizedString(@"取消")];
                [headImgSheet setTintColor:kAppGrayColor1];
                headImgSheet.tag = 2;
                headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
                headImgSheet.delegate = self;
                [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
                
            }
        }else
        {
            if ([CModel.user_id intValue] == _detailModel.user_id)//不是自己的评论，是回复别人的评论,只有删除
            {
                UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                [headImgSheet addButtonWithTitle:ASLocalizedString(@"删除")];
                [headImgSheet addButtonWithTitle:ASLocalizedString(@"取消")];
                [headImgSheet setTintColor:kAppGrayColor1];
                headImgSheet.tag = 0;
                headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
                headImgSheet.delegate = self;
                [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
            }else//不是自己的评论，是别人的评论,只能回复别人的评论
            {
                _isShowKeyBoard = YES;
//                _isShowKeyBoard =! _isShowKeyBoard;
                if (_isShowKeyBoard == YES)
                {
                    UIActionSheet *testSheet = [[UIActionSheet alloc] init];
                    [testSheet bk_addButtonWithTitle:ASLocalizedString(@"回复")handler:^{
                        [_sendBtn setTitle:ASLocalizedString(@"回复")forState:UIControlStateNormal];
                        [_commentTextField becomeFirstResponder];
                        _commentTextField.placeholder = [NSString stringWithFormat:ASLocalizedString(@"回复:%@"),CModel.nick_name];
                        _comment_id = CModel.comment_id;
                    }];

                    [testSheet bk_addButtonWithTitle:ASLocalizedString(@"复制")handler:^{
                        UIPasteboard * paste = [UIPasteboard generalPasteboard];
                        paste.string = CModel.content;
                        [BGHUDHelper alert:ASLocalizedString(@"复制成功")];
                    }];

                    [testSheet bk_addButtonWithTitle:ASLocalizedString(@"评论举报")handler:^{
                        [self goToReportControllerWithTag:3 commentModel:CModel];
//                        _liveReportV = [[SLiveReportView alloc]initWithFrame:CGRectMake(0,0,kScreenW,kScreenH)];
//                        _liveReportV.reportDelegate = self;
                    }];

                    [testSheet bk_setCancelButtonWithTitle:ASLocalizedString(@"取消") handler:nil];

                    [testSheet showInView:self];
                    
                }else
                {
                    _commentTextField.placeholder = ASLocalizedString(@"说点什么···");
                    _comment_id = @"";
                    [self tap];
                }
            }
        }
    }
}

- (void)clickNameStringWithTag:(int)tag{
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha  = 0;
        self.y = kScreenH;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
        CommentModel *CModel = _dataArray[tag];
        SHomePageVC *myVC = [[SHomePageVC alloc]init];
        myVC.user_id = CModel.user_id;
        myVC.type = 0;
        [[AppDelegate sharedAppDelegate] pushViewController:myVC animated:YES];
    }];
}

#pragma mark - Action
- (void)deleteCommentWithTag:(int)count{
    CommentModel *CModel = _dataArray[_rowCount];
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"del_comment" forKey:@"act"];
    if (CModel.comment_id.length)
    {
        [MDict setObject:CModel.comment_id forKey:@"comment_id"];
    }
    [MDict setObject:@"xr" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]== 1)
         {
             [_dataArray removeObjectAtIndex:_rowCount];
             _detailModel.info.comment_count = [NSString stringWithFormat:@"%d",(int)_dataArray.count];
             [_tableView reloadData];
             //需要告诉上一个页面评论数量
             if (self.operateCommentSuccessBlock) {
                 self.operateCommentSuccessBlock(_detailModel.info.comment_count);
             }
         }
         [[BGHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}


- (void)buttonClick{
    if (_commentTextField.text.length < 1)
    {
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"请输入评论的内容")];
        return;
    }
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"publish_comment" forKey:@"act"];
    [MDict setObject:@"1" forKey:@"type"];
    if (self.model.weibo_id.length)
    {
        [MDict setObject:self.model.weibo_id forKey:@"weibo_id"];
    }
    if (_comment_id.length)
    {
        [MDict setObject:_comment_id forKey:@"to_comment_id"];
    }
    [MDict setObject:@"xr" forKey:@"itype"];
    [MDict setObject:_commentTextField.text forKey:@"content"];
    [MDict setObject:_detailModel.info.user_id forKey:@"user_id"];
    
    [self inputViewDown];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"]== 1)
         {
             _commentTextField.text = @"";
             
             NSDictionary *commentDict = [responseJson objectForKey:@"comment"];
             if (commentDict && [commentDict isKindOfClass:[NSDictionary class]])
             {
                 CommentModel *CModel = [CommentModel mj_objectWithKeyValues:commentDict];
                 [_dataArray insertObject:CModel atIndex:0];
             }
             _detailModel.info.comment_count =[NSString stringWithFormat:@"%d",(int)_dataArray.count] ;
             [_tableView reloadData];
             //需要告诉上一个页面评论数量
             if (self.operateCommentSuccessBlock) {
                 self.operateCommentSuccessBlock(_detailModel.info.comment_count);
             }
         }else{
            [BGHUDHelper alert:[responseJson toString:@"error"]];
         }
//
//         [[BGHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

- (void)tap{
    _isShowKeyBoard = NO;
    [self inputViewDown];
}

- (void)inputViewDown{
    _commentTextField.placeholder = ASLocalizedString(@"说点什么···");
    _comment_id = @"";
    _isShowKeyBoard = NO;
    [_commentTextField resignFirstResponder];
}

- (void)goToReportControllerWithTag:(int)tag commentModel:(CommentModel *)model{
    [self hide];
    BGReportController *reportVC = [[BGReportController alloc]init];
    reportVC.weibo_id = _detailModel.info.weibo_id;
    reportVC.to_user_id = _detailModel.info.user_id;
    reportVC.commentID = model.comment_id;
    if (tag == 1)//动态
    {
        reportVC.reportType = 1;
    }else if (tag == 2)
    {
        reportVC.reportType = 2;
    }else if (tag == 3)
    {
        reportVC.reportType = 3;
    }
    [[AppDelegate sharedAppDelegate] pushViewController:reportVC animated:YES];
}

- (void)deleteDynamicWithString:(NSString *)string{
    NSMutableDictionary *MDict = [NSMutableDictionary new];
    [MDict setObject:@"user" forKey:@"ctl"];
    [MDict setObject:@"del_weibo" forKey:@"act"];
    if (self.model.weibo_id)
    {
        [MDict setObject:self.model.weibo_id forKey:@"weibo_id"];
    }
    [MDict setObject:@"xr" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:MDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self);
         if ([responseJson toInt:@"status"]== 1)
         {
             
         }
         [[BGHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex{
    if (actionSheet.tag == 0)//如果是自己的评论，且是自己的回复就只有删除取消
    {
        if (buttonIndex == 0)
        {
            [self deleteCommentWithTag:_rowCount];
        }else if (buttonIndex == 1)
        {
            
        }
    }else if(actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self goToReportControllerWithTag:1 commentModel:nil];
        }else if (buttonIndex == 1)
        {
            [self goToReportControllerWithTag:2 commentModel:nil];
        }
    }else if(actionSheet.tag == 2)
    {
        if (buttonIndex == 0)
        {
            _isShowKeyBoard =! _isShowKeyBoard;
            if (_isShowKeyBoard == YES)
            {
                [_sendBtn setTitle:ASLocalizedString(@"回复")forState:UIControlStateNormal];
                [_commentTextField becomeFirstResponder];
                CommentModel *CModel =_dataArray[_rowCount];
                _commentTextField.placeholder = [NSString stringWithFormat:ASLocalizedString(@"回复%@"),CModel.nick_name];
                _comment_id = CModel.comment_id;
            }else
            {
                _commentTextField.placeholder = ASLocalizedString(@"说点什么···");
                _comment_id = @"";
                [self tap];
            }
        }
    }else if(actionSheet.tag == 3)//自己对自己的更多去操作
    {
        if (buttonIndex == 0)
        {
            [self deleteDynamicWithString:self.model.weibo_id];
        }
    }
}

- (void)setOperateCommentSuccessBlock:(operateCommentSuccessBlock)operateCommentSuccessBlock{
    _operateCommentSuccessBlock = operateCommentSuccessBlock;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self buttonClick];
    
    return YES;
    
}

#pragma mark - Lazy Load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputViewDown)];
        [_tableView addGestureRecognizer:tap];
        _tableView.userInteractionEnabled = YES;
        [_tableView registerClass:[BGReplyCell class] forCellReuseIdentifier:kCommentCellID];
        [BGMJRefreshManager refresh:_tableView target:self headerRereshAction:@selector(headerReresh) footerRereshAction:@selector(refresherOfNew)];
    }
    return _tableView;
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _shadowView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
        _shadowView.alpha = 0;
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (UITextField *)commentTextField{
    if (!_commentTextField) {
        _commentTextField = [[UITextField alloc]initWithFrame:CGRectZero];
        _commentTextField.userInteractionEnabled = YES;
        _commentTextField.layer.cornerRadius = 3;
//        _commentTextField.leftViewMode = UITextFieldViewModeAlways;
//        _commentTextField.backgroundColor = kBackGroundColor;
        _commentTextField.textColor = kBlackColor;
//        RGB(153, 153, 153);
        _commentTextField.textAlignment = NSTextAlignmentLeft;
        _commentTextField.font = [UIFont systemFontOfSize:12];
        _commentTextField.delegate = self;
        _commentTextField.placeholder = ASLocalizedString(@"说点什么···");
        _commentTextField.returnKeyType = UIReturnKeySend;
//        UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,40)];
//        leftView.backgroundColor = kClearColor;
//        _commentTextField.leftView = leftView;
//        _commentTextField.leftViewMode = UITextFieldViewModeAlways;
//        _commentTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _commentTextField;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-110, 5, 100, 40)];
        _sendBtn.layer.cornerRadius = 3;
        _sendBtn.backgroundColor = kAppMainColor;
        [_sendBtn setTitle:ASLocalizedString(@"发表评论")forState:UIControlStateNormal];
        [_sendBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _sendBtn.hidden = YES;
    }
    return _sendBtn;
}

- (UIImageView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _bottomView.backgroundColor = kWhiteColor;
        _bottomView.userInteractionEnabled = YES;
        _bottomView.image = [UIImage imageNamed:@"mg_video_comment"];
    }
    return _bottomView;
}

- (UIView *)commentShadowView{
    if (!_commentShadowView) {
        _commentShadowView = [[UIView alloc]initWithFrame:CGRectZero];
        _commentShadowView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.2];
        _commentShadowView.alpha = 0;
        _commentShadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [_commentShadowView addGestureRecognizer:tap];
    }
    return _commentShadowView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
