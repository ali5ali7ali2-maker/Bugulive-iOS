//
//  MGNewDTNavView.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/11/26.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBadgeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGNewDTNavView : UIView

@property(nonatomic, strong) QMUIButton *postBtn;//发帖
@property(nonatomic, strong) QMUIButton *searchBtn;//搜索按钮
@property(nonatomic, strong) QMUIButton *chatBtn;//聊天按钮
@property(nonatomic, strong) JSBadgeView *jsbadge;//系统消息

@property(nonatomic, copy) void (^clickPostBlock)(NSInteger i);

@end

NS_ASSUME_NONNULL_END
