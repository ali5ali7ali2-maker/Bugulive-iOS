//
//  FDModel.m
//  FDFoundationObjC
//
//  Created by fandongtongxue on 2020/2/26.
//

#import "FDModel.h"
#import <MJExtension/MJExtension.h>

@implementation FDModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%s",__func__);
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@",self.mj_keyValues];
}

@end
