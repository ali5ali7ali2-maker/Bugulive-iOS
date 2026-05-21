//
//  SLeaderHeadView.m
//  BuguLive
//
//  Created by 丁凯 on 2017/9/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SLeaderHeadView.h"
#import "UserModel.h"
#import "BogoRankHeadGifView.h"

@implementation SLeaderHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kClearColor;
        [self creatMyUI];
    }
    return self;
}

- (void)creatMyUI
{
//    UIImageView *bgImgView = [UIImageView new];
//    [bgImgView setImage:[UIImage imageNamed:@"mg_new_rankBgImgVIew"]];
//    bgImgView.frame = self.bounds;
//    [self addSubview:bgImgView];
    
//    //底部视图
//    self.bottomImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height -108*kScaleHeight , self.width, 108*kScaleHeight)];
//    self.bottomImgView.image = [UIImage imageNamed:@"hm_bottom"];
//    self.bottomImgView.userInteractionEnabled = YES;
//    [self addSubview:self.bottomImgView];
    
    
    
    CGFloat headImgWidth = 50;
        
        //------------------------------左边部分------------------------------
        //头像
        self.LHeadImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/6 - headImgWidth/ 2 + 10, 15 + 25 + 10, headImgWidth, headImgWidth)];
        self.LHeadImgView.layer.cornerRadius = headImgWidth / 2;
        self.LHeadImgView.layer.masksToBounds = YES;
        self.LHeadImgView.userInteractionEnabled = YES;
        self.LHeadImgView.image = kDefaultPreloadHeadImg;
        [self addSubview:self.LHeadImgView];
        
        //等级头像
        self.LGoldImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/6 - 134 /4,15 + 23 + 25, 98, 76)];
        self.LGoldImgView.image = [UIImage imageNamed:@"mg_new_rank_second"];
        self.LGoldImgView.userInteractionEnabled = YES;
        self.LGoldImgView.tag = 1;
        [self addSubview:self.LGoldImgView];
        
        self.LGoldImgView.centerX = self.LHeadImgView.centerX;
        self.LGoldImgView.centerY = self.LHeadImgView.centerY - 23 / 2 + 7;
        
        //手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self.LGoldImgView addGestureRecognizer:tap];
        
        //名字性别等级底部的view
        self.LNSRView = [[UIView alloc]initWithFrame:CGRectMake(self.width/6 - 40*kScaleWidth, CGRectGetMaxY(self.LGoldImgView.frame) + kRealValue(18), 80*kScaleWidth, 40*kScaleHeight)]; // 增加高度以容纳两行
        self.LNSRView.backgroundColor = kClearColor;
        [self addSubview:self.LNSRView];
        
        //名字
        self.LNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.LNSRView.width, 20*kScaleHeight)];
        self.LNameLabel.textColor = kWhiteColor;
        self.LNameLabel.font = [UIFont systemFontOfSize:13];
        self.LNameLabel.textAlignment = NSTextAlignmentCenter; // 居中显示
        [self.LNSRView addSubview:self.LNameLabel];
    [self.LNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.LNSRView);
        make.top.equalTo(self.LNSRView).offset(0);
    }];
        
        //性别
        self.LSexImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.LNSRView.width -26-13-5, 20*kScaleHeight, 13, 13)]; // 调整位置
        [self.LNSRView addSubview:self.LSexImgView];
        
        //等级
        self.LRankImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.LNSRView.width-26, 20*kScaleHeight, 26, 13)]; // 调整位置
        [self.LNSRView addSubview:self.LRankImgView];
        
        //印票
        self.LTicketLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.LNSRView.frame)+2*kScaleHeight, self.width/3, 20*kScaleHeight)];
        self.LTicketLabel.textColor = kWhiteColor;
        self.LTicketLabel.textAlignment = NSTextAlignmentCenter;
        self.LTicketLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.LTicketLabel];
        
        //关注按钮
        self.LConcertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.LConcertBtn.frame = CGRectMake(0, self.LTicketLabel.bottom + kRealValue(10), 52, 25);
        self.LConcertBtn.centerX = self.LGoldImgView.centerX;
        self.LConcertBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.LConcertBtn.hidden = YES;
        [self.LConcertBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.LConcertBtn setBackgroundImage:[UIImage imageNamed:@"search_not_follow"] forState:UIControlStateNormal];
        self.LConcertBtn.tag = 1000 + 0;
        [self.LConcertBtn addTarget:self action:@selector(clickAttention:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.LConcertBtn];
        
        self.LTicketView = [self createTicketViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.LNSRView.frame)+2*kScaleHeight, 65, 30)];
        self.LTicketView.centerX = self.LGoldImgView.centerX;
        self.LValueLabel = [self.LTicketView.subviews firstObject];
        [self addSubview:self.LTicketView];
        
        //------------------------------中间部分------------------------------
        headImgWidth = 60;
        //头像
        self.MHeadImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2 - 50 / 2,15 + 15, headImgWidth, headImgWidth)];
        self.MHeadImgView.layer.cornerRadius = headImgWidth / 2;
        self.MHeadImgView.layer.masksToBounds = YES;
        self.MHeadImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.MHeadImgView.userInteractionEnabled = YES;
        [self addSubview:self.MHeadImgView];
        
        //等级头像
        self.MGoldImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2 - 134/2 / 2,15, 107, 79)];
        self.MGoldImgView.image = [UIImage imageNamed:@"mg_new_rank_first"];
        self.MGoldImgView.userInteractionEnabled = YES;
        self.MGoldImgView.tag = 0;
        [self addSubview:self.MGoldImgView];
        
        self.MGoldImgView.centerX = self.MHeadImgView.centerX ;
        self.MGoldImgView.centerY = self.MHeadImgView.centerY - 23 / 2;
        
        //手势
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self.MGoldImgView addGestureRecognizer:tap1];
        
        //名字性别等级底部的view
        self.MNSRView = [[UIView alloc]initWithFrame:CGRectMake(self.width/2 - 40*kScaleWidth, CGRectGetMaxY(self.MGoldImgView.frame)+kRealValue(18), 80*kScaleWidth, 40*kScaleHeight)]; // 增加高度以容纳两行
        self.MNSRView.backgroundColor = kClearColor;
        [self addSubview:self.MNSRView];
        
        //名字
        self.MNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.MNSRView.width, 20*kScaleHeight)];
        self.MNameLabel.textColor = kWhiteColor;
        self.MNameLabel.font = [UIFont systemFontOfSize:13];
        self.MNameLabel.textAlignment = NSTextAlignmentCenter; // 居中显示
        [self.MNSRView addSubview:self.MNameLabel];
    
    [self.MNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.MNSRView);
        make.top.equalTo(self.MNSRView).offset(0);
    }];
    
        
        //性别
        self.MSexImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.MNSRView.width -26-13-5, 20*kScaleHeight, 13, 13)]; // 调整位置
        [self.MNSRView addSubview:self.MSexImgView];
        
        //等级
        self.MRankImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.MNSRView.width-26, 20*kScaleHeight, 26, 13)]; // 调整位置
        [self.MNSRView addSubview:self.MRankImgView];
        
        //印票
        self.MTicketLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.LTicketLabel.frame), CGRectGetMaxY(self.MNSRView.frame)+2*kScaleHeight, self.width/3, 20*kScaleHeight)];
        self.MTicketLabel.textColor = kWhiteColor;
        self.MTicketLabel.textAlignment = NSTextAlignmentCenter;
        self.MTicketLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.MTicketLabel];
        
        //关注按钮
        self.MConcertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.MConcertBtn.frame = CGRectMake(0, self.MTicketLabel.bottom + kRealValue(10), 52, 25);
        self.MConcertBtn.centerX = self.MTicketLabel.centerX;
        self.MConcertBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.MConcertBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.MConcertBtn setBackgroundImage:[UIImage imageNamed:@"search_not_follow"] forState:UIControlStateNormal];
        self.MConcertBtn.tag = 1000 + 1;
        [self.MConcertBtn addTarget:self action:@selector(clickAttention:) forControlEvents:UIControlEventTouchUpInside];
        self.MConcertBtn.hidden = YES;
        [self addSubview:self.MConcertBtn];
        
        self.MTicketView = [self createTicketViewWithFrame:CGRectMake(self.MHeadImgView.centerX, CGRectGetMaxY(self.MNSRView.frame)+2*kScaleHeight, 65, 30)];
        self.MTicketView.centerX = self.MHeadImgView.centerX;
        self.MValueLabel = [self.MTicketView.subviews firstObject];
        [self addSubview:self.MTicketView];
        
        //------------------------------右边部分------------------------------
        //头像
        headImgWidth = 52;
        self.RHeadImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width*5/6 -23*kScaleHeight,self.LHeadImgView.top, headImgWidth, headImgWidth)];
        self.RHeadImgView.layer.cornerRadius = headImgWidth / 2;
        self.RHeadImgView.layer.masksToBounds = YES;
        self.RHeadImgView.userInteractionEnabled = YES;
        self.RHeadImgView.image = kDefaultPreloadHeadImg;
        [self addSubview:self.RHeadImgView];
        
        //等级头像
        self.RGoldImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width*5/6 - 83*kScaleHeight/2, 110, 98, 76)];
        self.RGoldImgView.image = [UIImage imageNamed:@"mg_new_rank_third"];
        self.RGoldImgView.userInteractionEnabled = YES;
        self.RGoldImgView.tag = 2;
        [self addSubview:self.RGoldImgView];
        
        self.RGoldImgView.centerX =  self.RHeadImgView.centerX;
        self.RGoldImgView.centerY = self.RHeadImgView.centerY - 23 / 2 + 7;
        
        //手势
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self.RGoldImgView addGestureRecognizer:tap2];
        
        //名字性别等级底部的view
        self.RNSRView = [[UIView alloc]initWithFrame:CGRectMake(self.width*5/6 - 40*kScaleWidth, CGRectGetMaxY(self.RGoldImgView.frame)+ kRealValue(18), 80*kScaleWidth, 40*kScaleHeight)]; // 增加高度以容纳两行
        self.RNSRView.backgroundColor = kClearColor;
        [self addSubview:self.RNSRView];
        
        //名字
        self.RNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.RNSRView.width, 20*kScaleHeight)];
        self.RNameLabel.textColor = kWhiteColor;
        self.RNameLabel.font = [UIFont systemFontOfSize:13];
        self.RNameLabel.textAlignment = NSTextAlignmentCenter; // 居中显示
        [self.RNSRView addSubview:self.RNameLabel];
    [self.RNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.RNSRView);
        make.top.equalTo(self.RNSRView).offset(0);
    }];
        //性别
        self.RSexImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.RNSRView.width -26-13-5, 20*kScaleHeight, 13, 13)]; // 调整位置
        [self.RNSRView addSubview:self.RSexImgView];
        
        //等级
        self.RRankImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.RNSRView.width-26, 20*kScaleHeight, 26, 13)]; // 调整位置
        [self.RNSRView addSubview:self.RRankImgView];
        
        //印票
        self.RTicketLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.MTicketLabel.frame), CGRectGetMaxY(self.RNSRView.frame)+2*kScaleHeight, self.width/3, 20*kScaleHeight)];
        self.RTicketLabel.textColor = kWhiteColor;
        self.RTicketLabel.textAlignment = NSTextAlignmentCenter;
        self.RTicketLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.RTicketLabel];
        
        //关注按钮
        self.RConcertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.RConcertBtn.frame = CGRectMake(0, self.RTicketLabel.bottom + kRealValue(10), 52, 25);
        self.RConcertBtn.centerX = self.RTicketLabel.centerX;
        [self.RConcertBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.RConcertBtn setBackgroundImage:[UIImage imageNamed:@"search_not_follow"] forState:UIControlStateNormal];
        self.RConcertBtn.tag = 1000 + 2;
        self.RConcertBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.RConcertBtn addTarget:self action:@selector(clickAttention:) forControlEvents:UIControlEventTouchUpInside];
        self.RConcertBtn.hidden = YES;
        [self addSubview:self.RConcertBtn];
        
        // 印票
        self.RTicketView = [self createTicketViewWithFrame:CGRectMake(self.RHeadImgView.centerX, CGRectGetMaxY(self.RNSRView.frame)+2*kScaleHeight, 65, 30)];
        self.RTicketView.centerX = self.RHeadImgView.centerX;
        self.RValueLabel = [self.RTicketView.subviews firstObject];
        [self addSubview:self.RTicketView];
    
}

