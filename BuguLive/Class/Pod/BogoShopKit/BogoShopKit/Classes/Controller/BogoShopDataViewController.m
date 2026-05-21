//
//  BogoShopDataViewController.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/7.
//

#import "BogoShopDataViewController.h"
#import "BogoShopKit.h"
#import "BogoShopDataModel.h"
#import <MJExtension/MJExtension.h>
#import "BogoWithDrawViewController.h"
#import "BogoNetworkKit.h"
#import "BogoNetworkResponseModel.h"
@interface BogoShopDataViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *day_moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *day_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *day_saleLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;

@end

@implementation BogoShopDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺数据";
    // Do any additional setup after loading the view from its nib.
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, FD_ScreenWidth - 20, 140);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:158/255.0 green:100/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:239/255.0 green:96/255.0 blue:246/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.bgView.layer insertSublayer:gl atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)requestData{
//    /shopapi/pay/shopRevenueUrl?uid=165999&token=dbb5e1a7327a551baaffac3d83c75775
    [[BogoNetwork shareInstance] POST:@"pay/shopRevenueUrl" param:nil success:^(BogoNetworkResponseModel * _Nonnull result) {
        BogoShopDataModel *model = [BogoShopDataModel mj_objectWithKeyValues:result.data];
        self.incomeLabel.text = [NSString stringWithFormat:@"%.2f",model.income.floatValue / 100];
        self.day_moneyLabel.text = model.day_money;
        self.moneyLabel.text = model.money;
        self.day_numLabel.text = model.day_num;
        self.numLabel.text = model.num;
        self.day_saleLabel.text = model.day_sale;
        self.saleLabel.text = model.sale;
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (IBAction)withDrawBtnAction:(UIButton *)sender {
    BogoWithDrawViewController *withDrawVC = [[BogoWithDrawViewController alloc]initWithNibName:NSStringFromClass([BogoWithDrawViewController class]) bundle:kShopKitBundle];
    [self.navigationController pushViewController:withDrawVC animated:YES];
}

@end
