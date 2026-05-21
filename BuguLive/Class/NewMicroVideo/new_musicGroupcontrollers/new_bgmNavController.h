//
//  new_bgmNavController.h
//  BuguLive
//
//  Created by bugu on 2019/5/27.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "music_obj.h"
@interface new_bgmNavController : UINavigationController
@property (nonatomic, copy)void(^useMusicBlock)(music_obj *model);
@end
