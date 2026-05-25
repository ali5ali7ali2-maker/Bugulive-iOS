//
//  BogoDelTextfield.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/13.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoDelTextfield.h"

@implementation BogoDelTextfield

-(void)deleteBackward {

    [super deleteBackward];
    if ([self.z_delegate respondsToSelector:@selector(zTextFieldDeleteBackward:)]) {

      [self.z_delegate zTextFieldDeleteBackward:self];
    }
}

@end
