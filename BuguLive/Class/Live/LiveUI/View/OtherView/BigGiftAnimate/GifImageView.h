//
//  GifImageView.h
//  iChatView
//
//  Created by ldh on 16/6/3.
//  Copyright © 2016年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimateConfigModel.h"

@protocol GifImageViewDelegate <NSObject>
@required

- (void)gifImageViewFinish:(AnimateConfigModel *)animateConfigModel andSenderName:(NSString *)senderName;
- (void)gifImageViewFinish2:(GiftModel *)giftModel andSenderName:(NSString *)senderName;

@end

@interface GifImageView : UIView

@property (nonatomic, weak) id<GifImageViewDelegate>    delegate;
@property (nonatomic, strong) AnimateConfigModel        *giftItem;
@property (nonatomic, strong) GiftModel        *giftModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;

- (id)initWithModel:(AnimateConfigModel*)gift inView:(UIView*)superView andSenderName:(NSString *)senderName;
- (id)initWithModel2:(GiftModel*)gift inView:(UIView*)superView andSenderName:(NSString *)senderName;

@end
