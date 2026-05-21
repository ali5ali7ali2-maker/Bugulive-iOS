//
//  BogoSearchNavTopView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSearchNavTopView.h"

@implementation BogoSearchNavTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    [self addSubview:self.searchField];
    [self addSubview:self.cancleBtn];
    self.cancleBtn.centerY = self.searchField.centerY = self.height / 2;
}

-(void)clickCancleBtn:(UIButton *)sender{
    [AppDelegate.sharedAppDelegate.topViewController.navigationController popViewControllerAnimated:YES];
}

-(UITextField *)searchField{
    if (!_searchField) {
        _searchField = [[UITextField alloc]initWithFrame:CGRectMake(kRealValue(12), 0, kScreenW - kRealValue(39) - kRealValue(22) - kRealValue(12 * 2),kRealValue(32))];
//        _searchField.text =ASLocalizedString( @"请输入搜索内容");
        _searchField.placeholder = ASLocalizedString(@"请输入搜索内容");
        _searchField.font = [UIFont systemFontOfSize:14];
        _searchField.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
        _searchField.backgroundColor = [UIColor colorWithHexString:@"#F4F5F9"];
        _searchField.layer.cornerRadius = kRealValue(32 / 2);
        _searchField.layer.masksToBounds = YES;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        imageView.image = [UIImage imageNamed:@"bogo_home_top_search"];
        imageView.center = leftView.center;
        [leftView addSubview:imageView];
        _searchField.leftView = leftView;
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        _searchField.delegate = self;
        _searchField.clearButtonMode = UITextFieldViewModeAlways;
        
        UIButton *btn = [_searchField valueForKey:@"_clearButton"];
        
        [btn setImage:[UIImage imageNamed:@"bogo_home_live_search_clear"] forState:UIControlStateNormal];
//        btn.backgroundColor = kRedColor;
//        [btn addTarget:self action:@selector(cliv) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchField;
}

-(UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setTitle:ASLocalizedString(@"取消") forState:UIControlStateNormal];
        _cancleBtn.frame = CGRectMake(kScreenW - kRealValue(60), 0, kRealValue(60), kRealValue(30));
        [_cancleBtn setTitleColor:[UIColor colorWithHexString:@"#9152F8"] forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancleBtn addTarget:self action:@selector(clickCancleBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

@end
