//
//  TrueLoveButton.m
//  BuguLive
//
//  Created by 志刚杨 on 2022/4/26.
//  Copyright © 2022 xfg. All rights reserved.
//

#import "TrueLoveButton.h"

@interface TrueLoveButton ()

@end

@implementation TrueLoveButton

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
    
//    self.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.15];

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
