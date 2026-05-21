//
//  Classification_view.h
//  iphoneLive
//
//  Created by bugu on 2018/12/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClassificationDelegate <NSObject>
- (void)didSelectWith:(id)obj andxiabiao:(NSInteger)index;
- (void)showAllClass;
@end
@interface Classification_view : UIView
@property (nonatomic,strong)UIScrollView *scrollview;
@property (nonatomic,weak)id<ClassificationDelegate>delegate;
@property (nonatomic,copy)NSArray *data_ary;
- (void)setClassWithAry:(NSArray *)ary;
- (void)selectWithIndex:(NSInteger )index;

+ (CGFloat)backWidthWithNeiRong:(NSString *)msg andFont:(UIFont *)font;
@end
