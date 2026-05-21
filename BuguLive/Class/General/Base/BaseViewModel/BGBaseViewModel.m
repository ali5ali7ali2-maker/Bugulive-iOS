//
//  BGBaseViewModel.m
//  BuguLive
//
//  Created by xfg on 2017/5/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseViewModel.h"

@implementation BGBaseViewModel

- (NetHttpsManager *)httpsManager
{
    if (!_httpsManager)
    {
        _httpsManager = [NetHttpsManager manager];
    }
    return _httpsManager;
}

- (GlobalVariables *)BuguLive
{
    if (!_BuguLive)
    {
        _BuguLive = [GlobalVariables sharedInstance];
    }
    return _BuguLive;
}

@end
