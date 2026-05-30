//
//  MGLiveWishView.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/5.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGLiveWishView.h"
#import "MGAddWishViewController.h"

@implementation MGLiveWishView


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
    titleL.text = ASLocalizedString(@"直播心愿单(0/3)");
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont boldSystemFontOfSize:16];
    _titleL = titleL;
    
    UIButton *wishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wishBtn setTitle:ASLocalizedString(@"心愿单")forState:UIControlStateNormal];
    [wishBtn setTitleColor:[UIColor colorWithHexString:@"#CD49FF"] forState:UIControlStateNormal];
    wishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [wishBtn addTarget:self action:@selector(clickWish:) forControlEvents:UIControlEventTouchUpInside];
    wishBtn.frame = CGRectMake(kScreenW - kRealValue(60), 0, kRealValue(60), kRealValue(44));
    _wishBtn = wishBtn;
    
    [self addSubview:bgView];
    [self addSubview:titleL];
    [self addSubview:_wishBtn];
    [self addSubview:self.tableView];
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _titleL.text = [NSString stringWithFormat:ASLocalizedString(@"直播心愿单(%ld/3)"),self.listArr.count];
    return self.listArr.count > 0 ? self.listArr.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArr.count - 1 == indexPath.row || self.listArr.count == 0) {
        return kRealValue(300);
    }
    return kRealValue(140);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MGLiveWishCell";
    MGLiveWishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.bottomView.hidden = YES;
    if (self.listArr.count > 0) {
        [cell resetModelArr:self.listArr[indexPath.row] indexPath:indexPath.row];
    }
    if (indexPath.row == self.listArr.count - 1) {
        cell.bottomView.hidden = NO;
    }
    
    if (self.listArr.count == 0) {
        [cell resetModelArr:nil indexPath:indexPath.row];
        cell.bottomView.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

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

//点击事件
-(void)protocolMGLiveWishClickType:(MGADD_WISH)wishType{
    //生成心愿单
    if (wishType == MGWISHTYPE_GENERATE) {
        //删除删掉的
        if (self.listDeleteArr.count > 0) {
            for (int i = 0; i < self.listDeleteArr.count; i ++) {
                MGLiveWishModel *model = self.listDeleteArr[i];
                [self deleteWishModel:model isShowAlert:i == self.listDeleteArr.count - 1];
            }
        }
//        //先全部删除
//        for (int i = 0; i < self.listArr.count; i ++) {
//            MGLiveWishModel *model = self.listArr[i];
//           [self deleteWishModel:model isShowAlert:NO];
//        }
        
        if (self.listArr.count < 1) {
            [FanweMessage alert:ASLocalizedString(@"请添加心愿")];
            return;
        }
        
        for (int i = 0; i < self.listArr.count; i ++) {

               MGLiveWishModel *model = self.listArr[i];
            
               if ([BGUtils isBlankString:model.g_id]) {
                   [FanweMessage alert:ASLocalizedString(@"请选择礼物")];
                   return;
               }
            
               if ([BGUtils isBlankString:model.g_num]) {
                   [FanweMessage alert:ASLocalizedString(@"请填写礼物数量")];
                   return;
               }

               if ([BGUtils isBlankString:model.txt]) {
                   model.txt = @"";
               }
            
            [self generateWishModel:model isShowAlert:i == self.listArr.count - 1];
            
        }
        return;
    }
    
    if (wishType == MGWISHTYPE_ADD && self.listArr.count > 2) {
        [FanweMessage alertHUD:ASLocalizedString(@"心愿单不能超过三个！")];
        return;
    }
    
    if (self.clickLiveWishBlock) {
        self.clickLiveWishBlock(wishType);
    }
}

//生成心愿单
-(void)generateWishModel:(MGLiveWishModel *)model isShowAlert:(BOOL)isShowAlert{
    
    if (StrValid(model.id)) {
        return;
    }
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    [mDict setObject:@"user_wish" forKey:@"ctl"];
    [mDict setObject:@"pub_wish" forKey:@"act"];
    [mDict setObject:model.g_id forKey:@"g_id"];
    [mDict setObject:model.g_num forKey:@"g_num"];
    [mDict setObject:model.txt forKey:@"txt"];

    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {

        if ([responseJson toInt:@"status"] == 1)
        {
            if (isShowAlert)
            {
                [FanweMessage alert:ASLocalizedString(@"保存成功")];
                [self requestModel];
            }
        }
    } FailureBlock:^(NSError *error) {
        [FanweMessage alert:error.description];
    }];
    
}

