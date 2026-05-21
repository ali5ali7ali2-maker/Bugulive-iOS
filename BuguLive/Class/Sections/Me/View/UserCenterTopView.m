//
//  UserCenterTopView.m
//  BuguLive
//
//  Created by 范东 on 2019/1/15.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "UserCenterTopView.h"
#import "userPageModel.h"
#import <QMUIMarqueeLabel.h>

@interface UserCenterTopView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet QMUIMarqueeLabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UIImageView *authImageView;
@property (weak, nonatomic) IBOutlet UILabel *authLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIImageView *certificateView;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;

@property (nonatomic, copy) clickBtnBlock clickBtnBlock;
@property (weak, nonatomic) IBOutlet UIButton *noAuthEditBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sexImageLeft;


//@property (weak, nonatomic) IBOutlet QMUIButton *signBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *certificationBtn;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editBtnLeftConstraint;


@end

@implementation UserCenterTopView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.recordBtn.titleLabel setNumberOfLines:0];
    [self.videoBtn.titleLabel setNumberOfLines:0];
    [self.focusBtn.titleLabel setNumberOfLines:0];
    [self.fansBtn.titleLabel setNumberOfLines:0];
    [self.recordBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.focusBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.videoBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.fansBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickIcon)];
    [self.iconImageView addGestureRecognizer:tap];
    
    self.signButton.spacingBetweenImageAndTitle = 3;
    self.signButton.imagePosition = QMUIButtonImagePositionLeft;

    self.certificateView.hidden = YES;
    self.backgroundColor = kClearColor;
    
//    [self.certificationBtn setTitle:ASLocalizedString(@"支付宝认证")forState:UIControlStateNormal];
    [self.certificationBtn setBackgroundImage:[UIImage imageNamed:@"mg_zhifu_certication"] forState:UIControlStateNormal];
//    [self.certificationBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.certificationBtn.spacingBetweenImageAndTitle = 3;
//    [self.certificationBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8]]];
//    self.certificationBtn.backgroundColor = [UIColor colorWithHexString:@"#CA93F7"];
//    [UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
//     setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8]];
//    self.certificationBtn.layer.masksToBounds = YES;
//    self.certificationBtn.layer.cornerRadius = 13 / 2;
    
    
    
    self.shopBtn.imagePosition = QMUIButtonImagePositionTop;
    self.shopBtn.spacingBetweenImageAndTitle = 5;
    self.vipBtn.imagePosition = QMUIButtonImagePositionTop;
    self.vipBtn.spacingBetweenImageAndTitle = 5;
    self.levelBtn.imagePosition = QMUIButtonImagePositionTop;
    self.levelBtn.spacingBetweenImageAndTitle = 5;
    self.familyBtn.imagePosition = QMUIButtonImagePositionTop;
    self.familyBtn.spacingBetweenImageAndTitle = 5;
    
    self.accountImgView.layer.cornerRadius = 4;
    self.accountImgView.layer.masksToBounds = YES;
    
    self.incomeImgView.layer.cornerRadius = 4;
    self.incomeImgView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapAccount = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAccount:)];
    [self.accountImgView addGestureRecognizer:tapAccount];
    self.accountImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapIncome = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickIncome:)];
    [self.incomeImgView addGestureRecognizer:tapIncome];
    self.incomeImgView.userInteractionEnabled = YES;
    
    self.nobleImgView.hidden = YES;
}

- (void)setViewWithModel:(userPageModel *)userInfoM{
    //头像
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userInfoM.head_image] placeholderImage:kDefaultPreloadHeadImg];
//    [self.backView sd_setImageWithURL:[NSURL URLWithString:userInfoM.head_image] placeholderImage:kDefaultPreloadHeadImg];
    self.backView.image = [UIImage imageNamed:@"me_center_back"];
