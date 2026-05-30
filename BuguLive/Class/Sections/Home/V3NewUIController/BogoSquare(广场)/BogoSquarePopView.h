//
//  BogoSquarePopView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/7/31.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BogoDrawView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoSquarePopView : BGBaseView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) BogoDrawView *topView;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *listArr;

@property(nonatomic, copy) void (^clickIndexBlock)(NSInteger index);






@end

NS_ASSUME_NONNULL_END
