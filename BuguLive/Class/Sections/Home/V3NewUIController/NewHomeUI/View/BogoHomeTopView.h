//
//  BogoHomeTopView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/18.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//点击直播的代理
@protocol BogoHomeTopViewDelegate <NSObject>

-(void)clickLiveBtn;

@end




@interface BogoHomeTopView : UIView<UITextFieldDelegate>

@property(nonatomic, strong) UIImageView *topImgView;
@property(nonatomic, strong) UIButton    *msgBtn;
@property(nonatomic, strong) UITextField    *searchField;

@property(nonatomic, weak) id<BogoHomeTopViewDelegate> delegate;



@end

NS_ASSUME_NONNULL_END
