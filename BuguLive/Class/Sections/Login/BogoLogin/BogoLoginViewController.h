//
//  BogoLoginViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/24.
//  Copyright © 2021 xfg. All rights reserved.
 //

#import "BGBaseViewController.h"
#import "BogoCountryChoiceViewController.h"
#import "BogoJHLogin.h"
//typedef enum : NSUInteger {
//    BOGO_LOGIN_TYPE_CODE,//获取验证码
//    BOGO_LOGIN_TYPE_CODE_LOGIN,//验证码登录
//    BOGO_LOGIN_TYPE_PHONE,//密码登录
//    BOGO_LOGIN_TYPE_REGISTER,//注册
//    BOGO_LOGIN_TYPE_FORGET,//忘记密码-获取验证码
//    BOGO_LOGIN_TYPE_FORGET_CODE,//确认忘记密码-输入+确认新密码
//    BOGO_LOGIN_TYPE_PHONE_CONFIRM,//验证手机号
//    BOGO_LOGIN_TYPE_PHONE_CHANGE,//更换手机号
//} BOGO_LOGIN_TYPE;


NS_ASSUME_NONNULL_BEGIN

@interface BogoLoginViewController : BGBaseViewController

@property(nonatomic, assign) BOGO_LOGIN_TYPE loginType;

@property(nonatomic, strong) NSString *phoneNum;

@property(nonatomic, strong) BogoChoiceAreaModel *areaModel;

@property(nonatomic, strong) NSString *tel_code;

@property(nonatomic, copy) void (^returnPhoneNumBlock)(NSString *phone);



@end

NS_ASSUME_NONNULL_END
