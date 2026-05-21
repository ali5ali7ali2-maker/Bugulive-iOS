//
//  BGVideoGiftAnimationView.h
//  BuguLive
//
//  Created by Mac on 2021/8/13.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GiftModel;
@class BGVideoGiftAnimationView;

NS_ASSUME_NONNULL_BEGIN

@protocol BGVideoGiftAnimationViewDelegate <NSObject>

- (void)animationView:(BGVideoGiftAnimationView *)animationView didFinishAnimation:(GiftModel *)model;

@end

@interface BGVideoGiftAnimationView : UIView

@property(nonatomic, strong) GiftModel *giftModel;

@property(nonatomic, weak) id<BGVideoGiftAnimationViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
