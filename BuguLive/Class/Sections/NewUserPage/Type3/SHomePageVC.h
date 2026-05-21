//
//  Type3ViewControllerFirst.h
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/5.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHomePageVC : UIViewController

@property(nonatomic, copy) NSString *user_id;

@property (nonatomic, assign) int          type;             //类型 0主页1直播

@property(nonatomic, copy) void (^clickHomePageBlock)(BOOL isFocus);

@end

NS_ASSUME_NONNULL_END
