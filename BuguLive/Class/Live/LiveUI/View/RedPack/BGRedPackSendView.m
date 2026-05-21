//
//  BGReadPackListView.m
//  BuguLive
//
//  Created by 志刚杨 on 2021/12/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGRedPackSendView.h"
#import "BGReadPackTableViewCell.h"
#import "BGRedPackModel.h"
#import <QMUIKit/QMUIKit.h>
#import "BGReadTextView.h"
@interface BGRedPackSendView()
@property(nonatomic, strong) UITableView *myTableView;
@property(nonatomic, strong) UILabel *labCount;
@property(nonatomic, strong) NSArray *list;
@property(nonatomic, strong) UIImageView *avatar;
@property(nonatomic, strong) UILabel *nickname;
@property(nonatomic, strong) UILabel *labDiamonds;
@property(nonatomic, strong) BGReadTextView *txtCoin;
@property(nonatomic, strong) BGReadTextView *txtNumber;
@end
@implementation BGRedPackSendView
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
    bgImg.image = [UIImage imageNamed:@"fahongbao_bgm"];
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
    labtitle.text = ASLocalizedString(@"直播间红包");
    labtitle.font = [UIFont systemFontOfSize:24];
    labtitle.textColor = [UIColor colorWithHexString:@"#FFC601"];
    [self addSubview:labtitle];
    [labtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(11);
    }];
    
    
  
    _labCount = [[UILabel alloc] init];//Нийт
    _labCount.text = ASLocalizedString(@"给当前直播间观众发红包");
    _labCount.font = [UIFont systemFontOfSize:15];
    _labCount.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [self addSubview:_labCount];
    
    [_labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(labtitle.mas_bottom).offset(13.5);
//        make.height.equalTo(@25);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
    
    }];

    _labCount.preferredMaxLayoutWidth = kRealValue(236);
    [_labCount setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _labCount.numberOfLines = 0;
    _labCount.lineBreakMode = NSLineBreakByWordWrapping;

    self.txtCoin = [BGReadTextView instanceView];
    self.txtCoin.labName.text = ASLocalizedString(@"总金额");
    self.txtCoin.labDes.text = ASLocalizedString(@"钻石");
    ViewRadius(self.txtCoin, 3);
    self.txtCoin.textFiled.placeholder = @"0";
    self.txtCoin.textFiled.textColor = [UIColor colorWithHexString:@"#FFD201"];
    
    [self addSubview:self.txtCoin];

    [self.txtCoin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.equalTo(@(kRealValue(21.5)));
        make.right.and.equalTo(@(kRealValue(-21.5)));

        make.height.equalTo(@44);
        make.top.equalTo(_labCount.mas_bottom).offset(36);
    }];
    
    self.txtNumber = [BGReadTextView instanceView];
    self.txtNumber.labName.text = ASLocalizedString(@"数量");
    self.txtNumber.labDes.text = ASLocalizedString(@"个");
    ViewRadius(self.txtNumber, 3);
    
    
    self.txtNumber.textFiled.placeholder = @"0";
    [self addSubview:self.txtNumber];
    [self.txtNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.equalTo(@(kRealValue(21.5)));
        make.right.and.equalTo(@(kRealValue(-21.5)));

        make.height.equalTo(@44);
        make.top.equalTo(self.txtCoin.mas_bottom).offset(9.5);
    }];
    
    
//    self.labDiamonds = [[UILabel alloc] init];
////    labtitle.text = NSLocalizedString(@"恭喜你！", nil);
//    self.labDiamonds.font = [UIFont systemFontOfSize:24];
//    self.labDiamonds.textColor = [UIColor colorWithHexString:@"#FFC601"];
//    [self addSubview:self.labDiamonds];
//    [self.labDiamonds mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.labCount.mas_bottom).offset(18.5);
//        make.centerX.equalTo(self);
//        make.height.equalTo(@30);
//
////        make.top.mas_equalTo(imgOpen.mas_bottom).offset(12);
//    }];
//
//
    QMUIFillButton *btnGetList = [[QMUIFillButton alloc] initWithFillColor:[UIColor colorWithHexString:@"#FFD201"] titleTextColor:[UIColor colorWithHexString:@"#FF0303"]];;
    [self addSubview:btnGetList];
    [btnGetList setTitle:ASLocalizedString(@"发送红包") forState:UIControlStateNormal];
    btnGetList.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnGetList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kRealValue(122)));
        make.height.equalTo(@(kRealValue(40)));
        make.centerX.equalTo(self);
        make.top.equalTo(self.txtNumber.mas_bottom).offset(30);
    }];
    
    [btnGetList addTarget:self action:@selector(handleSendEvent) forControlEvents:UIControlEventTouchUpInside];
    
//    "request": {
//        "requestData": "gVNZH4R74Sq5RLDpBIHnQ9\/W1XjhpEDIXENmWhDgomVRKEDpy8StjwlNV0REKMiAi4yYiKFxOmqV\nbobIvgHSbPjeSGIevZlgBWtRAGwulo+1t0zRbytnl\/ad81ToV9l+B5fe3vW5hAfnM0fzTKlT3ega\njOURhfjucQcSoTxBaNCACDuCccc2UTvJp+EwPndQXijp2bb2NaPCg5IPU2EzMjDa0HsmstEq1wfo\nCYjxuyuYfmWBk1nMj+AqdbiAFggsZWWU\/4wcXSDZvk2ql3v7QN\/jQ14BG+ZBAhUSQwFOG8YUGqvr\nn1sPXIbt0BCbDE8kYttX6jRXuEU1yDkQEt2Odg==\n",
//        "i_type": "1",
//        "ctl": "surprise",
//        "act": "requestSendSurprise",
//        "screen_width": 1080,
//        "screen_height": 2356,
//        "sdk_type": "android",
//        "sdk_version_name": "3.5",
//        "sdk_version": 2021122101,
//        "session_id": "0",
//        "video_id": "40556",
//        "diamonds": "1",
//        "people_quantity": "1",
//        "content": ""
//    }

}


- (void)setDiamonds:(NSString *)diamonds
{
//    _diamonds = diamonds;
    self.labDiamonds.text = [NSString stringWithFormat:@"%@%@",ASLocalizedString(@"钻石"),diamonds];

}

- (void)handleSendEvent {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"surprise" forKey:@"ctl"];
    [dict setValue:@"requestSendSurprise" forKey:@"act"];
    [dict setValue:self.video_id forKey:@"video_id"];
    
    if([BGUtils isBlankString:self.txtCoin.textFiled.text])
    {
        [BGHUDHelper alert:ASLocalizedString(@"请输入金额")];
        return;
    }
    
    if([BGUtils isBlankString:self.txtNumber.textFiled.text])
    {
        [BGHUDHelper alert:ASLocalizedString(@"请输入数量")];
        return;
    }
    
    
    [dict setValue:self.txtCoin.textFiled.text forKey:@"diamonds"];
    [dict setValue:self.txtNumber.textFiled.text forKey:@"people_quantity"];


    
    //        "diamonds": "1",
    //        "people_quantity": "1",
    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"104responseJson%@",responseJson);
        if ([responseJson toInt:@"status"] == 1) {
            [self hide];
        }else{
            [BGHUDHelper alert:responseJson[@"error"]];
            //接口请求失败
            NSLog(NSLocalizedString(@"守护列表请求数据失败responseJson:%@", nil),responseJson);
        }
    } FailureBlock:^(NSError *error) {
        NSLog(NSLocalizedString(@"守护列表请求数据失败error:%@", nil),error);
    }];
}

- (void)handleTapGestureRecognizer {
    
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
