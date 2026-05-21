//
//  MGShowVIPListView.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/19.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGShowVIPListView.h"

@implementation MGShowVIPListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(50))];
    bgView.backgroundColor = kWhiteColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = kRealValue(4);
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW / 2, kRealValue(44))];
    titleL.centerX = kScreenW / 2;
    titleL.text = ASLocalizedString(@"贵族列表");
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont boldSystemFontOfSize:16];
    _titleL = titleL;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(kScreenW - 40, 0, 40, 40);
    [closeBtn setImage:[UIImage imageNamed:@"com_close_2"] forState:UIControlStateNormal];
    closeBtn.hidden = YES;
    [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:bgView];
    [self addSubview:titleL];
    [self addSubview:self.tableView];
    [self addSubview:closeBtn];
}

- (void)closeBtnAction{
    [self.shadowView removeFromSuperview];
    [self removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRealValue(54);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BogoShowNobleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoShowNobleCell"];
    
    if (self.listArr.count > 0) {
//        MGShowVipModel *model = self.listArr[indexPath.row];
        [cell resetModel:self.listArr[indexPath.row]];
        WeakSelf
        cell.clickHeadBlock = ^(MGShowVipModel * _Nonnull model) {
            [weakSelf pushPesonVCWithModel:model];
        };
        cell.headViewAttentionBlock = ^(BOOL isAttention) {
            [weakSelf requestModelWithRoomID:weakSelf.roomID];
        };
        cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)pushPesonVCWithModel:(MGShowVipModel *)model{
    
    if (model.is_noble_mysterious.integerValue == 1) {
        return;;
    }
    
    SHomePageVC *tmpController= [[SHomePageVC alloc]init];
    tmpController.user_id = model.uid;
    tmpController.type = 0;
    [[AppDelegate sharedAppDelegate]pushViewController:tmpController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

//-(void)

//手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITableView class]]){
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

-(void)requestModelWithRoomID:(NSString *)roomID{
    self.roomID = roomID;
    self.listArr = [NSMutableArray array];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"get_noble_list_test" forKey:@"act"];
    [mDict setObject:roomID forKey:@"room_id"];

    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1)
        {
            NSArray *arr = [NSArray modelArrayWithClass:[MGShowVipModel class] json:[responseJson valueForKey:@"noble_list"]];
//            [responseJson valueForKey:@"noble_list"];
            [self.listArr removeAllObjects];
            [self.listArr addObjectsFromArray:arr];

            [self.tableView reloadData];
        }
    } FailureBlock:^(NSError *error) {

    }];
}


#pragma mark - Show And Hide
- (void)show:(UIView *)superView  withRoomID:(NSString *)roomID{
    [self requestModelWithRoomID:roomID];
    
    [superView addSubview:self.shadowView];
    [superView addSubview:self];

    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
        self.y = kScreenH / 2;
    }];
}



- (void)hide{
//
//    if (self.clickHideLiveWishBlock) {
//        self.clickHideLiveWishBlock();
//    }
//
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
        self.y = kScreenH;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.titleL.bottom, kScreenW, kScreenH / 2 - self.titleL.bottom) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"BogoShowNobleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BogoShowNobleCell"];
//        [_tableView registerClass:[BogoShowNobleCell class] forCellReuseIdentifier:@"BogoShowNobleCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
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


@end
