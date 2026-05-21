//
//  BogoYoungModeVideoViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/13.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoYoungModeVideoViewController : BGBaseViewController

@property ( nonatomic,assign) BOOL   notHaveTabbar;      //是否有tabbar
@property (nonatomic, strong) NSMutableDictionary *paramDict;
@property (nonatomic, assign) BOOL isHaveNavBar;

- (void)refreshHeader;

@property ( nonatomic,strong) UICollectionView                 *videoCollectionV;

@end

NS_ASSUME_NONNULL_END
