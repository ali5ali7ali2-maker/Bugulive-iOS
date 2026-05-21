//
//  BogoShopExplainView.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/5.
//

#import "BogoShopExplainView.h"

@interface BogoShopExplainView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;


@end

@implementation BogoShopExplainView


- (void)setModel:(BogoCommodityDetailShopModel *)model{
    _model= model;
    self.nameLabel.text = model.title;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] completed:nil];
    if (model.price) {
        
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price.floatValue / 100];
    }
    
    if (model.isHost) {
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.buyBtn.hidden = YES;
    }else{
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        self.buyBtn.hidden = NO;
    }
    
    
}

- (IBAction)buyBtnAction:(UIButton *)sender {
    if (self.clickBuyBlock) {
        self.clickBuyBlock(self.model);
    }
}

- (IBAction)closeBtnAction:(UIButton *)sender {
    [self hide];
//    [self removeFromSuperview];
}

- (void)show:(UIView *)superView offsetY:(CGFloat)offsetY{
//    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        CGFloat offsetY = offsetY;
        strongSelf.frame = CGRectMake(strongSelf.fd_left, offsetY, strongSelf.fd_width, strongSelf.fd_height);
    }];
}

- (void)hide{
    __weak __typeof(self)weakSelf = self;
    CGFloat offsetY = self.superview.fd_height;
    
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.frame = CGRectMake(strongSelf.fd_left, offsetY, strongSelf.fd_width, strongSelf.fd_height);
    } completion:^(BOOL finished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.shadowView removeFromSuperview];
        [strongSelf removeFromSuperview];
    }];
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight)];
        _shadowView.backgroundColor = [UIColor clearColor];
        _shadowView.userInteractionEnabled = YES;

    }
    return _shadowView;
}

@end
