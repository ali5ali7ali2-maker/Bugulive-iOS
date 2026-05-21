//
//  BGSoundEffectCell.h
//  BuguLive
//
//  Created by bugu on 2019/12/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGSoundEffectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGSoundEffectCell : UICollectionViewCell

@property(nonatomic, strong) BGSoundEffectModel *model;
//2020-1-2 点击播放某个音效
@property(nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
