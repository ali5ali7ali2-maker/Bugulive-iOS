//
//  BogoVideoModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/20.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoVideoModel : NSObject

+ (NSArray<BogoVideoModel *> *)testItems;
+ (NSArray<BogoVideoModel *> *)testItemsWithCount:(NSInteger)count;
+ (instancetype)testItem;

@property (nonatomic) NSInteger id;
@property (nonatomic, copy, nullable) NSString *mediaTitle;
@property (nonatomic, copy, nullable) NSString *cover;
@property (nonatomic, copy, nullable) NSString *avatar;
@property (nonatomic, copy, nullable) NSString *username;
@property (nonatomic, strong, nullable) NSURL *URL;

@end

NS_ASSUME_NONNULL_END
