//
//  CellForQAList.m
//  github:  https://github.com/samuelandkevin
//  CSDN:  http://blog.csdn.net/samuelandkevin
//  Created by samuelandkevin on 16/8/29.
//  Copyright © 2016年 HKP. All rights reserved.
//

#import "CellForWorkGroup.h"
#import "YHWorkGroupPhotoContainer.h"
#import "YHUserInfoManager.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

#import <ZQPlayer/ZQPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "HJAudioBubble.h"

#import <LCActionSheet.h>

const CGFloat contentLabelFontSize = 14.0;
CGFloat maxContentLabelHeight = 0;  //根据具体font而定
CGFloat kMarginContentLeft    = 10; //动态内容左边边距
CGFloat kMarginContentRight   = 10; //动态内容右边边边距
const CGFloat deleteBtnHeight = 30;
const CGFloat deleteBtnWidth  = 60;
const CGFloat moreBtnHeight   = 30;
const CGFloat moreBtnWidth    = 60;

@interface CellForWorkGroup()<HKPBotViewDelegate>

@property (nonatomic,strong)UIImageView *imgvAvatar;
@property (nonatomic,strong)UILabel     *labelName;
@property (nonatomic,strong)UIButton     *topBtn;

@property (nonatomic,strong)UILabel     *labelIndustry;
@property (nonatomic,strong)UILabel     *labelPubTime;
@property (nonatomic,strong)UILabel     *labelDistance;

@property (nonatomic,strong)UILabel     *labelCompany;
@property (nonatomic,strong)UILabel     *labelJob;
@property (nonatomic,strong)YYLabel     *labelContent;
@property (nonatomic,strong)UILabel     *labelDelete;
@property (nonatomic,strong)UILabel     *labelMore;



@property(nonatomic, strong) QMUIButton *sexBtn;

@property(nonatomic, strong) UIButton *followBtn;/**<关注按钮*/

@property (nonatomic,strong)UILabel     *labelTime;



@property(nonatomic,strong) AVPlayer *player;

@property (nonatomic,strong)YHWorkGroupPhotoContainer *picContainerView;
@property (nonatomic,strong)UIView      *viewSeparator;

@property(nonatomic, strong) UIButton *moreBtn;

//约束
@property (nonatomic,strong)NSLayoutConstraint *cstHeightlbMore;
@property (nonatomic,strong)NSLayoutConstraint *cstHeightlbDelete;
@property (nonatomic,strong)NSLayoutConstraint *cstCenterYlbDelete;
@property (nonatomic,strong)NSLayoutConstraint *cstLeftlbDelete;
@property (nonatomic,strong)NSLayoutConstraint *cstHeightlbContent;
@property (nonatomic,strong)NSLayoutConstraint *cstHeightPicContainer;
@property (nonatomic,strong)NSLayoutConstraint *cstTopPicContainer;
@property (nonatomic,strong)NSLayoutConstraint *cstTopViewBottom;


/** 音频气泡 */
@property (nonatomic, strong) HJAudioBubble *playAudio;

@property(nonatomic, strong) UIImageView *pauseImgView;

@end


static const CGFloat kCellHeight = 80.f;
static const CGFloat kBubbleW    = 150.f;
static const CGFloat kBubbleH    = 33.f;


@implementation CellForWorkGroup

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup{
    
    self.imgvAvatar = [UIImageView new];
    self.imgvAvatar.layer.cornerRadius = 22.5;
    self.imgvAvatar.layer.masksToBounds = YES;
    self.imgvAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatar:)];
    [self.imgvAvatar addGestureRecognizer:tapGuesture];
    [self.contentView addSubview:self.imgvAvatar];
    
    self.labelName  = [UILabel new];
    self.labelName.font = [UIFont systemFontOfSize:14.0f];
    self.labelName.textColor = kBlackColor;
