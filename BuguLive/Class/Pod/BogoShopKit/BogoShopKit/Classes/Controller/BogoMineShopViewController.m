//
//  BogoMineShopViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import "BogoMineShopViewController.h"
#import <QMUIKit/QMUIKit.h>
#import "BogoShopKit.h"
#import "BogoShopInfoViewController.h"
#import "BogoCommodityManagementViewController.h"
#import "BogoOrderManageViewController.h"

@interface BogoMineShopViewController ()

@property (weak, nonatomic) IBOutlet QMUIButton *infoBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *goodManageBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *orderManageBtn;

@end

@implementation BogoMineShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的店铺";
    
    self.infoBtn.imagePosition = QMUIButtonImagePositionTop;
    self.infoBtn.spacingBetweenImageAndTitle = 5;
    self.goodManageBtn.imagePosition = QMUIButtonImagePositionTop;
    self.goodManageBtn.spacingBetweenImageAndTitle = 5;
    self.orderManageBtn.imagePosition = QMUIButtonImagePositionTop;
    self.orderManageBtn.spacingBetweenImageAndTitle = 5;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)infoBtnAction:(id)sender {
    BogoShopInfoViewController *infoVC = [[BogoShopInfoViewController alloc]init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (IBAction)goodManageBtnAction:(id)sender {
    BogoCommodityManagementViewController *manageVC = [[BogoCommodityManagementViewController alloc]init];
    [self.navigationController pushViewController:manageVC animated:YES];
}

- (IBAction)orderManageBtnAction:(id)sender {
    BogoOrderManageViewController *manageVC = [[BogoOrderManageViewController alloc]init];
    manageVC.listType = BogoOrderManageViewControllerTypeShop;
    [self.navigationController pushViewController:manageVC animated:YES];
}

@end
