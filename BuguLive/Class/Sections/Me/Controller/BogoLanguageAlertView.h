//
//  BogoLanguageAlertView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/26.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoLanguageAlertView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UILabel *titleL;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *cancleBtn;
@property(nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIView *shadowView;

@property(nonatomic, strong) NSArray *listArr;

- (void)show:(UIView *)superView;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
