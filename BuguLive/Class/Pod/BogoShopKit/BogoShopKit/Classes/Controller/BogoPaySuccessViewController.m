//
//  BogoPaySuccessViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/24.
//

#import "BogoPaySuccessViewController.h"
#import "BogoPayOrderModel.h"
#import "BogoOrderDetailViewController.h"

@interface BogoPaySuccessViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation BogoPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"支付成功";
}

- (void)setModel:(BogoPayOrderModel *)model{
    _model = model;
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.money.floatValue]];
}

- (IBAction)seeOrderBtnAction:(id)sender {
    BogoOrderDetailViewController *orderVC = [[BogoOrderDetailViewController alloc]init];
    orderVC.so_id = @"";
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)goOnBtnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
