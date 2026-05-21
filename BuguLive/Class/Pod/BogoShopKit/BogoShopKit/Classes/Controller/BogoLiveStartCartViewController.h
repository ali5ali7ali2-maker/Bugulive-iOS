//
//  BogoLiveStartCartViewController.h
//  BuGuDY
//
//  Created by bogokj on 2020/3/27.
//  Copyright © 2020 宋晨光. All rights reserved.
//

#import "FDTableViewController.h"
#import "BogoLiveGoodAddViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoLiveStartCartViewController : FDTableViewController

- (void)setChangeCartCallBack:(changeCartCallBack)changeCartCallBack;

@property(nonatomic, copy) NSString *lid;

@end

NS_ASSUME_NONNULL_END