//    RGB16(0x303030);
    [self.contentView addSubview:self.labelName];
    
    
    
    self.topBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"dy_list_top"] forState:UIControlStateNormal];
        [btn setTitle:ASLocalizedString(@"置顶")forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        btn;
    });
    
    [self.contentView addSubview:self.topBtn];

    self.topBtn.hidden = YES;
    
    self.sexBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.sexBtn];
    
    self.followBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"dy_list_follow"] forState:UIControlStateNormal];
        [btn setTitle:ASLocalizedString(@"关注")forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [btn setTitleColor:[UIColor colorWithHexString:@"#CD49FF"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    [self.contentView addSubview:self.followBtn];

    self.followBtn.hidden = YES;
    
    
    
    self.labelIndustry = [UILabel new];
    self.labelIndustry.font = [UIFont systemFontOfSize:12.0f];
    self.labelIndustry.textColor = kBlackColor;
//    RGB16(0x303030);
    [self.contentView addSubview:self.labelIndustry];
    
    self.labelPubTime = [UILabel new];
    self.labelPubTime.font = [UIFont systemFontOfSize:13.0f];
    self.labelPubTime.textColor = kGrayColor;
//    RGBCOLOR(0, 191, 143);
    [self.contentView addSubview:self.labelPubTime];
    self.labelDistance  = [UILabel new];
    self.labelDistance.font = [UIFont systemFontOfSize:13.0f];
    self.labelDistance.textColor = kGrayColor;
    //    RGB16(0x303030);
    [self.contentView addSubview:self.labelDistance];
    self.labelCompany = [UILabel new];
    self.labelCompany.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:self.labelCompany];
    
    self.labelJob = [UILabel new];
    self.labelJob.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:self.labelJob];
    
    self.labelContent = [YYLabel new];
    self.labelContent.font = [UIFont systemFontOfSize:contentLabelFontSize];
    self.labelContent.numberOfLines = 0;
    self.labelContent.userInteractionEnabled = YES;
    [self.contentView addSubview:self.labelContent];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 2;
    [self.labelContent addGestureRecognizer:longPress];
    
    self.labelDelete = [UILabel new];
    self.labelDelete.font = [UIFont systemFontOfSize:14.0f];
    self.labelDelete.textColor = RGBCOLOR(61, 95, 155);
    self.labelDelete.contentMode = UIControlContentHorizontalAlignmentLeft;
    self.labelDelete.userInteractionEnabled = YES;
    UITapGestureRecognizer *deleteTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTap)];
    [self.labelDelete addGestureRecognizer:deleteTap];
    [self.contentView addSubview:self.labelDelete];
    
    self.labelMore = [UILabel new];
    self.labelMore.font = [UIFont systemFontOfSize:14.0f];
    self.labelMore.textColor = RGBCOLOR(0, 191, 143);
    self.labelMore.userInteractionEnabled = YES;
    UITapGestureRecognizer *moreTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMoreTap)];
    [self.labelMore addGestureRecognizer:moreTap];
    [self.contentView addSubview:self.labelMore];
    
    self.labelTime = [UILabel new];
    self.labelTime.font = [UIFont systemFontOfSize:14.0f];
    self.labelTime.textColor = RGBCOLOR(0, 191, 143);
    self.labelTime.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.labelTime];
    
    self.liksBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.liksBtn setImagePosition:QMUIButtonImagePositionLeft];
    [self.liksBtn setImage:[UIImage imageNamed:@"mg_dy_likes"] forState:UIControlStateNormal];
    [self.liksBtn setTitle:@"0" forState:UIControlStateNormal];
    self.liksBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.liksBtn.spacingBetweenImageAndTitle = 3;
    [self.liksBtn addTarget:self action:@selector(onLike) forControlEvents:UIControlEventTouchUpInside];
    
    self.liksBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.liksBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.liksBtn];
    
    self.commentBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.commentBtn setImagePosition:QMUIButtonImagePositionLeft];
    [self.commentBtn setImage:[UIImage imageNamed:@"mg_dy_comment"] forState:UIControlStateNormal];
    [self.commentBtn setTitle:@"0" forState:UIControlStateNormal];
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.commentBtn.spacingBetweenImageAndTitle = 3;
    [self.commentBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self.commentBtn addTarget:self action:@selector(onComment) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.commentBtn];
    
    self.picContainerView = [[YHWorkGroupPhotoContainer alloc] initWithWidth:kScreenW-20];
    [self.contentView addSubview:self.picContainerView];
    
