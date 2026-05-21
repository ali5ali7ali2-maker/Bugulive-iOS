//
//  BogoPKAudienceCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/22.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoPKAudienceCell.h"

@implementation BogoPKAudienceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imgView.layer.cornerRadius = 26 / 2;
    self.imgView.layer.masksToBounds = YES;
    
}

@end
