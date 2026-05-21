//
//  BogoLiveGoodAddTopView.m
//  BogoShopKit
//
//  Created by Mac on 2021/8/17.
//

#import "BogoLiveGoodAddTopView.h"
#import <YYKit/YYKit.h>
#import "BogoShopKit.h"
#import <QMUIKit/QMUIKit.h>

@interface BogoLiveGoodAddTopView ()<QMUITextFieldDelegate>

@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) QMUITextField *textField;
@property(nonatomic, strong) UIButton *searchBtn;

@end

@implementation BogoLiveGoodAddTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        [self addSubview:self.searchBtn];
        [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 44));
        }];
        [self addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backBtn.mas_right);
            make.right.equalTo(self.searchBtn.mas_left);
            make.height.mas_equalTo(30);
            make.top.equalTo(self).offset(7);
        }];
    }
    return self;
}

- (void)backBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topView:didClickBackBtn:)]) {
        [self.delegate topView:self didClickBackBtn:sender];
    }
}

- (void)searchBtnAction:(UIButton *)sender{
    [self.textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(topView:didClickSearchBtn:)]) {
        [self.delegate topView:self didClickSearchBtn:self.textField.text];
    }
}

#pragma mark - QMUITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchBtnAction:self.searchBtn];
    return YES;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:imageNamed(@"shop_back") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (QMUITextField *)textField{
    if (!_textField) {
        _textField = [[QMUITextField alloc]initWithFrame:CGRectZero];
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 34, 44)];
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 14, 14)];
        leftImageView.image = imageNamed(@"shop_搜索");
        [leftView addSubview:leftImageView];
        _textField.leftView = leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.placeholder = @"搜索商品名称";
        _textField.placeholderColor = [UIColor colorWithHexString:@"#AAAAAA"];
        _textField.textColor = [UIColor colorWithHexString:@"333333"];
        _textField.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.layer.cornerRadius = 15;
        _textField.clipsToBounds = YES;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.delegate = self;
    }
    return _textField;
}

- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor colorWithHexString:@"#9F64FF"] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

@end
