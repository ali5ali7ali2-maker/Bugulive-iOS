//
//  BogoSharePopView.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/10/22.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BogoPosterImgView.h"



NS_ASSUME_NONNULL_BEGIN

@interface BogoSharePopView : UIView

@property (nonatomic, strong) BogoPosterImgView *topSmView;

@property (nonatomic, strong) UIView           *container;
@property (nonatomic, strong) UIView           *posterContainerView;

@property (nonatomic, strong) UIButton         *cancel;



@property(nonatomic, strong) NSString *shareContent;

- (void)show;

- (void)dismiss;

@end

@interface ShareItem:UIView

@property (nonatomic, strong) UIImageView      *icon;
@property (nonatomic, strong) UILabel          *label;

-(void)startAnimation:(NSTimeInterval)delayTime;

@end


NS_ASSUME_NONNULL_END
