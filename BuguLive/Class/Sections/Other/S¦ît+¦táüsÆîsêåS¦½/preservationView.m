//
//  preservationView.m
//  UniversalApp
//
//  Created by xu on 2020/9/12.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "preservationView.h"
@interface preservationView ()
@property (nonatomic, strong)UIImageView *backImageView;
///头像
@property (nonatomic, weak) UIImageView *headImageView;
///昵称
@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *titleLabel;
///二维码
@property (nonatomic, weak) UIImageView *erImageView;

@property (nonatomic, weak)UIImageView *rightImageView;
@property (nonatomic, weak)UILabel *detaLabel;
@end
@implementation preservationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadView];
    }
    return self;
}
- (void)setModel:(videoListModel *)model{
    _model=model;
    
    [self.headImageView sd_setImageWithURL:safeurl(model.img) placeholderImage:emptyimage];
    self.nameLabel.text=[NSString stringWithFormat:@"@%@",model.user_nickname];
    self.titleLabel.text=model.title;
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];

    // 2. 给滤镜添加数据
    NSString *string =model.video_url;

    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

    [filter setValue:data forKeyPath:@"inputMessage"];

    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    self.erImageView.image=[self createNonInterpolatedUIImageFormCIImage:image withSize:80];
}
#pragma mark - # Event Response
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
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
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //水印图
    UIImage *waterimage = [UIImage imageNamed:@"erweima_biao"];
    [waterimage drawInRect:CGRectMake((outputImage.size.height-(outputImage.size.height)*0.3)*0.5, (outputImage.size.height-(outputImage.size.height)*0.3)*0.5, (outputImage.size.height)*0.3, (outputImage.size.height)*0.3)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;//[UIImage imageWithCGImage:scaledImage];
}
#pragma mark - # Life Cycle
- (void)loadView {
    self.backImageView=[UIImageView new];
    self.backImageView.image=[UIImage imageNamed:@"erweimafenxiang_bac"];
    [self addSubview:self.backImageView];
    
    UIImageView *rightImageView=[UIImageView new];
    rightImageView.image=[UIImage imageNamed:@"logo_er"];
    [self.backImageView addSubview:rightImageView];
    self.rightImageView=rightImageView;
    
    UIImageView *headImageView=[UIImageView new];
//    headImageView.image=emptyimage;
    [self.backImageView addSubview:headImageView];
    headImageView.contentMode=UIViewContentModeScaleAspectFill;
    headImageView.clipsToBounds = YES;
//    headImageView.layer.borderWidth=3;
//    headImageView.layer.borderColor=RGB(153, 153, 153).CGColor;
    self.headImageView=headImageView;
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.textColor = [UIColor whiteColor];
    [self.backImageView addSubview:nameLabel];
    self.nameLabel=nameLabel;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    [self.backImageView addSubview:titleLabel];
    titleLabel.alpha = 0.5;
    self.titleLabel=titleLabel;

    UIImageView *erImageView=[[UIImageView alloc]init];
    [self.backImageView addSubview:erImageView];
    self.erImageView=erImageView;
    
    erImageView.userInteractionEnabled=YES;
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dealLongPress:)];
    [erImageView addGestureRecognizer:longPress];

    UILabel *detaLabel = [UILabel new];
    detaLabel.text=KGlobalVariable.appmodel.share_video_content;//@"保存照片到相册\n打开布谷交友\n立即看到";
    detaLabel.textColor =RGB(153, 153, 153);
    detaLabel.font = [UIFont systemFontOfSize:15.88 weight:UIFontWeightMedium];
    [self.backImageView addSubview:detaLabel];
    detaLabel.numberOfLines=0;
    self.detaLabel=detaLabel;
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
        self.nameLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        self.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        self.detaLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];

        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(132.5/(33.5/20));
        }];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(145);
            make.top.mas_equalTo(self.rightImageView.mas_bottom).mas_offset(15);
            make.centerX.mas_equalTo(self);
        }];
        ViewRadius(self.headImageView, 8);
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(13);
            make.top.mas_equalTo(self.headImageView.mas_bottom).mas_offset(15);
            make.left.mas_equalTo(self.headImageView);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(5);
            make.left.mas_equalTo(self.headImageView);
            make.width.mas_equalTo(145);
        }];
        [self.erImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView).mas_offset(145/2-53);
            make.width.height.mas_equalTo(53);
            make.bottom.mas_equalTo(-15);
        }];
        [self.detaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.erImageView);
            make.left.mas_equalTo(self.erImageView.mas_right).mas_offset(10);
            make.right.mas_equalTo(self.headImageView.mas_right);
        }];
        ViewRadius(self, 8);
    }else{
        self.nameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        self.detaLabel.font = [UIFont systemFontOfSize:15.88 weight:UIFontWeightMedium];

        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.top.mas_equalTo(20+kStatusBarHeight);
            make.height.mas_equalTo(33.5);
        }];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(250);
            make.top.mas_equalTo(132-20+kStatusBarHeight);
            make.centerX.mas_equalTo(self);
        }];
        ViewRadius(self.headImageView, 8);
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
            make.bottom.mas_equalTo(-45-kTabBarHeight1);
        }];
        [self.detaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.erImageView);
//            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(90);
            make.left.mas_equalTo(180);
            make.right.mas_equalTo(self.headImageView.mas_right);
        }];
    }
    
}
#pragma mark - # Getter

@end
