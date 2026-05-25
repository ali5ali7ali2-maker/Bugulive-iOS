//
//  MGShopView.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/7/17.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGShopView : BGBaseView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) NSString *user_id;

- (instancetype)initWithFrame:(CGRect)frame UserId:(NSString *)userID ResponseJson:(NSDictionary *)json;

- (void)show:(UIView *)superView;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
