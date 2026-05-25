//
//  BogoDelTextfield.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/13.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BogoDelTextfield;

@protocol ZTextFieldDelegate <NSObject>

-(void)zTextFieldDeleteBackward:(BogoDelTextfield *)textField;

@end

@interface BogoDelTextfield : UITextField

@property (nonatomic, assign) id <ZTextFieldDelegate> z_delegate;


@end

NS_ASSUME_NONNULL_END
