//
//  BGReadPackListView.m
//  BuguLive
//
//  Created by 志刚杨 on 2021/12/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGRedPackResultList.h"
#import "BGReadPackResultTableViewCell.h"
#import "BGRedPackModel.h"
#import <QMUIKit/QMUIKit.h>
#import "BGOpenRedPackView.h"
#import "SurpriseGetDetailListModel.h"
@interface BGRedPackResultList()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *myTableView;
@property(nonatomic, strong) UILabel *labCount;
@property(nonatomic, strong) UILabel *labGetInfo;
@property(nonatomic, strong) NSArray *list;
@property(nonatomic, strong) UIImageView *ivAvatar;
@property(nonatomic, strong) UILabel *labNickname;
@property(nonatomic, strong) UILabel * labCount2;
@end
@implementation BGRedPackResultList
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initWithTableView];
        
    }
    return self;
}

- (void)initWithTableView {
    self.list = [NSArray array];
    UIImageView *bgImg = [[UIImageView alloc] init];
    bgImg.image = [UIImage imageNamed:@"hongbaoxiagnqing_bgm"];
    self.backgroundColor = kClearColor;
    [self addSubview:bgImg];

    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    UIImageView *ivAvatar = [[UIImageView alloc] init];
    [self addSubview:ivAvatar];
    [ivAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kRealValue(70)));
        make.height.equalTo(@(kRealValue(70)));
        make.top.equalTo(@(15));
        make.centerX.equalTo(self);
    }];
    
    ViewRadius(ivAvatar, kRealValue(35));
    
    [ivAvatar sd_setImageWithURL:[NSURL URLWithString:[IMAPlatform sharedInstance].host.imUserIconUrl]];
    
    
    
    self.labNickname = [[UILabel alloc] init];
    self.labNickname.text = [IMAPlatform sharedInstance].host.imUserName;
    self.labNickname.font = [UIFont systemFontOfSize:17];
    self.labNickname.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:self.labNickname];
    [self.labNickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(ivAvatar.mas_bottom).offset(6);
    }];
    
    
    _labCount = [[UILabel alloc] init];//Нийт
    _labCount.text = [NSString stringWithFormat:@"0"];
    _labCount.font = [UIFont systemFontOfSize:19];
    _labCount.textColor = [UIColor colorWithHexString:@"#FFC601"];
    [self addSubview:_labCount];
    [_labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self.labNickname.mas_bottom).offset(10.5);
    }];
    
    
    _labCount2 = [[UILabel alloc] init];//Нийт
    _labCount2.text = @"0";
    _labCount2.font = [UIFont systemFontOfSize:19];
    _labCount2.textColor = [UIColor colorWithHexString:@"#FFC601"];
    _labCount2.text = @""; //NSLocalizedString(@"已存入 我的钻石", nil);

    [self addSubview:_labCount2];
    [_labCount2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(_labCount.mas_bottom).offset(9);
    }];
    
    _labGetInfo = [[UILabel alloc] init];//Нийт
    _labGetInfo.text = @"";
    _labGetInfo.font = [UIFont systemFontOfSize:13];
    _labGetInfo.textColor = [UIColor colorWithHexString:@"#FF0303"];
    [self addSubview:_labGetInfo];
    [_labGetInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(_labCount2.mas_bottom).offset(23.5);
    }];
    
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.myTableView registerNib:[UINib nibWithNibName:[BGReadPackResultTableViewCell className] bundle:nil] forCellReuseIdentifier:@"BGReadPackResultTableViewCell"];
//    [self.myTableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"ReadPackCell"];
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self);
        make.top.equalTo(_labGetInfo.mas_bottom).offset(29);
    }];
    
    [self.myTableView reloadData];
    

    
//    self.qmui_borderPosition = QMUIViewBorderPositionBottom;
//    self
//    self.qmui_borderWidth = 1;
}

- (void)requestData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"surprise" forKey:@"ctl"];
    [dict setValue:@"requestGetSurpriseGetDetailList" forKey:@"act"];
    [dict setValue:self.model.id forKey:@"surprise_id"];
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"104responseJson%@",responseJson);
        if ([responseJson toInt:@"status"] == 1) {
            self.list = [NSArray modelArrayWithClass:SurpriseGetDetailListModel.class json:responseJson[@"list"]];
            self->_labCount.text = [NSString stringWithFormat:@"%@%@",responseJson[@"diamonds_quantity"],@"Coin"];
            
            self->_labGetInfo.text = responseJson[@"get_info"];

//            self->_labCount.text = [NSString stringWithFormat:@"%@ %ld",NSLocalizedString(@"剩余", nil),self.list.count];
//            self.labNickname.text = responseJson[@""];

            
            [self.myTableView reloadData];
        }else{
            //接口请求失败
            NSLog(NSLocalizedString(@"守护列表请求数据失败responseJson:%@", nil),responseJson);
        }
    } FailureBlock:^(NSError *error) {
        NSLog(NSLocalizedString(@"守护列表请求数据失败error:%@", nil),error);
    }];
}
#pragma mark UITableViewDelegate, UITableViewDataSource
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BGReadPackResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BGReadPackResultTableViewCell"];
    cell.backgroundColor = kWhiteColor;
    SurpriseGetDetailListModel *user = self.list[indexPath.row];
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:user.head_image]];
     cell.labNickname.text = user.nick_name;
    cell.labTime.text = user.get_time;
    cell.labCount.text = user.diamonds_quantity;
    return cell;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self hide];
    BGRedPackModel *user = self.list[indexPath.row];

    
//    BGOpenRedPackView *readView = [[BGOpenRedPackView alloc] init];
//    readView.video_id = self.video_id;
//    readView.userModel = user;
//    readView.frame = CGRectMake(40, 0, kScreenW-40*2, kScreenH-140*2);
//    readView.userModel = user;
////    readView.backgroundColor = kRedColor;
//    [readView show:[AppDelegate sharedAppDelegate].topViewController.view type:FDPopTypeCenter];
//    [readView requestData];
    
//    BGOpenRedPackView *
    
}

@end
