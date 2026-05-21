//
//  SignCollectCell.h
//  BuguLive
//
//  Created by bugu on 2019/11/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGSignModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SignCollectCell : UICollectionViewCell
@property(nonatomic, strong) BGSignRewardModel *model;
@property(nonatomic, assign) BOOL alreadySign;
@end

NS_ASSUME_NONNULL_END
