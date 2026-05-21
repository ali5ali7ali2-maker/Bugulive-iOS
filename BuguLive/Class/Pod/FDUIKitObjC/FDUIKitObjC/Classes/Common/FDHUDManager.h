//
//  FDHUDManager.h
//  FDUIKitObjC
//
//  Created by fandongtongxue on 2020/2/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDHUDManager : NSObject

+ (FDHUDManager *)defaultManager;

- (void)show:(NSString *)message ToView:(UIView *)superView;

- (void)showLoading:(NSString *)message ToView:(UIView *)superView;

- (void)hideLoading;

@end

NS_ASSUME_NONNULL_END
