//
//  BogoRechargeTopView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoRechargeTopView.h"

@implementation BogoRechargeTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setUpView{
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.diamondBtn.spacingBetweenImageAndTitle = 5;
    [self.diamondBtn setTitle:[GlobalVariables sharedInstance].appModel.diamond_name forState:UIControlStateNormal];
}




@end
