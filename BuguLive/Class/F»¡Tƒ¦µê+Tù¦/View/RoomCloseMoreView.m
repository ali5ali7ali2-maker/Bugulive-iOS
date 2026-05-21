//
//  RoomCloseMoreView.m
//  UniversalApp
//
//  Created by voidcat on 2023/12/27.
//  Copyright © 2023 voidcat. All rights reserved.
//

#import "RoomCloseMoreView.h"

@interface RoomCloseMoreView ()

@end

@implementation RoomCloseMoreView

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
    
//    NSArray *buttomTitle = @[@"Minimize", @"Share", @"Close", @"Cancel"];
    NSArray *buttomTitle = @[@"", @"", @"", @""];

    NSArray *buttonList = @[self.shareBtn, self.colseBtn ,self.cancelBtn];
    int i = 0;
    for (QMUIButton *button in buttonList) {
        button.imagePosition = QMUIButtonImagePositionTop;
        button.spacingBetweenImageAndTitle = 15;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:buttomTitle[i] forState:UIControlStateNormal];
        i++;
    }
    
}

#pragma mark - View
- (void)setupView {
    
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
