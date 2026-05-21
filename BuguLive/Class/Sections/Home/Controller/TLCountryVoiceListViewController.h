//
//  VideoViewController.h
//  BuguLive
//
//  Created by 王珂 on 17/5/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GKPageScrollView/GKPageScrollView.h>
#import <GKPageSmoothView/GKPageSmoothView.h>
#import "BogoHomeViewController.h"
@class TLCountryVoiceListViewController;
@interface TLCountryVoiceListViewController : BGBaseViewController
@property(nonatomic, strong) NSString *types;
@property (nonatomic, assign) NSInteger classified_id;
@property (nonatomic, assign) CGRect  viewFrame;
- (void)setNetworing:(int)page;
@property (nonatomic, copy) void(^listItemClick)(TLCountryVoiceListViewController *listVC, NSIndexPath *indexPath);
- (void)reloadData;
- (void)headerReresh;
- (void)footerRereshing;
@property(nonatomic, weak) id<BogoHomeTopViewDelegate> topViewdelegate;
@property(nonatomic, strong) NSDictionary *country;

@end
