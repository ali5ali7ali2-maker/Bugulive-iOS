//
//  GameVC.m
//  BuguLive
//
//  Created by voidcat on 2024/9/25.
//  Copyright © 2024 xfg. All rights reserved.
//

#import "GameVC.h"

@interface GameVC ()
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *topValueBack;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *cionLab;

@end

@implementation GameVC

#pragma mark - LifeCycle
- (void)dealloc {
    [self removeNotificationObserver];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)clickFruit:(id)sender {
    self.navigationController.navigationBar.hidden = NO;

    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.h5_url.fruitMachine_game_url isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];

    [self.navigationController pushViewController:tmpController animated:NO];

    
   
}

- (IBAction)clickgreedy:(id)sender {
    self.navigationController.navigationBar.hidden = NO;

    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.h5_url.greedy_game_url isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
    [self.navigationController pushViewController:tmpController animated:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNavBar];
    
    //设置view
    [self setupView];
   
    //请求数据
    [self requestData];
    
    //添加通知
    [self addNotificationObserver];
}

#pragma mark - View
- (void)setupNavBar {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)setupView {
    //圆角加边框，边框颜色#6280BF
    self.topValueBack.layer.cornerRadius = 11;
    self.topValueBack.layer.masksToBounds = YES;
    self.topValueBack.layer.borderWidth = 0.5;
    self.topValueBack.layer.borderColor = [UIColor colorWithHexString:@"#6280BF"].CGColor;
}

#pragma mark - Network
- (void)requestData {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:SafeStr([IMAPlatform sharedInstance].host.profile.faceURL)]];
    [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {
        self.cionLab.text = [NSString stringWithFormat:@"%@",[IMAPlatform sharedInstance].host.customInfoDict[@"coin"]];

    }];
}

#pragma mark- Delegate
#pragma mark UITableDatasource & UITableviewDelegate


#pragma mark - Private


#pragma mark - Event


#pragma mark - Public


#pragma mark - NSNotificationCenter
- (void)addNotificationObserver {
    
}

- (void)removeNotificationObserver {
    
}

#pragma mark - Setter


#pragma mark - Getter


#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    
}

@end
