//
//  ViewController.m
//  Gomoku
//
//  Created by Sekorm on 16/7/25.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ViewController.h"
#import "CheckerboardView.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<CLLocationManagerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property (nonatomic,weak) CheckerboardView * boardView;
@property (nonatomic,weak) UIButton * backButton;
@property (nonatomic,weak) UIButton * reStartBtn;
@property (nonatomic,weak) UIButton * changeBoardButton;
@property(nonatomic, strong) UILabel *info;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) UIImageView *backImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self startJJJ];
}


- (void)setUp{
    
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    
    _backImageView = [[UIImageView alloc] init];
    _backImageView.frame = CGRectMake(0, 0, kScreenW, kMainScreenHeight);
    [self.view addSubview:_backImageView];
    
    //添加棋盘
    CheckerboardView * boardView = [[CheckerboardView alloc]initWithFrame:CGRectMake(20, 30, ScreenW * 0.95, CGFLOAT_MAX)];
    boardView.center = self.view.center;
    [self.view addSubview:boardView];
    self.boardView = boardView;
    
    
    //悔棋
    UIButton * changeBoardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBoardButton setTitle:ASLocalizedString(@"初级棋盘")forState:UIControlStateNormal];
    [changeBoardButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    changeBoardButton.backgroundColor = [UIColor colorWithRed:200/255.0 green:160/255.0 blue:130/255.0 alpha:1];
    changeBoardButton.frame = CGRectMake(CGRectGetMidX(boardView.frame) - CGRectGetWidth(boardView.frame) * 0.3, CGRectGetMinY(boardView.frame) - 50, CGRectGetWidth(boardView.frame) * 0.6, 35);
    changeBoardButton.layer.cornerRadius = 4;
    [self.view addSubview:changeBoardButton];
    self.changeBoardButton = changeBoardButton;
    [changeBoardButton addTarget:self action:@selector(changeBoard:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //悔棋
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:ASLocalizedString(@"悔棋")forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    backButton.backgroundColor = [UIColor colorWithRed:200/255.0 green:160/255.0 blue:130/255.0 alpha:1];
    backButton.frame = CGRectMake(CGRectGetMinX(boardView.frame), CGRectGetMaxY(boardView.frame) + 15, CGRectGetWidth(boardView.frame) * 0.45, 30);
    backButton.layer.cornerRadius = 4;
    [self.view addSubview:backButton];
    self.backButton = backButton;
    [backButton addTarget:self action:@selector(backOneStep:) forControlEvents:UIControlEventTouchUpInside];
    
    //新游戏
    UIButton * reStartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reStartBtn setTitle:ASLocalizedString(@"新游戏")forState:UIControlStateNormal];
    reStartBtn.backgroundColor = [UIColor colorWithRed:200/255.0 green:160/255.0 blue:130/255.0 alpha:1];
    reStartBtn.frame = CGRectMake(CGRectGetMaxX(boardView.frame) - CGRectGetWidth(boardView.frame) * 0.45, CGRectGetMaxY(boardView.frame) + 15, CGRectGetWidth(boardView.frame) * 0.45, 30);
    reStartBtn.layer.cornerRadius = 4;
    [self.view addSubview:reStartBtn];
    self.reStartBtn = reStartBtn;
    [reStartBtn addTarget:self action:@selector(newGame) forControlEvents:UIControlEventTouchUpInside];
    
    
    //游戏背景
    UIButton * gameBg = [UIButton buttonWithType:UIButtonTypeCustom];
    [gameBg setTitle:ASLocalizedString(@"设置游戏背景")forState:UIControlStateNormal];
    gameBg.backgroundColor = [UIColor colorWithRed:200/255.0 green:160/255.0 blue:130/255.0 alpha:1];
    gameBg.frame = CGRectMake(CGRectGetMaxX(boardView.frame) - CGRectGetWidth(boardView.frame) * 0.45, CGRectGetMaxY(reStartBtn.frame) + 15, CGRectGetWidth(boardView.frame) * 0.45, 30);
    gameBg.layer.cornerRadius = 4;
    [self.view addSubview:gameBg];
    self.reStartBtn = gameBg;
    [gameBg addTarget:self action:@selector(setGameBg) forControlEvents:UIControlEventTouchUpInside];

    
    _info = [[UILabel alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + kStatusBarHeight, kScreenW, 40)];
    _info.text = ASLocalizedString(@"没有位置信息");
    [self.view addSubview:_info];
}

- (void)backOneStep:(UIButton *)sender{
    [self.boardView backOneStep:(UIButton *)sender];
}

- (void)newGame{
    
    [self.boardView newGame];
}

- (void)changeBoard:(UIButton *)btn{

    [self.boardView changeBoardLevel];
    [_changeBoardButton setTitle:[btn.currentTitle isEqualToString:ASLocalizedString(@"高级棋盘")]?ASLocalizedString(@"初级棋盘"):ASLocalizedString(@"高级棋盘")forState:UIControlStateNormal];
}

-(void)startJJJ
{
    [self startLocation];
}


-(void)startLocation{
    
    if ([CLLocationManager locationServicesEnabled]) {//判断定位操作是否被允许
        
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;//遵循代理
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.locationManager.distanceFilter = 10.0f;
        
        [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8以上版本定位需要）
        
        [self.locationManager startUpdatingLocation];//开始定位
        
    }else{//不能定位用户的位置的情况再次进行判断，并给与用户提示
        
        //1.提醒用户检查当前的网络状况
        
        //2.提醒用户打开定位开关
        [[BGHUDHelper sharedInstance] syncStopLoading];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    //当前所在城市的坐标值
    CLLocation *currLocation = [locations lastObject];
    
    NSLog(ASLocalizedString(@"经度=%f 纬度=%f 高度=%f"), currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    
    //根据经纬度反向地理编译出地址信息
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *address = [placemark addressDictionary];
            
            //  Country(国家)  State(省)  City（市）
            NSLog(@"#####%@",address);
            
            NSLog(@"%@", [address objectForKey:@"Country"]);
            
            NSLog(@"%@", [address objectForKey:@"State"]);
            
            NSLog(@"%@", [address objectForKey:@"City"]);
            _info.text = [NSString stringWithFormat:ASLocalizedString(@"欢迎来自%@的棋手"),[address objectForKey:@"City"]];
//            cell.rightLab.text = [address objectForKey:@"City"];
            
            [[BGHUDHelper sharedInstance] syncStopLoading];
        }
        
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [[BGHUDHelper sharedInstance] syncStopLoading];
    if ([error code] == kCLErrorDenied){
        //访问被拒绝
        [FanweMessage alertHUD:ASLocalizedString(@"访问被拒绝")];
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        [FanweMessage alertHUD:ASLocalizedString(@"无法获取位置信息")];
    }
    
}

- (void)setGameBg {
    [self clickHeadImage];
}


//编辑公会头像
-(void)clickHeadImage
{
    UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [headImgSheet addButtonWithTitle:ASLocalizedString(@"相机")];
    [headImgSheet addButtonWithTitle:ASLocalizedString(@"从手机相册选择")];
    [headImgSheet addButtonWithTitle:ASLocalizedString(@"取消")];
    headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
    headImgSheet.delegate = self;
    [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.modalTransitionStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:picker animated:YES completion:nil];
    }else if (buttonIndex == 1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:picker animated:YES completion:nil];
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//    [self.headBtn setImage:image forState:UIControlStateNormal];
    _backImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//点击返回按钮
- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

@end
