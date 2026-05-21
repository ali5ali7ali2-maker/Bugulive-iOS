//
//  MGReportCommentController.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/1/15.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "MGReportCommentController.h"
#import "BGOssManager.h"

@interface MGReportCommentController ()<UITextViewDelegate>

@property(nonatomic, strong) UIView *firstView;
@property(nonatomic, strong) UIView *secondView;

@property(nonatomic, strong) UIView *centerView;

@property(nonatomic, strong) UILabel *textViewL;
@property(nonatomic, strong) UILabel *placeHolderL;
@property(nonatomic, strong) UITextView *textView;

@property(nonatomic, strong) UIButton *commitBtn;

@property(nonatomic, strong) UIView *successView;

@property (nonatomic, strong) BGOssManager            *ossManager;              //oss 类

@end

@implementation MGReportCommentController

-(instancetype)initWithReportModel:(reportModel *)reportModel{
    MGReportCommentController *vc = [MGReportCommentController new];
    vc.model = reportModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _ossManager = [[BGOssManager alloc]initWithDelegate:self];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = ASLocalizedString(@"评论举报");
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    [self setUpFirstView];
    [self setUpSecondView];
    [self setUpThirdView];

    [self initPickerView];
    self.imageArray = [NSMutableArray array];
    [self.pickerCollectionView reloadData];
    
    self.commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commitBtn setTitle:ASLocalizedString(@"提交")forState:UIControlStateNormal];
    self.commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.commitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:[UIImage imageNamed:@"mg_sign_bg_ImgView"] forState:UIControlStateNormal];
    self.commitBtn.layer.cornerRadius = kRealValue(38 / 2);
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.frame = CGRectMake(0, kRealValue(380), kRealValue(240), kRealValue(38));
    self.commitBtn.centerX = kScreenW / 2;
    [self.commitBtn addTarget:self action:@selector(reportClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commitBtn];
    [self clickView];
    
    [self.view addSubview:self.successView];
    self.successView.hidden = YES;
}

-(void)setUpFirstView{
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(44))];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kRealValue(75), kRealValue(44))];
    label.text = ASLocalizedString(@"举报理由");
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#666666"];
    
    UILabel *reportL = [[UILabel alloc]initWithFrame:CGRectMake(label.right, 0, kRealValue(75), kRealValue(44))];
    reportL.text = self.model.name;
    reportL.textAlignment = NSTextAlignmentLeft;
    reportL.font = [UIFont systemFontOfSize:16];
    reportL.textColor = kBlackColor;
    
    
    
    [firstView addSubview:label];
    [firstView addSubview:reportL];
    self.firstView = firstView;
    [self.view addSubview:firstView];
}

#pragma mark 返回
- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpSecondView{
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(144))];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kRealValue(10), 0, kRealValue(120), kRealValue(44))];
    label.text = ASLocalizedString(@"举报描述(选填)");
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#666666"];
    
    UILabel *reportL = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - kRealValue(120), 0, kRealValue(120), kRealValue(44))];
    reportL.text = @"0/200";
    reportL.textAlignment = NSTextAlignmentRight;
    reportL.font = [UIFont systemFontOfSize:16];
    reportL.textColor = kBlackColor;
    _textViewL = reportL;
    
    UILabel *placeHolderL = [[UILabel alloc]initWithFrame:CGRectMake(kRealValue(10), 0, kScreenW / 2, kRealValue(44))];
    placeHolderL.text = ASLocalizedString(@"请详细描述您的举报理由");
    placeHolderL.font = [UIFont systemFontOfSize:14];
    placeHolderL.textColor = [UIColor colorWithHexString:@"#666666"];
    _placeHolderL = placeHolderL;
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(label.left, label.bottom, kScreenW - kRealValue(15 * 2), kRealValue(120))];
    textView.font = [UIFont systemFontOfSize:13];
    textView.delegate = self;
    _textView = textView;
    [firstView addSubview:textView];
    
    [textView addSubview:placeHolderL];
    [firstView addSubview:label];
    [firstView addSubview:reportL];
    [self.view addSubview:firstView];
    self.secondView = firstView;
    self.secondView.top = self.firstView.bottom;
}

-(void)setUpThirdView{
    

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, self.secondView.bottom, kScreenW, 163)];
//    view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [self.view addSubview:view];
    self.centerView = view;
    
}

