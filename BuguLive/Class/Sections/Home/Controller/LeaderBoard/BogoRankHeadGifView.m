//
//  BogoRankHeadGifView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/29.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoRankHeadGifView.h"

@implementation BogoRankHeadGifView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewArr = [NSMutableArray array];
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    
    NSArray *imgArr = @[@"mg_new_rank_left",@"mg_new_rank_center",@"mg_new_rank_right"];
//    mg_new_rank_left
    
    CGFloat viewWidth = (kScreenW - kRealValue(12 * 2)) / 3;
    
    for (int i = 0; i < imgArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        [imgView setImage:[UIImage imageNamed:imgArr[i]]];
        if (i == 0) {
            imgView.frame = CGRectMake(kRealValue(12), self.height, viewWidth, kRealValue(203));
        }else if (i == 1){
            imgView.frame = CGRectMake(kRealValue(12) + viewWidth * i, self.height, viewWidth, kRealValue(218));
        }else if (i == 2){
            imgView.frame = CGRectMake(kRealValue(12) + viewWidth * 2, self.height, viewWidth, kRealValue(203));
        }
//        imgView.bottom = self.height;
        imgView.alpha = 0;
        [self.viewArr addObject:imgView];
        [self addSubview:imgView];
    }
    
    for (int i = 0; i < self.viewArr.count; i ++) {
        
        UIView *view = self.viewArr[i];
        if (i == 1) {
            
            [UIView transitionWithView:view duration:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                view.bottom = self.height;
                view.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
            
        }else{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView transitionWithView:view duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    view.bottom = self.height;
                    view.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];
//            });
        }
    }
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDelay:1];
//    [UIView setAnimationDuration:2];
//    [UIView setAnimationRepeatCount:1];
//    [UIView setAnimationRepeatAutoreverses: YES];  // 翻转
//    [UIView setAnimationCurve:UIViewAnimationCurveLinear]; //设置动画变化的曲线
////    for (UIView *view in self.viewArr) {
////        <#statements#>
////    }
//    UIView *view = self.viewArr[2];
////    view.alpha = 0;
////    view.center = CGPointMake(view.center.x, view.center.y + 50);
//    view.bottom = self.height;
//    [UIView setAnimationDelegate:self];   // 设置代理 监测动画结束的
//    [UIView setAnimationDidStopSelector:@selector(shopAction)];
//    [UIView commitAnimations];
}


-(void)shopAction{
    NSLog(@"结束");
//
//    for (UIView *view in self.viewArr) {
//        view.alpha = 1;
//        view.bottom = self.height;
//    }
}

@end
