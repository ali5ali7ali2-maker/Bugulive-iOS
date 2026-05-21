//
//  BogoVideoPlayViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/20.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <SJVideoPlayer/SJVideoPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoVideoPlayViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong, readonly) UITableView *tableView;
//@property (nonatomic, strong, nullable) SJVideoPlayer *player;

-(instancetype)initWithModelArr:(NSMutableArray *)arr;

@end

NS_ASSUME_NONNULL_END
