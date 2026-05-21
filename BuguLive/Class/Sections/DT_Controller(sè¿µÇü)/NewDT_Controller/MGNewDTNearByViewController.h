//
//  MGNewDTNearByViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BaseViewController.h"

#import "MGNewDTNearPeopleCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGNewDTNearByViewController : BGBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

-(instancetype)initWithType:(MGNEWDT_TYPE)type;

@property(nonatomic, assign) MGNEWDT_TYPE type;

@end

NS_ASSUME_NONNULL_END
