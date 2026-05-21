//
//  SVGAAnimationView.h
//  SVGADemo
//
//  Created by bogokj on 2020/10/11.
//

#import <UIKit/UIKit.h>
@class SVGAAnimationView;
@class GiftModel;

NS_ASSUME_NONNULL_BEGIN

@protocol SVGAAnimationViewDelegate <NSObject>

- (void)svgaAnimationView:(SVGAAnimationView *)svgaAnimationView didFinishAnimation:(GiftModel *)msgModel;

@end

@interface SVGAAnimationView : UIView

@property(nonatomic, strong) GiftModel *giftModel;

@property(nonatomic, weak) id<SVGAAnimationViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
