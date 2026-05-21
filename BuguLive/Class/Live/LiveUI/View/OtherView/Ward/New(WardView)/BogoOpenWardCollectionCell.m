//
//  BogoOpenWardCollectionCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/10/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoOpenWardCollectionCell.h"

@implementation BogoOpenWardCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.btn.layer.cornerRadius = 4;
    self.btn.layer.masksToBounds = YES;
}



@end
