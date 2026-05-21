//
//  AppleIDManager.h
//  SignInWithAppleDemo
//
//  Created by bogokj on 2020/6/19.
//  Copyright © 2020 fandong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(13.0))

typedef void(^successBlock)(NSString *authorizationCode, NSString *identityToken, NSString *user);
typedef void(^failureBlock)(NSString *errorMsg);

@interface AppleIDManager : NSObject

@property(nonatomic, strong) ASAuthorizationAppleIDButton *loginBtn;

@property(nonatomic, strong) UIWindow *window;

@property(nonatomic, copy) successBlock successBlock;
@property(nonatomic, copy) failureBlock failureBlock;

+ (AppleIDManager *)defaultManager;

@end

NS_ASSUME_NONNULL_END
