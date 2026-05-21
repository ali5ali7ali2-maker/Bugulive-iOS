//
//  MPCHeadView.m
//  BuguLive
//
//  Created by 丁凯 on 2017/8/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MPCHeadView.h"
#import "userPageModel.h"
#import "BGSystemMacro.h"
#import "UserHomeModel.h"
#import "HPContributionCell.h"

@interface MPCHeadView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *imageArray;
@property(nonatomic, strong) UIImageView *nobleImageView;

@end

@implementation MPCHeadView

- (instancetype)initWithFrame:(CGRect)frame andHeadType:(int)headType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self creatMyViewWithType:headType];
        self.backgroundColor = kClearColor;
    }
    return self;
}

static UIView * extracted(MPCHeadView *object) {
    return object.nameView;
}

- (void)creatMyViewWithType:(int)headType
{
    //底部透明图片
    self.clearImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 250)];
    self.clearImgView.userInteractionEnabled = YES;
    self.clearImgView.contentMode  = UIViewContentModeScaleAspectFill;
    self.clearImgView.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadImg:)];
//    [self.clearImgView addGestureRecognizer:tap];
    [self addSubview:self.clearImgView];

    //透明的view
    self.clearView = [[UIImageView alloc]initWithFrame:CGRectMake(kRealValue(6), 156, kScreenW - kRealValue(6) * 2, kRealValue(184))];
    self.clearView.image = [UIImage imageNamed:@"bogo_home_person_Top_BgImage"];
    self.clearView.backgroundColor = kClearColor;
//    self.clearView.layer.cornerRadius = 10;
//    self.clearView.layer.masksToBounds = YES;
    self.clearView.userInteractionEnabled = YES;
