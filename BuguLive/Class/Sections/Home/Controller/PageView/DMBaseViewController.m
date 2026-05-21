//
//  DMBaseViewController.m
//  iphoneLive
//
//  Created by DMY on 2017/4/2.
//  Copyright © 2017年 DMY. All rights reserved.
//

#import "DMBaseViewController.h"
#import "TCBaseAppDelegate.h"
#define CPLAY
@interface DMBaseViewController ()
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) UIView *navtion;
@end

@implementation DMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"base controller");
    self.view.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        
        
    } else {
        
        // Fallback on earlier versions
        
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//        self.edgesForExtendedLayout = UIRectEdgeAll;
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Do any additional setup after loading the view.
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    self.view.frame = CGRectMake(self.view.frame.origin.x,20, self.view.frame.size.width, self.view.frame.size.height);

}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    self.view.frame = CGRectMake(self.view.frame.origin.x,20, self.view.frame.size.width, self.view.frame.size.height);

}

-(void)navtionWithTitle:(NSString *)title{
    self.navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kStatusBarHeight + kNavigationBarHeight)];
    self.navtion.backgroundColor = navigationBGColor;
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.text = title;
    [self.titleLab setFont:navtionTitleFont];
    self.titleLab.textColor = navtionTitleColor;
    self.titleLab.frame = CGRectMake(0, kStatusBarHeight,kScreenW,kNavigationBarHeight);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.navtion addSubview:self.titleLab];
    UIButton *returnBtn = [[UIButton alloc]init];
    returnBtn.frame = CGRectMake(10,kStatusBarHeight,kNavigationBarHeight,kNavigationBarHeight);
    [returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
//    returnBtn.tintColor = [UIColor blackColor];
    [returnBtn setImage:[UIImage imageNamed:@"uplive_left_back_icon"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [self.navtion addSubview:returnBtn];
    //隐藏分割线
//    UIView *fg =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_navtion.frame)-.5, kScreenW, .5)];
//    fg.backgroundColor =UIColorFromRGB(0xe5e5e5);
//    [_navtion addSubview:fg];
    [self.view addSubview:self.navtion];
}

-(void)setLeftButtonWith:(NSString *)title
{
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftbutton setTitle:title forState:UIControlStateNormal];
    leftbutton.tintColor = [UIColor whiteColor];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 100, 0, kScreenW/2 - 50, 64)];
    [bigBTN addTarget:self action:@selector(doLeftClick) forControlEvents:UIControlEventTouchUpInside];
    [bigBTN setBackgroundColor:[UIColor clearColor]];
    [self.navtion addSubview:bigBTN];
    leftbutton.frame = CGRectMake(kScreenW - 60,30,60,20);
//    [leftbutton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    leftbutton.tintColor = [UIColor blackColor];
//    [leftbutton setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(doLeftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navtion addSubview:leftbutton];

}

- (void)doLeftClick {
    if([self.navdelegate respondsToSelector:@selector(navLeftButtonClick)])
    {
        [self.navdelegate navLeftButtonClick];
    }
}

-(void)doReturn{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated: YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return NO;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