//    self.viewBottom = [HKPBotView new];
//    self.viewBottom.delegate = self;
//    self.viewBottom.hidden = YES;
//    [self.contentView addSubview:self.viewBottom];
    
    self.bottomView = [MGGroupBottomCellView new];
    self.bottomView.delegate = self;
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"4b5255"];
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.layer.cornerRadius = 4;
    self.bottomView.hidden = YES;
    [self.contentView addSubview:self.bottomView];
    
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreBtn setImage:[UIImage imageNamed:@"fw_personCenter_more"] forState:UIControlStateNormal];
    [self.moreBtn addTarget:self action:@selector(showMoreView:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.moreBtn];
    
    self.viewSeparator = [UIView new];
    self.viewSeparator.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.contentView addSubview:self.viewSeparator];
    
    
    
    kHJAudioBubbleConfig.leftBubbleImage = [UIImage imageNamed:@"AudioBubbleBg"];
    kHJAudioBubbleConfig.rightBubbleImage = [UIImage imageNamed:@"AudioBubbleBg"];
    
    self.playAudio = [[HJAudioBubble alloc] init];
    self.playAudio.frame = CGRectMake(0, 0, kBubbleW, kBubbleH);
    __weak __typeof(self)weakSelf = self;
    self.playAudio.bubbleClickBlock = ^(BOOL isAnimating) {
        [weakSelf playWithUrl];
    };
    //    self.playAudio.backgroundColor = [UIColor redColor];
    //    self.playAudio.userInteractionEnabled = YES;
    [self.contentView addSubview:self.playAudio];
    //添加手势
    //    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    //    [self.playAudio addGestureRecognizer:tapGesture];
    self.ClVideoview =[[VideoFrame alloc]init];
    [self.contentView addSubview:self.ClVideoview];
    _ClVideoview.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTouchActionVideo:)];
    [_ClVideoview addGestureRecognizer:tap];
    
//    self.pauseImgView = [UIImageView new];
//    self.pauseImgView.backgroundColor = kRedColor;
//    [_ClVideoview addSubview:self.pauseImgView];
    
    [self layoutUI];
    //    self.labelMore.backgroundColor    = [UIColor yellowColor];
    //    self.labelDelete.backgroundColor  = [UIColor blueColor];
    //    self.labelContent.backgroundColor = [UIColor redColor];
}

-(void)longPress:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {

//         UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//         if (self.labelContent.text) {
//             pasteboard.string = self.labelContent.text;
//             [BGHUDHelper alert:ASLocalizedString(@"动态内容已复制")];
//         }

    }
}

- (void)layoutUI{
    
    __weak typeof(self)weakSelf = self;
    
    [self.imgvAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(15);
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.width.height.mas_equalTo(45);
    }];
    
    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(15);
        make.left.equalTo(weakSelf.imgvAvatar.mas_right).offset(10);
        make.right.equalTo(weakSelf.followBtn.mas_left).offset(-30);
    }];
    
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.labelName.mas_centerY);
        make.left.equalTo(weakSelf.labelName.mas_right).offset(10);
    }];
    
    [self.sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.labelName.mas_left).offset(-3);
//        make.top.mas_equalTo(self.labelName.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.imgvAvatar.mas_right).offset(10);
        make.bottom.mas_equalTo(self.imgvAvatar.mas_bottom).offset(-5);

