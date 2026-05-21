//
//  NSDate+FD.h
//  FDFoundationObjC
//
//  Created by fandongtongxue on 2020/2/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (FD)


/// 当前时间戳
- (NSString *)fd_currentTimestamp;


/// 时间戳转时间
/// @param timestamp 时间戳
+ (NSString *)fd_getTimeFromTimestamp:(double)timestamp;

+ (NSString *)fd_getTimeSimpleFromTimestamp:(double)timestamp;

+ (NSString *)fd_getHHmmTimeFromTimestamp:(double)timestamp;


@end

NS_ASSUME_NONNULL_END
