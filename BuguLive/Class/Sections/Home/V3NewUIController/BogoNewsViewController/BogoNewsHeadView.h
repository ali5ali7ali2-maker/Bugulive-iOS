//
//  BogoNewsHeadView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/13.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "UIButton+Badge.h"

#import "BogoNewsTabNumModel.h"

@protocol BogoNewsHeadViewDelegate <NSObject>

-(void)clickHeadControl:(NSInteger)index;

@end


NS_ASSUME_NONNULL_BEGIN

@interface BogoNewsHeadView : UIView

@property(nonatomic, strong) id<BogoNewsHeadViewDelegate> delegate;

@property(nonatomic, strong) BogoNewsTabNumModel *model;

@end

NS_ASSUME_NONNULL_END
