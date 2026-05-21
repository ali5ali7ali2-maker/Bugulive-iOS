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
@interface TLVoiceListViewController : BGBaseViewController
@property(nonatomic, strong) NSString *types;
@property (nonatomic, assign) NSInteger classified_id;
@property (nonatomic, assign) CGRect  viewFrame;
- (void)setNetworing:(int)page;
@property (nonatomic, copy) void(^listItemClick)(TLVoiceListViewController *listVC, NSIndexPath *indexPath);
@property (nonatomic, copy) void(^listScrollViewScrollCallback)(UIScrollView *scrollView);
- (void)reloadData;
- (void)headerReresh;
- (void)footerRereshing;
@property(nonatomic, weak) id<BogoHomeTopViewDelegate> topViewdelegate;

@end