//    if (userInfoM.v_icon.length && [userInfoM.is_authentication intValue]== 2){
//        self.certificateView.hidden = NO;
//        [self.certificateView sd_setImageWithURL:[NSURL URLWithString:userInfoM.v_icon] placeholderImage:kDefaultPreloadHeadImg];
//    }else{
//        self.certificateView.hidden = YES;
//    }
    
    if (![userInfoM.is_vip isEqualToString:@"1"]) {
        self.vipImageView.hidden = YES;
        self.sexImageLeft.constant = 5;
        self.editBtnLeftConstraint.constant = 15;
    }else{
        self.vipImageView.hidden = NO;
        self.editBtnLeftConstraint.constant = 24;
    }
    
    
    //贵族图标是否显示
    if (StrValid(userInfoM.noble_icon)) {
        self.nobleImgView.hidden = NO;
        
        self.nobleLeftImgConstraint.constant = 61;
        [self.nobleImgView sd_setImageWithURL:[NSURL URLWithString:userInfoM.noble_icon]];
        
    }else{
        self.nobleImgView.hidden = YES;
        self.nobleLeftImgConstraint.constant = 10;
    }
    
    self.rankLeftConstraint.constant = 81;
    //认证是否显示
    if ([userInfoM.is_authentication intValue]>0)
    {
        if (userInfoM.v_explain && ![userInfoM.v_explain isEqualToString:@""])
        {
//            [self.certificationBtn setTitle:userInfoM.v_explain forState:UIControlStateNormal];
            self.certificationBtn.hidden = NO;
            
        }else{
            self.certificationBtn.hidden = YES;
            self.rankLeftConstraint.constant = 10;
        }
    }else{
        self.certificationBtn.hidden = YES;
        self.rankLeftConstraint.constant = 10;
    }
    
    
    //账号 vip 性别 等级 编辑
    if (userInfoM.nick_name.length < 1)
    {
        userInfoM.nick_name = ASLocalizedString(@"暂无昵称");
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:userInfoM.nick_name];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, userInfoM.nick_name.length)];
    [attr addAttribute:NSForegroundColorAttributeName
                       value:kWhiteColor
                       range:[userInfoM.nick_name rangeOfString:userInfoM.nick_name]];
//    [attr addAttribute:NSBackgroundColorAttributeName value:[UIColor blueColor] range:[string rangeOfString:@"ent"]];
    
    self.nameLabel.attributedText = attr;
    self.nameLabel.textColor = kWhiteColor;
    
