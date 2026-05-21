//
//  PerfectInfoPopView.m
//  BuguLive
//
//  Created by Mac on 2021/9/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "PerfectInfoPopView.h"

@interface PerfectInfoPopView ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation PerfectInfoPopView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, kScreenH, kScreenW, 157 + FD_Bottom_SafeArea_Height);
    self.contentLabel.text = [NSString stringWithFormat:ASLocalizedString(@"已为您自动匹配昵称“%@”和默认头像是否修改？"),[GlobalVariables sharedInstance].userModel.nick_name];
}

- (IBAction)closeBtnAction:(UIButton *)sender {
    [self hide];
}

- (IBAction)editBtnAction:(UIButton *)sender {
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoPopView:didClickEditBtn:)]) {
        [self.delegate infoPopView:self didClickEditBtn:sender];
    }
}

@end
