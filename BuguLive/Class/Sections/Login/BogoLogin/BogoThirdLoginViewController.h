//
//  BogoThirdLoginViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/29.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoThirdLoginViewController : BGBaseViewController

@property(nonatomic, strong) UMSocialUserInfoResponse *userInfo;
@property(nonatomic, strong) UserModel *model;
//@property(nonatomic, strong) NSString *user_id;
//@property(nonatomic, strong) NSString *need_bind_mobile;
@property(nonatomic, copy) void (^bindSuccess)(void);

@end

NS_ASSUME_NONNULL_END
