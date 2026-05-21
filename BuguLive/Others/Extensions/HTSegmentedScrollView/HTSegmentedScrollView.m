//
//  HTSegmentedScrollView.m
//  HTSegmentedScrollViewDemo
//
//  Created by iOS_zzy on 2018/3/28.
//  Copyright © 2018年 runThor. All rights reserved.
//

#import "HTSegmentedScrollView.h"

@interface HTSegmentedScrollView () <UIScrollViewDelegate>

@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UIView *segmentMarkView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *itemArr;
@end

@implementation HTSegmentedScrollView

- (void)addSegmentedItems:(NSArray *)items {
    // 分段控件
    self.itemArr = [NSMutableArray array];
    
    for (int i=0; i<items.count; i++) {
        UIButton *itemBtn = [[UIButton alloc] init];
        [itemBtn setTitle:items[i] forState:UIControlStateNormal];
        [itemBtn setTitleColor:RGB(119, 119, 119) forState:UIControlStateNormal];
        [itemBtn setTitleColor:RGB(59, 59, 59) forState:UIControlStateSelected];
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        itemBtn.selected = (i == 0);
        [itemBtn addTarget:self action:@selector(handleItemEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemBtn];
        [self.itemArr addObject:itemBtn];
    }
    
    [self.itemArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [self.itemArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@22);
        make.top.equalTo(self).offset(10);
    }];
    
    
}

- (void)handleItemEvent:(UIButton *)sender {
    for (int i =0; i<self.itemArr.count; i++) {
        UIButton *item = self.itemArr[i];
        item.selected = NO;
    }
    
    int indexPath = [self.itemArr indexOfObject:sender];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.scrollView setContentOffset:CGPointMake(indexPath * self.scrollView.frame.size.width, 0)];
    } completion:nil];
    
    sender.selected = YES;
}


- (void)addScrollViews:(NSArray *)views {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, self.frame.size.width, self.frame.size.height - 100)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * views.count, self.scrollView.frame.size.height);
    [self addSubview:self.scrollView];
    
    for (int i = 0; i < views.count; i++) {
        if (![views[i] isKindOfClass:[UIView class]]) {
            return;
        }
        
        [views[i] setFrame:CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [self.scrollView addSubview:views[i]];
    }
}

#pragma mark - Actions

// 点击分段选项
- (void)changeSegment:(UISegmentedControl *)segmentedControl {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.segmentMarkView.transform = CGAffineTransformMakeTranslation((self.segmentedControl.frame.size.width/self.segmentedControl.numberOfSegments) * segmentedControl.selectedSegmentIndex, 0);
        
        [self.scrollView setContentOffset:CGPointMake(segmentedControl.selectedSegmentIndex * self.scrollView.frame.size.width, 0)];
    } completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.segmentMarkView.transform = CGAffineTransformMakeTranslation(scrollView.contentOffset.x/scrollView.frame.size.width * (self.segmentedControl.frame.size.width/self.segmentedControl.numberOfSegments), 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.segmentedControl.selectedSegmentIndex = (int)(scrollView.contentOffset.x/scrollView.frame.size.width);
}

@end
