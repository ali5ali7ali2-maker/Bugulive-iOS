//
//  BogoInviteListCell.m
//  UniversalApp
//
//  Created by Mac on 2021/6/10.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoInviteListCell.h"
#import "BogoInviteResponseModel.h"

@interface BogoInviteListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation BogoInviteListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoInviteResponseModelLists *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image]];
    [self.nameLabel setText:model.nick_name];
    self.moneyLabel.text = [NSString stringWithFormat:@"+%@",model.coin];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.addtime.doubleValue]];
    [self.timeLabel setText:time];
    self.contentLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