//        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(20);
    }];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.imgvAvatar.mas_centerY);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(29);
   }];
    [self.labelIndustry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.labelName.mas_bottom);
        make.left.equalTo(weakSelf.labelName.mas_right).offset(10);
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
//        make.right.equalTo(weakSelf.labelPubTime.mas_left).offset(-10);
        make.width.mas_greaterThanOrEqualTo(60);
    }];
    
    [self.labelIndustry setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
    [self.labelIndustry setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.labelPubTime mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.labelName.mas_bottom);
        make.centerY.mas_equalTo(self.moreBtn.mas_centerY).offset(-5);
        make.left.mas_equalTo(self.imgvAvatar.mas_left);
    }];
    
    [self.labelDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.equalTo(weakSelf.labelName.mas_bottom);
        make.centerY.mas_equalTo(self.moreBtn.mas_centerY).offset(-5);
        
        make.left.mas_equalTo(self.labelPubTime.mas_right).offset(5);
    }];
    
    [self.labelDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.centerY.mas_equalTo(self.labelPubTime.mas_centerY);
        make.left.mas_equalTo(self.labelPubTime.mas_right).offset(10);
    }];
    
//    [self.labelPubTime setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
//    [self.labelPubTime setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.labelCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labelName.mas_bottom).offset(9);
        make.left.equalTo(weakSelf.labelName.mas_left);
        make.right.equalTo(weakSelf.labelJob.mas_left).offset(-10);
    }];
    
    [self.labelJob mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.labelCompany.mas_bottom);
        make.left.equalTo(weakSelf.labelCompany.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.width.mas_greaterThanOrEqualTo(80);
    }];
    
    [self.labelJob setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
    [self.labelJob setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
    
    _cstHeightlbContent = [NSLayoutConstraint constraintWithItem:self.labelContent attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self.contentView addConstraint:_cstHeightlbContent];
    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgvAvatar.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.imgvAvatar.mas_left);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.bottom.equalTo(weakSelf.labelMore.mas_top).offset(-11);
    }];
    
    // 不然在6/6plus上就不准确了
    self.labelContent.preferredMaxLayoutWidth = kScreenW - 20;
    
    _cstHeightlbMore = [NSLayoutConstraint constraintWithItem:self.labelMore attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self.contentView addConstraint:_cstHeightlbMore];
    
    [self.labelMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labelContent.mas_bottom).offset(11);
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.width.mas_equalTo(80);
    }];
    
//    _cstHeightlbDelete = [NSLayoutConstraint constraintWithItem:self.labelDelete attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
//    [self.contentView addConstraint:_cstHeightlbDelete];
//    _cstCenterYlbDelete = [NSLayoutConstraint constraintWithItem:self.labelDelete attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.commentBtn attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
//    [self.contentView addConstraint:_cstCenterYlbDelete];
//    _cstLeftlbDelete    = [NSLayoutConstraint constraintWithItem:self.labelDelete attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.commentBtn attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
//    [self.contentView addConstraint:_cstLeftlbDelete];
    
//    [self.labelDelete mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(80);
//        make.centerY.mas_equalTo(self.labelPubTime.mas_centerY);
//        make.left.mas_equalTo(self.labelPubTime.mas_right);
//    }];
    
    _cstHeightPicContainer = [NSLayoutConstraint constraintWithItem:self.picContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self.contentView addConstraint:_cstHeightPicContainer];
    _cstTopPicContainer = [NSLayoutConstraint constraintWithItem:self.picContainerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.labelMore attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
    [self.contentView addConstraint:_cstTopPicContainer];
    [self.picContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.right.mas_greaterThanOrEqualTo(weakSelf.contentView).offset(-10);
    }];
    
