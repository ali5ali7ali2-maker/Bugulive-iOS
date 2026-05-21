//
//  RoomMicManageCell.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/7.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomMicManageCell.h"
#import "RoomUserInfo.h"

@interface RoomMicManageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *manageBtn;
@property (weak, nonatomic) IBOutlet UIButton *micBtn;

@end

@implementation RoomMicManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setType:(RoomMicManageCellType)type{
    _type = type;
    if (type == RoomMicManageCellTypeApplyList) {
        self.manageBtn.hidden = YES;
    }
}

- (void)setModel:(RoomUserInfo *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:nil];
    [self.nameLabel setText:model.nick_name];
    if (model.status.integerValue == 1) {
        self.micBtn.hidden = NO;
        if (_type == RoomMicManageCellTypeUserList) {
            [self.manageBtn setTitle:ASLocalizedString(@"抱下麦") forState:UIControlStateNormal];
        }else if (_type == RoomMicManageCellTypeManageView){
            [self.manageBtn setTitle:ASLocalizedString(@"抱下麦") forState:UIControlStateNormal];
        }else{
            [self.manageBtn setTitle:ASLocalizedString(@"在麦上") forState:UIControlStateNormal];
        }
        self.micBtn.selected = model.is_ban_voice.integerValue;
        self.manageBtn.layer.borderColor = RGB(211, 146, 210).CGColor;
        self.manageBtn.layer.borderWidth = 1;
    }else{
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0, 0, 72, 30);
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(1, 1);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:121/255.0 green:195/255.0 blue:251/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:176/255.0 green:149/255.0 blue:254/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:160/255.0 blue:238/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0.0),@(0.6f),@(1.0f)];
        [self.manageBtn.layer insertSublayer:gl atIndex:0];
        self.micBtn.hidden = YES;
        if (_type == RoomMicManageCellTypeUserList) {
            [self.manageBtn setTitle:ASLocalizedString(@"抱上麦") forState:UIControlStateNormal];
        }else if (_type == RoomMicManageCellTypeManageView){
            [self.manageBtn setTitle:ASLocalizedString(@"同意上麦") forState:UIControlStateNormal];
        }else{
            [self.manageBtn setTitle:ASLocalizedString(@"上麦") forState:UIControlStateNormal];
        }
    }
}

- (IBAction)manageBtnAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:ASLocalizedString(@"在麦上")]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(manageCell:didClickManageBtn:)]) {
        [self.delegate manageCell:self didClickManageBtn:sender];
    }
}

- (IBAction)micBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(manageCell:didClickMicBtn:)]) {
        [self.delegate manageCell:self didClickMicBtn:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
