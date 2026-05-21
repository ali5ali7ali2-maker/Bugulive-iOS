//
//  WardPrivilegeButton.h
//  BuguLive
//
//  Created by 范东 on 2019/2/1.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WardPrivilegeButton : UIControl

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) NSDictionary *dict;

@end

NS_ASSUME_NONNULL_END
