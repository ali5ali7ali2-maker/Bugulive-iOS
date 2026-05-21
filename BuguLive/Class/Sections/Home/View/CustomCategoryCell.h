//
//  CustomCategoryCell.h
//  BuguLive
//
//  Created by voidcat on 2024/7/25.
//  Copyright © 2024 xfg. All rights reserved.
//

#import "JXCategorySubTitleCell.h"
#import <JXCategoryViewExt/JXCategorySubTitleView.h>
#import <JXCategoryViewExt/JXCategoryView.h>
NS_ASSUME_NONNULL_BEGIN

@interface CustomCategoryCell : JXCategoryTitleCell
@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) NSLayoutConstraint *subTitleLabelCenterX;

@property (nonatomic, strong) UIView *backgroundView1;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *unselectedBackgroundColor;

@end
NS_ASSUME_NONNULL_END