-(void)clickView{
    
    self.maxCount = 4;
//    //选择图片 图片和视频不能共存
//    [self addNewImg];
    
    if (self.pickerCollectionView.hidden == YES) {
        self.pickerCollectionView.hidden = NO;
    }
    
    [self updatePickerViewFrameY:self.secondView.bottom+10];
    
    self.centerView.frame = CGRectMake(0, self.pickerCollectionView.bottom+20, kScreenW, 163);
    
    [self.pickerCollectionView reloadData];
    [self changeCollectionViewHeight];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeHolderL.hidden = YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    self.placeHolderL.hidden = YES;
    if (textView.text.length > 199) {
        textView.text = [textView.text substringToIndex:199];
    }
    self.textViewL.text = [NSString stringWithFormat:@"%ld/200",textView.text.length];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length < 1) {
        self.placeHolderL.hidden = NO;
    }
}


- (void)reportClick
{
    if (self.arrSelected >0)
    {
        [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在上传")];
       
        __block typeof(self)blockself =self;
       
        [self PhassetgetBigImageArray:self.arrSelected isSubmit:YES callBack:^(NSArray *ary, bool isImg) {
            if (self.arrSelected.count == ary.count)
            {
                NSMutableArray *smallImageDataArray = [ary copy];
                [blockself submitToserverWith:smallImageDataArray isImg:isImg];
            }
        }];
        
    }
}



#pragma mark - 上传数据到服务器前将图片转data（上传服务器用form表单：未写）
- (void)submitToserverWith:(NSArray * )imgary isImg:(BOOL)isImg{
    
    
    __weak __typeof(self)weakSelf = self;
    [_ossManager showUploadOfOssServiceOfDataMarray:self.bigImageArray andSTDynamicSelectType:STDynamicSelectPhoto andComplete:^(BOOL finished, NSMutableArray<NSString *> *urlStrMArray) {
        
        NSLog(@"%@",urlStrMArray);
        
        [[BGHUDHelper sharedInstance]syncStopLoading];
        NSString *imgStr = [urlStrMArray componentsJoinedByString:@","];
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"user" forKey:@"ctl"];
        [parmDict setObject:@"tipoff_weibo" forKey:@"act"];
        [parmDict setObject:@"xr" forKey:@"itype"];
        [parmDict setObject:[NSString stringWithFormat:@"%d",self.model.ID] forKey:@"type"];
        [parmDict setObject:imgStr forKey:@"screenshot"];
        [parmDict setObject:@"3" forKey:@"report_type"];//视频评论举报
        [parmDict setObject:weakSelf.textView.text forKey:@"remark"];
        
        
        
            if (self.model.to_userID.length > 0)
            {
                [parmDict setObject:self.model.to_userID forKey:@"to_user_id"];
            }

            if (self.model.weibo_id.length > 0)
            {
                [parmDict setObject:self.model.weibo_id forKey:@"weibo_id"];
            }

            FWWeakify(self)
            [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
             {
                 FWStrongify(self)
                 if ([responseJson toInt:@"status"] == 1)
                 {
                     [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"举报成功")];
                     self.successView.hidden = NO;
                 }else
                 {
                     [[BGHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
                 }
                 
             } FailureBlock:^(NSError *error)
             {
                 NSLog(@"error==%@",error);
             }];

    }];
}


-(void)clickComplete:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView *)successView{
    if (!_successView) {
        _successView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _successView.backgroundColor = kWhiteColor;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kRealValue(119), kRealValue(56), kRealValue(56))];
        
        [imgView setImage:[UIImage imageNamed:@"mg_report_success"]];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom + kRealValue(10), kScreenW / 2, kRealValue(20))];
        label.text = ASLocalizedString(@"举报提交成功");
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"333333"];
        label.font = [UIFont systemFontOfSize:16];
        
        UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, label.bottom + kRealValue(10), kScreenW - kRealValue(20), kRealValue(20))];
        subLabel.text = ASLocalizedString(@"我们将在24小时之内进行处理");
        subLabel.textAlignment = NSTextAlignmentCenter;
        subLabel.textColor = [UIColor colorWithHexString:@"666666"];
        subLabel.font = [UIFont systemFontOfSize:14];
        
        UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        completeBtn.frame = CGRectMake(0, subLabel.bottom + kRealValue(40), kRealValue(250), kRealValue(32));
        
        [completeBtn setTitle:ASLocalizedString(@"完成")forState:UIControlStateNormal];
        [completeBtn setBackgroundImage:[UIImage imageNamed:@"mg_sign_bg_ImgView"] forState:UIControlStateNormal];
        completeBtn.layer.cornerRadius = kRealValue(38 / 2);
        completeBtn.layer.masksToBounds = YES;
        [completeBtn addTarget:self action:@selector(clickComplete:) forControlEvents:UIControlEventTouchUpInside];
        
        imgView.centerX = completeBtn.centerX = subLabel.centerX = label.centerX = kScreenW / 2;
        
        [_successView addSubview:imgView];
        [_successView addSubview:label];
        [_successView addSubview:subLabel];
        [_successView addSubview:completeBtn];
        
    }
    return _successView;
}

@end
