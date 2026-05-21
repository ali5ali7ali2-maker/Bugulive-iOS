//
//  SVGAAnimate.h
//  FanweApp
//
//  Created by 志刚杨 on 2017/12/26.
//  Copyright © 2017年 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimateConfigModel.h"

@protocol SVGAViewDelegate <NSObject>
@required

- (void)SVGAViewFinish:(CustomMessageModel *)animateConfigModel andSenderName:(NSString *)senderName;

@end

@interface SVGAAnimate : UIView

@property (nonatomic, weak) id<SVGAViewDelegate> delegate;
@property (nonatomic, strong) CustomMessageModel *giftItem;

- (id)initWithModel:(CustomMessageModel*)gift inView:(UIView*)superView andSenderName:(NSString *)senderName;

+ (void) showGift:(CustomMessageModel*)gift inVc:(UIViewController*)vc;
@end
