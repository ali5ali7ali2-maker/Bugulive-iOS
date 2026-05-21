//
//  BogoVirsualDetailListCell.m
//  BuguLive
//
//  Created by Mac on 2021/1/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoInviteWithDrawLogCell.h"
#import "BogoVirtualListModel.h"
#import "WBStatusHelper.h"

@interface BogoInviteWithDrawLogCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@end

@implementation BogoInviteWithDrawLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoVirtualListModel *)model{
    _model = model;
    self.titleLabel.text = model.content;
    self.timeLabel.text = [WBStatusHelper stringWithTimelineDate:[NSDate dateWithTimeIntervalSince1970:model.addtime.integerValue]];
    NSString *prefix = @"-";
    NSString *colorHex = @"#F42416";
    self.contentLabel.textColor = [UIColor colorWithHexString:colorHex];
    self.contentLabel.text = [NSString stringWithFormat:@"%@%@",prefix,model.money];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
