//
//  GuiZuViewController.m
//  BuguLive
//
//  Created by bugu on 2019/12/2.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "GuiZuViewController.h"
#import "GuiZuView.h"

#import "GuiZuBottomView.h"

@interface GuiZuViewController ()
@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic, strong) UIScrollView *titleScrollView;
@property(nonatomic, strong) UIView *titlesView;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) GuiZuView *guiZuView;

@property(nonatomic, strong) GuiZuBottomView *bottomView;

@end

@implementation GuiZuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBtnWithBlock];

    // Do any additional setup after loading the view.
}

- (void)backBtnWithBlock
{
    // 返回按钮
    [self setupBackBtnWithBlock:nil];
}
- (void)initFWUI{
    [super initFWUI];
    [self.view addSubview:self.mainScrollView];
    
    [self.view addSubview:self.bottomView];
    [self.mainScrollView addSubview:self.guiZuView];
       
       [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.right.mas_equalTo(0);
           make.bottom.mas_equalTo(isIPhoneX()?-34 :0);
           make.height.mas_equalTo(70);
       }];
    self.guiZuView.frame = CGRectMake(0, 0, kScreenW, kRealValue(550));
   
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-20);
    }];
    [self.view addSubview:self.titlesView];
    
}


-(void)initFWData
{
    [super initFWData];
   
    [self.bottomView setDataWithGift:@"333" money:@"3" day:@"33"];
    
}

#pragma mark 主页和直播的点击事件
- (void)HLBtnClick:(UIButton *)btn
{
    [self updateUIWithTag:(int)btn.tag];
}

- (void)updateUIWithTag:(int)tag
{
    for (UIButton *newBtn in self.titlesView.subviews)
    {
        if ([newBtn isKindOfClass:[UIButton class]])
        {
            if (newBtn.tag ==tag)
            {
              [newBtn setTitleColor:[UIColor colorWithHexString:@"#FFEF77"] forState:UIControlStateNormal];
              newBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            }else
            {
                [newBtn setTitleColor:[UIColor colorWithHexString:@"#E5E5E5"] forState:UIControlStateNormal];
                newBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            }
           
        }
    }
    
 //页面刷新
//    [_myScrollView scrollRectToVisible:CGRectMake(tag * kScreenW, 0, kScreenW, CGRectGetHeight(_myScrollView.frame)) animated:YES];
}

#pragma mark - setter
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = ({
            UIScrollView * scrollView = [[UIScrollView alloc]init];
//            scrollView.contentSize = CGSizeMake(kScreenW, kScreenH);
            
            
            scrollView;
        });
    }
    return _mainScrollView;
}

- (GuiZuView *)guiZuView{
    if (!_guiZuView) {
        _guiZuView = [[GuiZuView alloc]init];;
        
    }
    return _guiZuView;
}
- (GuiZuBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[GuiZuBottomView alloc]init];
    }
    return _bottomView;
}

- (UIView *)titlesView{
    if (!_titlesView) {
        _titlesView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 45*kAppRowHScale)];
             _titlesView.backgroundColor = [UIColor clearColor];
             NSArray *nameArray = @[ASLocalizedString(@"玄铁"),ASLocalizedString(@"青铜"),ASLocalizedString(@"白银"),ASLocalizedString(@"黄金"),ASLocalizedString(@"铂金"),ASLocalizedString(@"钻石"),ASLocalizedString(@"星耀"),ASLocalizedString(@"王者")];
             CGFloat btnWidth = kScreenW/nameArray.count;
             for (int i = 0; i < nameArray.count; i ++)
             {
                 UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                 button.frame = CGRectMake(btnWidth*i ,0,btnWidth, 49);
                 [button setTitle:nameArray[i] forState:0];
                 button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                 if (self.type == i)
                 {
                     [button setTitleColor:[UIColor colorWithHexString:@"#FFEF77"] forState:UIControlStateNormal];
                     button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                 }else
                 {
                     [button setTitleColor:[UIColor colorWithHexString:@"#E5E5E5"] forState:UIControlStateNormal];
                     button.titleLabel.font = [UIFont systemFontOfSize:14];
                 }
                 button.tag = i;
                 [button addTarget:self action:@selector(HLBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                 [_titlesView addSubview:button];
             }
    }
    return _titlesView;
}


@end
