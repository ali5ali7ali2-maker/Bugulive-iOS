//
//  BogoLiveGoodAddTopView.h
//  BogoShopKit
//
//  Created by Mac on 2021/8/17.
//

#import <UIKit/UIKit.h>
@class BogoLiveGoodAddTopView;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoLiveGoodAddTopViewDelegate <NSObject>

- (void)topView:(BogoLiveGoodAddTopView *)topView didClickBackBtn:(UIButton *)sender;
- (void)topView:(BogoLiveGoodAddTopView *)topView didClickSearchBtn:(NSString *)key;

@end

@interface BogoLiveGoodAddTopView : UIView

@property(nonatomic, weak) id<BogoLiveGoodAddTopViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
