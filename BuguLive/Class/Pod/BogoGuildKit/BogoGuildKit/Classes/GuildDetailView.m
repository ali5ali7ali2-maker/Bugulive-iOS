//
//  GuildDetailView.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import "GuildDetailView.h"
#import "FDUIKitObjC.h"
#import <QMUIKit/QMUIKit.h>
#import "GuildDetailModel.h"
#import <UIImageView+WebCache.h>
#import "BogoNetworkKit.h"

@interface GuildDetailView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *memberLabel;

@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
//显示待处理申请时73，不显示时10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *applyView;
@property (weak, nonatomic) IBOutlet UILabel *applyNumLabel;

@property (weak, nonatomic) IBOutlet UIView *memberView;
@property (weak, nonatomic) IBOutlet UIView *rankView;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property(nonatomic, strong) QMUIPopupMenuView *popView;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdViewConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *presidentLabel;

@property (weak, nonatomic) IBOutlet UILabel *preMemberLabel;
@property (weak, nonatomic) IBOutlet UILabel *contributeRankLabel;

@property (weak, nonatomic) IBOutlet UILabel *applyLabel;

@end

@implementation GuildDetailView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight);
    [self.memberView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(memberViewAction)]];
    [self.rankView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rankViewViewAction)]];
    [self.applyView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applyViewViewAction)]];
    [self.joinBtn setTitle:@"加入审核中" forState:UIControlStateDisabled];
    [self.joinBtn setTitleColor:FD_WhiteColor forState:UIControlStateDisabled];
    self.presidentLabel.text = ASLocalizedString(@"会长");
    self.preMemberLabel.text = ASLocalizedString(@"公会成员");
    self.applyLabel.text = ASLocalizedString(@"待处理申请");
    self.contributeRankLabel.text = ASLocalizedString(@"公会贡献榜");
    self.tipLabel.text = ASLocalizedString(@"您的创建公会申请，正在审核中...");
    [self.joinBtn setTitle:ASLocalizedString(@"加入公会") forState:UIControlStateNormal];
}

