//
//  NSString+FD.h
//  FDFoundationObjC
//
//  Created by fandongtongxue on 2020/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FD)

- (CGSize)fd_textSizeIn:(CGSize)size font:(UIFont *)font;

- (CGSize)fd_textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)breakMode;

- (CGSize)fd_textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)abreakMode align:(NSTextAlignment)alignment;

- (NSString *)md5;

@end

NS_ASSUME_NONNULL_END
