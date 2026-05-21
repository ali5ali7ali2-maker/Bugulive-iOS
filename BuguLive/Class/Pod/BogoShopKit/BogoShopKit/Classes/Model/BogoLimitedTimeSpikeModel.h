//
//  BogoLimitedTimeSpikeModel.h
//
//
//  Created by JSONConverter on 2021/07/15.
//  Copyright © 2021年 JSONConverter. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BogoLimitedTimeSpikeModel: NSObject
@property (nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *currentTime;

@property(nonatomic, assign) NSInteger min;

@end
