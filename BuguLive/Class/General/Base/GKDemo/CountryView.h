//
//  CountryView.h
//  BuguLive
//
//  Created by voidcat on 2024/9/18.
//  Copyright © 2024 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountryView : UIView

- (instancetype)initWithFrame:(CGRect)frame countries:(NSArray<NSDictionary *> *)countries;
//block
@property (nonatomic, copy) void (^countryBlock)(NSDictionary *country);
@end


NS_ASSUME_NONNULL_END
