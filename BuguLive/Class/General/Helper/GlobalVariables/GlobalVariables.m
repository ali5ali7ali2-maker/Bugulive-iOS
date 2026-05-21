

//
//  GlobalVariables.m
//  BuguLive
//
//  Created by xfg on 16/2/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GlobalVariables.h"
#import "NSString+guoMS.h"
#import "BogoNetworkKit.h"

static NSString *BGNormalizedAESKey(NSString *aesKey)
{
    if (![aesKey isKindOfClass:[NSString class]]) {
        return @"";
    }

    NSString *trimmed = [aesKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimmed.length < 16) {
        return @"";
    }

    if (trimmed.length > 16) {
        trimmed = [trimmed substringToIndex:16];
    }
    return trimmed;
}

@implementation GlobalVariables

@synthesize token    = _token;

@synthesize userModel    = _userModel;


@synthesize is_guartian    = _is_guartian;

+ (GlobalVariables *)sharedInstance
{
    static GlobalVariables *myInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        myInstance = [[self alloc] init];
        
        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
        myInstance.config = tmpDict;
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        myInstance.newestLivingMArray = tmpArray;
        
        NSMutableArray *tmpArray2 = [[NSMutableArray alloc] init];
        myInstance.listMsgMArray = tmpArray2;
        
        // 两种情况启用新打包时的域名：1、如果本地保存的日期版本号为空；2、本地保存的日期版本号小于当前打包时填写的日期版本号（意思是更新版本）
        NSString *tmpVersionTime = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersionTimeKey];
        if ([BGUtils isBlankString:tmpVersionTime] || [tmpVersionTime longLongValue] < [VersionTime longLongValue])
        {
            if (AppDoMainUrlArray)
            {
                if ([AppDoMainUrlArray count])
                {
                    NSString *tmpMainUrl = [AppDoMainUrlArray firstObject];
                    tmpMainUrl = [tmpMainUrl stringByAppendingString:AppDoMainUrlSuffix];
                    myInstance.currentDoMianUrlStr = tmpMainUrl;
                    
                    myInstance.doMainUrlArray = AppDoMainUrlArray;
                }
                else
                {
                    [FanweMessage alert:ASLocalizedString(@"域名列表不为空，但是没有数据！")];
                }
            }
            else
            {
                [FanweMessage alert:ASLocalizedString(@"域名列表为空！")];
            }
        }
        else
        {
            // 获取保存在本地的域名列表
            NSArray *tmpMainUrlArray = [[NSUserDefaults standardUserDefaults] objectForKey:kAppDoMainUrlListKey];
            if (tmpMainUrlArray)
            {
                if ([tmpMainUrlArray count])
                {
                    myInstance.doMainUrlArray = tmpMainUrlArray;
                }
                else
                {
                    myInstance.doMainUrlArray = AppDoMainUrlArray;
                }
            }
            else
            {
                myInstance.doMainUrlArray = AppDoMainUrlArray;
            }
            
            // 获取保存在本地的域名
            NSString *tmpMainUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCurrentMainUrlKey];
            // 如果保存在本地的域名为空，则启用域名列表中的首个域名
            if ([BGUtils isBlankString:tmpMainUrl])
            {
                if (myInstance.doMainUrlArray)
                {
                    if ([myInstance.doMainUrlArray count])
                    {
                        tmpMainUrl = [myInstance.doMainUrlArray firstObject];
                        tmpMainUrl = [tmpMainUrl stringByAppendingString:AppDoMainUrlSuffix];
                    }
                    else
                    {
                        [FanweMessage alert:ASLocalizedString(@"域名列表不为空，但是没有数据！")];
                    }
                }
                else
                {
                    [FanweMessage alert:ASLocalizedString(@"域名列表为空！")];
                }
            }
            myInstance.currentDoMianUrlStr = tmpMainUrl;
        }
        
        if ([IsNeedStorageDoMainUrl isEqualToString:@"YES"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:myInstance.currentDoMianUrlStr forKey:kAppCurrentMainUrlKey];
            [[NSUserDefaults standardUserDefaults] setObject:VersionTime forKey:kAppVersionTimeKey];
        }
        
        // 获取保存在本地的AESKey
        NSString *tmpAESKeyUrl = [KeyChainHelper serviceForKey:kFWAESKey];
        if ([BGUtils isBlankString:tmpAESKeyUrl])
        {
            tmpAESKeyUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kFWAESKey];
            if (![BGUtils isBlankString:tmpAESKeyUrl])
            {
                [KeyChainHelper addService:tmpAESKeyUrl withKey:kFWAESKey];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kFWAESKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        tmpAESKeyUrl = BGNormalizedAESKey(tmpAESKeyUrl);
        // If no stored AES key exists (or it is malformed), keep using packaged fallback.
        if ([BGUtils isBlankString:tmpAESKeyUrl])
        {
            tmpAESKeyUrl = BGNormalizedAESKey(AppAESKey);
        }
        myInstance.aesKeyStr = tmpAESKeyUrl;
        
        AppModel *appModel = [[AppModel alloc]init];
        myInstance.appModel = appModel;
        
    });
    return myInstance;
}

