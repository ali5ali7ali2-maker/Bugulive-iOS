//
//  BogoYouthModePassWordViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/11.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGBaseViewController.h"

typedef enum : NSUInteger {
    BOGO_YOUNTH_TYPE_PASSWORD_SET,//设置密码
    BOGO_YOUNTH_TYPE_PASSWORD_CONFIRM,//确认密码
    BOGO_YOUNTH_TYPE_PASSWORD_CLOSE,//关闭
    BOGO_YOUNTH_TYPE_PASSWORD_INPUTORIGIN,//输入原密码
    
} BOGO_YOUNTH_TYPE;

NS_ASSUME_NONNULL_BEGIN

@interface BogoYouthModePassWordViewController : BGBaseViewController

-(instancetype)initWithYounthType:(BOGO_YOUNTH_TYPE)type;

@property(nonatomic, assign) BOGO_YOUNTH_TYPE type;

@property(nonatomic, strong) NSString *phone;

@end

NS_ASSUME_NONNULL_END
