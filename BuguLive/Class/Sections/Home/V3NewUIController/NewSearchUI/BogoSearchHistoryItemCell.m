//
//  BogoSearchHistoryItemCell.m
//  BuguLive
//
//  Created by Mac on 2021/9/27.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSearchHistoryItemCell.h"
#import "BogoSearchHistoryModel.h"

@interface BogoSearchHistoryItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BogoSearchHistoryItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoSearchHistoryModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
}

@end
