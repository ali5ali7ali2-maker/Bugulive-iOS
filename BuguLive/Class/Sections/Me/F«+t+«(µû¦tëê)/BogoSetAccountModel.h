//
//  BogoSetAccountModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/28.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoSetAccountModel : NSObject

@property(nonatomic, strong) NSString *mobile;
@property(nonatomic, strong) NSString *tel_code;
@property(nonatomic, strong) NSString *QQ;
@property(nonatomic, strong) NSString *wx;
@property(nonatomic, strong) NSString *is_young;

@property(nonatomic, strong) NSString *diamonds;
@property(nonatomic, strong) NSString *ticket;

@end

NS_ASSUME_NONNULL_END
