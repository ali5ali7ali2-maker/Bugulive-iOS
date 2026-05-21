//
//  BogoGoodDetailNavView.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "BogoGoodDetailNavView.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"

@interface BogoGoodDetailNavView ()

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *backBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *shareBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@end

@implementation BogoGoodDetailNavView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, FD_ScreenWidth, 44 + [UIApplication sharedApplication].statusBarFrame.size.height);
}

- (void)setBackAlpha:(CGFloat)backAlpha{
    _backAlpha = backAlpha;
    self.backView.alpha = backAlpha;
    NSLog(@"backAlpha:%f",backAlpha);
    if (backAlpha > 0.5) {
        [self.backBtn setImage:[UIImage imageNamed:@"返回-sel" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:@"分享-sel" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        self.lineView.fd_centerX = self.detailBtn.fd_centerX;
    }else{
        [self.backBtn setImage:[UIImage imageNamed:@"返回-nor" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:@"分享-nor" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        self.lineView.fd_centerX = self.goodBtn.fd_centerX;
    }
}

- (IBAction)backBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navView:didClickBackBtn:)]) {
        [self.delegate navView:self didClickBackBtn:sender];
    }
}

- (IBAction)shareBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navView:didClickShareBtn:)]) {
        [self.delegate navView:self didClickShareBtn:sender];
    }
}

- (IBAction)goodBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navView:didClickGoodBtn:)]) {
        [self.delegate navView:self didClickGoodBtn:sender];
    }
}

- (IBAction)detailBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navView:didClickDetailBtn:)]) {
        [self.delegate navView:self didClickDetailBtn:sender];
    }
}

@end
