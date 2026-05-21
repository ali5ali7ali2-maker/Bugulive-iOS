//
//  RoomMicUserListView.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/8.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomMicUserListView.h"
//#import "RoomMicManageCell.h"
#import "RoomModel.h"
#import "RoomUserInfo.h"
#import "BGRoomMicManageCell.h"
#import "HTSegmentedScrollView.h"
#import "VoiceHTTPManger.h"
@interface RoomMicUserListView ()<UITableViewDelegate,UITableViewDataSource,RoomMicManageCellDelegate>

@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) UILabel *applyLabel;
@property(nonatomic, strong) UIView *shadowView;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITableView *tableView2;

@property(nonatomic, strong) QMUIButton *searchBtn;

@end

@implementation RoomMicUserListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        HTSegmentedScrollView *segView = [[HTSegmentedScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.height)];
        [self addSubview:segView];
        
        [segView addSegmentedItems:@[ASLocalizedString(@"上麦申请"), ASLocalizedString(@"麦位管理")]];
        

        
        
        
        
        self.backgroundColor = kWhiteColor;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 50)];
        titleLabel.textColor = kAppGrayColor1;
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = ASLocalizedString(@"抱人上麦");
        titleLabel.hidden = YES;
        [self addSubview:titleLabel];
        [self addSubview:self.searchBtn];
        self.searchBtn.hidden = YES;
        [self addSubview:self.backBtn];
//        [self addSubview:self.tableView];
        
        
        [segView addScrollViews:@[self.tableView, self.tableView2]];

        
        
    }
    return self;
}
- (void)searchBtnAction:(QMUIButton *)sender{
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(userListView:didClicSearchBtn:)]) {
//        [self.delegate userListView:self didClicSearchBtn:sender];
//    }
    

    
    [self addSearchTF];
    
    
    
}

-(void)request
{
    
}
- (void)addSearchTF {
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ASLocalizedString(@"请输入用户ID：") message:nil preferredStyle:UIAlertControllerStyleAlert];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:ASLocalizedString(@"抱TA上麦") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          //获取第1个输入框；
          UITextField *userNameTextField = alertController.textFields.firstObject;
          
          //获取第2个输入框；
    //      UITextField *passwordTextField = alertController.textFields.lastObject;
          
          NSLog(@"用户ID = %@",userNameTextField.text);
            if (StrValid(userNameTextField.text)) {
                [self searchID:userNameTextField.text];

            }
        }]];
        
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:ASLocalizedString(@"取消") style:UIAlertActionStyleDefault handler:nil]];
        
        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
          textField.placeholder = ASLocalizedString(@"请输入用户ID");
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
    //    //定义第二个输入框；
    //    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    //      textField.placeholder = @"请输入密码";
    //    }];
        
        [self.vc presentViewController:alertController animated:true completion:nil];
        
    
    
    
}
- (void)searchID:(NSString *)ID {
    
    BOOL ret = NO;
    for (RoomUserInfo *model in self.dataArray) {
        if ([model.user_id isEqualToString:ID]) {
            ret = YES;
//            RoomMicManageCell * messageCell = [[RoomMicManageCell alloc]init];
            BGRoomMicManageCell * messageCell = [[BGRoomMicManageCell alloc]init];

            messageCell.model = model;
            if (self.delegate && [self.delegate respondsToSelector:@selector(userListView:manageCell:didClickManageBtn:)]) {
                [self.delegate userListView:self manageCell:messageCell didClickManageBtn:nil];
            }
        }
    }
    
    if (ret == NO) {
        
    }
    
}

- (void)reqeustData {
    
    [self.voiceApi requestWheatListType:@"0" block:^(NSDictionary *selfPtr) {
         NSMutableArray *dataArr = [NSMutableArray modelArrayWithClass:RoomUserInfo.class json:selfPtr[@"data"]];
         self.dataArray = dataArr;
        [self.tableView reloadData];
     }];
    
    [self.voiceApi requestWheatListType:@"1" block:^(NSDictionary *selfPtr) {
         NSMutableArray *dataArr = [NSMutableArray modelArrayWithClass:RoomUserInfo.class json:selfPtr[@"data"]];
         self.dataArray2 = dataArr;
        [self.tableView2 reloadData];
     }];
    
    
}
- (void)setModel:(RoomModel *)model{
    _model = model;
    [self requestData];
}

