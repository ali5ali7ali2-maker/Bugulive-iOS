//
//  BGReadPackListView.m
//  BuguLive
//
//  Created by 志刚杨 on 2021/12/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGOpenRedPackView.h"
#import "BGReadPackTableViewCell.h"
#import "BGRedPackModel.h"
#import "BGRedPackResultView.h"
#import <QMUIKit/QMUIKit.h>

@interface BGOpenRedPackView()
@property(nonatomic, strong) UITableView *myTableView;
@property(nonatomic, strong) UILabel *labCount;
@property(nonatomic, strong) NSArray *list;
@property(nonatomic, strong) UIImageView *avatar;
@property(nonatomic, strong) UILabel *nickname;

@end
@implementation BGOpenRedPackView
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
    bgImg.image = [UIImage imageNamed:@"hongbao_bgm"];
    self.backgroundColor = kClearColor;
    [self addSubview:bgImg];

    UIImageView *imgOpen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yuan"]];
    [self addSubview:imgOpen];
    [imgOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(80.5));
        make.height.and.width.equalTo(@(120));
        make.centerX.equalTo(self);
    }];
    
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer)];
    [imgOpen addGestureRecognizer:tapGesture];
    imgOpen.userInteractionEnabled = YES;
    
    UILabel *labOpen = [[UILabel alloc] init];
    labOpen.text = @"Get";
    labOpen.textColor = kRedColor;
    labOpen.font = [UIFont boldSystemFontOfSize:29];
    
    [self addSubview:labOpen];
    [labOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imgOpen);
    }];
    
    
    
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    UILabel *labtitle = [[UILabel alloc] init];
    labtitle.text = ASLocalizedString(@"恭喜发财，大吉大利");
    labtitle.font = [UIFont systemFontOfSize:24];
    labtitle.textColor = [UIColor colorWithHexString:@"#FFC601"];
    [self addSubview:labtitle];
    [labtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(imgOpen.mas_bottom).offset(12);
    }];
    
    
    

    
    
    
    self.avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [self addSubview:self.avatar];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labtitle.mas_bottom).offset(30);
        make.height.and.width.equalTo(@kRealValue(70));
        make.centerX.equalTo(self);
    }];
    ViewRadius(self.avatar, kRealValue(70)/2);

    _labCount = [[UILabel alloc] init];//Нийт
    _labCount.text = @"nickname";
    _labCount.font = [UIFont systemFontOfSize:18];
    _labCount.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [self addSubview:_labCount];
    
    [_labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self.avatar.mas_bottom).offset(8.5);
    }];
    
    
//    self.qmui_borderPosition = QMUIViewBorderPositionBottom;
//    self
//    self.qmui_borderWidth = 1;
}

- (void)handleTapGestureRecognizer {
    [self requestData];
}

- (void)setUserModel:(BGRedPackModel *)userModel
{
    _userModel = userModel;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:userModel.head_image]];
    self.labCount.text = userModel.nick_name;
}

- (void)requestData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"surprise" forKey:@"ctl"];
    [dict setValue:@"requestGetSurprise" forKey:@"act"];
    [dict setValue:self.userModel.id forKey:@"surprise_id"];
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"104responseJson%@",responseJson);
        if ([responseJson toInt:@"status"] == 1) {

//            BGRedPackModel *user = self.list[indexPath.row];

            [self hide];
            BGRedPackResultView *readView = [[BGRedPackResultView alloc] init];
//            readView.video_id = self.video_id;
            readView.model = self.userModel;
            
            readView.frame = CGRectMake(40, 0, kRealValue(266), kRealValue(338));
            readView.centerX = self.centerX;
            readView.centerY = self.centerY;
//            readView.userModel = user;
        //    readView.backgroundColor = kRedColor;
            readView.diamonds = [NSString stringWithFormat:@"%@",responseJson[@"diamonds"]];

            [readView show:[AppDelegate sharedAppDelegate].topViewController.view type:FDPopTypeCenter];

            
        }else{
            //error
            [BGHUDHelper alert:responseJson[@"error"]];
        }
    } FailureBlock:^(NSError *error) {
        NSLog(NSLocalizedString(@"守护列表请求数据失败error:%@", nil),error);
    }];
}
#pragma mark UITableViewDelegate, UITableViewDataSource
 


@end
