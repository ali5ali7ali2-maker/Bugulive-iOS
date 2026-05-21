//
//  CarItem.h
//  FanweApp
//
//  Created by 志刚杨 on 2017/12/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CarModel : NSObject

@end

@interface CarItemModel : NSObject
@property(nonatomic, strong) NSString *carID;
@property(nonatomic, strong) NSString *money;
@property(nonatomic, strong) NSString *experience;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *svga;
@property(nonatomic, strong) NSString *thumb;

@end
