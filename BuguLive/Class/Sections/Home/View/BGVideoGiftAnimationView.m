//
//  BGVideoGiftAnimationView.m
//  BuguLive
//
//  Created by Mac on 2021/8/13.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGVideoGiftAnimationView.h"
#import "GiftModel.h"

@interface BGVideoGiftAnimationView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation BGVideoGiftAnimationView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(kScreenW, kScreenH / 4, 186, 38);
}

- (void)setGiftModel:(GiftModel *)giftModel{
    _giftModel = giftModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:giftModel.icon]];
    self.nameLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@礼物送出成功"),giftModel.name];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(10, self.top, self.width, self.height);
    } completion:^(BOOL finished) {
        [self performBlock:^(id selfPtr) {
            [UIView animateWithDuration:0.25 animations:^{
                self.frame = CGRectMake(-kScreenW, self.top, self.width, self.height);
            } completion:^(BOOL finished) {
                self.frame = CGRectMake(kScreenW, self.top, self.width, self.height);
                [self performBlock:^(id selfPtr) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(animationView:didFinishAnimation:)]) {
                        [self.delegate animationView:self didFinishAnimation:giftModel];
                    }
                } afterDelay:1];
            }];
        } afterDelay:2];
    }];
}

@end
