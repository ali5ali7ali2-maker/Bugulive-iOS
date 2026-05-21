//
//  NSDate+FD.m
//  FDFoundationObjC
//
//  Created by fandongtongxue on 2020/2/29.
//

#import "NSDate+FD.h"

@implementation NSDate (FD)

- (NSString *)fd_currentTimestamp{
    long timestamp = [self timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld",timestamp];
}

+ (NSString *)fd_getTimeFromTimestamp:(double)timestamp{
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

+ (NSString *)fd_getTimeSimpleFromTimestamp:(double)timestamp{
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd"];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}
+ (NSString *)fd_getHHmmTimeFromTimestamp:(double)timestamp{
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}
@end