//    [[UIColor whiteColor] colorWithAlphaComponent:0.85];
    [self addSubview:self.clearView];
    
    // 返回
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0,kStatusBarHeight, 50,44);
    self.backButton.backgroundColor = [UIColor clearColor];
    self.backButton.hidden = YES;
    if (headType == 1)
    {
        [self.backButton setImage:[UIImage imageNamed:@"fw_me_search"] forState:UIControlStateNormal];
        self.backButton.hidden = YES;
    }else if (headType == 2)
    {
        [self.backButton setImage:[UIImage imageNamed:@"ac_auction_back"] forState:UIControlStateNormal];
    }
    self.backButton.tag = 100;
    [self.backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    //谁的主页
    self.outLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2-90, kStatusBarHeight, 180,44)];
    self.outLabel.textColor = [UIColor blackColor];
    self.outLabel.font = [UIFont systemFontOfSize:16];
    self.outLabel.textAlignment = NSTextAlignmentCenter;
    if (headType == 1)
    {
     self.outLabel.text = ASLocalizedString(@"我的");
    }
    [self addSubview:self.outLabel];
    
    //直播
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.messageBtn.tag = 101;
    [self.messageBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.messageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.messageBtn.hidden = YES;
//    self.messageBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

    [self.messageBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.messageBtn];
    
    if (headType == 1)
    {
        self.messageBtn.frame = CGRectMake(kScreenW-40,kStatusBarHeight+(44-28)/2,30,28);
        // 设置角标
        [self initBadgeBtn:self.messageBtn];
        [self.messageBtn setImage:[UIImage imageNamed:@"fw_me_news"] forState:UIControlStateNormal];
        self.messageBtn.hidden = YES;
    }else
    {
      self.messageBtn.frame = CGRectMake(kScreenW-60,kStatusBarHeight,50,44);
    }
    
    //头像
    self.headImgView = [[UIImageView alloc]init];
    self.headImgView.frame = CGRectMake(kScreenW/2-85*kScaleWidth/2,85,85*kScaleWidth, 85*kScaleWidth);
    self.headImgView.hidden = YES;
//    self.headImgView.layer.borderWidth = 2;
    self.headImgView.image = kDefaultPreloadHeadImg;
    self.headImgView.contentMode = UIViewContentModeScaleAspectFit;
//    self.headImgView.layer.borderColor = kBlackColor.CGColor;
    self.headImgView.layer.cornerRadius = 85*kScaleWidth/2;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadImg:)];
    [self.headImgView addGestureRecognizer:tapHead];
    [self addSubview:self.headImgView];
    
    //认证图标
    self.vImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame)-kViconWidthOrHeight2*1.3, CGRectGetMaxY(self.headImgView.frame)-kViconWidthOrHeight2*1.3, kViconWidthOrHeight2, kViconWidthOrHeight2)];
    [self addSubview:self.vImgView];
    self.vImgView.hidden = YES;
    
    //头像
    self.headImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headImgBtn.frame = CGRectMake(kScreenW/2-85*kScaleWidth/2,85,85*kScaleWidth, 85*kScaleWidth);
    self.headImgBtn.tag = 102;
    self.headImgBtn.backgroundColor = kClearColor;
    self.headImgBtn.hidden = YES;
    [self.headImgBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.headImgBtn];
    
    //名字 性别 等级
    self.nameView = [[UIView alloc]initWithFrame:CGRectMake(kRealValue(26), kRealValue(15) , self.clearView.width / 2, 30)];
    self.nameView.backgroundColor = kClearColor;
    [self.clearView addSubview:self.nameView];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = kBlackColor;
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [extracted(self) addSubview:self.nameLabel];
    
    self.livingBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.nameLabel.right + 10, 0, 60, 16)];
    self.livingBtn.centerY = self.nameLabel.centerY;
    [self.livingBtn setImage:[UIImage imageNamed:@"回播中"] forState:UIControlStateNormal];
    [self.livingBtn setImage:[UIImage imageNamed:@"直播中"] forState:UIControlStateSelected];
    [self.livingBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.livingBtn.tag = 101;
    [extracted(self) addSubview:self.livingBtn];
    
    self.vipImgView = [[UIImageView alloc]init];
    self.vipImgView.image = [UIImage imageNamed:@"mg_new_vip_icon"];
    [self.clearView addSubview:self.vipImgView];
    
    self.nobleImageView = [[UIImageView alloc]init];
    [self.clearView addSubview:self.nobleImageView];
    
    self.sexImgView = [[UIImageView alloc]init];
    [self.clearView addSubview:self.sexImgView];
    
    self.rankImgView = [[UIImageView alloc]init];
    [self.clearView addSubview:self.rankImgView];
    
    self.concertBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
//    [self.concertBtn setTitle:ASLocalizedString(@"关注")forState:UIControlStateNormal];
//    [self.concertBtn setImage:[UIImage imageNamed:@"me_new_head_concertTitle"] forState:UIControlStateNormal];
    [self.concertBtn addTarget:self action:@selector(clickAttention:) forControlEvents:UIControlEventTouchUpInside];
    [self.concertBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.concertBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.concertBtn setBackgroundImage:[UIImage imageNamed:@"bogo_home_person_Concert_normal"] forState:UIControlStateNormal];//mg_new_list_concert
//
    self.concertBtn.frame = CGRectMake(self.clearView.width - 10 - 53 - 10, 0, 53, 22);
    self.concertBtn.centerY = self.nameView.centerY;
    self.concertBtn.imagePosition = QMUIButtonImagePositionLeft;
    self.concertBtn.spacingBetweenImageAndTitle = 2;
    self.concertBtn.hidden = YES;
    [self.clearView addSubview:self.concertBtn];
    
    if (headType == 1)
    {
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editBtn setImage:[UIImage imageNamed:@"fw_me_bianji"] forState:UIControlStateNormal];
        self.editBtn.tag = 103;
        [self.editBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.nameView addSubview:self.editBtn];
    }else
    {
       self.messageBtn.frame = CGRectMake(kScreenW - 60,kStatusBarHeight,50,44);
    }
    
    //签名
    self.signatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.nameView.frame), kScreenW,21)];
    self.signatureLabel.textAlignment = NSTextAlignmentCenter;
    self.signatureLabel.textColor = kBlackColor;
    self.signatureLabel.font = [UIFont systemFontOfSize:12];
    self.signatureLabel.hidden = YES;
    [self.clearView addSubview:self.signatureLabel];
    
    //账号
    self.accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameView.left,CGRectGetMaxY(self.signatureLabel.frame), kScreenW,21)];
    self.accountLabel.textColor = kBlackColor;
    self.accountLabel.font = [UIFont systemFontOfSize:12];
    self.accountLabel.textAlignment = NSTextAlignmentLeft;
    [self.clearView addSubview:self.accountLabel];
    
