//
//  BogoNoNetworkView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/26.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoNoNetworkView.h"

@implementation BogoNoNetworkView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.resetBtn.layer.cornerRadius = 4;
    self.resetBtn.layer.masksToBounds = YES;
}

- (IBAction)clickRestBtn:(UIButton *)sender {
    
    if (self.clickResetBlock) {
        self.clickResetBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
