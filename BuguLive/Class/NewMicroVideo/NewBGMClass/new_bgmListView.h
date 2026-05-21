//
//  new_bgmListView.h
//  BuguLive
//
//  Created by bugu on 2019/5/25.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "new_bgmitemCell.h"
#import "UIView+addVideoToView.h"
//音乐列表

@protocol new_bgmSureDelegate<NSObject>
- (void)SureUseobj:(music_obj *)model;
@end
@interface new_bgmListView : UIView
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, weak)id<new_bgmSureDelegate>delegate;
@property (nonatomic, weak)AVPlayer *player;
- (void)setDatasource:(NSArray *)datasource andPage:(int)page;
@end