//    //认证和认证的图标
    self.certificateBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.certificateBtn setTitle:ASLocalizedString(@"身份认证")forState:UIControlStateNormal];
    self.certificateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [self.certificateBtn setImagePosition:QMUIButtonImagePositionLeft];
    [self.certificateBtn setImage:[UIImage imageNamed:@"mg_dt_near_cert"] forState:UIControlStateNormal];
    [self.certificateBtn setTitleColor:[UIColor colorWithHexString:@"#04AEFB"] forState:UIControlStateNormal];
    self.certificateBtn.userInteractionEnabled = NO;
//    [self.certificateBtn setBackgroundImage:[UIImage imageNamed:@"mg_people_certBgImView"] forState:UIControlStateNormal];
    self.certificateBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    self.certificateBtn.spacingBetweenImageAndTitle = 2;
    self.certificateBtn.frame = CGRectMake(0, 0, kRealValue(80), 13);
    [self.clearView addSubview:self.certificateBtn];
    
    self.shopBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.clearView.width - 75 - 10, self.clearView.top - 35, 70, 70)];
    NSLog(@"%@",self.shopBtn);
    [self.shopBtn setImage:[UIImage imageNamed:@"my_商品橱窗"] forState:UIControlStateNormal];
    self.shopBtn.tag = 114;
    self.shopBtn.hidden = YES;
    [self.shopBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.shopBtn];
    
    
    //底部的view
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.clearView.frame),kScreenW,62)];
    self.bottomView.backgroundColor = kBackGroundColor;
    self.bottomView.hidden = YES;
    [self addSubview:self.bottomView];
    
    
    @autoreleasepool
    {
        self.itemView = [[UIView alloc]initWithFrame:CGRectMake(0, self.nameView.bottom, kScreenW, 70)];
//        self.itemView.layer.cornerRadius  = 3;
        self.itemView.layer.masksToBounds = YES;
        self.itemView.backgroundColor = kClearColor;
        [self.clearView addSubview:self.itemView];
        NSArray *array;
        if (headType == 1)
        {
           array = @[ASLocalizedString(@"回播"),ASLocalizedString(@"小视频"),ASLocalizedString(@"关注"),ASLocalizedString(@"粉丝"),];
        }else if (headType == 2)
        {
           array = @[ASLocalizedString(@"送出"),ASLocalizedString(@"关注"),ASLocalizedString(@"粉丝"),];
        }
        
        CGFloat labelW = kScreenW / 3;
//        (kScreenW-20-array.count-1)/array.count;
        
        for (int i = 0; i < array.count; i++)
        {
            UILabel *nameLabel    = [[UILabel alloc]initWithFrame:CGRectMake((labelW+1)*i,self.itemView.height/2 - 20, labelW, 25)];
            nameLabel.tag         = array.count +i;
            nameLabel.text        = array[i];
            nameLabel.textColor   = [UIColor colorWithHex:0x333333];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.font        = [UIFont systemFontOfSize:12];
            [self.itemView addSubview:nameLabel];
            
            UILabel *numLabel     = [[UILabel alloc]initWithFrame:CGRectMake((labelW+1)*i,self.itemView.height/2, labelW, 25)];
            numLabel.tag          = i;
            numLabel.text        = array[i];
            numLabel.textColor    = kAppGrayColor1;
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.font         = [UIFont systemFontOfSize:12];
            [self.itemView addSubview:numLabel];
            
            UIButton  *itemBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
            itemBtn.frame           = CGRectMake((labelW+1)*i, 3, labelW, self.itemView.height-6);
            itemBtn.backgroundColor = kClearColor;
            itemBtn.tag             = 104 + i;
            [itemBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.itemView addSubview:itemBtn];
            
            if (i < array.count-1)
            {
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((labelW+1)*i+labelW, 15, 1, 20)];
                lineView.centerY = self.itemView.height / 2;
                lineView.backgroundColor = kAppSpaceColor4;
                [self.itemView addSubview:lineView];
            }
        }
    }
    [self addSubview:self.tableView];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.height - kRealValue(45) - 10, kScreenW, kRealValue(45)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"HPContributionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HPContributionCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)shopBtnAction{
    NSLog(@"278");
}

