//
//  RoomUsers.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/1.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomUsers.h"
#import "RoomUserInfo.h"

@interface RoomUsers ()

@end

@implementation RoomUsers

- (instancetype)init{
    if (self = [super init]) {
        [self setDefault];
    }
    return self;
}

- (void)addFirstUser:(RoomUserInfo *)user{
    if (!user) {
        return;
    }
    if (self.dataArray.count == 0) {
        [self.dataArray addObject:[self emptyUser]];
    }
    [self.dataArray replaceObjectAtIndex:0 withObject:user];
}

- (void)addUser:(RoomUserInfo *)user forIndex:(NSInteger)index{
    if (!user) {
        return;
    }
    if (index < 0 || index >= self.dataArray.count) {
        return;
    }
    
   //去重。 麦上用户异常退出，由于没有心跳回调，此时还在原麦位上，用户又上麦
    [self removeUser:user.user_id];
//管理员抱主播
    user.is_room = @"1";
    [self.dataArray replaceObjectAtIndex:index withObject:user];
}

- (void)removeUser:(NSString *)user_id{
    if ([self getIndexOfUser:user_id] != 100) {
        [self.dataArray replaceObjectAtIndex:[self getIndexOfUser:user_id] withObject:[self emptyUser]];
    }
}

- (void)updateUser:(NSString *)user_id volume:(NSInteger)volume{
    if ([self getIndexOfUser:user_id] != 100) {
        RoomUserInfo *user = self.dataArray[[self getIndexOfUser:user_id]];
        user.volume = volume;
    }
}

- (void)updateUser:(NSString *)user_id isMuted:(BOOL)isMuted{
    if ([self getIndexOfUser:user_id] != 100) {
        RoomUserInfo *user = self.dataArray[[self getIndexOfUser:user_id]];
        user.isMuted = isMuted;
        user.volume = 0;
        user.is_ban_voice = isMuted ? @"1" : @"0";
    }
}

- (BOOL)updateUser:(NSString *)uid is_admin:(NSString *)is_admin{
    if ([self getIndexOfUser:uid] != 100) {
        RoomUserInfo *user = [self.dataArray objectAtIndex:[self getIndexOfUser:uid]];
        user.is_admin = is_admin;
        NSLog(@"更新用户管理员状态成功");
        return YES;
    }
    NSLog(@"更新用户管理员状态失败 uid:%@",uid);
    return NO;
}
- (BOOL)updateUser:(NSString *)uid is_admin:(NSString *)is_admin purview_msg_type:(BOOL)purview_msg_type{
    if ([self getIndexOfUser:uid] != 100) {
        RoomUserInfo *user = [self.dataArray objectAtIndex:[self getIndexOfUser:uid]];
        
        if (purview_msg_type) {
            user.is_host = is_admin;

        } else {
            user.is_admin = is_admin;

        }
        NSLog(@"更新用户管理员状态成功");
        return YES;
    }
    NSLog(@"更新用户管理员状态失败 uid:%@",uid);
    return NO;
}
- (BOOL)fetchUser_isMuted:(NSString *)user_id{
    
    if ([self getIndexOfUser:user_id] != 100) {
        RoomUserInfo *user = self.dataArray[[self getIndexOfUser:user_id]];
        return user.isMuted+user.is_ban_voice.intValue;
    }
    return YES;
}


- (void)updateUser:(NSString *)user_id head_url:(NSString *)head_url{
    if ([self getIndexOfUser:user_id] != 100) {
        RoomUserInfo *user = self.dataArray[[self getIndexOfUser:user_id]];
        user.headwear_url = head_url;
    }
}

- (void)updateUser:(RoomUserInfo *)userInfo{
    
    if ([self getIndexOfUser:userInfo.user_id] != 100) {
        RoomUserInfo *user = self.dataArray[[self getIndexOfUser:userInfo.user_id]];
        user.headwear_url = userInfo.headwear_url;
//        user.mike_url = userInfo.mike_url;
        user.gift_earnings = userInfo.gift_earnings;

    }
}

- (void)removeAllUser{
    [self setDefault];
}

- (void)setDefault{
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[self emptyUser]];
    [self.dataArray addObject:[self emptyUser]];
    [self.dataArray addObject:[self emptyUser]];
    [self.dataArray addObject:[self emptyUser]];
    [self.dataArray addObject:[self emptyUser]];
    [self.dataArray addObject:[self emptyUser]];
    [self.dataArray addObject:[self emptyUser]];
    [self.dataArray addObject:[self emptyUser]];
    [self.dataArray addObject:[self emptyUser]];
    [self.dataArray addObject:[self emptyUser]];

}

- (NSInteger)getIndexOfUser:(NSString *)user_id{
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        RoomUserInfo *user = self.dataArray[i];
        if ([user.user_id isEqualToString:user_id]) {
            return i;
        }
    }
    return 100;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (RoomUserInfo *)emptyUser{
    RoomUserInfo *user = [[RoomUserInfo alloc]init];
    user.user_id = @"0";
    return user;
}

@end
