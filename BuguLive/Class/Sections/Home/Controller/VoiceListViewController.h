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
@interface VoiceListViewController : BGBaseViewController
@property(nonatomic, strong) NSString *types;
@property (nonatomic, assign) NSInteger classified_id;
@property (nonatomic, assign) CGRect  viewFrame;
- (void)setNetworing:(int)page;
@property (nonatomic, copy) void(^listItemClick)(VoiceListViewController *listVC, NSIndexPath *indexPath);
@property (nonatomic, copy) void(^listScrollViewScrollCallback)(UIScrollView *scrollView);
- (void)reloadData;
- (void)headerReresh;
- (void)footerRereshing;
@end