-(void)clickHeadImg:(UITapGestureRecognizer *)sender{
    if (self.headViewBgImageBlock) {
        self.headViewBgImageBlock(self.clearImgView.image);
    }
}

//个人主页
- (void)setViewWithModel:(UserHomeModel*)model withUserId:(NSString *)userId
{
    
    //银票前三名
    for (UserHomeModelCuser_list *listModel in model.cuser_list) {
//        SenderModel *model = [SenderModel new];
//        model.head_image = listModel.head_image;
        
        if (listModel.is_noble_ranking_stealth == 1) {
            [self.imageArray addObject:@"is_noble_ranking_stealth"];
        }else{
            [self.imageArray addObject:listModel.head_image];
        }
        
        
    }
    [self.tableView reloadData];
    self.userID = userId;
    UserHomeModelUser *cModel;
    
    if (model.user)
    {
        cModel = model.user;
    }else{
        cModel = [[UserHomeModelUser alloc]init];
    }
    
    self.shopBtn.hidden = model.user.shop_status.integerValue != 1;
    
    if (model.has_focus == 1) {
//        [self.concertBtn setTitle:ASLocalizedString(@"已关注")forState:UIControlStateNormal];
//        [self.concertBtn setImage:nil forState:UIControlStateNormal];
//        [self.concertBtn setBackgroundImage:nil forState:UIControlStateNormal];
//        [self.concertBtn setBackgroundColor:[UIColor colorWithHexString:@"#E5E5E5"]];
        [self.concertBtn setBackgroundImage:[UIImage imageNamed:@"bogo_home_person_Concert_select"] forState:UIControlStateNormal];
        
//        self.concertBtn.layer.cornerRadius = 5;
    }else{
//        [self.concertBtn setTitle:ASLocalizedString(@"关注")forState:UIControlStateNormal];
//        [self.concertBtn setImage:[UIImage imageNamed:@"me_new_head_concertTitle"] forState:UIControlStateNormal];
        [self.concertBtn setBackgroundImage:[UIImage imageNamed:@"bogo_home_person_Concert_normal"] forState:UIControlStateNormal];
//        [self.concertBtn setBackgroundColor:kWhiteColor];
//        self.concertBtn.layer.cornerRadius = 5;
    }
    
//    self.outLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@的主页"),userId];
    self.outLabel.text = ASLocalizedString(@"用户主页");
    self.outLabel.hidden = YES;
    //底部透明图
//    [self.clearImgView sd_setImageWithURL:[NSURL URLWithString:cModel.head_image]];
    //头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:cModel.head_image] placeholderImage:kDefaultPreloadHeadImg];
    [self.clearImgView sd_setImageWithURL:[NSURL URLWithString:cModel.head_image] placeholderImage:kDefaultPreloadHeadImg];
    
    
    
    //认证是否显示
    if ([model.user.is_authentication intValue]>0)
    {
        if (model.user.v_icon && ![model.user.v_icon isEqualToString:@""])
        {
            self.certificateBtn.hidden = NO;
            [self.certificateBtn setTitle:model.user.v_explain forState:UIControlStateNormal];
//            [self.vImgView sd_setImageWithURL:[NSURL URLWithString:model.user.v_icon] placeholderImage:kDefaultPreloadHeadImg];
        }else
        {
            self.certificateBtn.hidden = YES;
        }
    }else
    {
        self.certificateBtn.hidden = YES;
    }
    

    
    
    //名字 性别 等级
    if (cModel.nick_name.length < 1)
    {
        cModel.nick_name = ASLocalizedString(@"暂无昵称");
    }
    
    
    
//    if (cModel.is_noble_ranking_stealth.intValue == 1) {
//        cModel.nick_name = [NSString stringWithFormat:@"神秘人%@",cModel.user_id];
//    }else{
//        
//    }
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:cModel.nick_name];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, cModel.nick_name.length)];
    CGFloat width =[cModel.nick_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    if (width + 52 > (kScreenW+6))
    {
        width = kScreenW-52-6;
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    self.nameLabel.attributedText = attr;

    self.nameLabel.frame = CGRectMake(0, 0, width,30);
    self.livingBtn.centerY = self.nameLabel.centerY;
    self.livingBtn.left = self.nameLabel.right + 10;
    self.sexImgView.frame = CGRectMake(self.nameView.left,self.nameView.bottom + 10,12,12);
    self.rankImgView.frame = CGRectMake(width+24,self.nameLabel.bottom,28,14);
    self.accountLabel.top = self.sexImgView.bottom + 5;
    self.itemView.top = self.accountLabel.bottom - 5;
    
    self.certificateBtn.frame = CGRectMake(self.rankImgView.right + 5, 0, kRealValue(80), 13);
    
    if (cModel.is_vip != 1) {
        self.vipImgView.hidden = YES;
    }else{
        self.vipImgView.hidden = NO;
    }
    
    if (cModel.noble_icon.length) {
        self.nobleImageView.hidden = NO;
        [self.nobleImageView sd_setImageWithURL:[NSURL URLWithString:cModel.noble_icon]];
    }else{
        self.nobleImageView.hidden = YES;
    }
    
    if (self.vipImgView.hidden) {
//        self.vipImgView.frame = CGRectMake(self.sexImgView.right + 5, self.nameLabel.bottom, 15, 15);
        self.rankImgView.frame = CGRectMake(self.sexImgView.right + 5, self.nameLabel.bottom, 28, 14);
    }else{
        self.vipImgView.frame = CGRectMake(self.sexImgView.right + 5, self.nameLabel.bottom, 15, 15);
        self.rankImgView.frame = CGRectMake(self.vipImgView.right + 5, self.nameLabel.bottom, 28, 14);
    }
    if (!self.nobleImageView.hidden) {
        self.nobleImageView.frame = CGRectMake(self.rankImgView.right + 5, self.nameLabel.bottom, 45, 16);
        self.certificateBtn.left = self.nobleImageView.right + 5;
    }
    self.nobleImageView.centerY = self.rankImgView.centerY = self.vipImgView.centerY = self.sexImgView.centerY;

    

    
    if ([cModel.sex isEqualToString:@"1"])
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
    }else
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
    }
    if (cModel.user_level.length < 1)
    {
        cModel.user_level = @"1";
    }
    self.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%@",cModel.user_level]];

    //签名
    if (cModel.signature.length < 1)
    {
        self.signatureLabel.text = ASLocalizedString(@"TA好像忘记签名了");
    }else
    {
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:cModel.signature];
        [attr1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]} range:NSMakeRange(0,cModel.signature.length)];
        self.signatureLabel.attributedText = attr1;
    }
    if (cModel.luck_num.length && [cModel.luck_num intValue] > 0)
    {
     self.accountLabel.text = [NSString stringWithFormat:@"%@:%@",self.BuguLive.appModel.account_name,cModel.luck_num];
    }else
    {
     self.accountLabel.text = [NSString stringWithFormat:@"%@:%@",self.BuguLive.appModel.account_name,userId];
    }
    
    
    //认证
    NSString *v_explainString;
    if (cModel.v_explain.length < 1)
    {
        self.certificateView.hidden = YES;
        v_explainString = cModel.v_explain = ASLocalizedString(@"未认证");
        CGRect rect = self.certificateView.frame;
        rect.size.height = 0;
        self.certificateView.frame = rect;
        
    }else
    {
        self.certificateView.hidden = NO;
        self.certificateImgView.hidden = NO;
        v_explainString = [NSString stringWithFormat:ASLocalizedString(@"认证:%@"),cModel.v_explain];
    }
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:v_explainString];
    self.certificateLabel.attributedText = attr2;
    CGFloat width1 =[v_explainString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width;
    self.certificateLabel.frame = CGRectMake(CGRectGetMaxX(self.certificateImgView.frame)+3, 0, width1, 21);

    //送出 关注 粉丝
    for (UILabel *label in self.itemView.subviews)
    {
        if ([label isKindOfClass:[UILabel class]])
        {
            if (label.tag == 3)
            {
                if (cModel.n_use_diamonds.length)
                {
                 label.text =cModel.n_use_diamonds;
                }else
                {
                  label.text =@"0";
                }
                
            }else if (label.tag == 4)
            {
                if (cModel.n_focus_count.length)
                {
                    label.text =cModel.n_focus_count;
                }else
                {
                    label.text =@"0";
                }
            }else if (label.tag == 5)
            {
                if (cModel.n_fans_count.length)
                {
                    label.text =cModel.n_fans_count;
                }else
                {
                    label.text =@"0";
                }
            }
        }
    }
    [self updateNewFrame];
}

