//
//  AppleIDManager.m
//  SignInWithAppleDemo
//
//  Created by bogokj on 2020/6/19.
//  Copyright © 2020 fandong. All rights reserved.
//

#import "AppleIDManager.h"

@interface AppleIDManager ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@end

@implementation AppleIDManager

+ (AppleIDManager *)defaultManager{
    static AppleIDManager *defaultManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        defaultManager = [[self alloc] init];
    });
    return defaultManager;
}

- (void)loginBtnAction:(ASAuthorizationAppleIDButton *)sender API_AVAILABLE(ios(13.0)){
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *request = [provider createRequest];
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        ASAuthorizationController *authC = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        authC.delegate = self;
        authC.presentationContextProvider = self;
        [authC performRequests];
    }
}

#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSString *state = credential.state;
        NSString *user = credential.user;
        NSPersonNameComponents *fullName = credential.fullName;
        NSString *email = credential.email;
        NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        
//    state:(null)
//    user:001872.a22fc8cc2d0a4d0bacaf109007e19351.0650
//    fullName:<NSPersonNameComponents: 0x283e109a0> {givenName = 晨光, familyName = 宋, middleName = (null), namePrefix = (null), nameSuffix = (null), nickname = (null) phoneticRepresentation = (null) }
//    email:qjhnjd6nfq@privaterelay.appleid.com
//    authorizationCode:c7a061f7c639a4a079b7005969f17d853.0.rryxs.9P6Uup8Lxr6mMFO169OnlA
//    identityToken:eyJraWQiOiJlWGF1bm1MIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLmJ1Z3VsaXZlU2hvcC5jb20iLCJleHAiOjE2NDE1MzgyMjIsImlhdCI6MTY0MTQ1MTgyMiwic3ViIjoiMDAxODcyLmEyMmZjOGNjMmQwYTRkMGJhY2FmMTA5MDA3ZTE5MzUxLjA2NTAiLCJjX2hhc2giOiJLUVhONUFIczVtVlNVU1ZVWlE3LV9BIiwiZW1haWwiOiJxamhuamQ2bmZxQHByaXZhdGVyZWxheS5hcHBsZWlkLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjoidHJ1ZSIsImlzX3ByaXZhdGVfZW1haWwiOiJ0cnVlIiwiYXV0aF90aW1lIjoxNjQxNDUxODIyLCJub25jZV9zdXBwb3J0ZWQiOnRydWUsInJlYWxfdXNlcl9zdGF0dXMiOjJ9.20XmZONFE4nsfvd5Q4HSuBqbezRuGxiZ-eRGlw-l5gbuNjlLP_iHuZsVo8tf6JqLzYRA_j7pkliTslyvhURZiul8yWI7DsGYXsl85EMWFsIeKj780O9HnOuI4pWM66VJu0-EWwasGaD_4JsxGp74h89EWm0X9M-x9n8g-gEuD1k8jO5bq9IPEMBLdkMJgfp8H8vBbUnEl5BGWUsd5-fK6sXcSCq4NQLwAhsQqSWFVKGDtIsEUy1898cbBvr1AHmh5n9M9jGPr4zkv7z7hyaS8chHOdB93w2EkskqwLb95rxHax92JQHOrpYHqD1-cw5_zLmjU_QAcN1EYsR4JzzMtQ
//    realUserStatus:2
        
        NSLog(@"授权成功\nstate:%@\nuser:%@\nfullName:%@\nemail:%@\nauthorizationCode:%@\nidentityToken:%@\nrealUserStatus:%ld", state,user,fullName,email,authorizationCode,identityToken,realUserStatus);
        if (self.successBlock) {
            self.successBlock(authorizationCode, identityToken, user);
        }
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        // 用户登录使用的是: 现有密码凭证
               ASPasswordCredential *credential = (ASPasswordCredential *)authorization.credential;
               NSString *user = credential.user; // 密码凭证对象的用户标识(用户的唯一标识)
               NSString *password = credential.password;
               NSLog(@"Apple登录_现有密码凭证: %@, %@", user, password);
    }else{
        
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    NSString *errorMsg = @"";
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = NSLocalizedString(@"用户取消了授权请求",nil);
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = NSLocalizedString(@"授权请求失败",nil);
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = NSLocalizedString(@"授权请求响应无效",nil);
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = NSLocalizedString(@"未能处理授权请求",nil);
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"";
//            errorMsg = NSLocalizedString(@"授权请求失败未知原因",nil);
            break;
            
        default:
            break;
    }
    NSLog(@"授权失败:errorMsg:%@",errorMsg.length ? errorMsg : error.localizedDescription);
    if (self.failureBlock) {
        self.failureBlock(errorMsg.length ? errorMsg : error.localizedDescription);
    }
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    return self.window;
}

- (ASAuthorizationAppleIDButton *)loginBtn API_AVAILABLE(ios(13.0)){
    if (!_loginBtn) {
        if (@available(iOS 13.2, *)) {
            _loginBtn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignUp style:ASAuthorizationAppleIDButtonStyleBlack];
        } else {
            // Fallback on earlier versions
        }
        [_loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _loginBtn;
}

@end