//    [self.ClVideoview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.imgvAvatar.mas_left).offset(10);
//        make.top.equalTo(weakSelf.labelContent.mas_bottom).offset(5);
//        make.right.equalTo(weakSelf.contentView).offset(-10);
//        //        make.height.equalTo(weakSelf.ClVideoview.mas_width).multipliedBy(0.75);
//        make.height.equalTo(@0);
//    }];
    [self.playAudio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kBubbleW));
        make.height.equalTo(@(kBubbleH));    make.top.equalTo(self.picContainerView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.imgvAvatar.mas_right).offset(10);
        //        make.left.equalTo(self).offset(10);
    }];
    
    [self.picContainerView setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisVertical];
    [self.picContainerView setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];
    
    _cstTopViewBottom = [NSLayoutConstraint constraintWithItem:self.moreBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.playAudio attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20];
    _cstTopViewBottom.priority = UILayoutPriorityDefaultLow;
    [self.contentView addConstraint:_cstTopViewBottom];
    
//    [self.viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(44);
//    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kRealValue(-15));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
//        make.top.equalTo(_playAudio.mas_bottom).offset(2).priorityHigh();
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.moreBtn.mas_left);
        make.centerY.mas_equalTo(self.moreBtn.mas_centerY);
        make.width.mas_equalTo(50 * 3);
        make.height.mas_equalTo(30);
    }];
    
    [self.labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imgvAvatar.mas_left);
//        (self.labelName.mas_left);
        make.centerY.mas_equalTo(self.moreBtn.mas_centerY).offset(-5);
    }];
    
    [self.liksBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imgvAvatar.mas_left);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(@20);
        make.top.mas_equalTo(self.labelPubTime.mas_bottom).offset(10);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.liksBtn.mas_right).offset(10);
        make.width.mas_equalTo(@98);
        make.height.mas_equalTo(@20);
        make.centerY.mas_equalTo(self.liksBtn.mas_centerY);
    }];

    
    /*******使用HYBMasonryAutoCell*******/
    [self.viewSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.commentBtn.mas_bottom).offset(15);
//        .mas_equalTo(25);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.hyb_lastViewInCell = self.bottomView;
}

- (void)setModel:(MGGroupUserInfo *)model{
    
    _model = model;
    _bottomView.hidden = YES;
//    model.bottomViewSelect;
    
    if (model.no_name.intValue == 1 && ![model.uid isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
        self.imgvAvatar.image = [UIImage imageNamed:@"匿名头像"];
        
    } else {
        [self.imgvAvatar sd_setImageWithURL:[NSURL URLWithString:_model.head_image] placeholderImage:[UIImage imageNamed:@"匿名头像"]];
    }
    
    if ([BGUtils isBlankString:_model.timing]) {
        [self.labelPubTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
            if ([BGUtils isBlankString:self.model.timing]) {
                make.left.mas_equalTo(self.labelPubTime.mas_left).offset(-5);
            }else{
                make.left.mas_equalTo(self.imgvAvatar.mas_left);
            }
        }];
    }
    
    [self.liksBtn setTitleColor:[UIColor colorWithHexString:[_model.is_like isEqualToString:@"1"] ? @"#FF268E" : @"#999999"] forState:UIControlStateNormal];
    
    if (model.cover_url.length > 4 && ![model.cover_url isEqualToString:@""])
    {
        [self.ClVideoview.video_coverImg sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
        self.ClVideoview.hidden = NO;
        [self.ClVideoview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgvAvatar.mas_left);
            make.top.equalTo(self.labelContent.mas_bottom).offset(kRealValue(7));
            make.width.mas_equalTo(kRealValue(135));
            make.height.mas_equalTo(kRealValue(184));
        }];
        
        [self.pauseImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.ClVideoview);
        }];
        
        [self.playAudio mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kBubbleW));
            make.height.equalTo(@(kBubbleH));
            make.top.equalTo(self.ClVideoview.mas_bottom).offset(10);
            make.left.equalTo(self.imgvAvatar.mas_right).offset(10);
        }];
    }else
    {
        self.ClVideoview.hidden =YES;
        [self.ClVideoview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgvAvatar.mas_left).offset(10);
            make.top.equalTo(self.labelContent.mas_bottom).offset(0);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@0);
        }];
        [self.playAudio mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kBubbleW));
            make.height.equalTo(@(kBubbleH));
            make.top.equalTo(self.picContainerView.mas_bottom).offset(10);
            make.left.equalTo(self.imgvAvatar.mas_right).offset(10);
        }];
    }
    
    if (model.no_name.intValue == 1 && ![model.uid isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
        self.labelName.text     = ASLocalizedString(@"匿名用户");
        
        __weak typeof(self)weakSelf = self;
        
        [self.labelName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.imgvAvatar.mas_centerY);
            make.left.equalTo(weakSelf.imgvAvatar.mas_right).offset(10);
        }];
        self.sexBtn.hidden = YES;
    }else{
        
        self.labelName.text     = _model.nick_name;
        __weak typeof(self)weakSelf = self;
        
        [self.labelName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView).offset(15);
            make.left.equalTo(weakSelf.imgvAvatar.mas_right).offset(10);
        }];
        self.sexBtn.hidden = NO;
    }
    
    self.topBtn.hidden = YES;
    
    if (model.no_name.intValue == 1 || [model.uid isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier] || self.homeType == MGDTHOMETYPE_MY) {
        self.followBtn.hidden = YES;
    }else{
        self.followBtn.hidden = _model.is_focus.intValue;
    }
    
