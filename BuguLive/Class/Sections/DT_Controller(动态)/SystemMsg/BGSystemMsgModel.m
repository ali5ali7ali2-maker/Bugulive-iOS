//
//  BGSystemMsgModel.m
//  BuguLive
//
//  Created by bugu on 2019/12/16.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGSystemMsgModel.h"

@implementation BGSystemMsgModel

- (NSString *)getTimeStr
{
    return [BGUtils formatTime:self.addtime];
}

@end
