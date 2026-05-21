//
//  RoomUsers.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/1.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RoomUserInfo;

NS_ASSUME_NONNULL_BEGIN

@interface RoomUsers : NSObject

@property(nonatomic, strong) NSMutableArray *dataArray;

- (void)addFirstUser:(RoomUserInfo *)user;

- (void)addUser:(RoomUserInfo *)user forIndex:(NSInteger)index;

- (void)removeUser:(NSString *)uid;

- (void)updateUser:(NSString *)uid volume:(NSInteger)volume;

- (void)updateUser:(NSString *)uid isMuted:(BOOL)isMuted;

- (BOOL)updateUser:(NSString *)uid is_admin:(NSString *)is_admin;

- (BOOL)updateUser:(NSString *)uid is_admin:(NSString *)is_admin purview_msg_type:(BOOL)purview_msg_type;
//获取麦上用户麦克风状态
- (BOOL)fetchUser_isMuted:(NSString *)user_id;

- (void)removeAllUser;

- (NSInteger)getIndexOfUser:(NSString *)uid;

- (void)updateUser:(NSString *)user_id head_url:(NSString *)head_url;

- (void)updateUser:(RoomUserInfo *)userInfo;



@end

NS_ASSUME_NONNULL_END
