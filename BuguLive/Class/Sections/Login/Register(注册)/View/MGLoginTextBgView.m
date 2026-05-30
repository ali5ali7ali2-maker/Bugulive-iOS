//
//  MGLoginTextBgView.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/6/28.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "MGLoginTextBgView.h"

@implementation MGLoginTextBgView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(kRealValue(20), 0, kScreenW - kRealValue(20 * 2), kRealValue(44))];
    textField.placeholder = @"";
    textField.font = [UIFont systemFontOfSize:14];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField = textField;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kRealValue(15), textField.bottom, kScreenW - kRealValue(15 * 2), 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E1E1E1"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:ASLocalizedString(@"发送验证码")forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FF4949"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.hidden = YES;
    _codeBtn = btn;
    
    
    [self addSubview:textField];
    [self addSubview:line];
    [self addSubview:btn];
    
}

-(void)clickCodeBtn:(UIButton *)sender{
    
    if (self.type == MGREGISTER_VIEW_TYPE_COUNTRY) {
        
    }else{
        if(self.clickCodeBtnBlock) {
            self.clickCodeBtnBlock(YES);
        }
    }
}

- (void)setUpTextViewWithPlaceholder:(NSString *)placeholder text:(NSString *)text showRightBtn:(BOOL)showRightBtn type:(MGREGISTER_VIEW_TYPE)type{
    
    _type = type;
    
    if (![BGUtils isBlankString:placeholder]) {
        self.textField.placeholder = placeholder;
    }
    if (![BGUtils isBlankString:text]) {
        self.textField.text = text;
    }
    
    self.codeBtn.hidden = !showRightBtn;
    
    self.textField.frame = CGRectMake(kRealValue(15), 0, kScreenW - kRealValue(15 * 2), kRealValue(44));
    
    if (showRightBtn) {
        self.textField.width = self.textField.width - kRealValue(100);
        self.codeBtn.frame = CGRectMake(kScreenW - kRealValue(100) - kRealValue(8), 0, kRealValue(100), kRealValue(44));
        self.codeBtn.centerY = self.textField.centerY;
    }
    
    if (type == MGREGISTER_VIEW_TYPE_COUNTRY) {
        UIImageView *iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        iconImgView.image = [UIImage imageNamed:ASLocalizedString(@"中国")];

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kRealValue(40), kRealValue(20))];
        [view addSubview:iconImgView];
        self.textField.leftView = view;
        self.textField.leftViewMode = UITextFieldViewModeAlways;
        self.textField.text = text;
        self.textField.userInteractionEnabled = NO;
        [self.codeBtn setImage:[UIImage imageNamed:@"com_arrow_down_3"] forState:UIControlStateNormal];
        [self.codeBtn setTitle:@"   " forState:UIControlStateNormal];
        self.codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.codeBtn.userInteractionEnabled = NO;
    }else{
        self.textField.userInteractionEnabled = YES;
    }
    
}
    
@end
