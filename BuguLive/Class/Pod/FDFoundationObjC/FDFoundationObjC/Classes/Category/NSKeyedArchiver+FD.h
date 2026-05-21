//
//  NSKeyedArchiver+FD.h
//  FDFoundationObjC
//
//  Created by 范东 on 2020/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSKeyedArchiver (FD)

+ (NSData *)fd_dataWithCustomClass:(id<NSSecureCoding>)customClassObject;

+ (id<NSSecureCoding>)fd_customInstanceFromData:(NSData *)data ForClass:(Class)classType;

@end

NS_ASSUME_NONNULL_END
