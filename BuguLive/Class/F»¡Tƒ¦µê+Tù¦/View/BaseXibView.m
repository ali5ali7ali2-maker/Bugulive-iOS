//
//  BaseXibView.m
//  UniversalApp
//
//  Created by 志刚杨 on 2018/1/26.
//  Copyright © 2018年 voidcat. All rights reserved.
//

#import "BaseXibView.h"

@implementation BaseXibView
+(instancetype)getView{
    NSString *className = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    return [nib instantiateWithOwner:nil options:nil].firstObject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
