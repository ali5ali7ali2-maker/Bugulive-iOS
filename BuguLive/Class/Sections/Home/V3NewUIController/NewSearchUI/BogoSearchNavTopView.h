//
//  BogoSearchNavTopView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoSearchNavTopView : UIView<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *searchField;
@property(nonatomic, strong) UIButton *cancleBtn;


@end

NS_ASSUME_NONNULL_END
