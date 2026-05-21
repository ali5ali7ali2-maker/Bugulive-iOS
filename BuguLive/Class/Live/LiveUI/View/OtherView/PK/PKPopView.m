//
//  PKPopView.m
//  BuguLive
//
//  Created by 范东 on 2019/1/24.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "PKPopView.h"
#import "PKTimeModel.h"

#import <QMUIButton.h>

#define kPKPopViewTimePrefix @""
//ASLocalizedString(@"PK时长     ")
@interface PKPopView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) PKPopViewType type;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) QMUIButton *timeBtn;

@property (nonatomic, copy) clickTimeCellBlock clickTimeCellBlock;
@property (nonatomic, copy) clickSetTimeBlcok clickSetTimeBlcok;
@property (nonatomic, copy) clickPkBtnBlock clickPkBtnBlock;
@property (nonatomic, copy) clickEndPkBtnBlock clickEndPkBtnBlock;

@end

@implementation PKPopView

- (instancetype)initWithType:(PKPopViewType)type{
    if (self = [super init]) {
        _type = type;
        [self initSubview];
    }
    return self;
}

- (void)initSubview{
    switch (_type) {
        case PKPopViewTypeInvication:
        {
            [self requestPKListData];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
            titleLabel.textColor = kBlackColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = ASLocalizedString(@"设置PK时长")
            ;
            titleLabel.font = [UIFont systemFontOfSize:17];
            [self addSubview:titleLabel];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, kScreenW, 0.5)];
            lineView.backgroundColor = kBlackColor;
            [self addSubview:lineView];
            
            //            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, lineView.bottom + 20, kScreenW - 200, 30)];
            //            timeLabel.font = [UIFont systemFontOfSize:15];
            //            timeLabel.textColor = kWhiteColor;
            //            [self addSubview:timeLabel];
            //            self.timeLabel = timeLabel;
            
            //            UIButton *timeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kRealValue(75), kRealValue(200), kRealValue(40))];
            QMUIButton *timeBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
            timeBtn.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
//            [UIColor colorWithHexString:@"#28292F"];
            timeBtn.frame = CGRectMake(0, 75, 200, 40);
            timeBtn.centerX = kScreenW / 2;
            [timeBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            timeBtn.layer.masksToBounds = YES;
            timeBtn.imagePosition = QMUIButtonImagePositionRight;
            timeBtn.layer.cornerRadius = 4;
            [timeBtn setImage:[UIImage imageNamed:@"lr_live_go_up"] forState:UIControlStateNormal];
            timeBtn.spacingBetweenImageAndTitle = 20;
            [timeBtn addTarget:self action:@selector(timeBtnAction) forControlEvents:UIControlEventTouchUpInside];
            self.timeBtn = timeBtn;
            [self addSubview:timeBtn];
            
            UIButton *pkBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, timeBtn.bottom + 40, kScreenW - 100, 44)];
            [pkBtn setTitle:ASLocalizedString(@"确定发起PK")
                   forState:UIControlStateNormal];
            [pkBtn setBackgroundImage:[UIImage imageNamed:@"com_button_btn"] forState:UIControlStateNormal];
            [pkBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
            [pkBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [pkBtn addTarget:self action:@selector(pkBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:pkBtn];
            
            self.backgroundColor = kWhiteColor;
//            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95];
        }
            break;
        case PKPopViewTypeDetail:
        {
            
            self.backgroundColor = kWhiteColor;
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
            titleLabel.textColor = kBlackColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = ASLocalizedString(@"约战PK")
            ;
            titleLabel.font = [UIFont systemFontOfSize:15];
            [self addSubview:titleLabel];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, kScreenW, 0.5)];
            lineView.backgroundColor = kBlackColor;
            [self addSubview:lineView];
            
            UIImageView *middleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 57, 12)];
            [middleImageView setImage:[UIImage imageNamed:@"bg_over_pk_middle"]];
            middleImageView.centerX = kScreenW / 2;
            [self addSubview:middleImageView];
            
            UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            leftImageView.layer.cornerRadius = 50;
            leftImageView.clipsToBounds = YES;
            leftImageView.contentMode = UIViewContentModeScaleAspectFit;
            leftImageView.centerY = middleImageView.centerY;
            leftImageView.right = middleImageView.left - 10;
            [leftImageView sd_setImageWithURL:[NSURL URLWithString:[[[IMAPlatform sharedInstance] host] imUserIconUrl]] placeholderImage:kDefaultPreloadHeadImg];
            [self addSubview:leftImageView];
            self.leftImageView = leftImageView;
            
            UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            rightImageView.layer.cornerRadius = 50;
            rightImageView.clipsToBounds = YES;
            rightImageView.contentMode = UIViewContentModeScaleAspectFit;
            rightImageView.centerY = middleImageView.centerY;
            rightImageView.left = middleImageView.right + 10;
            [self addSubview:rightImageView];
            self.rightImageView = rightImageView;
            
            UIButton *endPkBtn = [[UIButton alloc]initWithFrame:CGRectMake(64, self.rightImageView.bottom+20, kScreenW - 128, 44)];
            [endPkBtn setBackgroundImage:[UIImage imageNamed:@"bg_over_pk_text"] forState:UIControlStateNormal];
            [endPkBtn setTitle:ASLocalizedString(@"结束PK")
                      forState:UIControlStateNormal];
            [endPkBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [endPkBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
            [endPkBtn addTarget:self action:@selector(endPkBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:endPkBtn];
        }
            break;
        case PKPopViewSelectTime:
        {
            self.backgroundColor = kWhiteColor;
            [self addSubview:self.tableView];
            [self requestPKListData];
        }
            break;
        default:
            break;
    }
}

