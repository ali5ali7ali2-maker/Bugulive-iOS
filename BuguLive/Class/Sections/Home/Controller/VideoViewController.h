//
//  VideoViewController.h
//  BuguLive
//
//  Created by 王珂 on 17/5/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : BGBaseViewController
@property(nonatomic, strong) NSString *types;
@property (nonatomic, assign) NSInteger classified_id;
@property (nonatomic, assign) CGRect  viewFrame;
- (void)setNetworing:(int)page;

@end
