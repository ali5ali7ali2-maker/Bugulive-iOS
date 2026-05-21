//
//  UIView+FD.m
//  FDUIKitObjC
//
//  Created by fandongtongxue on 2020/2/26.
//

#import "UIView+FD.h"

@implementation UIView (FD)

- (CGSize)fd_size {
    return self.frame.size;
}

- (CGFloat)fd_width {
    return self.fd_size.width;
}

- (CGFloat)fd_height {
    return self.fd_size.height;
}

- (CGPoint)fd_origin {
    return self.frame.origin;
}

- (CGFloat)fd_x {
    return self.fd_origin.x;
}

- (CGFloat)fd_y {
    return self.fd_origin.y;
}

- (CGFloat)fd_left {
    return self.fd_origin.x;
}

- (CGFloat)fd_top {
    return self.fd_origin.y;
}

- (CGFloat)fd_bottom {
    return self.fd_origin.y + self.fd_size.height;
}

- (CGFloat)fd_right {
    return self.fd_origin.x + self.fd_size.width;
}

- (void)setFd_size:(CGSize)fd_size {
    CGRect frame = self.frame;
    frame.size = fd_size;
    self.frame = frame;
}

- (void)setFd_width:(CGFloat)fd_width {
    CGSize size = self.fd_size;
    size.width = fd_width;
    self.fd_size = size;
}

- (void)setFd_height:(CGFloat)fd_height {
    CGSize size = self.fd_size;
    size.height = fd_height;
    self.fd_size = size;
}

- (void)setFd_origin:(CGPoint)fd_origin {
    CGRect frame = self.frame;
    frame.origin = fd_origin;
    self.frame = frame;
}

- (void)setFd_x:(CGFloat)fd_x {
    CGPoint origin = self.fd_origin;
    origin.x = fd_x;
    self.fd_origin = origin;
}

- (void)setFd_y:(CGFloat)fd_y {
    CGPoint origin = self.fd_origin;
    origin.y = fd_y;
    self.fd_origin = origin;
}

- (void)setFd_left:(CGFloat)fd_left {
    CGPoint origin = self.fd_origin;
    origin.x = fd_left;
    self.fd_origin = origin;
}

- (void)setFd_top:(CGFloat)fd_top{
    CGPoint origin = self.fd_origin;
    origin.y = fd_top;
    self.fd_origin = origin;
}

- (void)setFd_bottom:(CGFloat)fd_bottom {
    CGPoint origin = self.fd_origin;
    origin.y = fd_bottom - self.fd_height;
    self.fd_origin = origin;
}

- (void)setFd_right:(CGFloat)fd_right {
    CGPoint origin = self.fd_origin;
    origin.x = fd_right - self.fd_width;
    self.fd_origin = origin;
}

- (CGFloat)fd_centerX {
    return self.center.x;
}

- (void)setFd_centerX:(CGFloat)fd_centerX{
    self.center = CGPointMake(fd_centerX, self.center.y);
}

- (CGFloat)fd_centerY {
    return self.center.y;
}

- (void)setFd_centerY:(CGFloat)fd_centerY {
    self.center = CGPointMake(self.center.x, fd_centerY);
}

@end
