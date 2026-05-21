//
//  BGFirebaseSMS.h
//  BuguLive
//
//  Created by 志刚杨 on 2022/7/25.
//  Copyright © 2022 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGFirebaseSMS : UIViewController
-(void)sendSMS:(NSString *)phone block:(AppCommonBlock)block;
-(void)verifyCode:(NSString *)code block:(AppCommonBlock)block;
@end

NS_ASSUME_NONNULL_END
