//
//  FDNetworkResponseModel.m
//  FDNetworkObjC
//
//  Created by 范东 on 2020/3/8.
//

#import "FDNetworkResponseModel.h"

@implementation FDNetworkResponseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"类名:%@未定义的键%@",NSStringFromClass([self class]),key);
}

@end
