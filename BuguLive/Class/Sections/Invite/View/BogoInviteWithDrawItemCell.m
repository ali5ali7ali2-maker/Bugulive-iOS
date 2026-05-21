//
//  BogoInviteWithDrawItemCell.m
//  UniversalApp
//
//  Created by Mac on 2021/6/10.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoInviteWithDrawItemCell.h"
#import "BogoInviteWithDrawResponseModel.h"

@interface BogoInviteWithDrawItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *onlyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *onlyImageView;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@end

@implementation BogoInviteWithDrawItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoInviteWithDrawResponseModelList *)model{
    _model = model;
    self.onlyLabel.hidden = !model.is_only;
    self.onlyImageView.hidden = !model.is_only;
    self.moneyLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@元"),model.money];
    self.selectImageView.hidden = !model.selected;
    self.moneyLabel.textColor = model.selected ? [UIColor colorWithHexString:@"#F42416"] : [UIColor colorWithHexString:@"333333"];
}

@end
