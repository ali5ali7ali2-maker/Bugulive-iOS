//
//  MSmallVideoVC.h
//  BuguLive
//
//  Created by 丁凯 on 2017/8/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseViewController.h"

@interface MSmallVideoVC : BGBaseViewController

@property ( nonatomic,assign) BOOL   notHaveTabbar;      //是否有tabbar
@property (nonatomic, strong) NSMutableDictionary *paramDict;
@property (nonatomic, assign) BOOL isHaveNavBar;

- (void)refreshHeader;

@property ( nonatomic,strong) UICollectionView                 *videoCollectionV;

@end