- (void)setUIWithDict:(NSDictionary *)dict
{
    if ([dict count])
    {
        UserModel *model2 = [UserModel mj_objectWithKeyValues:dict];
        if (model2.live_in == FW_LIVE_STATE_ING)
        {
            self.livingBtn.selected = YES;
//            [self.messageBtn setTitle:ASLocalizedString(@"直播中")forState:UIControlStateNormal];
        }
        else if (model2.live_in == FW_LIVE_STATE_RELIVE)
        {
            self.livingBtn.selected = NO;
//            [self.messageBtn setTitle:ASLocalizedString(@"回播中")forState:UIControlStateNormal];
        }
        
        NSShadow *shadow = [[NSShadow alloc] init];

       shadow.shadowBlurRadius = 2;//阴影半径，默认值3

       shadow.shadowColor = [UIColor blackColor];//阴影颜色

       shadow.shadowOffset = CGSizeMake(0,2);//阴影偏移量，x向右偏移，y向下偏移，默认是（0，-3）

       NSAttributedString * attributedText = [[NSAttributedString alloc] initWithString:self.messageBtn.titleLabel.text attributes:@{NSShadowAttributeName:shadow}];
        
        [self.messageBtn setAttributedTitle:attributedText forState:UIControlStateNormal];
        
    }else
    {
        self.livingBtn.hidden = YES;
        self.messageBtn.hidden = YES;
    }
}