//    self.followBtn.hidden = NO;
    

    //    self.labelIndustry.text = _model.;
//    self.labelPubTime.text  = _model.publishTime;
    self.labelCompany.text  = _model.company;
    self.labelPubTime.text = _model.timing;
    
    self.labelDistance.hidden = YES;
    if (model.address.length > 1) {
        self.labelDistance.text = model.address;
    }
    
//    self.labelDistance.text = [NSString stringWithFormat:@"%.2fkm",[_model.juli floatValue]];

//    [self getDateDisplayString:[_model.addtime doubleValue]];
    self.labelJob.text      = _model.job;
    
    /*************动态内容*************/
    maxContentLabelHeight   = kRealValue(300);
//    _labelContent.font.pointSize * 6;
    
    if (_model.theme_id.intValue != 0) {
        NSString * theme = [NSString stringWithFormat:@"#%@#",_model.theme];
        NSString * content = [NSString stringWithFormat:@"%@%@", theme, _model.content];
        NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:content];
        [mutableString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:contentLabelFontSize] range:NSMakeRange(0, mutableString.length)];

        FWWeakify(self)
        [mutableString setTextHighlightRange:NSMakeRange(0, theme.length) color:[UIColor colorWithHexString:@"#2C71DF"] backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
               FWStrongify(self)
            [self topicTap];
        }];
        self.labelContent.attributedText = mutableString;
//        self.labelContent.text  = [NSString stringWithFormat:@"%@%@", _model.theme, _model.content];
    } else {
        NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:_model.content];
        [mutableString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:contentLabelFontSize] range:NSMakeRange(0, mutableString.length)];

        self.labelContent.attributedText = mutableString;
