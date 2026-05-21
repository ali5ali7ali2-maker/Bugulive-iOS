//
//  MGSaveHeadImgViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/6/11.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "MGSaveHeadImgViewController.h"
#import "TZImageManager.h"

@interface MGSaveHeadImgViewController ()

@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) UIImageView *headImgView;

@property(nonatomic, strong) UIButton *saveBtn;

@end

@implementation MGSaveHeadImgViewController

-(instancetype)initWithHeadImageWithImage:(UIImage *)image{
    MGSaveHeadImgViewController *vc = [MGSaveHeadImgViewController new];
    vc.headImage = image;
    return vc;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImage:[UIImage imageNamed:@"com_arrow_vc_back_2"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backBtn.frame = CGRectMake(15, kStatusBarHeight + 5, kRealValue(30), kRealValue(30));
    self.headImgView.contentMode  = UIViewContentModeScaleAspectFill;
    self.headImgView.clipsToBounds = YES;
    
    self.headImgView = [UIImageView new];
    self.headImgView.frame = CGRectMake(0, 0, kScreenW, kRealValue(250));
    self.headImgView.image = self.headImage;
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveBtn setTitle:ASLocalizedString(@"保存")forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(saveHeadImage:) forControlEvents:UIControlEventTouchUpInside];
    self.saveBtn.backgroundColor = kAppNewMainColor;
    self.saveBtn.layer.cornerRadius = kRealValue(40 / 2);
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.frame = CGRectMake(kRealValue(30), kScreenH - kRealValue(30) - kRealValue(80),  kScreenW - kRealValue(30 * 2), kRealValue(40));
    [self.view addSubview:self.saveBtn];
    
    [self.view addSubview:self.headImgView];
    [self.view addSubview:self.backBtn];
}

-(void)clickBack:(UIButton *)sender{
//    [self.navigationController popViewControllerAnimated:YES];
    if (self.navigationController.viewControllers.count >1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
       [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)saveHeadImage:(UIButton *)sender{
    [[TZImageManager manager] savePhotoWithImage:self.headImage completion:^(PHAsset *asset, NSError *error) {
        if (!error) {
            [FanweMessage alertHUD:ASLocalizedString(@"保存头像成功!")];
        }else{
            [FanweMessage alertHUD:error.localizedDescription];
        }
    }];
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