- (void)setCellWithModel:(userPageModel *)userInfoM
{
    self.userID = userInfoM.user_id;
    //底部透明头像
//    [self.clearImgView sd_setImageWithURL:[NSURL URLWithString:userInfoM.head_image]];
    
    //头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:userInfoM.head_image] placeholderImage:kDefaultPreloadHeadImg];
    if (userInfoM.v_icon.length && [userInfoM.is_authentication intValue]== 2)
    {
        self.vImgView.hidden = NO;
        [self.vImgView sd_setImageWithURL:[NSURL URLWithString:userInfoM.v_icon] placeholderImage:kDefaultPreloadHeadImg];
    }else
    {
        self.vImgView.hidden = YES;
    }
    
    //账号 vip 性别 等级 编辑
    if (userInfoM.nick_name.length < 1)
    {
        userInfoM.nick_name = ASLocalizedString(@"暂无昵称");
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:userInfoM.nick_name];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, userInfoM.nick_name.length)];
    CGFloat width =[userInfoM.nick_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    self.nameLabel.attributedText = attr;
    if ([userInfoM.sex isEqualToString:@"1"])
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
    }else
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
    }
    if (userInfoM.user_level.length < 1)
    {
        userInfoM.user_level = @"1";
    }
    self.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%@",userInfoM.user_level]];
    self.rankImgView.backgroundColor = kRedColor;
    if ([userInfoM.is_vip isEqualToString:@"1"])
    {
        if (width + 20 + 19 + 33 + 30 + 5 > kScreenW)
        {
            width = kScreenW - 20 - 19 -33 - 30;
            self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        }
        self.nameLabel.frame  = CGRectMake(0, 0, width, 30);
        self.sexImgView.frame = CGRectMake(10, self.nameLabel.bottom + 5, 15, 15);
        self.vipImgView.frame = CGRectMake(self.sexImgView.right + 5, self.nameLabel.bottom, 15, 15);
        self.rankImgView.frame = CGRectMake(self.vipImgView.right + 5, self.nameLabel.bottom, 28, 14);
//        self.editBtn.frame = CGRectMake(width+20+19+33, 0, 30,30);
        
        CGRect nameRect = self.nameView.frame;
        nameRect.size.width = (width+20+19+33+30);
        nameRect.origin.x = (kScreenW - (width+20+19+33+30))/2;
        self.nameView.frame = nameRect;
    }else
    {
        if (width +19 +33 +30 > (kScreenW+6))
        {
            width = kScreenW-19 -33 -30-6;
            self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        }
        self.nameLabel.frame  = CGRectMake(0, 0, width, 30);
        self.sexImgView.frame = CGRectMake(0, self.nameLabel.bottom + 5, 15, 15);
//        self.vipImgView.frame = CGRectMake(self.sexImgView.right + 5, self.nameLabel.bottom, 15, 15);
        self.rankImgView.frame = CGRectMake(self.sexImgView.right + 5, self.nameLabel.bottom, 28, 14);
        
        
        CGRect nameRect = self.nameView.frame;
        nameRect.size.width = (width +19 +33 +30);
        nameRect.origin.x = (kScreenW - (width +19 +33 +30))/2;
        self.nameView.frame = nameRect;
    }
    
    self.certificateView.centerY = self.rankImgView.centerY;
    
    if (self.nobleImageView.hidden) {
        self.certificateBtn.left = self.rankImgView.right;
    }else{
        self.certificateBtn.left = self.nobleImageView.right;
    }
    
    
    //签名
    if (userInfoM.signature.length < 1)
    {
        self.signatureLabel.text = ASLocalizedString(@"TA好像忘记签名了");
    }else
    {
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:userInfoM.signature];
        [attr1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]} range:NSMakeRange(0,userInfoM.signature.length)];
        self.signatureLabel.attributedText = attr1;
    }
    
    //账号
    if ([userInfoM.luck_num intValue] > 0)
    {
        if (self.BuguLive.appModel.account_name.length > 0)
        {
            self.accountLabel.text =[NSString stringWithFormat:@"%@:%@",self.BuguLive.appModel.account_name, userInfoM.luck_num];
        }else
        {
            self.accountLabel.text =[NSString stringWithFormat:@"%@:%@",self.BuguLive.appModel.account_name,userInfoM.luck_num];
        }
    }
    else
    {
        if (self.BuguLive.appModel.account_name.length > 0)
        {
            self.accountLabel.text =[NSString stringWithFormat:@"%@:%@",self.BuguLive.appModel.account_name, userInfoM.user_id];
        }else
        {
            self.accountLabel.text =[NSString stringWithFormat:@"%@:%@",
                                     ASLocalizedString(@"账号"), userInfoM.user_id];
        }
    }
    
    //认证
    NSString *v_explainString;
    if (userInfoM.v_explain.length < 1)
    {
        self.certificateView.hidden = YES;
        v_explainString = userInfoM.v_explain = ASLocalizedString(@"未认证");
        CGRect rect = self.certificateView.frame;
        rect.size.height = 0;
        self.certificateView.frame = rect;
    }else
    {
        self.certificateView.hidden = NO;
        self.certificateImgView.hidden = NO;
        v_explainString = [NSString stringWithFormat:ASLocalizedString(@"认证:%@"),userInfoM.v_explain];
        NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:v_explainString];
        self.certificateLabel.attributedText = attr2;
        
        CGFloat width1 =[v_explainString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width;
        self.certificateLabel.frame = CGRectMake(CGRectGetMaxX(self.certificateImgView.frame)+3, 0, width1, 21);
        CGRect rect = self.certificateView.frame;
        rect.size.width = width1+20;
        rect.size.height = 21;
        self.certificateView.frame = rect;
        self.certificateLabel.frame = CGRectMake(18, 0, width1, 21);
    }

    

    //直播 小视频 关注 粉丝
    for (UILabel *label in self.itemView.subviews)
    {
        if ([label isKindOfClass:[UILabel class]])
        {
            if (label.tag == 4)
            {
                if (userInfoM.n_video_count.length)
                {
                    label.text = userInfoM.n_video_count;
                }else
                {
                    label.text =@"0";
                }
                
            }else if (label.tag == 5)
            {
                if (userInfoM.n_svideo_count.length)
                {
                    label.text =userInfoM.n_svideo_count;
                }else
                {
                    label.text =@"0";
                }
            }else if (label.tag == 6)
            {
                if (userInfoM.n_focus_count.length)
                {
                    label.text =userInfoM.n_focus_count;
                 }else
                {
                    label.text =@"0";
                }
            }else if (label.tag == 7)
            {
                if (userInfoM.n_fans_count.length)
                {
                    label.text =userInfoM.n_fans_count;
                }else
                {
                    label.text =@"0";
                }
            }
        }
    }
    [self updateNewFrame];
}

