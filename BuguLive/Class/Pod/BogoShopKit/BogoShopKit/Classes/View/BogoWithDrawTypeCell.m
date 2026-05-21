//
//  BogoWithDrawTypeCell.m
//  UniversalApp
//
//  Created by Mac on 2021/6/12.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoWithDrawTypeCell.h"

@interface BogoWithDrawTypeCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;


@end

@implementation BogoWithDrawTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectBtn.selected = selected;
}

@end
