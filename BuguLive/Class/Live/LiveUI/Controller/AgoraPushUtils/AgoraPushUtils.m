//
//  AgoraPushUtils.m
//  BuguLive
//
//  Created by 志刚杨 on 2022/6/25.
//  Copyright © 2022 xfg. All rights reserved.
//

#import "AgoraPushUtils.h"

@implementation AgoraPushUtils
+(AgoraLiveTranscoding *)getLiveHostTranscoding:(NSString *)uid
{
    AgoraLiveTranscoding *mTranscoding = [[AgoraLiveTranscoding alloc] init];
    CGSize size = CGSizeMake(720, 1280);
    mTranscoding.size = size;
    
    AgoraLiveTranscodingUser *mTranscodingMainHostUser = [[AgoraLiveTranscodingUser alloc] init];
    mTranscodingMainHostUser.uid = uid.intValue;
    mTranscodingMainHostUser.rect = CGRectMake(0, 0, 720, 1280);
    [mTranscoding addUser:mTranscodingMainHostUser];
    return mTranscoding;
}

+(void)setLianMaiTranscodingUser:(AgoraLiveTranscoding *)transcoding nowNum:(int)nowNum uid:(NSString *)uid
{
    AgoraLiveTranscodingUser *transcodingUser = [[AgoraLiveTranscodingUser alloc] init];
    transcodingUser.uid = uid.intValue;
    int width = transcoding.size.width / 4;
    int height = width *1.5;
    int x = transcoding.size.width - width - width/2;
    int y = 1280 - ((nowNum) * height + nowNum * 10);
    transcodingUser.rect = CGRectMake(x, y, width, height);
    transcodingUser.zOrder = 100;
    NSLog(@"设置用户 = %@",NSStringFromCGRect(transcodingUser.rect));
    [transcoding addUser:transcodingUser];
}
+(AgoraLiveTranscoding *)getPKLiveTranscodingLeftUid:(NSString *)leftUid rightUid:(NSString *)rightUid
{
    NSMutableArray *transcodingUsers = [NSMutableArray array];
    int sHeight = kScreenH;
    // 自己的PK视图
    int height = 720 / 16 * 9;
    int y = (int) (1280 / 10 * 2.5);
    AgoraLiveTranscoding *mTranscodingPK = [AgoraLiveTranscoding new];
    mTranscodingPK.size = CGSizeMake(720, 1280);
    
    AgoraLiveTranscodingUser *transcodingLeftUser = [AgoraLiveTranscodingUser new];
    transcodingLeftUser.uid = leftUid.intValue;
    transcodingLeftUser.rect = CGRectMake(0, y, mTranscodingPK.size.width / 2, height);
    
    AgoraLiveTranscodingUser *transcodingRightUser = [AgoraLiveTranscodingUser new];
    transcodingRightUser.uid = rightUid.intValue;
    transcodingRightUser.rect = CGRectMake(mTranscodingPK.size.width / 2, y, mTranscodingPK.size.width / 2, height);
    [transcodingUsers addObject:transcodingLeftUser];
    [transcodingUsers addObject:transcodingRightUser];
    [mTranscodingPK setTranscodingUsers:transcodingUsers];
    
    return mTranscodingPK;
}

@end
