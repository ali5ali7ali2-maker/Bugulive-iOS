//
//  RoomUserListView.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/16.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomUserListView.h"
#import "RoomModel.h"
#import "RoomUserListCell.h"
#import "RoomUserInfo.h"

@interface RoomUserListView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView *shadowView;
//@property(nonatomic, strong) NSString *page;
@property(nonatomic, assign) int page;
@end

@implementation RoomUserListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kWhiteColor;
        [self initSubview];
        self.page = 1;
    }
    return self;
}

- (void)initSubview{
    [self addSubview:self.titleLabel];
    [self addSubview:self.tableView];
}

- (void)refreshData{
    __weak __typeof(self)weakSelf = self;
    //http://www.bogo.voice.broadcast/mapi/public/index.php/api/Voice_api/get_voice_userlist
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"audience_list" forKey:@"act"];
    [dict setValue:self.room_id forKey:@"room_id"];
    [dict setValue:@(self.page) forKey:@"page"];
//    [[BGHUDHelper sharedInstance] syncLoading];

    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
//        [[BGHUDHelper sharedInstance] syncStopLoading];
        if ([responseJson toInt:@"status"] == 1) {
            if(self.page == 1)
            {
                [weakSelf.dataArray removeAllObjects];
            }
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header setState:MJRefreshStateIdle];

            NSMutableArray *data = responseJson[@"data"];
            if(data.count == 0)
            {
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            else
            {
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
            }
            for (NSDictionary *dict in data) {
                RoomUserInfo *model = [RoomUserInfo mj_objectWithKeyValues:dict];
                [weakSelf.dataArray addObject:model];
            }
            
            [weakSelf.tableView reloadData];
            [weakSelf.titleLabel setText:ASLocalizedString(@"在线观众")];
        }

        
        
    } FailureBlock:^(NSError *error) {
//        [[BGHUDHelper sharedInstance] syncStopLoading];
    }];
    /*
    NSString *url = [[CYURLUtils sharedCYURLUtils] makeURLWithC:@"Voice_api" A:@"get_voice_userlist"];
    [CYNET POSTv2:url parameters:@{@"id":_model.voice.id} responseCache:^(id responseObject) {
        //do nothing
    } success:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            [strongSelf.dataArray removeAllObjects];
            for (NSDictionary *dict in responseObject[@"userlist"]) {
                RoomUserInfo *model = [RoomUserInfo mj_objectWithKeyValues:dict];
                [strongSelf.dataArray addObject:model];
            }
            [strongSelf.tableView reloadData];
            [strongSelf.titleLabel setText:[NSString stringWithFormat:@"在线观众（%ld人）",strongSelf.dataArray.count]];
        }
    } failure:^(NSString *error) {
        [[HUDHelper sharedInstance] tipMessage:error];
    } hasCache:NO];*/
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RoomUserListCell class]) forIndexPath:indexPath];
    [cell setModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomUserInfo *info = self.dataArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(listView:didSelectUser:)]) {
        [self.delegate listView:self didSelectUser:info];
    }
}

- (void)show:(UIView *)superView{
    [self refreshData];
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    [self becomeFirstResponder];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.frame = CGRectMake(strongSelf.left, kScreenH / 2, strongSelf.width, strongSelf.height);
    }];
}

- (void)hide{
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.frame = CGRectMake(strongSelf.left, kScreenH, strongSelf.width, strongSelf.height);
    } completion:^(BOOL finished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.shadowView removeFromSuperview];
        [strongSelf removeFromSuperview];
    }];
}

- (UIView *)shadowView{
    if (!_shadowView) {
        
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _shadowView.backgroundColor = kClearColor;
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 70)];
        _titleLabel.text = ASLocalizedString(@"在线观众");
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = kBlackColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.width, self.height - 50) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RoomUserListCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RoomUserListCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kClearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = NO;
        _tableView.mj_header = header;
        
        //底部刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        
    }
    return _tableView;
}

-(void)headerRereshing{
    self.page = 1;
    [self refreshData];
}

-(void)footerRereshing{
    self.page++;
    [self refreshData];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