//    if ([userInfoM.sex isEqualToString:@"1"]){
//        self.sexImageView.image = [UIImage imageNamed:@"com_male_selected"];
//    }else{
//        self.sexImageView.image = [UIImage imageNamed:@"com_female_selected"];
//    }
    
    [self.sexImageView setImage:[UIImage imageNamed:[userInfoM.sex isEqualToString:@"1"] ? @"dy_sex_male" :@"dy_sex_female"]];
    
    if (userInfoM.user_level.length < 1){
        userInfoM.user_level = @"1";
    }
    self.rankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%@",userInfoM.user_level]];
    //签名
    if (userInfoM.signature.length < 1){
        self.signLabel.text = ASLocalizedString(@"TA好像忘记签名了");
    }else{
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:userInfoM.signature];
        [attr1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]} range:NSMakeRange(0,userInfoM.signature.length)];
        self.signLabel.attributedText = attr1;
    }
    //账号
    if ([userInfoM.luck_num intValue] > 0){
        if (self.BuguLive.appModel.account_name.length > 0){
            self.accountLabel.text =[NSString stringWithFormat:@"%@:%@",self.BuguLive.appModel.account_name, userInfoM.luck_num];
        }else{
            self.accountLabel.text =[NSString stringWithFormat:@"%@:%@",self.BuguLive.appModel.account_name,userInfoM.luck_num];
        }
    }
    else{
        if (self.BuguLive.appModel.account_name.length > 0){
            self.accountLabel.text =[NSString stringWithFormat:@"%@:%@",self.BuguLive.appModel.account_name, userInfoM.user_id];
        }else{
            self.accountLabel.text =[NSString stringWithFormat:@"%@:%@",
                                     ASLocalizedString(@"账号"), userInfoM.user_id];
        }
    }
    //认证
    NSString *v_explainString;
    if (userInfoM.v_explain.length < 1){
        self.authImageView.hidden = YES;
        v_explainString = userInfoM.v_explain = ASLocalizedString(@"未认证");
        self.authLabel.hidden = YES;
        self.authImageView.hidden = YES;
        self.editBtn.hidden = NO;
        self.noAuthEditBtn.hidden = NO;
    }else{
        self.authImageView.hidden = NO;
        v_explainString = [NSString stringWithFormat:ASLocalizedString(@"认证:%@"),userInfoM.v_explain];
        self.authLabel.text = v_explainString;
        self.authImageView.hidden = NO;
        self.editBtn.hidden = NO;
        self.noAuthEditBtn.hidden = YES;
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 5;
    style.alignment = NSTextAlignmentCenter;
    NSString *content = userInfoM.n_video_count.length ? [NSString stringWithFormat:ASLocalizedString(@"%@\n回播"),userInfoM.n_video_count] : ASLocalizedString(@"0\n回播");
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:content];
    [attString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
    [self.recordBtn setAttributedTitle:attString forState:UIControlStateNormal];
    
    content = userInfoM.n_svideo_count.length ? [NSString stringWithFormat:ASLocalizedString(@"%@\n小视频"),userInfoM.n_svideo_count] : ASLocalizedString(@"0\n小视频");
    attString = [[NSMutableAttributedString alloc]initWithString:content];
    [attString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
    [self.videoBtn setAttributedTitle:attString forState:UIControlStateNormal];
    
    content = userInfoM.focus_count.length ? [NSString stringWithFormat:ASLocalizedString(@"%@\n关注"),userInfoM.focus_count] : ASLocalizedString(@"0\n关注");
    attString = [[NSMutableAttributedString alloc]initWithString:content];
    [attString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
    [self.focusBtn setAttributedTitle:attString forState:UIControlStateNormal];
    
    content = userInfoM.n_fans_count.length ? [NSString stringWithFormat:ASLocalizedString(@"%@\n粉丝"),userInfoM.n_fans_count] : ASLocalizedString(@"0\n粉丝");
    attString = [[NSMutableAttributedString alloc]initWithString:content];
    [attString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
    [self.fansBtn setAttributedTitle:attString forState:UIControlStateNormal];
    
    self.diamondL.text = [NSString stringWithFormat:ASLocalizedString(@"%@余额：%@"),[GlobalVariables sharedInstance].appModel.diamond_name,userInfoM.diamonds];
    self.incomeL.text = [NSString stringWithFormat:@"%@：%@",[GlobalVariables sharedInstance].appModel.ticket_name,userInfoM.n_useable_ticket];
    
}

- (void)clickIcon{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeIcon);
    }
}

- (IBAction)setBtnAction:(UIButton *)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeSet);
    }
}

- (IBAction)editBtnAction:(UIButton *)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeEdit);
    }
}

- (IBAction)recordBtnAction:(id)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeRecord);
    }
}

- (IBAction)videoBtnAction:(id)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeVideo);
    }
}

- (IBAction)focusBtnAction:(id)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeFocus);
    }
}

- (IBAction)fansBtnAction:(id)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeFan);
    }
}
- (IBAction)noAuthEditBtnAction:(id)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeEdit);
    }
}


- (IBAction)signBtnClick:(id)sender {

    NSLog(ASLocalizedString(@"点击签到按钮"));
    if (self.clickBtnBlock) {
           self.clickBtnBlock(UserCenterTopViewBtnTypeSign);
       }
}


- (IBAction)clickShopBtn:(QMUIButton *)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeShop);
    }
}

- (IBAction)clickVipBtn:(QMUIButton *)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeVIP);
    }
}

- (IBAction)clickLevelBtn:(QMUIButton *)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeLevel);
    }
}

- (IBAction)clickFamilyBtn:(QMUIButton *)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeFamily);
    }
}

-(void)clickAccount:(UITapGestureRecognizer *)sender{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeAccount);
    }
}

-(void)clickIncome:(UITapGestureRecognizer *)sender{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(UserCenterTopViewBtnTypeIncome);
    }
}

- (void)setClickBtnBlock:(clickBtnBlock)clickBtnBlock{
    _clickBtnBlock = clickBtnBlock;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
