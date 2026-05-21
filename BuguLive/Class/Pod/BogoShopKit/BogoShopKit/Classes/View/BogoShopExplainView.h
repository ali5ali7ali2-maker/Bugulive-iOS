//
//  BogoShopExplainView.h
//  BogoShopKit
//
//  Created by Mac on 2021/7/5.
//

#import <UIKit/UIKit.h>
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import <SDWebImage/SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoShopExplainView : UIView


@property(nonatomic, strong) UIView *shadowView;

- (void)show:(UIView *)superView offsetY:(CGFloat)offsetY;

- (void)hide;

@property(nonatomic, strong) BogoCommodityDetailShopModel *model;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property(nonatomic, copy) void (^clickBuyBlock)(BogoCommodityDetailShopModel *model);


@end

NS_ASSUME_NONNULL_END
