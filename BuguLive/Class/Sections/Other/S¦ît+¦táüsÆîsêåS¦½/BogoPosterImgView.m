//
//  BogoPosterImgView.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/10/23.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "BogoPosterImgView.h"


@interface BogoPosterImgView ()


///头像
@property (nonatomic, weak) UIImageView *headImageView;
///昵称
@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *titleLabel;
///二维码
@property (nonatomic, weak) UIImageView *erImageView;

@property (nonatomic, weak)UIImageView *rightImgView;

@property (nonatomic, weak)UIImageView *leftImgView;

@property (nonatomic, weak)UILabel *leftLabel;

@property (nonatomic, weak)UILabel *rightLabel;

@property(nonatomic, strong) UIView *bottomView;

@end

@implementation BogoPosterImgView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadView];
    }
    return self;
}

- (void)setModel:(ShareModel *)model{
    _model = model;
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user" forKey:@"ctl"];
    [parmDict setObject:@"userinfo" forKey:@"act"];
    FWWeakify(self)
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
        {
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            self.userModel = [userPageModel mj_objectWithKeyValues:[responseJson objectForKey:@"user"]];
            
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.head_image]];
            self.nameLabel.text = self.userModel.nick_name;
            self.titleLabel.text = [NSString stringWithFormat:@"ID:%@", self.userModel.user_id];
            
         }else
         {
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
         
     } FailureBlock:^(NSError *error)
     {
         
     }];
    
    
    
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];

    // 2. 给滤镜添加数据
    NSString *string = model.share_url;

    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

    [filter setValue:data forKeyPath:@"inputMessage"];

    // 3. 生成二维码
    self.erImageView.image =
    [self createNonInterpolatedUIImageFormCIImage:[self creatQRcodeWithUrlstring:string] withSize:110];
}


- (CIImage *)creatQRcodeWithUrlstring:(NSString *)urlString{
    
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *outputImage = [filter outputImage];
    return outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}



#pragma mark - # Life Cycle
- (void)loadView {
    self.backImageView=[UIImageView new];
    self.backImageView.image=[UIImage imageNamed:@"erweimafenxiang_bac"];
    self.backImageView.backgroundColor = kWhiteColor;
    [self addSubview:self.backImageView];
    
    self.bottomView = [UIView new];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    [self.backImageView addSubview:self.bottomView];
    
    
    UIImageView *rightImgView=[UIImageView new];
    rightImgView.image=[UIImage imageNamed:@"bogo_share_phone"];
    rightImgView.backgroundColor = kClearColor;
    
    self.rightImgView=rightImgView;
    
    UIImageView *leftImgView = [UIImageView new];
    leftImgView.image=[UIImage imageNamed:@"bogo_share_save"];
    leftImgView.backgroundColor = kClearColor;
    
    self.leftImgView = leftImgView;
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.text = ASLocalizedString(@"保存图片\n到相册");
    leftLabel.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
    leftLabel.font = [UIFont systemFontOfSize:10];
    leftLabel.numberOfLines = 0;
    _leftLabel = leftLabel;
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.text = ASLocalizedString(@"打开布谷直播\n立即看到");
    rightLabel.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
    rightLabel.font = [UIFont systemFontOfSize:10];
    rightLabel.numberOfLines = 0;
    _rightLabel = rightLabel;
    
    [self.bottomView addSubview:leftLabel];
    [self.bottomView addSubview:rightLabel];
    [self.bottomView addSubview:leftImgView];
    [self.bottomView addSubview:rightImgView];
    
    UIImageView *headImageView = [UIImageView new];
//    headImageView.image=emptyimage;
    headImageView.backgroundColor = kYellowColor;
    [self.backImageView addSubview:headImageView];
    headImageView.contentMode=UIViewContentModeScaleAspectFill;
    headImageView.clipsToBounds = YES;
//    headImageView.layer.borderWidth=3;
//    headImageView.layer.borderColor=RGB(153, 153, 153).CGColor;
    self.headImageView=headImageView;
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.textColor = [UIColor colorWithHexString:@"#777777"];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.backImageView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor colorWithHexString:@"#777777"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backImageView addSubview:titleLabel];
    self.titleLabel=titleLabel;
    
    UIImageView *erImageView = [[UIImageView alloc]init];
    erImageView.backgroundColor = kBlueColor;
    [self.headImageView addSubview:erImageView];
    self.erImageView = erImageView;
    
    erImageView.userInteractionEnabled=YES;
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dealLongPress:)];
    [erImageView addGestureRecognizer:longPress];

    #pragma mark - # Private Methods
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
}


#pragma mark->长按识别二维码
-(void)dealLongPress:(UIGestureRecognizer*)pressSender{
    NSString *content = @"" ;
    //取出选中的图片
    UIImageView*tempImageView=(UIImageView*)pressSender.view;
    if(tempImageView.image){
        UIImage *pickImage =tempImageView.image;
        NSData *imageData = UIImagePNGRepresentation(pickImage);
        CIImage *ciImage = [CIImage imageWithData:imageData];
        
        //创建探测器
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
        NSArray *feature = [detector featuresInImage:ciImage];
        
        //取出探测到的数据
        for (CIQRCodeFeature *result in feature) {
            content = result.messageString;
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:content] options: @{} completionHandler: nil];
        }
        //进行处理(音效、网址分析、页面跳转等)
    }
}



- (void)setIs_Small:(BOOL)is_Small{
    _is_Small=is_Small;
    if (is_Small==YES) {
        self.nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        self.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        self.leftLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        self.rightLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];

        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(145);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
            make.centerX.mas_equalTo(self);
        }];
        
        self.headImageView.layer.cornerRadius = 8;
        self.headImageView.layer.masksToBounds = YES;
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(22);
            make.top.mas_equalTo(15);
            make.centerX.mas_equalTo(self.backImageView);
//            make.left.mas_equalTo(self.headImageView);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(5);
//            make.left.mas_equalTo(self.headImageView);
            make.centerX.mas_equalTo(self.backImageView);
            make.width.mas_equalTo(145);
        }];
        [self.erImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.headImageView);
        }];
        
        
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(54);
        }];
        
        [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(self.bottomView);
            make.width.height.mas_equalTo(20);
        }];
        
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bottomView);
            make.left.mas_equalTo(self.leftImgView.mas_right).mas_offset(10);
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(35);
        }];
        
        [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftLabel.mas_right).mas_offset(60);
            make.centerY.mas_equalTo(self.bottomView);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(22);
        }];
        
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bottomView);
            make.left.mas_equalTo(self.rightImgView.mas_right).mas_offset(10);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(35);
        }];
        
        
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
    }else{
        self.nameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        self.leftLabel.font = [UIFont systemFontOfSize:15.88 weight:UIFontWeightMedium];

        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(250);
            make.top.mas_equalTo(132-20+kStatusBarHeight);
            make.centerX.mas_equalTo(self);
        }];
        self.headImageView.layer.cornerRadius = 8;
        self.headImageView.layer.masksToBounds = YES;
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(self.headImageView.mas_bottom).mas_offset(30);
            make.left.mas_equalTo(60);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(15);
            make.left.mas_equalTo(60);
            make.right.mas_equalTo(-60);
        }];
        [self.erImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(85);
            make.width.height.mas_equalTo(78);
            make.bottom.mas_equalTo(-45-49);
        }];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.erImageView);
//            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(90);
            make.left.mas_equalTo(180);
            make.right.mas_equalTo(self.headImageView.mas_right);
        }];
    }
    
}



@end
