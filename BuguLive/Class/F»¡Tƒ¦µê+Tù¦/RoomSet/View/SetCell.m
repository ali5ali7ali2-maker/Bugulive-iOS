//
//  SetCell.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/5.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "SetCell.h"

@interface SetCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;

@end

@implementation SetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    // Initialization code
}

- (void)setType:(SetCellType)type{
    _type = type;
    if (_type == SetCellTypeRoom) {
        self.backgroundColor = [UIColor colorWithHexString:@"1B1823"];
        self.leftTitleLabel.textColor = kWhiteColor;
        self.rightTitleLabel.textColor = [UIColor colorWithHexString:@"#A79FAE"];
    }
}
- (void)setLeftFont:(NSInteger)leftFont{
    _leftFont = leftFont;
    self.leftTitleLabel.font = [UIFont systemFontOfSize:leftFont];
}

- (void)setRightFont:(NSInteger)rightFont{
    _rightFont = rightFont;
    self.rightTitleLabel.font = [UIFont systemFontOfSize:rightFont];

    
}

- (void)setLeftMediumFont:(NSInteger)leftMediumFont{
    _leftMediumFont = leftMediumFont;
    self.leftTitleLabel.font = [UIFont systemFontOfSize:leftMediumFont weight:UIFontWeightMedium];

}

- (void)setLeftTitle:(NSString *)leftTitle{
    _leftTitle = leftTitle;
    [self.leftTitleLabel setText:leftTitle];
    if ([leftTitle isEqualToString:ASLocalizedString(@"退出登录")]) {
        [self.leftTitleLabel setTextColor:[UIColor colorWithHexString:@"#918DFE"]];
    }
    self.nextBtn.hidden = [leftTitle isEqualToString:ASLocalizedString(@"账号")];
}

- (void)setRightTitle:(NSString *)rightTitle{
    _rightTitle = rightTitle;
    if (rightTitle.length) {
        self.rightTitleLabel.hidden = NO;
        [self.rightTitleLabel setText:rightTitle];
    }
    if ([_leftTitle isEqualToString:ASLocalizedString(@"语音介绍")]) {
//        if (curUser.audio_file.length) {
//            self.audioBtn.hidden = NO;
//            [self.audioBtn setTitle:[NSString stringWithFormat:@"          %@ ”",curUser.audio_time] forState:UIControlStateNormal];
//        }else{
//            self.audioBtn.hidden = YES;
//        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
