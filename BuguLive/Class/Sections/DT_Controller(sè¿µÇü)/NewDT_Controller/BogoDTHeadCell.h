//
//  BogoDTHeadCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGDynamicTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoDTHeadCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *topicTitleBtn;


-(void)resetControlModel:(MGDynamicTopicModel *)model;


@end

NS_ASSUME_NONNULL_END
