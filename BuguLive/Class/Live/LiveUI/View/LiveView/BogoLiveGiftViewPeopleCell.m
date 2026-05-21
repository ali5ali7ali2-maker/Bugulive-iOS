//
//  BogoLiveGiftViewPeopleCell.m
//  UniversalApp
//
//  Created by bogokj on 2020/1/14.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BogoLiveGiftViewPeopleCell.h"
#import "RoomUserInfo.h"
#import "RoomUsers.h"

@interface BogoLiveGiftViewPeopleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *masterImageView;

@end

@implementation BogoLiveGiftViewPeopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUser:(RoomUserInfo *)user{
    _user = user;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:user.head_image] placeholderImage:kDefaultPreloadHeadImg];
    self.iconImageView.layer.borderWidth = 1;
    if ([_dataArray indexOfObject:user] == 0) {
        self.numberLabel.hidden = YES;
        self.masterImageView.hidden = NO;
    }else{
        self.numberLabel.hidden = NO;
        self.masterImageView.hidden = YES;
        [self.numberLabel setText:[NSString stringWithFormat:@"%ld",[_dataArray indexOfObject:user]]];
    }
    if (user.selected) {
        self.iconImageView.layer.borderColor = [UIColor colorWithHexString:@"#C28CF8"].CGColor;
        self.numberLabel.backgroundColor = [UIColor colorWithHexString:@"26E8C6"];
        self.iconImageView.layer.borderWidth = 2;
        [self.masterImageView setImage:[UIImage imageNamed:@"master"]];
    }else{
        self.iconImageView.layer.borderColor = kClearColor.CGColor;
        self.iconImageView.layer.borderWidth = 0;

        self.numberLabel.backgroundColor = [kBlackColor colorWithAlphaComponent:0.2];
        [self.masterImageView setImage:[UIImage imageNamed:@"master_noraml"]];
    }
    
    self.numberLabel.hidden = YES;

}

@end
