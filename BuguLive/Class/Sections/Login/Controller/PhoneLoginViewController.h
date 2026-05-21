//
//  PhoneLoginViewController.h
//  BuguLive
//
//  Created by 范东 on 2019/1/16.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhoneLoginViewController : BGBaseViewController

@property (nonatomic, assign) BOOL             LSecBPhone;                         //登入成功之后绑定手机
@property (nonatomic, assign) BOOL             LNSecBPhone;                        //未登入成功之后绑定手机
@property (nonatomic, copy) NSString           *loginType;                         //登入类型
@property (nonatomic, copy) NSString           *loginId;                           //登入id
@property (nonatomic, copy) NSString           *accessToken;                       //登入accessToken

@end

NS_ASSUME_NONNULL_END
