//
//  FDAction.m
//  FDFoundationObjC
//
//  Created by fandongtongxue on 2020/2/27.
//

#import "FDAction.h"

@implementation FDAction

- (instancetype)initWithTitle:(NSString *)title type:(FDActionType)type CallBack:(fd_handleAction _Nullable)fd_handleAction{
    if (self = [super init]) {
        self.title = title;
        self.fd_handleAction = fd_handleAction;
        self.type = type;
    }
    return self;
}

+ (instancetype)actionWithTitle:(NSString *)title type:(FDActionType)type CallBack:(fd_handleAction _Nullable)fd_handleActionCallBack{
    return [[FDAction alloc] initWithTitle:title type:type CallBack:fd_handleActionCallBack];
}

@end
