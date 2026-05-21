//
//  MGRegisterViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/6/28.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "BGBaseViewController.h"

typedef enum : NSUInteger {
    MGLOGIN_TYPE_REGISTER,//注册
    MGLOGIN_TYPE_FINDPASSWORD,//找回密码
    MGLOGIN_TYPE_CODELOGIN,//验证码登录
} MGLOGIN_TYPE;

NS_ASSUME_NONNULL_BEGIN

@interface MGRegisterViewController : BGBaseViewController

@property(nonatomic, assign) MGLOGIN_TYPE loginType;

-(instancetype)initWithLoginType:(MGLOGIN_TYPE)loginType;

@end

NS_ASSUME_NONNULL_END
