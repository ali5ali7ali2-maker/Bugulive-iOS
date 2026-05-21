//
//  PKBattleViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/30.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

//@protocol PKBattleDelegate <NSObject>
//
//-(void)pushToLiveController:(LivingModel *)model modelArr:(NSArray *)modelArr isFirstJump:(BOOL)isFirstJump;
//
//@end

@interface PKBattleViewController : BGBaseViewController<UITableViewDelegate,UITableViewDataSource>


//@property(nonatomic, strong) id<PKBattleDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
