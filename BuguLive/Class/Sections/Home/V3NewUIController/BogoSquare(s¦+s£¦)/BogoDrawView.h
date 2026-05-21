//
//  BogoDrawView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/7/31.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoDrawView : UIView


- (instancetype)initStartPoint:(CGPoint)startPoint
                   middlePoint:(CGPoint)middlePoint
                      endPoint:(CGPoint)endPoint
                         color:(UIColor*)color;


@end

NS_ASSUME_NONNULL_END
