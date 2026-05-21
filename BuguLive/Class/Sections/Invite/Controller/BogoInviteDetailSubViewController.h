//
//  BogoInviteDetailSubViewController.h
//  UniversalApp
//
//  Created by Mac on 2021/6/10.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BogoInviteDetailSubViewControllerType) {
    BogoInviteDetailSubViewControllerTypeDirect = 1,
    BogoInviteDetailSubViewControllerTypeDirectIndirect,
};

@interface BogoInviteDetailSubViewController : BogoBaseViewController

@property(nonatomic, assign) BogoInviteDetailSubViewControllerType type;

@end

NS_ASSUME_NONNULL_END
