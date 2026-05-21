@implementation UIView (RTL)
- (void)setRtlOverturned:(BOOL)rtlOverturned {
    objc_setAssociatedObject(self, @selector(rtlOverturned), @(rtlOverturned), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rtlOverturned {
    return [objc_getAssociatedObject(self, @selector(rtlOverturned)) boolValue];
}
- (CGFloat)leading {
    NSAssert(self.superview != nil, @"使用leading必须当前view添加到superView！");
    if ([self isRTL]) {
        return self.superview.width - self.right;
    }
    return self.left;
}

- (void)setLeading:(CGFloat)leading {
    NSAssert(self.superview != nil, @"使用leading必须当前view添加到superView！");
    if ([self isRTL]) {
        self.right = self.superview.width - leading;
    } else {
        self.left = leading;
    }
}

- (CGFloat)trailing {
    NSAssert(self.superview != nil, @"使用trailing必须当前view添加到superView！");
    if ([self isRTL]) {
        return self.leading + self.width;
    }
    return self.right;
}

- (void)setTrailing:(CGFloat)trailing {
    NSAssert(self.superview != nil, @"使用trailing必须当前view添加到superView！");
    if ([self isRTL]) {
        self.right = self.superview.width - trailing + self.width;
    } else {
        self.left = trailing - self.width;
    }
}

- (void)checkOverturn {
    // 避免重复翻转
    if (self.rtlOverturned) {
        return;
    }
    self.rtlOverturned = YES;
    // 基于transform翻转
    self.transform = CGAffineTransformScale(self.transform, -1, 1);
}

-(BOOL)isRTL
{
    return [UIView appearance].semanticContentAttribute == UISemanticContentAttributeForceRightToLeft;

}

@end
