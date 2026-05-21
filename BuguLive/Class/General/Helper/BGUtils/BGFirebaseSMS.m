//
//  BGFirebaseSMS.m
//  BuguLive
//
//  Created by 志刚杨 on 2022/7/25.
//  Copyright © 2022 xfg. All rights reserved.
//

#import "BGFirebaseSMS.h"
#import "UIViewController+Alerts.h"
@import FirebaseCore;
@import FirebaseFirestore;
@import FirebaseAuth;

@implementation BGFirebaseSMS
-(void)sendSMS:(NSString *)phone block:(AppCommonBlock)block
{
    [[FIRPhoneAuthProvider provider] verifyPhoneNumber:phone
                                            UIDelegate:nil
                                            completion:^(NSString * _Nullable verificationID, NSError * _Nullable error) {
      if (error) {
          [BGHUDHelper alert:error.localizedDescription];
        return;
      }
      else{
          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
          [defaults setObject:verificationID forKey:@"authVerificationID"];
          
          block(nil);
      }
      // Sign in using the verificationID and the code sent to the user
      // ...
    }];
}
-(void)verifyCode:(NSString *)code block:(AppCommonBlock)block
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *verificationID = [defaults stringForKey:@"authVerificationID"];

    FIRAuthCredential *credential = [[FIRPhoneAuthProvider provider]
        credentialWithVerificationID:verificationID
                    verificationCode:code];
    
    [[FIRAuth auth] signInWithCredential:credential
                              completion:^(FIRAuthDataResult * _Nullable authResult,
                                           NSError * _Nullable error) {
        if (error && error.code == FIRAuthErrorCodeSecondFactorRequired) {
          FIRMultiFactorResolver *resolver = error.userInfo[FIRAuthErrorUserInfoMultiFactorResolverKey];
          NSMutableString *displayNameString = [NSMutableString string];
          for (FIRMultiFactorInfo *tmpFactorInfo in resolver.hints) {
            [displayNameString appendString:tmpFactorInfo.displayName];
            [displayNameString appendString:@" "];
          }
        

          [self showTextInputPromptWithMessage:[NSString stringWithFormat:@"Select factor to sign in\n%@", displayNameString]
                                completionBlock:^(BOOL userPressedOK, NSString *_Nullable displayName) {
           FIRPhoneMultiFactorInfo* selectedHint;
           for (FIRMultiFactorInfo *tmpFactorInfo in resolver.hints) {
             if ([displayName isEqualToString:tmpFactorInfo.displayName]) {
               selectedHint = (FIRPhoneMultiFactorInfo *)tmpFactorInfo;
             }
           }
           [FIRPhoneAuthProvider.provider
            verifyPhoneNumberWithMultiFactorInfo:selectedHint
            UIDelegate:nil
            multiFactorSession:resolver.session
            completion:^(NSString * _Nullable verificationID, NSError * _Nullable error) {
              if (error) {
                  [BGHUDHelper alert:error.localizedDescription];
              } else {
                [self showTextInputPromptWithMessage:[NSString stringWithFormat:@"Verification code for %@", selectedHint.displayName]
                                     completionBlock:^(BOOL userPressedOK, NSString *_Nullable verificationCode) {
                 FIRPhoneAuthCredential *credential =
                     [[FIRPhoneAuthProvider provider] credentialWithVerificationID:verificationID
                                                                  verificationCode:verificationCode];
                 FIRMultiFactorAssertion *assertion = [FIRPhoneMultiFactorGenerator assertionWithCredential:credential];
                 [resolver resolveSignInWithAssertion:assertion completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
                   if (error) {
                       [BGHUDHelper alert:error.localizedDescription];

                   } else {
                     NSLog(@"Multi factor finanlize sign in succeeded.");
                   }
                 }];
               }];
              }
            }];
         }];
        }
      else if (error) {
          [BGHUDHelper alert:error.localizedDescription];

        // ...
        return;
      }
      // User successfully signed in. Get user data from the FIRUser object
      if (authResult == nil) { return; }
      FIRUser *user = authResult.user;
        [user getIDTokenForcingRefresh:YES completion:^(NSString * _Nullable token, NSError * _Nullable error) {
            NSLog(@"google token %@...",token);
            AppBlockModel *model = [AppBlockModel new];
            model.retDict = @{@"token":token};
            block(model);
        }];
    }];
    
}
@end
