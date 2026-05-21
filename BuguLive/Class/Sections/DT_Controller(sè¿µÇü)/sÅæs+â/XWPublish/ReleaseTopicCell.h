//
//  ReleaseTopicCell.h
//  BuguLive
//
//  Created by bugu on 2019/11/28.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGDynamicTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReleaseTopicCell : UITableViewCell
@property(nonatomic, strong) UILabel *topicLabel;
@property(nonatomic, strong) UILabel *numLabel;

@property(nonatomic, strong) MGDynamicTopicModel *topic;
@end

NS_ASSUME_NONNULL_END