//删除心愿单
-(void)deleteWishModel:(MGLiveWishModel *)model isShowAlert:(BOOL)isShowAlert{
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    [mDict setObject:@"user_wish" forKey:@"ctl"];
    [mDict setObject:@"del_wish" forKey:@"act"];
    [mDict setObject:model.id forKey:@"id"];

    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {

        if ([responseJson toInt:@"status"] == 1)
        {
            
//           if (isShowAlert) [FanweMessage alert:ASLocalizedString(@"生成成功")];
        }
    } FailureBlock:^(NSError *error) {
        [FanweMessage alert:error.description];
    }];
}

////生成心愿
//-(void)generateWish{
//    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
//    [mDict setObject:@"user_wish" forKey:@"ctl"];
////    [mDict setObject:@"del_wish" forKey:@"act"];
//
//    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
//        if ([responseJson toInt:@"status"] == 1)
//        {
//
//        }
//    } FailureBlock:^(NSError *error) {
//
//    }];
//}

//删除
-(void)protocolLiveWishClickDelteModel:(MGLiveWishModel *)model{
    
    if (![BGUtils isBlankString:model.id]) {
        [self.listDeleteArr addObject:model];
    }else{
        

    }
    
    [self.listArr removeObject:model];
    [self.tableView reloadData];
    
//    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
//    [mDict setObject:@"user_wish" forKey:@"ctl"];
//    [mDict setObject:@"del_wish" forKey:@"act"];
//    [mDict setObject:model.id forKey:@"id"];
//
//    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
//
//        if ([responseJson toInt:@"status"] == 1)
//        {
//            [FanweMessage alertHUD:ASLocalizedString(@"删除心愿成功")];
//            [self.tableView reloadData];
//        }
//    } FailureBlock:^(NSError *error) {
//
//    }];
}

//请求心愿单列表
-(void)requestModel{
    self.listArr = [NSMutableArray array];
    self.listDeleteArr = [NSMutableArray array];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user_wish" forKey:@"ctl"];
    [mDict setObject:@"wish_list" forKey:@"act"];
    //4-16 3.心愿单无效。
    [mDict setObject:_roomId forKey:@"room_id"];
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] == 1)
        {
           NSArray *arr = [responseJson valueForKey:@"list"];
           if (arr.count > 0) {
               for (NSDictionary *dic in arr)
               {
                   MGLiveWishModel *model = [MGLiveWishModel mj_objectWithKeyValues:dic];
                   [self.listArr addObject:model];
               }
           }
            _titleL.text = [NSString stringWithFormat:ASLocalizedString(@"直播心愿单(%ld/3)"),self.listArr.count];
            
           [self.tableView reloadData];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - Show And Hide
- (void)show:(UIView *)superView{
    
    [self requestModel];
    
    [superView addSubview:self.shadowView];
    [superView addSubview:self];

    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
        self.y = kScreenH / 2;
    }];
}

- (void)hide{
    
    
    
    if (self.clickHideLiveWishBlock) {
        self.clickHideLiveWishBlock();
    }
    
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
        [_tableView registerClass:[MGLiveWishCell class] forCellReuseIdentifier:@"MGLiveWishCell"];
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

//心愿单列表
-(void)clickWish:(UIButton *)sender{
    if (self.clickLiveWishBlock) {
        self.clickLiveWishBlock(MGWISHTYPE_LIST);
    }
}

-(void)clickAddWish:(UIButton *)sender{
    
    
    
    if (self.clickLiveWishBlock) {
        self.clickLiveWishBlock(MGWISHTYPE_ADD);
    }
}



@end
