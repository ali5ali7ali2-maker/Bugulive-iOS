//
//  GiftGroupView.h
//  BuguLive
//
//  Created by 范东 on 2019/1/28.
//  Copyright © 2019 xfg. All rights reserved.
//  礼物分组视图

#import "BGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickGiftGroupBtnBlock)(NSInteger index);

@interface GiftGroupView : UIControl
//BGBaseView


/**
 初始化方法
 
 @param frame frame
 @param titleArray 标题数组
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame TitleArray:(NSArray *)titleArray;

- (void)setClickGiftGroupBtnBlock:(clickGiftGroupBtnBlock)clickGiftGroupBtnBlock;

/**
 设置当前选中index
 
 @param index index
 */
- (void)resetIndexs:(NSInteger)index;

//@property(nonatomic, assign) NSInteger indexs;

@end

NS_ASSUME_NONNULL_END
