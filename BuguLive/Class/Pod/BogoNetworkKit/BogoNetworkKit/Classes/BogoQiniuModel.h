//
//  BogoQiniuModel.h
//  BogoNetworkKit
//
//  Created by bogokj on 2020/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoQiniuModel : NSObject

@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *domain;
@property(nonatomic, copy) NSString *bucket;

@end

NS_ASSUME_NONNULL_END
