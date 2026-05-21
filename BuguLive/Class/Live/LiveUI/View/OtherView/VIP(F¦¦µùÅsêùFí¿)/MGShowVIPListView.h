//
//  MGShowVIPListView.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/19.
//  Copyright © 2019 xfg. All rights reserved.
//

//贵族列表弹窗

#import <UIKit/UIKit.h>
#import "MGShowVIPCell.h"
#import "MGShowVipModel.h"
#import "BogoShowNobleCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGShowVIPListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UILabel *titleL;
@property(nonatomic, strong) UIButton *wishBtn;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *shadowView;

@property(nonatomic, strong) NSMutableArray *listArr;

@property(nonatomic, strong) NSString *roomID;

@property(nonatomic, copy) void (^clickHideLiveWishBlock)();

- (void)show:(UIView *)superView withRoomID:(NSString *)roomID;

- (void)hide;


@end

NS_ASSUME_NONNULL_END
