//
//  UIButton+AppLocale.m
//  Pods
//
//  Created by Yeung Yiu Hung on 19/2/2016.
//
//

#import "UIButton+AppLocale.h"

@implementation UIButton (AppLocale)

- (void)setLocalizedString{
//    if ([self respondsToSelector:@selector(localizedKey)] && self.localizedKey.length != 0) {
//        [self setTitle:AMLocalizedString(self.localizedKey, nil) forState:UIControlStateNormal];
//    }
    
    [self setTitle:ASLocalizedString(self.titleLabel.text) forState:UIControlStateNormal];
    
    [LocalizationSystem checkXibString:self.titleLabel.text];
}

@end
