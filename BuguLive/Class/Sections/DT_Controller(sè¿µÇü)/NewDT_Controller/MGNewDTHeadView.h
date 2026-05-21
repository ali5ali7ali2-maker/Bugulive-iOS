//
//  MGNewDTHeadView.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/11/26.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGDynamicTopicModel.h"



NS_ASSUME_NONNULL_BEGIN

@class MGNewDTHeadControl;

@interface MGNewDTHeadView : UIView
@property(nonatomic, strong) UIView *firstView;
@property(nonatomic, strong) UIView *topicView;
@property(nonatomic, strong) UIScrollView *titleScroll;

@property(nonatomic, strong) NSMutableArray *tpicControlArr;
@property(nonatomic, strong) NSMutableArray *topicArr;

-(void)resetTopicModel:(NSArray *)arr;

@property(nonatomic, copy) void (^MGNewDTHeadViewTopicBlock)(NSInteger index);

@end


@interface MGNewDTHeadControl : UIControl

@property(nonatomic, strong) QMUIButton *topicTitleBtn;

@property(nonatomic, strong) UIImageView *bgImgView;
@property(nonatomic, strong) UILabel *timeL;

-(void)resetControlModel:(MGDynamicTopicModel *)model;

@end

NS_ASSUME_NONNULL_END
