//
//  BGReadTextView.m
//  BuguLive
//
//  Created by 志刚杨 on 2021/12/25.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGReadTextView.h"

@implementation BGReadTextView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
+( BGReadTextView *)instanceView{
    return [[[ NSBundle mainBundle ] loadNibNamed : @"BGReadTextView" owner : self options : nil ] lastObject ];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