//        self.labelContent.text  = _model.content;
    }
    
    //查看详情按钮
    self.labelMore.text     = ASLocalizedString(@"查看全部");
    CGFloat moreBtnH = 0;
    if (_model.shouldShowMoreButton) { // 如果文字高度超过60
        moreBtnH = moreBtnHeight;
        
        if (_model.isOpening) { // 如果需要展开
            _labelMore.text = ASLocalizedString(@"收起");
            _cstHeightlbContent.constant = HUGE;
        } else {
            _labelMore.text = ASLocalizedString(@"查看全部");
            _cstHeightlbContent.constant = maxContentLabelHeight;
        }
    }else{
            _cstHeightlbContent.constant = maxContentLabelHeight;
    }
    
    //删除按钮
    self.labelDelete.text   = ASLocalizedString(@"删除");
    CGFloat delBtnH = 0;
    
    
    if ([_model.uid isEqualToString:[IMAPlatform sharedInstance].host.userId]) {
        delBtnH = deleteBtnHeight;
        self.labelDelete.hidden = NO;
        self.moreBtn.hidden = NO;
        
        self.labelDistance.hidden = YES;
    }else{
        self.moreBtn.hidden = YES;

        self.labelDistance.hidden = NO;
        self.labelDelete.hidden = YES;
    }
    
    self.moreBtn.hidden = YES;
    
    //更新“查看详情”和“删除按钮”的约束
    _cstHeightlbMore.constant   = moreBtnH;
    _cstHeightlbDelete.constant = delBtnH;
    
    if (moreBtnH) {
        _cstLeftlbDelete.constant    = 10;
        _cstCenterYlbDelete.constant = 0;
    }else{
        _cstLeftlbDelete.constant    = -80;
        _cstCenterYlbDelete.constant = 11;
    }
    
    if ([_model.sex isEqualToString:@"1"]) {
        [self.sexBtn setImage:[UIImage imageNamed:@"dy_sex_male"] forState:UIControlStateNormal];
    }else{
        [self.sexBtn setImage:[UIImage imageNamed:@"dy_sex_female"] forState:UIControlStateNormal];
    }
    
    
    
    CGFloat picTop = 0;
    if (moreBtnH) {
        picTop = 10;
    }else{
        picTop = 0;
    }
    
    _cstTopPicContainer.constant    = picTop;
    
    
    CGFloat picContainerH = [self.picContainerView setupPicUrlArray:_model.picUrls];
    self.picContainerView.picOriArray = _model.picUrls;
    
    _cstHeightPicContainer.constant = picContainerH;
    
    CGFloat viewBottomTop = 0;
    if(_model.picUrls.count){
        viewBottomTop = 15;
    }
    
    
    _cstTopViewBottom.constant = viewBottomTop;
    
//    _bottomView.btnLike.selected = [_model.is_like isEqualToString:@"1"] ? YES: NO;
    
    [self.liksBtn setImage:[UIImage imageNamed:[_model.is_like isEqualToString:@"1"] ? @"mg_dy_likes_select" : @"mg_dy_likes"] forState:UIControlStateNormal];

//    if ([_model.is_like isEqualToString:@"1"]) {
//        [self.liksBtn setTitleColor:kAppNewMainColor forState:UIControlStateNormal];
//    }else{
//        [self.liksBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//    }
    
     //点赞数
    [_bottomView resetBottomViewWithComment:_model.comments likes:_model.praise];
    
    [self.liksBtn setTitle:_model.praise forState:UIControlStateNormal];
    [self.commentBtn setTitle:_model.comments forState:UIControlStateNormal];
    
    if(self.model.audio.length > 0)
    {
        [_playAudio mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(kBubbleH));
        }];
        _playAudio.hidden = NO;
    }
    else
    {
        [_playAudio mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        _playAudio.hidden = YES;
    }
}


