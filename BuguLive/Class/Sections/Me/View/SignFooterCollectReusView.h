//
//  SignFooterCollectReusView.h
//  BuguLive
//
//  Created by bugu on 2019/11/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignFooterCollectReusView : UICollectionReusableView

@property(nonatomic, strong) UIButton *signBtn;
@property(nonatomic, assign) BOOL alreadySign;

@property (nonatomic, copy) dispatch_block_t signBlock;

@end

NS_ASSUME_NONNULL_END