- (void)setPkTimeModel:(PKTimeModel *)pkTimeModel{
    _pkTimeModel = pkTimeModel;
    //    self.timeLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@%@分钟"),kPKPopViewTimePrefix,pkTimeModel.time];
    [self.timeBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"%@%@分钟")
                            ,kPKPopViewTimePrefix,pkTimeModel.time] forState:UIControlStateNormal];
}

#pragma mark - Data
- (void)requestPKListData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    //    ctl=pk&act=pk_list
    if(![GlobalVariables sharedInstance].openAgora)
    {
        [dict setObject:@"pk_tencent" forKey:@"ctl"];
    }
    else
    {
        [dict setObject:@"pk_agora" forKey:@"ctl"];
    }
    [dict setValue:@"pk_list" forKey:@"act"];
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            NSLog(ASLocalizedString(@"PKList接口请求成功responseJson:%@")
                  ,responseJson);
            [self.dataArray removeAllObjects];
            NSArray *listArray = [responseJson objectForKey:@"list"];
            if (listArray.count) {
                for (NSDictionary *dict in listArray) {
                    PKTimeModel *model = [PKTimeModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
            }
            PKTimeModel *model = self.dataArray.firstObject;
            //            if (self.timeLabel) {
            //                self.timeLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@%@分钟"),kPKPopViewTimePrefix,model.time];
            //            }
            if (self.timeBtn) {
                [self.timeBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"%@%@分钟")
                                        ,kPKPopViewTimePrefix,model.time] forState:UIControlStateNormal];
            }
            
            if (self.tableView) {
                [self.tableView reloadData];
            }
        }else{
            NSLog(ASLocalizedString(@"PKList接口请求失败responseJson:%@")
                  ,responseJson);
        }
    } FailureBlock:^(NSError *error) {
        NSLog(ASLocalizedString(@"PKList接口请求失败error:%@")
              ,error);
    }];
}

- (void)requestPKUserInfo{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"user" forKey:@"ctl"];
    [dict setValue:@"user_home" forKey:@"act"];
    [dict setValue:_otherId forKey:@"to_user_id"];
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            NSLog(ASLocalizedString(@"获取对方用户信息成功responseJson:%@")
                  ,responseJson);
            [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:responseJson[@"user"][@"head_image"]] placeholderImage:kDefaultPreloadHeadImg];
        }else{
            NSLog(ASLocalizedString(@"获取对方用户信息失败responseJson:%@")
                  ,responseJson);
        }
    } FailureBlock:^(NSError *error) {
        NSLog(ASLocalizedString(@"获取对方用户信息失败error:%@")
              ,error);
    }];
}

#pragma mark - Action
- (void)timeBtnAction{
    if (self.clickSetTimeBlcok) {
        self.clickSetTimeBlcok();
    }
}

- (void)pkBtnAction{
    [self hide];
    if (self.clickPkBtnBlock) {
        if (_pkTimeModel) {
            self.clickPkBtnBlock(_pkTimeModel.id);
        }else{
            PKTimeModel *model = self.dataArray.firstObject;
            self.clickPkBtnBlock(model.id);
        }
    }
}

- (void)endPkBtnAction{
    [self hide];
    if (self.clickEndPkBtnBlock) {
        self.clickEndPkBtnBlock();
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    PKTimeModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@分钟")
                           ,model.time];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    headerView.backgroundColor = kWhiteColor;
    UILabel *onlineListLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenW - 10, 40)];
    onlineListLabel.text = ASLocalizedString(@"PK时间选择")
    ;
    onlineListLabel.font = [UIFont systemFontOfSize:15];
    onlineListLabel.textColor = kBlackColor;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, kScreenW, 0.5)];
    lineView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.3];
    [headerView addSubview:onlineListLabel];
    [headerView addSubview:lineView];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PKTimeModel *model = self.dataArray[indexPath.row];
    [self hide];
    if (self.clickTimeCellBlock) {
        self.clickTimeCellBlock(model);
    }
}

#pragma mark - Show And Hide
- (void)show:(UIView *)superView{
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
//    //2020-1-4 最上方
//    [superView bringSubviewToFront:self.shadowView];
//    //[self bringSubviewToFront:self.shadowView];

    if (_type == PKPopViewTypeDetail) {
        [self requestPKUserInfo];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
        if (_type == PKPopViewTypeDetail) {
            self.y = kScreenH - 268;
        }else{
            self.y = kScreenH - 268;
        }
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
        self.y = kScreenH;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - Block
- (void)setClickSetTimeBlcok:(clickSetTimeBlcok)clickSetTimeBlcok{
    _clickSetTimeBlcok = clickSetTimeBlcok;
}

- (void)setClickTimeCellBlock:(clickTimeCellBlock)clickTimeCellBlock{
    _clickTimeCellBlock = clickTimeCellBlock;
}

- (void)setClickPkBtnBlock:(clickPkBtnBlock)clickPkBtnBlock{
    _clickPkBtnBlock = clickPkBtnBlock;
}

- (void)setClickEndPkBtnBlock:(clickEndPkBtnBlock)clickEndPkBtnBlock{
    _clickEndPkBtnBlock = clickEndPkBtnBlock;
}

#pragma mark - Lazy Load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
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

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 200) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

@end
