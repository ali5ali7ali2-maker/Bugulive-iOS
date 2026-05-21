//
//  WardPopView.m
//  BuguLive
//
//  Created by 范东 on 2019/1/28.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "WardPopView.h"
#import "WardViewTopCell.h"
#import "WardViewCell.h"
#import "WardPopViewModel.h"

@interface WardPopView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) clickOpenBtnBlock clickOpenBtnBlock;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, strong) UIView *noWardView;
@property (nonatomic, strong) UILabel *noWardViewLabel;
@property (nonatomic, strong) NSDictionary *json;
@property (nonatomic, copy) clickWardPopViewCellBlock clickWardPopViewCellBlock;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation WardPopView

- (instancetype)initWithFrame:(CGRect)frame UserId:(nonnull NSString *)userID ResponseJson:(nonnull NSDictionary *)json{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = KMGMainBGColor;
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        self.user_id = userID;
        self.json = json;
        
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.bottom.equalTo(self).offset(-10);
            make.height.equalTo(@50);
        }];
        
        bottomView.layer.cornerRadius = 5;
        bottomView.backgroundColor = [UIColor colorWithHexString:@"#F2F0FF"];
        
        [self initSubview];
    }
    return self;
}


-(void)setGradientLayer
{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.bounds;
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:174/255.0 green:44/255.0 blue:241/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:137/255.0 green:106/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0f)];

    [self.layer insertSublayer:gl atIndex:0];
    self.layer.cornerRadius = 20;
}

- (void)initSubview{
    
    [self setGradientLayer];
    
    [self addSubview:self.titleLabel];
    

    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom - 0.5, self.width, 0.5)];
    lineView.backgroundColor = kClearColor;
    [self addSubview:lineView];
    [self addSubview:self.tableView];
    [self setData];
    
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
    [dict setValue:@"guardians" forKey:@"ctl"];
    [dict setValue:@"index" forKey:@"act"];
    [dict setValue:self.user_id forKey:@"host_id"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        FWStrongify(self)
        NSLog(@"104responseJson%@",responseJson);
        if ([responseJson toInt:@"status"] == 1) {
            //守护数量
            [self.dataArray removeAllObjects];
            //是否已经开通守护
            NSString *is_guartian = responseJson[@"is_guartian"];
            //守护数量
            NSString *guardian_sum = responseJson[@"guardian_sum"];
            NSString *guardian_time = responseJson[@"guartian_time"];
            if (guardian_time.length > 10) {
                guardian_time = [guardian_time substringToIndex:10];
            }
            
            
            [self.titleLabel setText:[NSString stringWithFormat:ASLocalizedString(@"守护(%@)"),guardian_sum]];
            if (![self.user_id isEqualToString:[IMAPlatform sharedInstance].host.imUserId]) {
                if (!self.tipLabel) {
                    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.tableView.bottom + 10, self.width - 120, 40)];
                    tipLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
                    tipLabel.font = [UIFont systemFontOfSize:15];
                    tipLabel.numberOfLines = 0;
                    tipLabel.backgroundColor = kClearColor;
                    [self addSubview:tipLabel];
                    self.tipLabel = tipLabel;
                }
                if (is_guartian.integerValue == 2) {
                    self.tipLabel.text = ASLocalizedString(@"快去为你喜爱的主播开通守护吧!");
                }else{
                    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",ASLocalizedString(@"到期时间:"),guardian_time]];
                    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(ASLocalizedString(@"到期时间:").length, guardian_time.length)];
                    self.tipLabel.attributedText = attr;
                }
                
                UIButton *openBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.tipLabel.right, self.tableView.bottom + 5, 100, 40)];
                if (is_guartian.integerValue == 1) {
                    [openBtn setTitle:ASLocalizedString(@"续费守护")forState:UIControlStateNormal];
                }else{
                    [openBtn setTitle:ASLocalizedString(@"开通守护")forState:UIControlStateNormal];
                }
                
                [openBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                [openBtn setBackgroundImage:[UIImage imageNamed:@"lr_btn_ward_bg"] forState:UIControlStateNormal];
                [openBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [openBtn addTarget:self action:@selector(openBtnAction) forControlEvents:UIControlEventTouchUpInside];
                openBtn.layer.cornerRadius = 20;
                openBtn.clipsToBounds = YES;
                [self addSubview:openBtn];
            }else{
                self.tableView.frame = CGRectMake(0, self.titleLabel.bottom, self.bounds.size.width, self.bounds.size.height - self.titleLabel.height);
            }
            NSArray *list = responseJson[@"list"];
            if (list && list.count) {
                for (NSDictionary *dict in list) {
                    WardPopViewModel *model = [WardPopViewModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                
                if (self.dataArray.count > 0) {
                    WardPopViewModel *model = self.dataArray.firstObject;
//                    if (model.total_diamonds.integerValue < 1) {
//
//                    }
                    
                    WardPopViewModel *emptyModel = [WardPopViewModel new];
                    if (model.total_diamonds.intValue == 0) {
                        emptyModel.uid = @"0";
                        [self.dataArray insertObject:emptyModel atIndex:0];
                    }
                }
                
//                WardPopViewModel *firstModel = self.dataArray.firstObject;
//                if (!firstModel.total_diamonds.integerValue) {
//                    WardPopViewModel *model = [[WardPopViewModel alloc]init];
//                    model.total_diamonds = @"0";
//                    [self.dataArray insertObject:model atIndex:0];
//                }
                
//                if (!self.dataArray.count) {
//                    [self addSubview:self.noWardView];
//                }else{
                    [self.noWardView removeFromSuperview];
//                }
                [self.tableView reloadData];
            }else{
//                [self addSubview:self.noWardView];
                if ([self.user_id isEqualToString:[IMAPlatform sharedInstance].host.imUserId]) {
                    self.noWardViewLabel.text = ASLocalizedString(@"我的守护正星夜兼程的赶来");
                }else{
                    self.noWardViewLabel.text = ASLocalizedString(@"成为TA的第一个守护");
                }
            }
        }else{
            //接口请求失败
            NSLog(ASLocalizedString(@"守护列表请求数据失败responseJson:%@"),responseJson);
        }
    } FailureBlock:^(NSError *error) {
        NSLog(ASLocalizedString(@"守护列表请求数据失败error:%@"),error);
    }];
}

