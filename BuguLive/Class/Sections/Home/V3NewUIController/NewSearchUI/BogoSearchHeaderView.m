//
//  BogoSearchHeaderView.m
//  BuguLive
//
//  Created by Mac on 2021/9/27.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSearchHeaderView.h"

@interface BogoSearchHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation BogoSearchHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.allBtn.imagePosition = QMUIButtonImagePositionRight;
    self.allBtn.spacingBetweenImageAndTitle = 5;
    self.allBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.allBtn setTitle:ASLocalizedString(@"查看全部") forState:UIControlStateNormal];
}

- (void)setType:(BogoSearchHeaderViewType)type{
    _type= type;
    switch (type) {
        case BogoSearchHeaderViewTypeUser:
            self.typeLabel.text = ASLocalizedString(@"相关用户");
            break;
        case BogoSearchHeaderViewTypeVideo:
            self.typeLabel.text = ASLocalizedString(@"相关短视频");
            break;
        case BogoSearchHeaderViewTypeDynamic:
            self.typeLabel.text = ASLocalizedString(@"相关动态");
            break;
        default:
            break;
    }
}

- (IBAction)allBtnAction:(QMUIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didClickAllBtn:)]) {
        [self.delegate headerView:self didClickAllBtn:sender];
    }
}

@end
