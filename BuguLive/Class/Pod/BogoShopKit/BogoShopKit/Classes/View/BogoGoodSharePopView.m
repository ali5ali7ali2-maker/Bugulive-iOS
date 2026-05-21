//
//  BogoGoodSharePopView.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/29.
//

#import "BogoGoodSharePopView.h"
#import <QMUIKit/QMUIKit.h>
#import "FDUIKitObjC.h"
#import "BogoCommodityDetailModel.h"
#import "BogoShopKit.h"
#import <YYKit/YYKit.h>

@interface BogoGoodSharePopView ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *normalLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *contentLabel;

@property (unsafe_unretained, nonatomic) IBOutlet QMUIButton *weChatBtn;
@property (unsafe_unretained, nonatomic) IBOutlet QMUIButton *timeLineBtn;
@property (unsafe_unretained, nonatomic) IBOutlet QMUIButton *qqBtn;
@property (unsafe_unretained, nonatomic) IBOutlet QMUIButton *qzoneBtn;
@end

@implementation BogoGoodSharePopView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, FD_ScreenHeight, FD_ScreenWidth, 186 + FD_Bottom_SafeArea_Height);
    self.weChatBtn.imagePosition = QMUIButtonImagePositionTop;
    self.weChatBtn.spacingBetweenImageAndTitle = 5;
    self.timeLineBtn.imagePosition = QMUIButtonImagePositionTop;
    self.timeLineBtn.spacingBetweenImageAndTitle = 5;
    self.qqBtn.imagePosition = QMUIButtonImagePositionTop;
    self.qqBtn.spacingBetweenImageAndTitle = 5;
    self.qzoneBtn.imagePosition = QMUIButtonImagePositionTop;
    self.qzoneBtn.spacingBetweenImageAndTitle = 5;
}

- (IBAction)cancelBtnAction:(id)sender {
    [self hide];
}

- (void)setType:(BogoGoodSharePopViewType)type{
    _type = type;
    self.normalLabel.hidden = (type == BogoGoodSharePopViewTypeMarketing);
    self.titleLabel.hidden = (type == BogoGoodSharePopViewTypeNormal);
    self.contentLabel.hidden = (type == BogoGoodSharePopViewTypeNormal);
    if (@available(iOS 11.0, *)) {
        self.frame = CGRectMake(0, FD_ScreenHeight, FD_ScreenWidth, type == BogoGoodSharePopViewTypeMarketing ? 220 + FD_Bottom_SafeArea_Height : 180 + FD_Bottom_SafeArea_Height);
    } else {
        // Fallback on earlier versions
        self.frame = CGRectMake(0, FD_ScreenHeight, FD_ScreenWidth, type == BogoGoodSharePopViewTypeMarketing ? 220 : 180);
    }
}

- (void)setDetailModel:(BogoCommodityDetailModel *)detailModel{
    _detailModel = detailModel;
//    http://video.bogokj.com/api/page/share_goods
//    [[BogoNetwork shareInstance] POST:@"page/share_goods" param:@{@"token":[BogoNetwork shareInstance].token,@"gid":detailModel.gid} success:^(BogoNetworkResponseModel * _Nonnull result) {
////        "is_commission": 1,
////        "commission_coin": 25800
//        NSString *is_commission = [NSString stringWithFormat:@"%@",result.data[@"is_commission"]];
//        self.type = is_commission.integerValue == 1 ? BogoGoodSharePopViewTypeMarketing : BogoGoodSharePopViewTypeNormal;
//        NSString *commission_coin = [NSString stringWithFormat:@"%@",result.data[@"commission_coin"]];
////        [self.titleLabel setText:detailModel.price.floatValue * detailModel.commission.floatValue/10000];
//        [self.titleLabel setText:[NSString stringWithFormat:@"赚￥%.2f",detailModel.price.floatValue * detailModel.commission.floatValue/10000]];
////         [NSString stringWithFormat:@"赚%.2f",commission_coin.floatValue/100]];
//        NSString *content = [NSString stringWithFormat:@"只要你的好友通过你的链接购买此商品，你就能赚到至少%.2f元利润哦~",detailModel.price.floatValue * detailModel.commission.floatValue/10000];
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:content];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"F46628"] range:NSMakeRange(@"只要你的好友通过你的链接购买此商品，你就能赚到至少".length, [NSString stringWithFormat:@"%.2f",commission_coin.floatValue/100].length)];
//        [self.contentLabel setAttributedText:attr];
//        [self show:[UIApplication sharedApplication].keyWindow type:FDPopTypeBottom];
//    } failure:^(NSString * _Nonnull error) {
//
//    }];
}

- (IBAction)btnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popView:didClickBtn:)]) {
        [self.delegate popView:self didClickBtn:sender];
    }
}

@end
