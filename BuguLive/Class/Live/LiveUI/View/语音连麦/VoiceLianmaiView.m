//
//  VoiceLianmaiView.m
//  BuguLive
//
//  Created by 志刚杨 on 2022/10/13.
//  Copyright © 2022 xfg. All rights reserved.
//

#import "VoiceLianmaiView.h"

@interface VoiceLianmaiView ()

@end

@implementation VoiceLianmaiView
{

}
#pragma mark - LifeCycle
- (void)dealloc {
    [self removeNotificationObserver];
}

- (void)setTotalVolume:(NSInteger)totalVolume
{
    _totalVolume = totalVolume;
    if(_totalVolume > 10)
    {
        _yyimg.hidden = NO;
    }
    else
    {
        _yyimg.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
     //设置view
     [self setupView];
    
     //请求数据
     [self requestData];
    self.micbutton.userInteractionEnabled = NO;
     //设置通知
     [self addNotificationObserver];
    ViewRadius(self.headImageView, kRealValue(50)/2);
    
    
    _yyimg = [[YYAnimatedImageView alloc] init];
    _yyimg.image = [YYImage imageNamed:@"mic_pppp.webp"];
    self.backgroundColor = kClearColor;
    _yyimg.backgroundColor = kClearColor;
    _yyimg.hidden = YES;
    [self addSubview:_yyimg];
    [_yyimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self).offset(20);
        make.height.equalTo(self).offset(20);
    }];
    
    [self sendSubviewToBack:_yyimg];
    
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
