//
//  BGIMLoginManager.m
//  BuguLive
//
//  Created by xfg on 2017/1/11.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGIMLoginManager.h"

@implementation BGIMLoginManager

BogoSingletonM(Instance);

- (id)init
{
    @synchronized (self)
    {
        self = [super init];
        if (self)
        {
            BOOL isAutoLogin = [IMAPlatform isAutoLogin];
            if (!_loginParam && isAutoLogin)
            {
                _loginParam = [IMALoginParam loadFromLocal];
            }
            else
            {
                _loginParam = [[IMALoginParam alloc] init];
            }
        }
        return self;
    }
}


/**
 获取UserSig
 
 @param succ 成功回调
 @param failed 失败回调
 */
- (void)getUserSig:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user" forKey:@"ctl"];
    [mDict setObject:@"usersig" forKey:@"act"];
    
    FWWeakify(self)
    
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        
        self.loginParam.userSig = [responseJson objectForKey:@"usersig"];
        self.loginParam.tokenTime = [[NSDate date] timeIntervalSince1970];
        
        if (![BGUtils isBlankString:self.loginParam.userSig])
        {
            [self loginImSDK:NO succ:^{
                
                if (succ)
                {
                    succ();
                }
                
            } failed:^(int errId, NSString *errMsg) {
                
                if (failed)
                {
                    failed(FWCode_Normal_Error, [NSString stringWithFormat:@"IM error %d %@", errId, errMsg]);
                }
                
            }];
        }
        else
        {
            [FanweMessage alert:ASLocalizedString(@"获取签名为空")];
            if (failed)
            {
                failed(FWCode_Normal_Error, ASLocalizedString(@"获取签名为空"));
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
        [FanweMessage alert:ASLocalizedString(@"获取签名失败，请稍后尝试")];
        if (failed)
        {
            failed(FWCode_Normal_Error, ASLocalizedString(@"请求网络失败"));
        }
        
    }];
}

#pragma mark - 登录IMSDK
- (void)loginImSDK:(BOOL)isShowHud succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    BOOL isAutoLogin = [IMAPlatform isAutoLogin];
    if (!_loginParam && isAutoLogin)
    {
        _loginParam = [IMALoginParam loadFromLocal];
    }
    
    [IMAPlatform configWith:_loginParam.config];
    
    if ([_loginParam isVailed])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self doLogin:isShowHud succ:succ failed:failed];
        });
    }
}

#pragma mark 登录IMSDK
- (void)doLogin:(BOOL)isShowHud succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    if ([_loginParam isExpired])
    {
        [[AppDelegate sharedAppDelegate] enterLoginUI];
        
        if (failed)
        {
            failed(1, ASLocalizedString(@"过期，重新登录"));
        }
        return;
    }
    
    if (_isIMSDKOK || _isLogingIMSDK)
    {
        if (failed)
        {
            failed(0, ASLocalizedString(@"已经登录或者正在登录"));
        }
        return;
    }
    
    _isLogingIMSDK = YES;
    
    if (isShowHud)
    {
        [self showMyHud];
        
        [self performSelector:@selector(hideMyHud) withObject:nil afterDelay:5];
    }
    
    FWWeakify(self)
    
//    __weak IMAPlatform *ws = self;
    
    [[V2TIMManager sharedInstance] login:_loginParam.identifier userSig:_loginParam.userSig succ:^{
        FWStrongify(self)
        
        fwwo.isLogingIMSDK = NO;
        fwwo.isIMSDKOK = YES;
        
        [fwwo.loginParam saveToLocal];
        [[IMAPlatform sharedInstance] configOnEnterMainUIWith:_loginParam];
        
        [IMAPlatform setAutoLogin:YES];
        [BogoNetwork shareInstance].uid = _loginParam.identifier;
        [AppViewModel userStateChange:@"Login"];
        [AppViewModel updateApnsCode];
        [fwwo enterBigGroup];
        
        [fwwo hideMyHud];
        
        if (succ)
        {
            succ();
        }
    } fail:^(int code3, NSString *desc3) {
//        DebugLog(@"TIMLogin Failed: code=%d err=%@", code, desc);
        if (code3 == 6206)
        {
            // 互踢重联
            // 重新再登录一次
            [FanweMessage alert:ASLocalizedString(@"下线通知") message:ASLocalizedString(@"您的账号在其他设备登录，如果不是您的操作，请及时修改密码") isHideTitle:NO destructiveAction:^{
                FWStrongify(self)
                // 退出
                _isLogingIMSDK = NO;
                [[AppDelegate sharedAppDelegate] enterLoginUI];
        
            }];
            
            
        }
        else
        {
            FWStrongify(self)
            
            fwwo.isLogingIMSDK = NO;
            
            [fwwo hideMyHud];
            [FanweMessage alert:[NSString stringWithFormat:ASLocalizedString(@"登录IMSDK错误码： %d %@"),code3,desc3]];

            if (failed)
            {
                failed(code3, desc3);
            }
        }
    }];
    
