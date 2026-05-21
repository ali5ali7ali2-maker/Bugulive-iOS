//
//  SHomeDynamicView.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/5/20.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YHTimeLineListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHomeDynamicView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, copy) NSString *user_id;

- (instancetype)initWithFrame:(CGRect)frame andUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
