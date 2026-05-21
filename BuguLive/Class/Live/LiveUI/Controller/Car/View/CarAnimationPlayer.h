//
//  CarAnimationPlayer.h
//  FanweApp
//
//  Created by 志刚杨 on 2017/12/20.
//  Copyright © 2017年 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGA.h"
#import "UserModel.h"
@protocol CarAnimationPlayerDelegate <NSObject>
@optional
-(void)CarAnimationHiddenPlayerDelegate;
@end
@interface CarAnimationPlayer : UIView
@property (nonatomic, strong) SVGAPlayer *aPlayer;
@property (nonatomic, strong) UIImageView *titleView;
-(void)setContent:(UserModel *)userModel;
@property(nonatomic, weak) id<CarAnimationPlayerDelegate> delegate;
@end
