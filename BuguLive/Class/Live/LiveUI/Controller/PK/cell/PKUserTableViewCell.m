//
//  PKUserTableViewCell.m
//  FanweApp
//
//  Created by 志刚杨 on 2018/7/18.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "PKUserTableViewCell.h"

@interface PKUserTableViewCell()

@property (nonatomic, copy) clickPkBlock clickPkBlock;

@end

@implementation PKUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.pkBtn setTitle:ASLocalizedString(@"发起PK") forState:UIControlStateNormal];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.nickname.layer.cornerRadius = 15;
    self.nickname.layer.masksToBounds = YES;
}
- (IBAction)pkBtnAction:(id)sender {
    if (self.clickPkBlock) {
        self.clickPkBlock(_user);
    }
}

- (void)setUser:(UserModel *)user{
    _user = user;
    [self.nickname sd_setImageWithURL:[NSURL URLWithString:user.head_image] placeholderImage:kDefaultPreloadHeadImg];
    self.username.text = user.nick_name;
    
    
    
    self.sexImgView.image = [user.sex isEqualToString:@"1"] ? [UIImage imageNamed:@"com_male_selected"] : [UIImage imageNamed:@"com_female_selected"];
    
    [_rankImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%@",user.user_level]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setClickPkBlock:(clickPkBlock)clickPkBlock{
    _clickPkBlock = clickPkBlock;
}

@end
