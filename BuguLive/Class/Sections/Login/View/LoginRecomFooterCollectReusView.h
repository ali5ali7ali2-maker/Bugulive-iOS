//
//  LoginRecomFooterCollectReusView.h
//  BuguLive
//
//  Created by bugu on 2019/12/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginRecomFooterCollectReusView : UICollectionReusableView

@property (nonatomic, copy) dispatch_block_t changeBlock;
@property (nonatomic, copy) dispatch_block_t goBlock;

@end

NS_ASSUME_NONNULL_END
