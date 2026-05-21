//
//  BGReadPackListView.m
//  BuguLive
//
//  Created by 志刚杨 on 2021/12/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGReadPackListView.h"
#import "BGReadPackTableViewCell.h"
#import "BGRedPackModel.h"
#import <QMUIKit/QMUIKit.h>
#import "BGOpenRedPackView.h"
@interface BGReadPackListView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *myTableView;
@property(nonatomic, strong) UILabel *labCount;
@property(nonatomic, strong) NSArray *list;
@end
@implementation BGReadPackListView
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
    bgImg.image = [UIImage imageNamed:@"qianghongbao_bgm"];
    self.backgroundColor = kClearColor;
    [self addSubview:bgImg];

    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    UILabel *labtitle = [[UILabel alloc] init];
    labtitle.text = ASLocalizedString(@"直播间红包");
    labtitle.font = [UIFont systemFontOfSize:24];
    labtitle.textColor = [UIColor colorWithHexString:@"#FFC601"];
    [self addSubview:labtitle];
    [labtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(11);
    }];
    
    
    _labCount = [[UILabel alloc] init];//Нийт
    _labCount.text = [NSString stringWithFormat:@"%@",ASLocalizedString(@"剩余")];
    _labCount.font = [UIFont systemFontOfSize:15];
    _labCount.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [self addSubview:_labCount];
    [_labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(labtitle.mas_bottom).offset(10.5);
    }];
    
    
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.myTableView registerNib:[UINib nibWithNibName:[BGReadPackTableViewCell className] bundle:nil] forCellReuseIdentifier:@"ReadPackCell"];
//    [self.myTableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"ReadPackCell"];
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self);
        make.top.mas_equalTo(77);
    }];
    
    [self.myTableView reloadData];
    

    
//    self.qmui_borderPosition = QMUIViewBorderPositionBottom;
//    self
//    self.qmui_borderWidth = 1;
}

- (void)requestData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"surprise" forKey:@"ctl"];
    [dict setValue:@"requestGetSurpriseList" forKey:@"act"];
    [dict setValue:self.video_id forKey:@"video_id"];
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"104responseJson%@",responseJson);
        if ([responseJson toInt:@"status"] == 1) {
            self.list = [NSArray modelArrayWithClass:BGRedPackModel.class json:responseJson[@"list"]];
            
            self->_labCount.text = [NSString stringWithFormat:@"%@ %ld",ASLocalizedString(@"剩余"),self.list.count];

            
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
    BGReadPackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReadPackCell"];
    cell.backgroundColor = kWhiteColor;
    BGRedPackModel *user = self.list[indexPath.row];
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:user.head_image]];
     cell.labNickname.text = user.nick_name;
    cell.labTime.text = ASLocalizedString(@"派发了一个即时红包");
    return cell;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self hide];
    BGRedPackModel *user = self.list[indexPath.row];

    
    BGOpenRedPackView *readView = [[BGOpenRedPackView alloc] init];
    readView.video_id = self.video_id;
    readView.userModel = user;
    readView.frame = CGRectMake(40, 0, kScreenW-40*2, kScreenH-140*2);
    readView.userModel = user;
//    readView.backgroundColor = kRedColor;
    [readView show:[AppDelegate sharedAppDelegate].topViewController.view type:FDPopTypeCenter];
//    [readView requestData];
    
//    BGOpenRedPackView *
    
}

@end
