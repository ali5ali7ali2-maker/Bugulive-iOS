//
//  YHPlayerViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/8/29.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHPlayerViewController : BaseViewController

-(instancetype)initWithPlayerURL:(NSString *)url;
@property(nonatomic, strong) NSString *url;

@end

NS_ASSUME_NONNULL_END
