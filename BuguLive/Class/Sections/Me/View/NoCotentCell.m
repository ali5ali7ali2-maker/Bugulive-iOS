//
//  NoCotentCell.m
//  BuguLive
//
//  Created by 杨仁伟 on 2017/9/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "NoCotentCell.h"

@implementation NoCotentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    for (UIView *subView in self.subviews) {
        [subView setLocalizedString];
    }
    
    // Initialization code
}

@end
