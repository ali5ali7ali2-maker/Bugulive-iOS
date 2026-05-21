//
//  NSKeyedArchiver+FD.m
//  FDFoundationObjC
//
//  Created by 范东 on 2020/3/13.
//

#import "NSKeyedArchiver+FD.h"

@implementation NSKeyedArchiver (FD)

+ (NSData *)fd_dataWithCustomClass:(id<NSSecureCoding>)customClassObject{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver setRequiresSecureCoding:YES];
    [archiver encodeObject:customClassObject forKey:NSKeyedArchiveRootObjectKey];
    [archiver finishEncoding];
    return data;
}

+ (id<NSSecureCoding>)fd_customInstanceFromData:(NSData *)data ForClass:(Class)classType{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    [unarchiver setRequiresSecureCoding:YES];
    
    return [unarchiver decodeObjectOfClass:[classType class] forKey:NSKeyedArchiveRootObjectKey];
}

@end
