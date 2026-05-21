//
//  SmallVideoViewController.h
//  BuguLive
//
//  Created by 范东 on 2019/1/21.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SmallVideoViewController : BGBaseViewController

@property (nonatomic, assign) BOOL isHiddenTabbar;
@property (nonatomic, strong) SegmentView     *segmentView;
@property (nonatomic, strong) SegmentView     *listSegmentView;
@property (nonatomic, copy) NSString          *user_id;

@end

NS_ASSUME_NONNULL_END