- (void)setData{
    [self.dataArray removeAllObjects];
    //是否已经开通守护
    NSString *is_guartian = [NSString stringWithFormat:@"%@", self.json[@"is_guartian"]];
    //守护数量
    NSString *guardian_sum = [NSString stringWithFormat:@"%@", self.json[@"guardian_sum"]];
    NSString *guartian_time = [NSString stringWithFormat:@"%@", self.json[@"guartian_time"]];
    
    guardian_sum = [BGUtils isBlankString:guardian_sum] ? @"0" : guardian_sum;
    guartian_time = [BGUtils isBlankString:guartian_time] ? @"" : guartian_time;
    
    if (guartian_time.length > 10) {
        guartian_time = [guartian_time substringToIndex:10];
    }
    
    [self.titleLabel setText:[NSString stringWithFormat:ASLocalizedString(@"守护(%@)"),guardian_sum]];
    if (![self.user_id isEqualToString:[IMAPlatform sharedInstance].host.imUserId]) {
        if (!self.tipLabel) {
            UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.tableView.bottom + 10, self.width - 120, 40)];
            tipLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            tipLabel.font = [UIFont systemFontOfSize:15];
            tipLabel.numberOfLines = 0;
            tipLabel.backgroundColor = kClearColor;
            [self addSubview:tipLabel];
            self.tipLabel = tipLabel;
        }
        if (is_guartian.integerValue == 2) {
            self.tipLabel.text = ASLocalizedString(@"快去为你喜爱的主播开通守护吧!");
        }else{
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",ASLocalizedString(@"到期: "),guartian_time]];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#399ADF"] range:NSMakeRange(ASLocalizedString(@"到期: ").length, guartian_time.length)];
            self.tipLabel.attributedText = attr;
        }
        
        UIButton *openBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.tipLabel.right, self.tableView.bottom + 5, 100, 40)];
        if (is_guartian.integerValue == 1) {
            [openBtn setTitle:ASLocalizedString(@"续费守护")forState:UIControlStateNormal];
        }else{
            [openBtn setTitle:ASLocalizedString(@"开通守护")forState:UIControlStateNormal];
        }
        [openBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [openBtn setBackgroundImage:[UIImage imageNamed:@"lr_btn_ward_bg"] forState:UIControlStateNormal];
        [openBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [openBtn addTarget:self action:@selector(openBtnAction) forControlEvents:UIControlEventTouchUpInside];
        openBtn.layer.cornerRadius = 20;
        openBtn.clipsToBounds = YES;
        [self addSubview:openBtn];
    }else{
        self.tableView.frame = CGRectMake(0, self.titleLabel.bottom, self.bounds.size.width, self.bounds.size.height - self.titleLabel.height);
    }
    NSArray *list = self.json[@"list"];
    if (list && list.count) {
        for (NSDictionary *dict in list) {
            WardPopViewModel *model = [WardPopViewModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        
        WardPopViewModel *firstModel = self.dataArray.firstObject;
        if (!firstModel.total_diamonds.integerValue) {
            WardPopViewModel *model = [[WardPopViewModel alloc]init];
            model.total_diamonds = @"0";
            [self.dataArray insertObject:model atIndex:0];
        }
        
        if (!self.dataArray.count) {
//            [self addSubview:self.noWardView];
            if ([self.user_id isEqualToString:[IMAPlatform sharedInstance].host.imUserId]) {
                self.noWardViewLabel.text = ASLocalizedString(@"我的守护正星夜兼程的赶来");
            }else{
                self.noWardViewLabel.text = ASLocalizedString(@"成为TA的第一个守护");
            }
        }else{
            [self.noWardView removeFromSuperview];
        }
        [self.tableView reloadData];
    }else{
//        [self addSubview:self.noWardView];
        if ([self.user_id isEqualToString:[IMAPlatform sharedInstance].host.imUserId]) {
            self.noWardViewLabel.text = ASLocalizedString(@"我的守护正星夜兼程的赶来");
        }else{
            self.noWardViewLabel.text = ASLocalizedString(@"成为TA的第一个守护");
        }
    }
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

- (void)openBtnAction{
    [self hide];
    if (self.clickOpenBtnBlock) {
        self.clickOpenBtnBlock();
    }
}

- (void)setClickOpenBtnBlock:(clickOpenBtnBlock)clickOpenBtnBlock{
    _clickOpenBtnBlock = clickOpenBtnBlock;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count > 0 ? self.dataArray.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count < 1) {
        WardViewTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WardViewTopCell class])];
        cell.layer.cornerRadius = 0;
        cell.clipsToBounds = YES;
        [cell setModel:nil];
        return cell;
    }
    
    if (indexPath.row >= self.dataArray.count) {
        WardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WardViewCell class])];
        return cell;
    }
    WardPopViewModel *model = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        WardViewTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WardViewTopCell class])];
        cell.layer.cornerRadius = 0;
        cell.clipsToBounds = YES;
        [cell setModel:model];
        return cell;
    }
    WardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WardViewCell class])];
    cell.backgroundColor = [UIColor colorWithHexString:@"#A060F0"];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 176;
    }
    return 79;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(ASLocalizedString(@"点击了守护列表中的第%ld项"),indexPath.row);
    if (self.dataArray.count > 0) {
        WardPopViewModel *model = self.dataArray[indexPath.row];
        if (model.uid) {
            [self hide];
            if (self.clickWardPopViewCellBlock) {
                self.clickWardPopViewCellBlock(model);
            }
        }
    }
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WardViewTopCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([WardViewTopCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WardViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([WardViewCell class])];
        _tableView.backgroundColor = kClearColor;
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
        _titleLabel.text = ASLocalizedString(@"守护");
        _titleLabel.textColor = kWhiteColor;
        _titleLabel.backgroundColor = kClearColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)noWardView{
    if (!_noWardView) {
        _noWardView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _noWardView.top = kRealValue(44);
        _noWardView.height = self.tableView.height - kRealValue(44);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 103, 103)];
        imageView.centerX = self.tableView.width / 2;
        imageView.top = self.titleLabel.bottom + 10;
        imageView.image = [UIImage imageNamed:@"lr_img_back_ward_no"];
        [_noWardView addSubview:imageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, imageView.bottom + 20, self.tableView.width - 20, 20)];
        label.textColor = RGB(230, 230, 230);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [_noWardView addSubview:label];
        self.noWardViewLabel = label;
    }
    return _noWardView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
