//
//  MGGroupBottomCellView.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/4/23.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QMUIButton.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MGBotViewDelegate <NSObject>

- (void)onComment;
- (void)onLike;
- (void)onShare;

@end


@interface MGGroupBottomCellView : UIView

@property(nonatomic, strong) QMUIButton *btnLike;
@property(nonatomic, strong) QMUIButton *btnComment;
@property(nonatomic, strong) QMUIButton *btnShare;

@property (nonatomic,weak)id<MGBotViewDelegate>delegate;

-(void)resetBottomViewWithComment:(NSString *)comment likes:(NSString *)likes;

@end

NS_ASSUME_NONNULL_END
