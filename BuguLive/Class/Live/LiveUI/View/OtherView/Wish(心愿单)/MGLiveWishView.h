//
//  MGLiveWishView.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/5.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGLiveWishCell.h"


#import "MGLiveWishModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGLiveWishView : UIView<UITableViewDelegate,UITableViewDataSource,MGLiveWishCellDelegate>

@property(nonatomic, strong) UILabel *titleL;
@property(nonatomic, strong) UIButton *wishBtn;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *shadowView;


@property(nonatomic, strong) NSMutableArray *listArr;
@property(nonatomic, strong) NSMutableArray *listDeleteArr;

@property(nonatomic, copy) void (^clickLiveWishBlock)(MGADD_WISH wishType);
//隐藏心愿view
@property(nonatomic, copy) void (^clickHideLiveWishBlock)();

- (void)show:(UIView *)superView;

- (void)hide;
@property (nonatomic,strong) NSString *roomId;
@end

NS_ASSUME_NONNULL_END
