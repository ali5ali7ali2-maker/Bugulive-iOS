//
//  MGSignCollectCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/21.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BGSignModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGSignCollectCell : UICollectionViewCell
@property(nonatomic, strong) BGSignRewardModel *model;
@property(nonatomic, assign) BOOL alreadySign;

@end

NS_ASSUME_NONNULL_END