-(void)judgeIsAttentionWith{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
  
    [parmDict setObject:@"index" forKey:@"act"];

    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
     
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - Action
- (void)onMoreTap
{
    if (_delegate && [_delegate respondsToSelector:@selector(onMoreInCell:)]) {
        [_delegate onMoreInCell:self];
    }
}

- (void)deleteTap{
    
    [FanweMessage alertController:ASLocalizedString(@"确定删除该动态？")viewController:nil destructiveAction:^{
        if (_delegate && [_delegate respondsToSelector:@selector(onDeleteInCell:)]) {
            [_delegate onDeleteInCell:self];
        }
    } cancelAction:^{
        
    }];

//    [FanweMessage alert:ASLocalizedString(@"提示")message:ASLocalizedString(@"确定删除该动态？")destructiveAction:^{
//        if (_delegate && [_delegate respondsToSelector:@selector(onDeleteInCell:)]) {
//            [_delegate onDeleteInCell:self];
//        }
//    } cancelAction:^{
//
//    }];
}

- (void)topicTap{
    if (_delegate && [_delegate respondsToSelector:@selector(onTopicInCell:)]) {
        [_delegate onTopicInCell:self];
    }
}

- (void)followAction{
    if (_delegate && [_delegate respondsToSelector:@selector(onFollowInCell:)]) {
          [_delegate onFollowInCell:self];
      }
}

#pragma mark - Gesture

- (void)onAvatar:(UITapGestureRecognizer *)recognizer{
    
    if (self.model.no_name.intValue == 1 && ![self.model.uid isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
        
        return;
    }
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if (_delegate && [_delegate respondsToSelector:@selector(onAvatarInCell:)]) {
            [_delegate onAvatarInCell:self];
        }
    }
}

-(void)showMoreView:(UIButton *)sender{
    
//    sender.selected = !sender.selected;
//    self.bottomView.hidden = sender.selected;
//    self.model.bottomViewSelect = sender.selected;
    [self deleteTap];
}

#pragma mark - HKPBotViewDelegate

- (void)onAvatar{
    
}

- (void)onMore{
    
}

- (void)onComment{
    if (_delegate && [_delegate respondsToSelector:@selector(onCommentInCell:)]) {
        [_delegate onCommentInCell:self];
    }
}

- (void)onLike{
    
    if (_delegate && [_delegate respondsToSelector:@selector(onLikeInCell:)]) {
        [_delegate onLikeInCell:self];
    }
}

- (void)onShare{
    if (_delegate && [_delegate respondsToSelector:@selector(onShareInCell:)]) {
        [_delegate onShareInCell:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark- 音乐播放相关
//播放音乐
-(void)playWithUrl
{
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_model.audio]];
    
    //替换当前音乐资源
    [self.player replaceCurrentItemWithPlayerItem:item];
    //开始播放
    
    __weak __typeof(self)weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([weakSelf.player.currentItem duration]);
        if (current == total) {
            [weakSelf.playAudio stopAnimating];
        }
    }];
    
    [self.player play];
    
}

-(AVPlayer *)player
{
    if (_player == nil) {
        //初始化_player
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@""]];
        _player = [[AVPlayer alloc] initWithPlayerItem:item];
    }
    
    return _player;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)onTouchActionVideo:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(onTouchActionVideo:withFullScreen:)])
    {
        [self.delegate onTouchActionVideo:self withFullScreen:YES];
    }
}




//时间显示内容
-(NSString *)getDateDisplayString:(long long) miliSeconds{
    NSLog(ASLocalizedString(@"-时间戳---%lld_----"),miliSeconds);
    
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli;
    //1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init ];
    
    //2. 指定日历对象,要去取日期对象的那些部分.
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:myDate];
    
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd hh:mm";
    } else {
        if (nowCmps.day==myCmps.day) {
            dateFmt.AMSymbol = ASLocalizedString(@"上午");
            dateFmt.PMSymbol = ASLocalizedString(@"下午");
            dateFmt.dateFormat = @"aaa hh:mm";
            
        } else if((nowCmps.day-myCmps.day)==1) {
            dateFmt.dateFormat = ASLocalizedString(@"昨天");
        } else {
            if ((nowCmps.day-myCmps.day) <=7) {
                switch (comp.weekday) {
                    case 1:
                        dateFmt.dateFormat = ASLocalizedString(@"星期日");
                        break;
                    case 2:
                        dateFmt.dateFormat = ASLocalizedString(@"星期一");
                        break;
                    case 3:
                        dateFmt.dateFormat = ASLocalizedString(@"星期二");
                        break;
                    case 4:
                        dateFmt.dateFormat = ASLocalizedString(@"星期三");
                        break;
                    case 5:
                        dateFmt.dateFormat = ASLocalizedString(@"星期四");
                        break;
                    case 6:
                        dateFmt.dateFormat = ASLocalizedString(@"星期五");
                        break;
                    case 7:
                        dateFmt.dateFormat = ASLocalizedString(@"星期六");
                        break;
                    default:
                        break;
                }
            }else {
                dateFmt.dateFormat = @"MM-dd hh:mm";
            }
        }
    }
    return [dateFmt stringFromDate:myDate];
}

@end
