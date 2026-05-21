//
//  BGReadPackListView.m
//  BuguLive
//
//  Created by 志刚杨 on 2021/12/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGRedPackResultView.h"
#import "BGReadPackTableViewCell.h"
#import "BGRedPackModel.h"
#import <QMUIKit/QMUIKit.h>
#import "BGRedPackResultList.h"
@interface BGRedPackResultView()
@property(nonatomic, strong) UITableView *myTableView;
@property(nonatomic, strong) UILabel *labCount;
@property(nonatomic, strong) NSArray *list;
@property(nonatomic, strong) UIImageView *avatar;
@property(nonatomic, strong) UILabel *nickname;
@property(nonatomic, strong) UILabel *labDiamonds;
@end
@implementation BGRedPackResultView
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
    bgImg.image = [UIImage imageNamed:@"kaihongbao_bgm"];
    self.backgroundColor = kClearColor;
    [self addSubview:bgImg];

//    UIImageView *imgOpen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yuan"]];
//    [self addSubview:imgOpen];
//    [imgOpen mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(80.5));
//        make.height.and.width.equalTo(@(120));
//        make.centerX.equalTo(self);
//    }];
//
//    //添加手势
//    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer)];
//    [imgOpen addGestureRecognizer:tapGesture];
//    imgOpen.userInteractionEnabled = YES;
//
//    UILabel *labOpen = [[UILabel alloc] init];
//    labOpen.text = @"Get";
//    labOpen.textColor = kRedColor;
//    labOpen.font = [UIFont boldSystemFontOfSize:29];
//
//    [self addSubview:labOpen];
//    [labOpen mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(imgOpen);
//    }];
    
    
    
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    UILabel *labtitle = [[UILabel alloc] init];
    labtitle.text = ASLocalizedString(@"恭喜你");
    labtitle.font = [UIFont systemFontOfSize:24];
    labtitle.textColor = [UIColor colorWithHexString:@"#FFC601"];
    [self addSubview:labtitle];
    [labtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(kRealValue(20));
        make.height.equalTo(@30);

            
//        make.top.mas_equalTo(imgOpen.mas_bottom).offset(12);
    }];
    
  
    _labCount = [[UILabel alloc] init];//Нийт
    _labCount.text = ASLocalizedString(@"抢到了钻石红包");
    _labCount.font = [UIFont systemFontOfSize:18];
    _labCount.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [self addSubview:_labCount];
    
    [_labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(labtitle.mas_bottom).offset(8.5);
        make.height.equalTo(@25);
    }];
    
    
    self.labDiamonds = [[UILabel alloc] init];
//    labtitle.text = NSLocalizedString(@"恭喜你！", nil);
    self.labDiamonds.font = [UIFont systemFontOfSize:24];
    self.labDiamonds.textColor = [UIColor colorWithHexString:@"#FFC601"];
    [self addSubview:self.labDiamonds];
    [self.labDiamonds mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labCount.mas_bottom).offset(18.5);
        make.centerX.equalTo(self);
        make.height.equalTo(@30);

//        make.top.mas_equalTo(imgOpen.mas_bottom).offset(12);
    }];
    
    
    QMUIFillButton *btnGetList = [[QMUIFillButton alloc] initWithFillColor:[UIColor colorWithHexString:@"#FFFFFF"] titleTextColor:[UIColor colorWithHexString:@"#DA0404"]];;
    [self addSubview:btnGetList];
    [btnGetList setTitle:ASLocalizedString(@"查看领取详情") forState:UIControlStateNormal];
    btnGetList.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnGetList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kRealValue(132)));
        make.height.equalTo(@(kRealValue(30)));
        make.centerX.equalTo(self);
        make.top.equalTo(self.labDiamonds.mas_bottom).offset(15);
    }];
    
    [btnGetList addTarget:self action:@selector(handleTapGestureRecognizer) forControlEvents:UIControlEventTouchUpInside];
    

}


- (void)setDiamonds:(NSString *)diamonds
{
    _diamonds = diamonds;
    self.labDiamonds.text = [NSString stringWithFormat:@"%@%@",ASLocalizedString(@"钻石"),diamonds];

}

- (void)handleTapGestureRecognizer {
//    BGRedPackResultList *
    
    [self hide];
    BGRedPackResultList *readView = [[BGRedPackResultList alloc] init];
//            readView.video_id = self.video_id;
//            readView.userModel = user;
    readView.model = self.model;
    readView.frame = CGRectMake(40, 0, kRealValue(295), kRealValue(420));
    readView.centerX = self.centerX;
    readView.centerY = self.centerY;
    readView.model = self.model;
    [readView requestData];
//            readView.userModel = user;
//    readView.backgroundColor = kRedColor;
    
//    "request": {
//        "requestData": "gVNZH4R74Sq5RLDpBIHnQ9\/W1XjhpEDIXENmWhDgomVRKEDpy8StjwlNV0REKMiAi4yYiKFxOmqV\nbobIvgHSbPjeSGIevZlgBWtRAGwulo+1t0zRbytnl\/ad81ToV9l+B5fe3vW5hAfnM0fzTKlT3ega\njOURhfjucQcSoTxBaNCACDuCccc2UTvJp+EwPndQXijp2bb2NaPCg5IPU2EzMhekZEqySGwctX\/k\nPaU3fhLF0oadee4nzxkxL5TgVfLQZN99wBQIVuvdrTtzx08qJQ==\n",
//        "i_type": "1",
//        "ctl": "surprise",
//        "act": "requestGetSurpriseGetDetailList",
//        "screen_width": 1080,
//        "screen_height": 2356,
//        "sdk_type": "android",
//        "sdk_version_name": "3.5",
//        "sdk_version": 2021122101,
//        "session_id": "0",
//        "surprise_id": "87"
//    }
    
//    readView.diamonds = [NSString stringWithFormat:@"%@",responseJson[@"diamonds"]];

    [readView show:[AppDelegate sharedAppDelegate].topViewController.view type:FDPopTypeCenter];
    
}

- (void)setUserModel:(BGRedPackModel *)userModel
{
//    _userModel = userModel;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:userModel.head_image]];
    self.labCount.text = userModel.nick_name;
}

- (void)requestData{
    
}
#pragma mark UITableViewDelegate, UITableViewDataSource
 


@end
