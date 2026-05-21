//
//  FDAction.h
//  FDFoundationObjC
//
//  Created by fandongtongxue on 2020/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^fd_handleAction)(void);

typedef NS_ENUM(NSInteger, FDActionType) {
    FDActionTypeDefault,
    FDActionTypeCancel
};

@interface FDAction : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) fd_handleAction fd_handleAction;
@property(nonatomic, assign) FDActionType type;

+ (instancetype _Nullable )actionWithTitle:(NSString *_Nullable)title type:(FDActionType)type CallBack:(fd_handleAction _Nullable )fd_handleAction;

@end

NS_ASSUME_NONNULL_END
