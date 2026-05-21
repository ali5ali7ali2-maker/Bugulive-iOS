//
//  RoomPasswordView.m
//  BuguLive
//
//  Created by voidcat on 2024/5/20.
//  Copyright © 2024 xfg. All rights reserved.
//

#import "RoomPasswordView.h"

@interface RoomPasswordView ()

@end

@implementation RoomPasswordView

#pragma mark - LifeCycle
- (void)dealloc {
    [self removeNotificationObserver];
}

- (void)awakeFromNib {
    [super awakeFromNib];
     //设置view
     [self setupView];
    
     //请求数据
     [self requestData];
     
     //设置通知
     [self addNotificationObserver];
}

#pragma mark - View
- (void)setupView {
    
    self.labPassword.text = ASLocalizedString(@"输入密码");
    self.txtPassword.placeholder = ASLocalizedString(@"输入密码");
    self.txtPassword.placeholderColor = [UIColor colorWithHexString:@"#999999"];
    //设置UISwich 颜色
    self.swcPassword.onTintColor = [UIColor colorWithHexString:@"#CCCCCC"];
    
    self.swcPassword.tintColor = [UIColor colorWithHexString:@"#CCCCCC"];
    self.txtPassword.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    ViewRadius(self.txtPassword, 10);
    
    //监听self.labPassword
    [self.txtPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if(textField.text.length > 0)
    {
        self.swcPassword.on = YES;
    }
    else
    {
        self.swcPassword.on = NO;
    }
}
- (IBAction)swChanged:(UISwitch *)sender {
    if(!sender.on)
    {
        self.txtPassword.text = @"";
    }
}


#pragma mark - Network
- (void)requestData {
    
}

#pragma mark- Delegate
#pragma mark UITableDatasource & UITableviewDelegate


#pragma mark - Private


#pragma mark - Event


#pragma mark - Public


#pragma mark - NSNotificationCenter
- (void)addNotificationObserver {
    
}

- (void)removeNotificationObserver {
    
}

#pragma mark - Setter


#pragma mark - Getter


@end
