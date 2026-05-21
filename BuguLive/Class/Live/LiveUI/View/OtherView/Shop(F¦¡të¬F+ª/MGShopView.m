//
//  MGShopView.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/7/17.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "MGShopView.h"
#import "MGShopTableCell.h"

@implementation MGShopView

-(instancetype)initWithFrame:(CGRect)frame UserId:(NSString *)userID ResponseJson:(NSDictionary *)json{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kWhiteColor;
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        self.user_id = userID;
//        self.json = json;
        [self initSubview];
    }
    return self;
}
- (void)initSubview{
    [self addSubview:self.titleLabel];
    

    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom - 0.5, self.width, 0.5)];
    lineView.backgroundColor = kClearColor;
    [self addSubview:lineView];
    [self addSubview:self.tableView];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, kRealValue(25), kRealValue(25))];
    closeBtn.right = self.right - kRealValue(25);
    [closeBtn setImage:[UIImage imageNamed:@"pl_publishlive_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [self bringSubviewToFront:closeBtn];
}

-(void)closeBtn:(UIButton *)sender{
    [self hide];
}

- (void)requestWardData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"myshop" forKey:@"ctl"];
    [dict setValue:@"get_other_shop_product_list" forKey:@"act"];
    [dict setValue:self.user_id forKey:@"to_user_id"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 200) {
            //守护数量
        }
        [self.dataArray removeAllObjects];
        NSArray *arr = [responseJson valueForKey:@"list"];
        
        for (NSDictionary *dic in arr) {
            MGShopListModel *model = [MGShopListModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:model];
        }
        
        [self.tableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
//    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
//
//                if ([responseJson toInt:@"status"] == 200) {
//                    //守护数量
//                    [self.dataArray removeAllObjects];
//                    NSDictionary *dataDic = [responseJson valueForKey:@"data"];
//                    //守护数量
//                    NSString *total = dataDic[@"total"];
//
//                    [self.titleLabel setText:[NSString stringWithFormat:ASLocalizedString(@"道具礼物(%@)"),total]];
//
//                        self.tableView.frame = CGRectMake(0, self.titleLabel.bottom, self.bounds.size.width, self.bounds.size.height - self.titleLabel.height);
//
//                    NSArray *list = dataDic[@"data"];
//                    if (list && list.count) {
//                        for (NSDictionary *dict in list) {
//                            GiftModel *model = [GiftModel mj_objectWithKeyValues:dict];
//                            model.isSelected = NO;
//                            if (self.dataArray.count < 1) {
//                                model.isSelected = YES;
//                            }
//                            [self.dataArray addObject:model];
//                        }
//
//
//                        if (!self.dataArray.count) {
//                            [self addSubview:self.noWardView];
//                        }else{
//                            [self.noWardView removeFromSuperview];
//                        }
//                        [self.tableView reloadData];
//                    }else{
//
//                    }
//                }else{
//                    //接口请求失败
//                    NSLog(ASLocalizedString(@"守护列表请求数据失败responseJson:%@"),responseJson);
//                }
//
//    } failure:^(NSString *errorStr, id mark) {
//
//    }];
}

- (void)show:(UIView *)superView{
    [self requestWardData];
    
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        //        self.center = CGPointMake(kScreenW / 2, kScreenH / 2);
        self.bottom = kScreenH;
        self.shadowView.alpha = 1;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, kScreenH, self.width, self.height);
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.shadowView removeFromSuperview];
    }];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= self.dataArray.count) {
        return nil;
    }
    MGShopListModel *model = self.dataArray[indexPath.row];
    
    MGShopTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MGShopTableCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell resetViewWithModel:model];
    
//    cell.clickBtnBlock = ^(GiftModel * _Nonnull model) {
//
//
////        _model = model;
//    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MGShopListModel *model = self.dataArray[indexPath.row];
    
    if (![model.shop_url containsString:@"http"]) {
        [BGHUDHelper alert:ASLocalizedString(@"URL不合法")];
        return;
    }
       
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.shop_url]];
    
}

#pragma mark - Lazy Load
- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScaleH)];
        _shadowView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.3];
        _shadowView.alpha = 0;
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom, self.bounds.size.width, self.bounds.size.height - self.titleLabel.height - 60) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MGShopTableCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([MGShopTableCell class])];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WardViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([WardViewCell class])];
        _tableView.backgroundColor = kWhiteColor;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 50)];
        _titleLabel.text = ASLocalizedString(@"商品列表");
        _titleLabel.textColor = kBlackColor;
        _titleLabel.backgroundColor = kWhiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

//- (UIView *)noWardView{
//    if (!_noWardView) {
//        _noWardView = [[UIView alloc]initWithFrame:self.tableView.bounds];
//        _noWardView.top = kRealValue(44);
//        _noWardView.height = self.tableView.height - kRealValue(44);
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 188, 130)];
//        imageView.centerX = self.tableView.width / 2;
//        imageView.top = self.titleLabel.bottom + 10;
//        imageView.image = [UIImage imageNamed:ASLocalizedString(@"暂无数据")];
//        [_noWardView addSubview:imageView];
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, imageView.bottom + 20, self.tableView.width - 20, 20)];
//        label.textColor = RGB(230, 230, 230);
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont systemFontOfSize:15];
//        [_noWardView addSubview:label];
//        self.noWardViewLabel = label;
//    }
//    return _noWardView;
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
