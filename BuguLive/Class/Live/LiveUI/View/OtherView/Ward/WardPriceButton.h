//
//  WardPriceButton.h
//  BuguLive
//
//  Created by 范东 on 2019/1/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WardPriceButton : UIControl

@property (nonatomic, strong) NSArray *type_name;
@property (nonatomic, strong) NSDictionary *dict;

- (void)setSelected:(BOOL)selected;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