#pragma mark 保存服务端下发的域名列表
- (void)storageAppMainUrls:(NSArray *)mainUrlArray
{
    self.doMainUrlArray = mainUrlArray;
    [[NSUserDefaults standardUserDefaults] setObject:mainUrlArray forKey:kAppDoMainUrlListKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 保存当前可用的域名，一下次启动app时使用
- (void)storageAppCurrentMainUrl:(NSString *)currentMainUrl
{
    currentMainUrl = [self getStandardMainUrl:currentMainUrl];
    
    self.currentDoMianUrlStr = currentMainUrl;
    if ([IsNeedStorageDoMainUrl isEqualToString:@"YES"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:currentMainUrl forKey:kAppCurrentMainUrlKey];
        [[NSUserDefaults standardUserDefaults] setObject:VersionTime forKey:kAppVersionTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark 获取系统准确的接口地址（主要为了防止客户后台备用域名填写的有问题）
- (NSString *)getStandardMainUrl:(NSString *)urlStr
{
    if (![BGUtils isBlankString:urlStr])
    {
        // 如果有多个 AppDoMainUrlSuffix 时，先全部删除
        if ([urlStr countOccurencesOfString:AppDoMainUrlSuffix] > 1)
        {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:AppDoMainUrlSuffix withString:@""];
        }
        
        // 根域名如果不包含 AppDoMainUrlSuffix 则加上
        if ([urlStr rangeOfString:AppDoMainUrlSuffix].location == NSNotFound)
        {
            urlStr = [urlStr stringByAppendingString:AppDoMainUrlSuffix];
        }
        
        return urlStr;
    }
    return @"";
}

#pragma mark 保存当前可用的aeskey，一下次启动app时使用
- (void)storageAppAESKey:(NSString *)aesKeyStr
{
    aesKeyStr = BGNormalizedAESKey(aesKeyStr);
    self.aesKeyStr = aesKeyStr;
    if (![BGUtils isBlankString:aesKeyStr]) {
        [KeyChainHelper addService:aesKeyStr withKey:kFWAESKey];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kFWAESKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setToken:(NSString *)token{
    if ([self isStr:token] && token.length > 0) {
        [KeyChainHelper addService:token withKey:@"token"];
    } else {
        [KeyChainHelper addService:@"" withKey:@"token"];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _token = token;
    [BogoNetwork shareInstance].token = token;
}

-(NSString *)token{
    if (!_token) {
        _token = [KeyChainHelper serviceForKey:@"token"];
        if (![self isStr:_token] || _token.length == 0) {
            _token = [self readStrFromUser:@"token"];
            if ([self isStr:_token] && _token.length > 0) {
                [KeyChainHelper addService:_token withKey:@"token"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    return _token ?: @"";
}

- (void)setIs_guartian:(NSString *)is_guartian{
    [self writeStr:is_guartian forKey:@"is_guartian"];
    _is_guartian = is_guartian;
}

-(NSString *)is_guartian{
    if (!_is_guartian) {
        _is_guartian = [self readStrFromUser:@"is_guartian"];
    }
    return _is_guartian;
}



-(void)storageLoginString:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:string];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(UIImage *)getKatongImageWidthID:(NSString *)uid
{
    if(StrValid(uid))
    {
        NSString *iid = [uid substringFromIndex:uid.length-1];
        return [UIImage imageNamed:NSStringFormat(@"kt%@.jpg",iid)];

    }
    else
    {
        return [UIImage imageNamed:@"kt0.jpg"];
    }
}





- (void)writeStr:(NSString *)strValue forKey:(NSString *)strKey{
    if ([self isStr:strKey ] ) {
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [user setObject:strValue  forKey:strKey];
        [user synchronize];
    }
}


- (NSString *)readStrFromUser:(NSString *)strKey{
    if ([self isStr:strKey]) {
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        NSString * strValue = [user objectForKey:strKey];
        if (strValue != nil && [strValue isKindOfClass:[NSString class]]&& strValue.length>0) {
            return strValue;
        }
    }
    return @"";
}



#pragma mark 验证字符串

- (BOOL)isStr:(NSString *)str{
    if (str != nil && [str isKindOfClass:[NSString class]] ) {
        return YES;
    }
    return NO;
}

- (BOOL)isDic:(NSDictionary *)dic{
    if (dic != nil && [dic isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *temp in windows) {
            if (temp.windowLevel == UIWindowLevelNormal) {
                window = temp;
                break;
            }
        }
    }
    //取当前展示的控制器
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    //如果为UITabBarController：取选中控制器
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    //如果为UINavigationController：取可视控制器
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    return result;
}

-(BOOL)openAgora
{
    return YES;
}

- (BOOL)openFirebaseSMS
{
    return NO;
}

@end
