//
//  WardTipView.h
//  BuguLive
//
//  Created by 范东 on 2019/2/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^tipWebViewDidFinishLoadBlock)();

@interface GamePopView : BGBaseView

- (void)setURL:(NSString *)url;

- (void)show:(UIView *)superView;

- (void)hide;

- (void)setTipWebViewDidFinishLoadBlock:(tipWebViewDidFinishLoadBlock)tipWebViewDidFinishLoadBlock;

@end

NS_ASSUME_NONNULL_END
