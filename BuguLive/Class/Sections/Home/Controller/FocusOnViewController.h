//
//  FocusOnViewController.h
//  BuguLive
//
//  Created by GuoMs on 16/7/4.
//  Copyright © 2016年 xfg. All rights reserved.
//

@protocol handleMainDelegate <NSObject>

// 跳转到直播界面
- (void)pushToLiveController:(LivingModel *)model modelArr:(NSArray *)modelArr isFirstJump:(BOOL)isFirstJump;
// 跳转主页
- (void)goToMainPage:(NSString *)userID;

- (void)goToNewestView;

@end

@interface FocusOnViewController : BGBaseViewController

@property (nonatomic, weak) id<handleMainDelegate>delegate;

@property (nonatomic, assign) CGRect collectionViewFrame;

- (void)requestNetWorking;

@end