- (void)updateNewFrame
{
    //透明图片和透明view
//    CGRect  newRect = self.clearView.frame =self.clearImgView.frame;
//    newRect.size.height = CGRectGetMaxY(self.certificateView.frame) +40;
    self.clearView.frame = CGRectMake(10, 223, kScreenW - 10 * 2, kRealValue(164));
    
    self.shopBtn.top = self.clearView.top - 30;
    if (!self.nobleImageView.hidden) {
        self.certificateBtn.frame = CGRectMake(self.nobleImageView.right + 3, 0, 200, 20);
    }else{
        self.certificateBtn.frame = CGRectMake(self.rankImgView.right + 3, 0, 200, 20);
    }
    
    self.certificateBtn.centerY = self.rankImgView.centerY;
    //self.certificateBtn.left = self.rankImgView.right + 2;
    self.headImgView.hidden = YES;
//    //底部灰色view
//    CGRect bottomRect = self.bottomView.frame;
//    bottomRect.origin.y = CGRectGetMaxY(self.clearView.frame);
//    self.bottomView.frame = bottomRect;
//    //底部灰色view
//    CGRect itemRect =  self.itemView.frame;
//    itemRect.origin.y = CGRectGetMaxY(self.clearView.frame)-20;
//    self.itemView.frame = itemRect;
//    //本身的view
//    CGRect myRect = self.frame;
//    myRect.size.height = self.clearView.size.height+60;
//    self.frame = myRect;
}