- (void)requestData{
    __weak __typeof(self)weakSelf = self;
    //http://www.bogo.voice.broadcast/mapi/public/index.php/api/Voice_Additional_api/voice_up_list
   
    /*
    
    NSString *url = [[CYURLUtils sharedCYURLUtils] makeVoiceURLWithC:@"Voice_Additional_api" A:@"voice_up_list"];
    [CYNET POSTv2:url parameters:@{@"voice_id":self.model.voice.user_id} responseCache:^(id responseObject) {
        //do nothing
    } success:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            [strongSelf.dataArray removeAllObjects];
            for (NSDictionary *dict in responseObject[@"list"]) {
                RoomUserInfo *model = [RoomUserInfo mj_objectWithKeyValues:dict];
                model.user_name = model.user_nickname;
                model.user_img = model.avatar;
                [strongSelf.dataArray addObject:model];
            }
            [strongSelf.applyLabel setText:[NSString stringWithFormat:ASLocalizedString(@"  房间在线 (%ld人)"),strongSelf.dataArray.count]];
            [strongSelf.tableView reloadData];
        }
    } failure:^(NSString *error) {
        [[HUDHelper sharedInstance] tipMessage:error];
    } hasCache:NO];
     
     */
}

- (void)backBtnAction:(UIButton *)sender{
    [self hide];
}

- (void)manageCell:(RoomMicManageCell *)messageCell didClickManageBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userListView:manageCell:didClickManageBtn:)]) {
        [self.delegate userListView:self manageCell:messageCell didClickManageBtn:sender];
    }
}

- (void)show:(UIView *)superView{
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    [self reqeustData];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.frame = CGRectMake(0, kScreenH - strongSelf.height, strongSelf.width, strongSelf.height);
    }];
}

- (void)hide{
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.frame = CGRectMake(0, kScreenH, strongSelf.width, strongSelf.height);
    } completion:^(BOOL finished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.shadowView removeFromSuperview];
        [strongSelf removeFromSuperview];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tableView)
    {
        return self.dataArray.count;
    }
    else
    {
        return self.dataArray2.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    RoomMicManageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RoomMicManageCell class]) forIndexPath:indexPath];
    BGRoomMicManageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BGRoomMicManageCell class]) forIndexPath:indexPath];

    cell.delegate = self;
    
    if(tableView == self.tableView)
    {
        [cell setType:RoomMicManageCellTypeApplyList];
        [cell setModel:self.dataArray[indexPath.row]];

    }
    else
    {
        [cell setType:RoomMicManageCellTypeManageView];
        [cell setModel:self.dataArray2[indexPath.row]];

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.applyLabel;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 50)];
        [_backBtn setImage:[UIImage imageNamed:@"back_b"] forState:UIControlStateNormal];

//        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
//        [_backBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        [_backBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}



- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height - 50) style:UITableViewStylePlain];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RoomMicManageCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RoomMicManageCell class])];
        [_tableView registerClass:[BGRoomMicManageCell class] forCellReuseIdentifier:NSStringFromClass([BGRoomMicManageCell class])];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UITableView *)tableView2{
    if (!_tableView2) {
        _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.width, self.height - 50) style:UITableViewStylePlain];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RoomMicManageCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RoomMicManageCell class])];
        [_tableView2 registerClass:[BGRoomMicManageCell class] forCellReuseIdentifier:NSStringFromClass([BGRoomMicManageCell class])];

        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.backgroundColor = kClearColor;
        _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView2;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)dataArray2{
    if (!_dataArray2) {
        _dataArray2 = [NSMutableArray array];
    }
    return _dataArray2;
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _shadowView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.4];
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

- (QMUIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[QMUIButton alloc]initWithFrame:CGRectMake(self.width- 80, 0, 70, 50)];
        _searchBtn.imagePosition = QMUIButtonImagePositionRight;
//        _searchBtn.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
        _searchBtn.spacingBetweenImageAndTitle = 30;
        [_searchBtn setImage:[UIImage imageNamed:@"seach"] forState:UIControlStateNormal];
        [_searchBtn setTitle:@"" forState:UIControlStateNormal];
//        _searchBtn.layer.cornerRadius = 17;
        _searchBtn.clipsToBounds = YES;
        [_searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

@end