- (UIView *)createTicketViewWithFrame:(CGRect)frame
{
    UIView *ticketView = [[UIView alloc] initWithFrame:frame];
    ticketView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    ticketView.layer.cornerRadius = 6;
    ticketView.layer.masksToBounds = YES;

    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/2)];
    valueLabel.textColor = [UIColor colorWithHexString:@"#FFF45B"];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.font = [UIFont systemFontOfSize:8];
    [ticketView addSubview:valueLabel];
    

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2)];
    nameLabel.textColor = [UIColor colorWithHexString:@"#FFF45B"];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:8];
    nameLabel.text = self.BuguLive.appModel.ticket_name;

    [ticketView addSubview:nameLabel];

    return ticketView;
}
- (void)setMyViewWithMArr:(NSMutableArray *)mArr andType:(int)type consumeType:(int)consumeType
{
    
    if (mArr.count)
    {
        NSString *str = consumeType <= 3 ? ASLocalizedString(@"贡献"): ASLocalizedString(@"获得");
        self.MGoldImgView.userInteractionEnabled = YES;
        UserModel *model1 = mArr[0];
        
         self.MConcertBtn.hidden = NO;
        if ([model1.is_focus isEqualToString:@"1"]) {
//            [self.MConcertBtn setTitle:ASLocalizedString(@"已关注")forState:UIControlStateNormal];
            [self.MConcertBtn setBackgroundImage:[UIImage imageNamed:@"search_had_follow"] forState:UIControlStateNormal];
        }
        
        self.MModel = model1;
        
        
        if (model1.is_noble_ranking_stealth.intValue == 1 && ![model1.user_id isEqualToString:[GlobalVariables sharedInstance].userModel.user_id]) {
            [self.MHeadImgView sd_setImageWithURL:nil placeholderImage:kDefaultNobleMysteriousHeadImg];
            self.MNameLabel.text =ASLocalizedString(@"神秘人");
//            self.MNameLabel.text = [NSString stringWithFormat:ASLocalizedString(@"神秘人%@"),model1.nick_name];
            model1.nick_name = self.MNameLabel.text;
            self.MSexImgView.hidden = self.MRankImgView.hidden = self.MConcertBtn.hidden = YES;
        }else{
            ;
            
            if ([model1.user_id isEqualToString:[GlobalVariables sharedInstance].userModel.user_id]) {
                [self.MHeadImgView sd_setImageWithURL:nil placeholderImage:kDefaultNobleMysteriousHeadImg];
            }else{
                [self.MHeadImgView sd_setImageWithURL:[NSURL URLWithString:model1.head_image] placeholderImage:[UIImage imageNamed:@"com_preload_head_img"]];
            }
            
            self.MNameLabel.text = model1.nick_name;
        }
        
        
        
        CGFloat width = [model1.nick_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
        [self updateViewWithWidth:width andView:self.MNSRView andLabel:self.MNameLabel andSexImg:self.MSexImgView andRankImg:self.MRankImgView andTag:3];
        //性别
        if ([model1.sex isEqualToString:@"1"])
        {
            self.MSexImgView.image = [UIImage imageNamed:@"com_male_selected"];
        }
        else
        {
            self.MSexImgView.image = [UIImage imageNamed:@"com_female_selected"];
        }
        //等级
        if ([model1.user_level intValue] !=0)
        {
            self.MRankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%@",model1.user_level]];
        }
        else
        {
            self.MRankImgView.image = [UIImage imageNamed:@"rank_1"];
        }
        if (type == 1)
        {
            self.MTicketLabel.text = [NSString stringWithFormat:ASLocalizedString(@"贡献%@%@"),[self checkDiamondNum:model1.use_ticket] ,self.BuguLive.appModel.ticket_name];
            self.MValueLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@"), [self checkDiamondNum:model1.use_ticket]];
        }
        else
        {
            NSString *ticketName = consumeType <= 3 ? [GlobalVariables sharedInstance].appModel.diamond_name : [GlobalVariables sharedInstance].appModel.ticket_name;
            self.MValueLabel.text = [NSString stringWithFormat:@"%@", [self checkDiamondNum:model1.ticket]];
        }
        
        
        if (mArr.count > 1)
        {
            self.LGoldImgView.userInteractionEnabled = YES;
            self.LConcertBtn.hidden = NO;
            UserModel *model2 = mArr[1];
            if ([model2.is_focus isEqualToString:@"1"]) {
//                [self.LConcertBtn setTitle:ASLocalizedString(@"已关注")forState:UIControlStateNormal];
                [self.LConcertBtn setBackgroundImage:[UIImage imageNamed:@"search_had_follow"] forState:UIControlStateNormal];
            }
            self.LModel = model2;
            
            if (model2.is_noble_ranking_stealth.intValue == 1 && ![model2.user_id isEqualToString:[GlobalVariables sharedInstance].userModel.user_id]) {
                [self.LHeadImgView sd_setImageWithURL:nil placeholderImage:kDefaultNobleMysteriousHeadImg];
                self.LNameLabel.text =ASLocalizedString( @"神秘人");
//                = [NSString stringWithFormat:ASLocalizedString(@"神秘人%@"),model2.nick_name];
                model2.nick_name = self.LNameLabel.text;
                self.LSexImgView.hidden = self.LRankImgView.hidden = self.LConcertBtn.hidden = YES;
            }else{
                
                if ([model2.user_id isEqualToString:[GlobalVariables sharedInstance].userModel.user_id]) {
                    [self.LHeadImgView sd_setImageWithURL:nil placeholderImage:kDefaultNobleMysteriousHeadImg];
                }else{
                    [self.LHeadImgView sd_setImageWithURL:[NSURL URLWithString:model2.head_image] placeholderImage:[UIImage imageNamed:@"com_preload_head_img"]];
                }
                
                
                self.LNameLabel.text = model2.nick_name;
            }
            
            
            
            
            CGFloat width2 =[model2.nick_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
            [self updateViewWithWidth:width2 andView:self.LNSRView andLabel:self.LNameLabel andSexImg:self.LSexImgView andRankImg:self.LRankImgView andTag:1];
            //性别
            if ([model2.sex isEqualToString:@"1"])
            {
                self.LSexImgView.image = [UIImage imageNamed:@"com_male_selected"];
            }
            else
            {
                self.LSexImgView.image = [UIImage imageNamed:@"com_female_selected"];
            }
            //等级
            if ([model2.user_level intValue] !=0)
            {
                self.LRankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%@",model2.user_level]];
            }
            else
            {
                self.LRankImgView.image = [UIImage imageNamed:@"rank_1"];
            }
            
            if (type == 1)
            {
                self.LTicketLabel.text = [NSString stringWithFormat:ASLocalizedString(@"贡献%@%@"),[self checkDiamondNum:model2.use_ticket],self.BuguLive.appModel.ticket_name];
                
                self.LValueLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@"), [self checkDiamondNum:model2.use_ticket]];

                
            }else
            {
                NSString *ticketName = consumeType <= 3 ? [GlobalVariables sharedInstance].appModel.diamond_name : [GlobalVariables sharedInstance].appModel.ticket_name;
                self.LValueLabel.text = [NSString stringWithFormat:@"%@", [self checkDiamondNum:model2.ticket]];

                
//                NSString *ticketName = consumeType <= 3 ? [GlobalVariables sharedInstance].appModel.diamond_name : [GlobalVariables sharedInstance].appModel.ticket_name;
//                self.LTicketLabel.text = [NSString stringWithFormat:@"%@%@%@",str,[self checkDiamondNum:model2.ticket],ticketName];
            }
        }
        
        if (mArr.count > 2)
        {
            self.RGoldImgView.userInteractionEnabled = YES;
            UserModel *model3 = mArr[2];
            self.RModel = model3;
            self.RConcertBtn.hidden = NO;
            if ([model3.is_focus isEqualToString:@"1"]) {
//                [self.RConcertBtn setTitle:ASLocalizedString(@"已关注")[self.RConcertBtn setBackgroundImage:[UIImage imageNamed:@"search_had_follow"] forState:UIControlStateNormal];
            }
            
            if (model3.is_noble_ranking_stealth.intValue == 1 && ![model3.user_id isEqualToString:[GlobalVariables sharedInstance].userModel.user_id]) {
                [self.RHeadImgView sd_setImageWithURL:nil placeholderImage:kDefaultNobleMysteriousHeadImg];
                self.RNameLabel.text =ASLocalizedString( @"神秘人");
//                [NSString stringWithFormat:ASLocalizedString(@"神秘人%@"),model3.nick_name];
                model3.nick_name = self.RNameLabel.text;
                self.RSexImgView.hidden = self.RRankImgView.hidden = self.RConcertBtn.hidden = YES;
            }else{
                
                if ([model3.user_id isEqualToString:[GlobalVariables sharedInstance].userModel.user_id]) {
                    [self.RHeadImgView sd_setImageWithURL:nil placeholderImage:kDefaultNobleMysteriousHeadImg];
                }else{
                    [self.RHeadImgView sd_setImageWithURL:[NSURL URLWithString:model3.head_image] placeholderImage:[UIImage imageNamed:@"com_preload_head_img"]];
                }
                
                
                
                self.RNameLabel.text = model3.nick_name;
            }
            
            
            
            CGFloat width3 =[model3.nick_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
            [self updateViewWithWidth:width3 andView:self.RNSRView andLabel:self.RNameLabel andSexImg:self.RSexImgView andRankImg:self.RRankImgView andTag:5];
            //性别
            if ([model3.sex isEqualToString:@"1"])
            {
                self.RSexImgView.image = [UIImage imageNamed:@"com_male_selected"];
            }
            else
            {
                self.RSexImgView.image = [UIImage imageNamed:@"com_female_selected"];
            }
            //等级
            if ([model3.user_level intValue] !=0)
            {
                self.RRankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%@",model3.user_level]];
            }
            else
            {
                self.RRankImgView.image = [UIImage imageNamed:@"rank_1"];
            }
            if (type == 1)
            {
                
                self.RValueLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@"), [self checkDiamondNum:model3.use_ticket]];
                
//                self.RTicketLabel.text = [NSString stringWithFormat:ASLocalizedString(@"贡献%@%@"),[self checkDiamondNum:model3.use_ticket],self.BuguLive.appModel.ticket_name];
            }else
            {
                
                NSString *ticketName = consumeType <= 3 ? [GlobalVariables sharedInstance].appModel.diamond_name : [GlobalVariables sharedInstance].appModel.ticket_name;
                self.RValueLabel.text = [NSString stringWithFormat:@"%@", [self checkDiamondNum:model3.ticket]];
                
//                NSString *ticketName = consumeType <= 3 ? [GlobalVariables sharedInstance].appModel.diamond_name : [GlobalVariables sharedInstance].appModel.ticket_name;
//                self.RTicketLabel.text = [NSString stringWithFormat:@"%@%@%@",str,[self checkDiamondNum:model3.ticket],ticketName];
            }
        }
        
        CGRect rect = self.frame;
        rect.size.height = 265;
        self.frame = rect;
        
        if (!StrValid(model1.nick_name)) {
           self.MTicketLabel.hidden = self.MNameLabel.hidden = self.MRankImgView.hidden = self.MConcertBtn.hidden = self.MSexImgView.hidden = YES;
        }
        
        if (mArr.count > 1) {
            UserModel *model2 = mArr[1];
            
            if (!StrValid(model2.nick_name)) {
                self.LTicketLabel.hidden = self.LNameLabel.hidden = self.LRankImgView.hidden = self.LConcertBtn.hidden = self.LSexImgView.hidden = YES;
            }
        }
        
        if (mArr.count > 2) {
            UserModel *model3 = mArr[2];
            if (!StrValid(model3.nick_name)) {
                self.RTicketLabel.hidden = self.RNameLabel.hidden = self.RRankImgView.hidden = self.RConcertBtn.hidden = self.RSexImgView.hidden = YES;
            }
        }
        
    }else
    {
        
        CGRect rect = self.frame;
        rect.size.height = 0;
        self.frame = rect;
    }
    
    if ([_LModel.user_id isEqualToString:[IMAPlatform sharedInstance].host.imUserId]) {
        self.LConcertBtn.hidden = YES;
    }
    
    if ([_MModel.user_id isEqualToString:[IMAPlatform sharedInstance].host.imUserId]) {
        self.MConcertBtn.hidden = YES;
    }
    if ([_RModel.user_id isEqualToString:[IMAPlatform sharedInstance].host.imUserId]) {
        self.RConcertBtn.hidden = YES;
    }
    NSLog(@"%@",[IMAPlatform sharedInstance].host.imUserId);
    
}

-(NSString *)checkDiamondNum:(NSString *)num{
    
    NSString *numStr = @"";
    float numF = num.floatValue;
    if (numF > 1000) {
        numStr = [NSString stringWithFormat:ASLocalizedString(@"%.1fK"),floorf(numF/1000)];
//        [NSString stringWithFormat:@"%.2f",num.floatValue];
    }else{
        numStr = [NSString stringWithFormat:@"%.0f",numF];
    }
    
    return numStr;
    
    
}

- (void)updateViewWithWidth:(CGFloat)width andView:(UIView *)bottomView andLabel:(UILabel *)label andSexImg:(UIImageView *)sexImgView andRankImg:(UIImageView *)rankImgView andTag:(int)tag
{
    if (width +10 + 13 +26 +6 > self.width/3)
    {
        width = self.width/3 -10 -13 -26 -6;
    }
    
    CGRect rect      = label.frame;
    rect.size.width  = width;
    label.frame      = rect;
    
    if (sexImgView.hidden && rankImgView.hidden) {
        label.width = 80*kScaleWidth + 10;
//        80*kScaleWidth
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    CGRect rect1      = bottomView.frame;
    rect1.size.width  = width +10 + 13 +26;
    rect1.origin.x    = tag * self.width/6 -(width + 10 +26)/2;
    bottomView.frame  = rect1;
    
    CGRect rect2      = sexImgView.frame;
    rect2.origin.x    = label.centerX - sexImgView.width/2;
    sexImgView.frame  = rect2;
    
    CGRect rect3      = rankImgView.frame;
    rect3.origin.x    = CGRectGetMaxX(sexImgView.frame) +5;
    rankImgView.frame  = rect3;
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    if (self.leadBlock)
    {
        self.leadBlock((int)tap.view.tag);
    }
    
}


-(void)clickAttention:(UIButton *)sender{
    NSString *uid = @"";
    if (sender.tag == 1000) {
        uid = self.LModel.user_id;
    }else if (sender.tag == 1001){
        uid = self.MModel.user_id;
    }else if (sender.tag == 1002){
        uid = self.RModel.user_id;
    }
    
    if (!uid) {
        [BGHUDHelper alert:ASLocalizedString(@"用户不存在")];
        return;
    }
    
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
    [dictM setObject:@"user" forKey:@"ctl"];
    [dictM setObject:@"follow" forKey:@"act"];
    [dictM setObject:uid forKey:@"to_user_id"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         
         if ([responseJson toInt:@"status"] == 1)
         {
             NSInteger has_focus = [responseJson toInt:@"has_focus"];
             
             if (has_focus == 1) {
//                 [sender setTitle:ASLocalizedString(@"已关注")forState:UIControlStateNormal];
                 [sender setBackgroundImage:[UIImage imageNamed:@"search_had_follow"] forState:UIControlStateNormal];
             }else{
                 [sender setBackgroundImage:[UIImage imageNamed:@"search_not_follow"] forState:UIControlStateNormal];
             }
         }
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error===%@",error);
     }];
}

@end