-(void)clickAttention:(UIButton *)sender{
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
    [dictM setObject:@"user" forKey:@"ctl"];
    [dictM setObject:@"follow" forKey:@"act"];
    [dictM setObject:self.userID forKey:@"to_user_id"];
    
    FWWeakify(self)
    [[NetHttpsManager manager] POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
     {
         
         if ([responseJson toInt:@"status"] == 1)
         {
             NSInteger has_focus = [responseJson toInt:@"has_focus"];
             if (has_focus == 1) {
//                 [sender setTitle:ASLocalizedString(@"已关注")forState:UIControlStateNormal];
//                 [sender setImage:nil forState:UIControlStateNormal];
                 
                 [sender setBackgroundImage:[UIImage imageNamed:@"bogo_home_person_Concert_select"] forState:UIControlStateNormal];
//                 [sender setBackgroundColor:[UIColor colorWithHexString:@"#E5E5E5"]];
//                 sender.layer.cornerRadius = 5;
                 if (self.headViewAttentionBlock) {
                     self.headViewAttentionBlock(YES);
                 }
             }else{
//                 [sender setTitle:ASLocalizedString(@"关注")forState:UIControlStateNormal];
//                 [sender setImage:[UIImage imageNamed:@"me_new_head_concertTitle"] forState:UIControlStateNormal];
                 [sender setBackgroundImage:[UIImage imageNamed:@"bogo_home_person_Concert_normal"] forState:UIControlStateNormal];
//                 [sender setBackgroundColor:kWhiteColor];
//                 sender.layer.cornerRadius = 5;
                 if (self.headViewAttentionBlock) {
                     self.headViewAttentionBlock(NO);
                 }
             }
         }
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error===%@",error);
     }];
}

- (void)buttonClick:(UIButton *)btn
{
    if (self.headViewBlock)
    {
        self.headViewBlock((int)btn.tag);
    }
}

/**
 设置 角标
 
 @param sender 对应的控件
 */
- (void)initBadgeBtn:(UIButton *)sender
{
    //-好友
    _badge = [[JSBadgeView alloc]initWithParentView:sender alignment:JSBadgeViewAlignmentTopRight];
    _badge.badgePositionAdjustment = CGPointMake(-6, 3);
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HPContributionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HPContributionCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellWithArray:self.imageArray];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kRealValue(45);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headView:didClickContribution:)]) {
        [self.delegate headView:self didClickContribution:nil];
    }
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}
@end