- (void)setModel:(GuildDetailModel *)model{
    _model = model;
    if (!_model) {
        self.topHeightConstraint.constant = 0;
        return;
    }
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.family_info.head_image]];
    self.creatorNameLabel.text = [NSString stringWithFormat:@"%@：%@",ASLocalizedString(@"公会族长"),model.family_info.nick_name];
    self.contentLabel.text = model.family_info.family_manifesto;
    
    
    CGFloat contentWidth = FD_ScreenWidth - 10 * 4 - 44 - 10;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.contentLabel.text length])];
    
    CGSize tmpSize = [attr  boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
    
    self.topHeightConstraint.constant = tmpSize.height + 55.5 + 15;
    
    
    self.nameLabel.text = model.family_info.family_name;
    self.memberLabel.text = [NSString stringWithFormat:@"%@%@",model.family_info.user_count,ASLocalizedString(@"人")];
    if ([[BogoNetwork shareInstance].uid isEqualToString:model.family_info.user_id]) {
        self.joinBtn.hidden = YES;
        self.rankTopConstraint.constant = 73;
        self.applyView.hidden = NO;
        if (model.apply.integerValue) {
            self.applyNumLabel.text = model.apply;
            self.applyNumLabel.hidden = NO;
        }else{
            self.applyNumLabel.hidden = YES;
        }
        self.moreBtn.hidden = model.family_info.status.integerValue == 0;
        if (model.family_info.status.integerValue == 0) {
            self.tipLabel.hidden = NO;
            self.topConstraint.constant = 41;
        }else{
            self.topConstraint.constant = 15;
            self.tipLabel.hidden = YES;
        }
        self.popView.items = @[[QMUIPopupMenuButtonItem itemWithImage:nil title:ASLocalizedString(@"编辑资料") handler:^(QMUIPopupMenuButtonItem *aItem) {
            [aItem.menuView hideWithAnimated:YES completion:^(BOOL finished) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:didClickEditBtnAction:)]) {
                    [self.delegate detailView:self didClickEditBtnAction:nil];
                }
            }];
        }],
                                     [QMUIPopupMenuButtonItem itemWithImage:nil title:ASLocalizedString(@"解散公会") handler:^(QMUIPopupMenuButtonItem *aItem) {
                                         [aItem.menuView hideWithAnimated:YES completion:^(BOOL finished) {
                                             FDAlertView *alert = [[FDAlertView alloc]initWithTitle:@"" message:ASLocalizedString(@"确定要解散该公会吗？解散后所有的积分值都会清空")];
                                             [alert addAction:[FDAction actionWithTitle:ASLocalizedString( @"取消") type:FDActionTypeCancel CallBack:nil]];
                                             [alert addAction:[FDAction actionWithTitle:ASLocalizedString(@"确定") type:FDActionTypeDefault CallBack:^{
                                                 if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:didClickDeleteBtnAction:)]) {
                                                     [self.delegate detailView:self didClickDeleteBtnAction:nil];
                                                 }
                                             }]];
                                             [alert show:[UIApplication sharedApplication].keyWindow];
                                         }];
                                     }]
                           ];
    }else{
        self.rankTopConstraint.constant = 10;
        if (model.join_status.integerValue != 1) {
            self.joinBtn.hidden = model.user_family_id.integerValue;
            if (model.join_status.integerValue == 0) {
                self.joinBtn.enabled = NO;
            }
        }else{
            self.moreBtn.hidden = NO;
//            self.popView.items = @[[QMUIPopupMenuButtonItem itemWithImage:nil title:ASLocalizedString(@"退出公会") handler:^(QMUIPopupMenuButtonItem *aItem) {
//                [aItem.menuView hideWithAnimated:YES completion:^(BOOL finished) {
//                    FDAlertView *alert = [[FDAlertView alloc]initWithTitle:@"" message:ASLocalizedString(@"确定要退出该公会吗？退出后所有的积分值都会清空")];
//                    [alert addAction:[FDAction actionWithTitle:ASLocalizedString(@"取消") type:FDActionTypeCancel CallBack:nil]];
//                    [alert addAction:[FDAction actionWithTitle:ASLocalizedString(@"确定") type:FDActionTypeDefault CallBack:^{
//                        if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:didClickQuitBtnAction:)]) {
//                            [self.delegate detailView:self didClickQuitBtnAction:nil];
//                        }
//                    }]];
//                    [alert show:[UIApplication sharedApplication].keyWindow];
//                }];
//            }]];
        }
    }
    if (model.lists.count > 0) {
        self.firstView.hidden = NO;
        [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:model.lists.firstObject.head_image]];
        if (model.lists.count > 1) {
            self.secondView.hidden = NO;
            [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:model.lists[1].head_image]];
            if (model.lists.count > 2) {
                self.thirdView.hidden = NO;
                [self.thirdImageView sd_setImageWithURL:[NSURL URLWithString:model.lists[2].head_image]];
            }
        }
        if (model.lists.count == 1) {
            self.firstViewConstraint.constant = 10;
        }else if (model.lists.count == 2){
            self.firstViewConstraint.constant = 45;
            self.secondViewConstraint.constant = 10;
        }else if (model.lists.count >= 3){
            self.firstViewConstraint.constant = 80;
            self.secondViewConstraint.constant = 45;
            self.thirdViewConstraint.constant = 10;
        }
    }else{
        self.firstView.hidden = YES;
        self.secondView.hidden = YES;
        self.thirdView.hidden = YES;
    }
}

- (IBAction)joinBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:didClickJoinBtnAction:)]) {
        [self.delegate detailView:self didClickJoinBtnAction:sender];
    }
}

- (IBAction)moreBtnAction:(UIButton *)sender {
    
    [self.popView showWithAnimated:YES];
    if(self.popView.items.count == 0)
    {
        [self.popView hideWithAnimated:NO];
    }
}

- (void)memberViewAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:didClickMemberViewAction:)]) {
        [self.delegate detailView:self didClickMemberViewAction:self.memberView];
    }
}

- (void)rankViewViewAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:didClickRankViewAction:)]) {
        [self.delegate detailView:self didClickRankViewAction:self.rankView];
    }
}

- (void)applyViewViewAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:didClickApplyViewAction:)]) {
        [self.delegate detailView:self didClickApplyViewAction:self.applyView];
    }
}

- (QMUIPopupMenuView *)popView{
    if (!_popView) {
        _popView = [[QMUIPopupMenuView alloc] init];
        _popView.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
        _popView.shouldShowItemSeparator = YES;
        _popView.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
            // 利用 itemConfigurationHandler 批量设置所有 item 的样式
            [aItem.button setTitleColor:[UIColor qmui_colorWithHexString:@"333333"] forState:UIControlStateNormal];
            aItem.button.titleLabel.font = [UIFont systemFontOfSize:14];
        };
        _popView.didHideBlock = ^(BOOL hidesByUserTap) {
            
        };
        _popView.sourceView = self.moreBtn;// 相对于 button4 布局
    }
    return _popView;
}

@end
