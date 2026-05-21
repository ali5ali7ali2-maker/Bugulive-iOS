//
//  MGLoginTextBgView.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/6/28.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MGREGISTER_VIEW_TYPE_COUNTRY,
    MGREGISTER_VIEW_TYPE_PHONE,
    MGREGISTER_VIEW_TYPE_CODE,
    MGREGISTER_VIEW_TYPE_PASSWORD,
    MGREGISTER_VIEW_TYPE_REPASSWORD,
} MGREGISTER_VIEW_TYPE;

@interface MGLoginTextBgView : UIView

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UIButton    *codeBtn;
@property(nonatomic, assign) MGREGISTER_VIEW_TYPE type;

@property(nonatomic, copy) void (^clickCodeBtnBlock)(BOOL clickRegister);

-(void)setUpTextViewWithPlaceholder:(NSString *)placeholder text:(NSString *)text showRightBtn:(BOOL)showRightBtn type:(MGREGISTER_VIEW_TYPE)type;

@end

NS_ASSUME_NONNULL_END
