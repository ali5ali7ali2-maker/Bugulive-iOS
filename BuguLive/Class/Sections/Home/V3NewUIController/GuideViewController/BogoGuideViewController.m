//
//  BogoGuideViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/19.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoGuideViewController.h"
#import "BogoGuideFirstView.h"

@interface BogoGuideViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) BogoGuideFirstView *firstView;

@end

@implementation BogoGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.scrollView addSubview:self.firstView];
    [self.view addSubview:self.scrollView];
}



-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    }
    return _scrollView;
}

-(BogoGuideFirstView *)firstView{
    if (_firstView) {
        _firstView = [[NSBundle mainBundle]loadNibNamed:@"BogoGuideFirstView"owner:self options:nil].lastObject;
    }
    return _firstView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