//    [[IMAPlatform sharedInstance] login:_loginParam succ:^{
//
//        FWStrongify(self)
//
//        self.isLogingIMSDK = NO;
//        self.isIMSDKOK = YES;
//
//        [self.loginParam saveToLocal];
//        [[IMAPlatform sharedInstance] configOnEnterMainUIWith:self.loginParam];
//
//        [AppViewModel userStateChange:@"Login"];
//        [AppViewModel updateApnsCode];
//        [self enterBigGroup];
//
//        [self hideMyHud];
//
//        if (succ)
//        {
//            succ();
//        }
//
//    } fail:^(int code, NSString *msg) {
//
//        FWStrongify(self)
//
//        self.isLogingIMSDK = NO;
//
//        [self hideMyHud];
//
//        if (failed)
//        {
//            failed(code, msg);
//        }
//
//#ifdef DEBUG
//        [FanweMessage alert:[NSString stringWithFormat:ASLocalizedString(@"登录IMSDK错误码： %d %@"),code,msg]];
//#endif
//
//    }];
}


     
#pragma mark 加入大群
- (void)enterBigGroup
{
    if (![BGUtils isBlankString:self.BuguLive.appModel.full_group_id])
    {
        FWWeakify(self)
        
        [[V2TIMManager sharedInstance] joinGroup:self.BuguLive.appModel.full_group_id msg:nil succ:^{
            NSLog(ASLocalizedString(@"加入全员广播大群成功"));
            
            FWStrongify(self)
            [self obtainAesKeyFromFullGroup:nil error:nil];
        } fail:^(int code, NSString *desc) {
//            NSLog(ASLocalizedString(@"加入全员广播大群失败，错误码：%d，错误原因：%@"),code,msg);

        }];
        
//        [[TIMGroupManager sharedInstance] joinGroup:self.BuguLive.appModel.full_group_id msg:nil succ:^{
//            NSLog(ASLocalizedString(@"加入全员广播大群成功"));
//
//            FWStrongify(self)
//            [self obtainAesKeyFromFullGroup:nil error:nil];
//
//        } fail:^(int code, NSString *msg) {
//            NSLog(ASLocalizedString(@"加入全员广播大群失败，错误码：%d，错误原因：%@"),code,msg);
//        }];
    }
}
    
- (void)obtainAesKeyFromFullGroup:(FWVoidBlock)succBlock error:(FWErrorBlock)errorBlock
{
    if (!self.isIMSDKOK)
    {
        if (errorBlock)
        {
            errorBlock(FWCode_Normal_Error, ASLocalizedString(@"IM还未登录成功"));
        }
        return;
    }
    
    if ([BGUtils isBlankString:self.BuguLive.appModel.full_group_id])
    {
        if (errorBlock)
        {
            errorBlock(FWCode_Normal_Error, ASLocalizedString(@"还未获取到全员广播大群ID"));
        }
        return;
    }
    
    if (_isObtainAESKeyIng)
    {
        if (errorBlock)
        {
            errorBlock(FWCode_Normal_Error, ASLocalizedString(@"请求中。。。"));
        }
        return;
    }
    else
    {
        _isObtainAESKeyIng = YES;
        
        [self showMyHud];
    }
    
    TIMGroupManager *groupManager = [TIMGroupManager sharedInstance];
    [self performSelector:@selector(hideMyHud) withObject:nil afterDelay:5];
    
    FWWeakify(self)
    [groupManager getGroupInfo:@[self.BuguLive.appModel.full_group_id] succ:^(NSArray *arr) {
        
        FWStrongify(self)
        self.isObtainAESKeyIng = NO;
        
        TIMGroupInfo *tmpGroupInfo = [arr firstObject];
        NSString *introduction = tmpGroupInfo.introduction;
        
        if (![BGUtils isBlankString:introduction])
        {
            if (![introduction isEqualToString:[GlobalVariables sharedInstance].aesKeyStr])
            {
                [[GlobalVariables sharedInstance] storageAppAESKey:introduction];
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshHome object:nil userInfo:nil];
            }
        }
        
        [self hideMyHud];
        
        if (succBlock)
        {
            succBlock();
        }
        
    } fail:^(int code, NSString *msg) {
        
        FWStrongify(self)
        self.isObtainAESKeyIng = NO;
        
        [self hideMyHud];
        
        if (errorBlock)
        {
            errorBlock(FWCode_Normal_Error, ASLocalizedString(@"获取到全员广播大群信息失败"));
        }
        
    }];
}

#pragma mark 
- (MBProgressHUD *)proHud
{
    if (!_proHud)
    {
        _proHud = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedAppDelegate].window animated:YES];
        _proHud.mode = MBProgressHUDModeIndeterminate;
    }
    return _proHud;
}

- (void)hideMyHud
{
    if (_proHud)
    {
        [_proHud hideAnimated:YES];
        _proHud = nil;
    }
}

- (void)showMyHud
{
//    [self.proHud showAnimated:YES];
}

@end
