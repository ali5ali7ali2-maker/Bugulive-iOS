//
//  BogoCommodityModelAddCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/16.
//

#import "BogoCommodityModelAddCell.h"
#import <YYKit/YYKit.h>

@interface BogoCommodityModelAddCell ()

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation BogoCommodityModelAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addBtn.layer.borderColor = [UIColor colorWithHexString:@"#C0C0C0"].CGColor;
    self.addBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
