//
//  FocusHeaderCollectReusView.h
//  BuguLive
//
//  Created by bugu on 2019/11/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FocusHeaderCollectReusView : UICollectionReusableView
@property(nonatomic, assign) NSInteger section;
@property (nonatomic, copy) dispatch_block_t randomBlock;

@end

NS_ASSUME_NONNULL_END
