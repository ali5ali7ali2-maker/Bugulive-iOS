//
//  SegmentView.m
//  live
//
//  Created by hysd on 15/8/19.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "SegmentView.h"

@interface SegmentView()
{
    int _itemCount;
}

@property(nonatomic, strong) UIView *indicatorView;

@end


@implementation SegmentView

- (id)initWithFrame:(CGRect)frame andItems:(NSArray*)items andSize:(NSInteger)size border:(BOOL)border isrankingRist:(BOOL)isrankingRist
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _itemCount = (int)items.count;
        self.segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        for(int index = 0; index < items.count; index++)
        {
            [self.segmentControl insertSegmentWithTitle:items[index] atIndex:index animated:NO];
        }
        self.segmentControl.selectedSegmentIndex = 1;
        self.segmentControl.tintColor = kWhiteColor;
        self.segmentControl.backgroundColor = kClearColor;
        [self.segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/(4*items.count), frame.size.height-3, kRealValue(20), 3)];
        _indicatorView.backgroundColor = kWhiteColor;
        _indicatorView.layer.cornerRadius = 3 / 2;
        _indicatorView.layer.masksToBounds = YES;
        _indicatorView.hidden = YES;
        if (isrankingRist)
        {
            NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:size + 2], NSForegroundColorAttributeName: kWhiteColor};
            [self.segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
            NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:size], NSForegroundColorAttributeName: kWhiteColor};
            [self.segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
            _indicatorView.hidden = NO;
        }
        else
        {
            NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:size], NSForegroundColorAttributeName: kWhiteColor};
            [self.segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
            NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: kWhiteColor};
            [self.segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
            
        }
        
        
        
        UIColor *Stock_Red = kClearColor;
        
        if (@available(iOS 13.0, *)) {
            _segmentControl.selectedSegmentTintColor = Stock_Red;
        } else {
            _segmentControl.tintColor = Stock_Red;
        }
        // 以下代码可以代替上面：
        [_segmentControl setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
       [_segmentControl setBackgroundImage:[UIImage imageWithColor:kClearColor] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        
//        if (!isrankingRist) {
//            [_segmentControl setImage:[UIImage imageNamed:@"du_voice_background"] forSegmentAtIndex:1];
////             setBackgroundImage:[UIImage imageNamed:@"du_voice_background"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//        }
        
        //去掉中间的分割线
        [_segmentControl setDividerImage:[UIImage imageWithColor:[UIColor clearColor]] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        [self addSubview:self.segmentControl];
        if(border)
        {
            UIView* sep = [[UIView alloc] initWithFrame:CGRectMake(0, self.segmentControl.frame.size.height-1, self.segmentControl.frame.size.width, 1)];
            sep.backgroundColor = kWhiteColor;
            [self.segmentControl addSubview:sep];
        }
        [self.segmentControl addSubview:_indicatorView];
    }
    return self;
}

- (void)setIsBlack:(bool)isBlack{
    NSDictionary* selectedTextAttributes = @{ NSForegroundColorAttributeName: [UIColor colorWithHexString:@"887BFF"]};
    [self.segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{ NSForegroundColorAttributeName: kBlackColor};
    [self.segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
}

- (void)segmentChanged:(UISegmentedControl *)sender
{
    
//    self.underLine.frame.origin.x = CGFloat(index) * self.view.frame.size.width/5 + self.view.frame.size.width/10 - 8.5
//    }

    NSLog(@"%@",sender);
    NSLog(@"superviewFrame%@",sender.superview);
    NSLog(@"%@",self);
    
    
    [UIView animateWithDuration:0.2f animations:^{
        

        NSInteger newX = self.segmentControl.selectedSegmentIndex
        *sender.width / 2 + _indicatorView.frame.size.width/2 + 16;
        
        _indicatorView.left = newX;
//        _indicatorView.centerX = self.segmentControl.selectedSegmentIndex * sender.width  + 15 + sender.width * self.segmentControl.selectedSegmentIndex;
        
        
        
    }];
    
    if(self.delegate)
    {
        [self.delegate segmentView:self selectIndex:self.segmentControl.selectedSegmentIndex];
    }
}

- (void)setSelectIndex:(NSInteger)index
{
    self.segmentControl.selectedSegmentIndex = index;
//     NSInteger newX = _segmentControl.selectedSegmentIndex * _indicatorView.frame.size.width;
//    NSInteger newX = self.segmentControl.selectedSegmentIndex *_indicatorView.frame.size.width*2+_indicatorView.frame.size.width/2;
    
    NSInteger newX = self.segmentControl.selectedSegmentIndex * self.segmentControl.width / 2 + _indicatorView.frame.size.width/2 + 16;
    [UIView animateWithDuration:0.2f animations:^{
        
        
        _indicatorView.left = newX;
    }];
}

- (NSInteger)getSelectIndex
{
    return self.segmentControl.selectedSegmentIndex;
}

- (void)changeIndex
{
    self.segmentControl.selectedSegmentIndex = 1;
    [self segmentChanged:self.segmentControl];
}

@end
