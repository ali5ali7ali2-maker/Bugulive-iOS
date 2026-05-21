//
//  BogoShopFillInfoCardCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import "BogoShopFillInfoCardCell.h"

@interface BogoShopFillInfoCardCell ()


@end

@implementation BogoShopFillInfoCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *handTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handImageBtnAction:)];
    [self.handImageView addGestureRecognizer:handTap];
    UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoImageBtnAction:)];
    [self.logoImageView addGestureRecognizer:logoTap];
    
//    UITapGestureRecognizer *addFrontTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(frontImageBtnAction:)];
//    [self.addHeadImageView addGestureRecognizer:addFrontTap];
//    UITapGestureRecognizer *addBackTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backImageBtnAction:)];
//    [self.addBackImageView addGestureRecognizer:addBackTap];
//    UITapGestureRecognizer *addHandTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handImageBtnAction:)];
//    [self.addHandImageView addGestureRecognizer:addHandTap];
    
    
    self.handImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.handImageView.clipsToBounds = YES;
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImageView.clipsToBounds = YES;
    
}

- (void)setIsSee:(BOOL)isSee{
    _isSee = isSee;
    self.handImageView.userInteractionEnabled = !isSee;
    self.logoImageView.userInteractionEnabled = !isSee;
}


- (void)handImageBtnAction:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(cardCell:didClickHandImageBtn:)]) {
        [self.delegate cardCell:self didClickHandImageBtn:sender];
    }
}

- (void)logoImageBtnAction:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(cardCell:didClickLogoImageBtn:)]) {
        [self.delegate cardCell:self didClickLogoImageBtn:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
