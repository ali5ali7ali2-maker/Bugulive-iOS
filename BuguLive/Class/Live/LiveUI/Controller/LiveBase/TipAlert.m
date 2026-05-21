//
//  TipAlert.m
//  BuguLive
//
//  Created by 志刚杨 on 2022/5/30.
//  Copyright © 2022 xfg. All rights reserved.
//

#import "TipAlert.h"

@implementation TipAlert

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = kClearColor;
    [self.btnAgree setBackgroundColor:kWhiteColor];
    [self.btnAgree setTitleColor:kBlackColor forState:UIControlStateNormal];
    
    [self.btnCancel setBackgroundColor:kWhiteColor];
    [self.btnCancel setTitleColor:kBlackColor forState:UIControlStateNormal];
    
    [self.btnAgree addTarget:self action:@selector(handleClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCancel addTarget:self action:@selector(handleClickEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleClickEvent:(UIButton *)sender {
    if (sender == self.btnAgree)
    {
        if (self.agree)
        {
            self.agree();
        }
    }
    else
    {
        if (self.cancel)
        {
            self.cancel();
        }
    }
}

@end