//
//  new_bgmitemCell.h
//  BuguLive
//
//  Created by bugu on 2019/5/25.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "music_obj.h"
@protocol new_bgmitemDelegate<NSObject>
- (void)selectItem:(music_obj *)model;
- (void)doCollection:(music_obj *)model;
@end
@interface new_bgmitemCell : UITableViewCell
@property (nonatomic, strong)music_obj *model;
@property (nonatomic, weak)id<new_bgmitemDelegate>delegate;
@end
