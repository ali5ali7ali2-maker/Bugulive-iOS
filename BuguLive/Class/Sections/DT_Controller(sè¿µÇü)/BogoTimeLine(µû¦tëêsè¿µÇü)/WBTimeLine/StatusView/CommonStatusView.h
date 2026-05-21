//
//  CommonStatusView.h
//  UniversalApp
//
//  Created by bogokj on 2019/11/19.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CommonStatusViewType) {
    CommonStatusViewTypeOnline,
    CommonStatusViewTypeBlindDate,
    CommonStatusViewTypeManyPeople
};

@interface CommonStatusView : UIView

@property(nonatomic, assign) CommonStatusViewType type;

@end

NS_ASSUME_NONNULL_END
