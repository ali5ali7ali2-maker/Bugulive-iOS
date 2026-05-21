//
//  ReleaseDynamicVC.m
//  BuguLive
//
//  Created by bugu on 2019/11/26.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "ReleaseDynamicVC.h"
#import "UITextView+ZWPlaceHolder.h"
#import "ChatEmojiView.h"
#import "EmojiObj.h"
#import "ChatBottomBarView.h"


#import "ReleaseAtPeopleVC.h"
#import "ReleaseTopicVC.h"

#import <CoreLocation/CoreLocation.h>

#import "PersonCenterUserModel.h"
#import "MGDynamicTopicModel.h"

#import "BzoneLogic.h"


#import "UIView+CWChat.h"
#import "CWRecordModel.h"
#import "BGOssManager.h"

#import "HJAudioBubble.h"
#import <ZQPlayer/ZQPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "JZVideoPlayerView.h"

#import "MultipleFileUploads.h"


#define kATFormat  @"@%@ "
#define kATRegular @"@[\\u4e00-\\u9fa5\\w\\-\\_]+ "
typedef NS_ENUM(NSInteger, BGMediaType)
{
    BGMediaTypeText =1,                    /**<1文本*/
    BGMediaTypeImage,                  /**<2图片*/
    BGMediaTypeVideo,                   /**<3视频*/
};
@interface ReleaseDynamicVC ()<UITextViewDelegate,JZPlayerViewDelegate>{

    JZVideoPlayerView *_jzPlayer;
}

@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UIButton *releaseeBtn;



@property(nonatomic, strong) UIScrollView *mainScrollView;
//备注
@property(nonatomic,strong) UITextView *titleTextView;/**<标题*/

@property(nonatomic,strong) UIView *centerView;/**<*/

@property(nonatomic,strong) ChatBarTextView *noteTextView;/**<文字*/
@property(nonatomic,strong) UIView *topicView;/**<话题*/
@property(nonatomic,strong) UIView *locationView;/**<定位*/

@property(nonatomic, strong) UILabel *contentNumL;

@property(nonatomic,strong) UIButton *locationBtn;/**<定位*/
@property(nonatomic, strong) NSString *city;
@property(nonatomic,strong) UIView *anonymousView;/**<匿名*/

@property(nonatomic, assign) BOOL showLocation;
@property(nonatomic, assign) BOOL hidName;

@property(nonatomic,strong) UIView *toolView;/**<工具*/

@property(nonatomic,strong) UIButton *topicBtn;/**<话题*/
@property(nonatomic,strong) UIButton *topicTipBtn;/**<话题Tip*/

@property(nonatomic,strong) UIButton *imageBtn;
@property(nonatomic, strong) UIButton *videoBtn;
@property(nonatomic,strong) UIButton *emojBtn;
@property(nonatomic, strong) UIButton *atBtn;


@property(nonatomic, assign) BOOL video;


//发布按钮
@property(nonatomic,strong) UIButton *submitBtn;
@property(nonatomic, strong) UIButton *delAudio;


@property (strong, nonatomic) ChatEmojiView *emojiView;
@property (assign, nonatomic) CGSize keyboardSize;
@property (assign, nonatomic) CGFloat oldTextViewHeight;
@property (assign, nonatomic) CGFloat animationDuration;
@property (nonatomic, assign, getter=isClosed) BOOL close;

@property (nonatomic, assign) FWChatBarShowType showType;

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) NSString *selectedTopicID;

@property(nonatomic, assign) NSInteger videoDurationTime;/**<限制-最大视频时长(秒)*/
@property(nonatomic, assign) NSInteger selectedVideoDurationTime;/**<视频时长(秒)*/

@property(nonatomic, assign) NSInteger textMaxlength;/**<限制-动态文本长度*/
@property(nonatomic, assign) NSInteger imgMaxCount;/**<限制-图片个数*/

@property(nonatomic, assign) BGMediaType type;

@property(nonatomic, strong) BzoneLogic *bzoneLogic;

@property (nonatomic, strong) BGOssManager            *ossManager;              //oss 类

/** 音频气泡 */
@property(nonatomic,strong) AVPlayer *player;

@property(nonatomic, strong) MultipleFileUploads *multipleFileUploads;

@property(nonatomic, strong) UIButton *addImgBtn;

@end

@implementation ReleaseDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    _ossManager = [[BGOssManager alloc]initWithDelegate:self];
    _bzoneLogic = [BzoneLogic new];
    self.selectedTopicID = @"";
    self.type = BGMediaTypeText;
    [self requestLimit];
    
    [self initViews];
    self.showInView = self.mainScrollView;
    
    [self initTopic];

    [self initPickerView];
    
    self.pickerCollectionView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,
                                                             NSFontAttributeName:[UIFont systemFontOfSize:15]
    } forState:UIControlStateNormal];
                                                          
}


#pragma mark - Private Methods

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (self.isClosed)
    {
        return;
    }
    self.keyboardSize = CGSizeZero;
    if (_showType == FWChatBarShowTypeKeyboard)
    {
        _showType = FWChatBarShowTypeNothing;
    }
    [self updateChatBarKeyBoardConstraints];
    //    [self updateChatBarConstraintsIfNeeded];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (self.isClosed)
    {
        return;
    }
    CGFloat oldHeight = self.keyboardSize.height;
    self.keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //兼容搜狗输入法：一次键盘事件会通知两次，且键盘高度不一。
    if (self.keyboardSize.height != oldHeight)
    {
        _showType = FWChatBarShowTypeNothing;
    }
    if (self.keyboardSize.height == 0)
    {
        _showType = FWChatBarShowTypeNothing;
        return;
    }
    // 获取键盘弹出动画时间
    _animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //    self.allowTextViewContentOffset = YES;
    [self updateChatBarKeyBoardConstraints];
    self.showType = FWChatBarShowTypeKeyboard;
}


- (void)updateChatBarKeyBoardConstraints
{
    self.toolView.y = kScreenH -(self.keyboardSize.height + MG_BOTTOM_MARGIN + 50);
    
}


- (void)requestLimit{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"dynamic_rule" forKey:@"act"];
    
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        NSArray * array = responseJson[@"data"];
        for (NSDictionary * dict in array) {
            NSString * name = dict[@"name"];
            if ([name isEqualToString:@"dynaic_video_length"]) {
                self.videoDurationTime = [dict[@"value"] integerValue];
            }
            
            if ([name isEqualToString:@"dynaic_txt_length"]) {
                self.textMaxlength = [dict[@"value"] integerValue];
                self.contentNumL.text = [NSString stringWithFormat:@"0/%ld",self.textMaxlength];
                self.noteTextView.zw_placeHolder= [NSString stringWithFormat:ASLocalizedString(@"想和大家分享些什么呢?(正文不能多于%ld字)"),self.textMaxlength] ;
            }
            if ([name isEqualToString:@"dynaic_img_length"]) {
                self.maxCount =
                self.imgMaxCount = [dict[@"value"] integerValue];
                
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
}

- (void)initNavView{
    
    self.closeBtn = ({
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    [self.view addSubview:self.closeBtn];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight - kRealValue(40));
        make.left.equalTo(@12);
        make.width.height.mas_equalTo(kRealValue(40));
    }];
    
    
    self.releaseeBtn = ({
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor colorWithHexString:@"#CD49FF"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitle:ASLocalizedString(@"发布")forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(releaseeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:self.releaseeBtn];
    
    [self.releaseeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.closeBtn);
        make.right.equalTo(@(-10));
    }];
}



/**
 *  初始化视图
 */

- (void)initViews{
    self.mainScrollView.frame = CGRectMake(0,(kNavigationBarHeight+kStatusBarHeight) , kScreenW, kScreenH-(kNavigationBarHeight+kStatusBarHeight)-(IPHONE_X ? 34 : 0));
    
    [self.view addSubview:self.mainScrollView];
    
    //    self.titleTextView.frame = CGRectMake(0, 10, kScreenW, 30);
    self.noteTextView.frame = CGRectMake(0,0, kScreenW, 130);
    [self.mainScrollView addSubview:self.noteTextView];
    
    
    
    //数字
    self.contentNumL.frame = CGRectMake(kScreenW / 2, self.noteTextView.bottom, kScreenW / 2 - kRealValue(5), kRealValue(20));
    self.contentNumL.text = [NSString stringWithFormat:@"0/%ld",self.textMaxlength];
    [self.mainScrollView addSubview:self.contentNumL];
    
    
    CGFloat viewWidth = (kScreenW - 10 * 4) / 3;
    self.addImgBtn.frame = CGRectMake(kRealValue(10), self.contentNumL.bottom, viewWidth, viewWidth);
    [self.mainScrollView addSubview:self.addImgBtn];
    
    
    self.pickerCollectionView.hidden = YES;
//    [self updatePickerViewFrameY:self.contentNumL.bottom+10];
    
    
    CGFloat height = 53;
    NSString * locationStr = ASLocalizedString(@" 定位");
    //    if (self.BuguLive.locationCity != nil && ![self.BuguLive.locationCity isEqualToString:@""]) {
    //        locationStr = self.BuguLive.locationCity;
    //                             }
    STBMKCenter *stBMKCenter = [STBMKCenter shareManager];
    
    if (!stBMKCenter.districtStr ||stBMKCenter.districtStr.length<2) {
    }else{
        locationStr = stBMKCenter.districtStr;
    }
    
    NSArray * titleArr = @[ASLocalizedString(@"话题"),locationStr,ASLocalizedString(@"匿名")];
    NSArray * imageArr = @[ASLocalizedString(@"话题"),ASLocalizedString(@"济南市"),ASLocalizedString(@"匿名")];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, self.addImgBtn.bottom + 10, kScreenW, 163)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [self.mainScrollView addSubview:view];
    self.centerView = view;
    
    for (int i = 0; i < 3; i ++) {
        
        UIView * aview = [[UIView alloc]initWithFrame:CGRectMake(0, 1+(height+1)*i, kScreenW, height)];
        aview.backgroundColor = kWhiteColor;
        [view addSubview:aview];
        
        QMUIButton *leftBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [leftBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [leftBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        leftBtn.imagePosition = QMUIButtonImagePositionLeft;
        [leftBtn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        leftBtn.spacingBetweenImageAndTitle = 3;
        leftBtn.userInteractionEnabled = NO;
        //        if (i == 1) {
        //            [leftBtn addTarget:self action:@selector(locationButtonClick) forControlEvents:UIControlEventTouchUpInside];
        //
        //        }
        if (i == 0) {
            //添加一个隐藏的 topicBtn
            
            QMUIButton *topicBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
            topicBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            topicBtn.imagePosition = QMUIButtonImagePositionRight;
            [topicBtn setImage:[UIImage imageNamed:@"删除话题"] forState:UIControlStateNormal];
            topicBtn.spacingBetweenImageAndTitle = 15;
            topicBtn.frame = CGRectMake(kScreenW-100-10, 15, 100, 24);
            topicBtn.layer.cornerRadius = 12;
            topicBtn.clipsToBounds = YES;
            topicBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
            [topicBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            topicBtn.hidden = YES;
            [topicBtn addTarget:self action:@selector(deleteTopicButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [aview addSubview:topicBtn];
            self.topicBtn = topicBtn;
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicViewTapped)];
            
            [aview addGestureRecognizer:tapRecognizer];
        }
        [aview addSubview:leftBtn];
        if (i == 1) {
            self.locationBtn = leftBtn;
        }
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(@0);
            make.width.equalTo(@200);
        }];
        
        
        QMUIButton *rightBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        if (i == 0) {
            [rightBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            [rightBtn setTitle:ASLocalizedString(@"参与话题,让更多人看到")forState:UIControlStateNormal];
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            rightBtn.imagePosition = QMUIButtonImagePositionRight;
            
            [rightBtn setImage:[UIImage imageNamed:@"进入"] forState:UIControlStateNormal];
            rightBtn.spacingBetweenImageAndTitle = 16;
            rightBtn.userInteractionEnabled = NO;
            self.topicTipBtn = rightBtn;
            
        } else {
            [rightBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
            [rightBtn setImage:[UIImage imageNamed:@"打开"] forState:UIControlStateSelected];
            [rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        rightBtn.tag = i;
        [aview addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-10));
            make.centerY.equalTo(@0);
            make.width.equalTo(@180);
            
        }];

    }
    
    
    UIView * toolsView = [[UIView alloc]init];
    
    [self.view addSubview:toolsView];
    toolsView.frame = CGRectMake(0,self.mainScrollView.bottom , kScreenW, kRealValue(44) + MG_BOTTOM_MARGIN);
    self.toolView = toolsView;
    self.toolView.backgroundColor = kWhiteColor;
    self.toolView.hidden = YES;
//    [self.view bringSubviewToFront:self.toolView];
    NSArray * imageToolArr = @[ASLocalizedString(@"照片"),ASLocalizedString(@"视频")];
//                               ,@"@"];
    
    for (int i = 0; i < imageToolArr.count; i ++) {
        
        QMUIButton *Btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        
        [Btn setImage:[UIImage imageNamed:imageToolArr[i]] forState:UIControlStateNormal];
        [Btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        Btn.tag = i+10;
        [toolsView addSubview:Btn];
        Btn.frame = CGRectMake(10+(26+20)*i, 10 + MG_TOP_MARGIN / 2, 26, 26);
        
        if (i == 2) {
            self.atBtn = Btn;
        }
    }
    
    [self.emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.left.mas_equalTo(0);
        make.height.mas_equalTo(kChatBarViewHeight);
        make.top.mas_equalTo(kScreenH);
    }];
}

- (CGSize)preferredSizeWithMaxWidth:(CGFloat)maxWidth view:(UIButton *)btn
{
    CGSize  size = [btn sizeThatFits:CGSizeMake(maxWidth, 24)] ;
    return CGSizeMake(size.width +25, size.height);
}


- (void)deleteTopicButtonClick{
    
    self.topicBtn.hidden = YES;
    self.topicTipBtn.hidden = NO;
    self.selectedTopicID = @"";
}

- (void)locationButtonClick{
    
    [FanweMessage alert:ASLocalizedString(@"请在设置->隐私->定位服务->本App下选择使用期间")];
}


- (void)topicViewTapped{
    
    //进入话题页面
    ReleaseTopicVC *tmpController = [[ReleaseTopicVC alloc]init];
    __weak __typeof(self)weakSelf = self;;
    tmpController.releaseTopicBlock = ^(MGDynamicTopicModel * _Nonnull topic) {
        weakSelf.topicTipBtn.hidden = YES;
        weakSelf.topicBtn.hidden = NO;
        weakSelf.selectedTopicID = topic.t_id;
        [weakSelf.topicBtn setTitle:[NSString stringWithFormat:@"#%@#",topic.name] forState:UIControlStateNormal];
        CGSize btnSize = [self preferredSizeWithMaxWidth:kScreenW-100 view:weakSelf.topicBtn];
        
        weakSelf.topicBtn.frame = CGRectMake(kScreenW-btnSize.width-10, 15, btnSize.width, 24);
    };
    [self.navigationController pushViewController:tmpController animated:YES];
    //选择话题后，设置frame
}

- (void)initTopic{
    if (self.topic) {
        self.topicTipBtn.hidden = YES;
        self.topicBtn.hidden = NO;
        if (![BGUtils isBlankString:self.topic.id]) {
            self.selectedTopicID = self.topic.id;
        }else{
            self.selectedTopicID = self.topic.t_id;
        }
        
        [self.topicBtn setTitle:[NSString stringWithFormat:@"#%@#",self.topic.name] forState:UIControlStateNormal];
        CGSize btnSize = [self preferredSizeWithMaxWidth:kScreenW-100 view:self.topicBtn];
        
        self.topicBtn.frame = CGRectMake(kScreenW-btnSize.width-10, 15, btnSize.width, 24);
    }

}

- (void)buttonClick:(UIButton *)sender{
    NSLog(ASLocalizedString(@"按钮===========%ld"),(long)sender.tag);
    [self.noteTextView resignFirstResponder];
    switch (sender.tag) {
            
        case 1:
        {//定位
            sender.selected = !sender.selected;
            self.showLocation = !self.showLocation;
            
            if (sender.selected) {
                
                [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"定位中...")];
                //加载地图
                [self startLocation];
                
                
            } else {
                [self.locationBtn setTitle:ASLocalizedString(@"定位")forState:UIControlStateNormal];
            }
            
            
        }
            break;
        case 2:
        {//匿名
            sender.selected = !sender.selected;
            self.hidName = !self.hidName;
            self.atBtn.hidden = (sender.selected == YES);
        }
            break;
            
        case 10:
        {//选择图片 图片和视频不能共存
            [self addNewImg];
            
            if (self.pickerCollectionView.hidden == YES) {
                self.pickerCollectionView.hidden = NO;
            }
            [self updatePickerViewFrameY:self.contentNumL.bottom+10];
            
            self.centerView.frame = CGRectMake(0, self.pickerCollectionView.bottom+20, kScreenW, 163);
            
        }
            break;
        case 11:
        {//选择视频 图片和视频不能共存
            [self addNewVideo];
            
            if (self.pickerCollectionView.hidden == YES) {
                self.pickerCollectionView.hidden = NO;
            }
            self.addImgBtn.hidden = YES;
            [self updatePickerViewFrameY:self.contentNumL.bottom+10];
            
            self.centerView.frame = CGRectMake(0, self.pickerCollectionView.bottom+20, kScreenW, 163);
        }
            break;
//        case 12:
//        {//弹出表情
//            if ([self.titleTextView isFirstResponder]) {
//                [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"只有内容部分才能发表情")];
//            }else{
////                [self showFaceView:YES];
//
//            }
//
//
//
//        }
//            break;
        case 12:
        {//@先不加
            /*
            NSInteger length = self.noteTextView.text.length;
            
            ReleaseAtPeopleVC *tmpController = [[ReleaseAtPeopleVC alloc]init];
            
            tmpController.releaseAtPeopleBlock = ^(PersonCenterUserModel * _Nonnull user) {
                UITextView *textView = self.noteTextView;
                
                NSString *insertString = [NSString stringWithFormat:kATFormat,user.nick_name];
                NSMutableString *string = [NSMutableString stringWithString:textView.text];
                [string insertString:insertString atIndex:length];
                self.noteTextView.text = string;
                
                [self.noteTextView becomeFirstResponder];
                textView.selectedRange = NSMakeRange(length + insertString.length, 0);
            };
            [self.navigationController pushViewController:tmpController animated:YES];
            */
        }
            break;
        default:
            break;
    }
    
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
            
            NSString * location = [address objectForKey:@"City"];
            self.city = location;
            [self.locationBtn setTitle:location forState:UIControlStateNormal];
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



- (void)pickerViewFrameChanged{
    
    if (self.arrSelected.count > 0) {
        self.addImgBtn.hidden = YES;
        [self updatePickerViewFrameY:self.contentNumL.bottom+10];
    }else{
        self.addImgBtn.hidden = NO;
        [self updatePickerViewFrameY:self.addImgBtn.bottom+10];
    }
    
    [self updateViewsFrame];
}

- (void)updateViewsFrame{
    self.centerView.frame = CGRectMake(0, self.pickerCollectionView.bottom+20, kScreenW, 163);
    
    //    allViewHeight = noteTextHeight + [self getPickerViewFrame].size.height + 30 + 100;
    
    self.mainScrollView.contentSize = CGSizeMake(0,[self getPickerViewFrame].size.height+140+20+163+20);
    
}


- (void)closeButtonClick{
    
    if (self.noteTextView.text.length == 0 && self.bigImageArray.count < 1 && self.arrSelected.count < 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSLog(ASLocalizedString(@"取消"));
    @autoreleasepool {
        
        __weak typeof(self)weakself =self;
        [FanweMessage alertController:ASLocalizedString(@"有修改，是否放弃上传")viewController:self destructiveAction:^{
             [weakself dismissViewControllerAnimated:YES completion:nil];
        } cancelAction:^{
            
        }];

        
//        __weak typeof(self)weakself =self;
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:ASLocalizedString(@"取消")style:UIAlertActionStyleCancel handler:nil];
//        UIAlertAction *actionGiveUpPublish = [UIAlertAction actionWithTitle:ASLocalizedString(@"放弃上传")style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            [weakself dismissViewControllerAnimated:YES completion:nil];
//        }];
//        [alertController addAction:actionCacel];
//        [alertController addAction:actionGiveUpPublish];
//        [self presentViewController:alertController animated:YES completion:nil];
//        actionCacel =nil;
//        actionGiveUpPublish =nil;
//        alertController =nil;
    }
}

#pragma mark -发布
- (void)releaseeButtonClick{
    
//    if (self.noteTextView.text.length<20) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"不能少于20字哦")preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:actionCacel];
//        [self presentViewController:alertController animated:YES completion:nil];
//        return;
//    }
    
    if (self.noteTextView.text.length>self.textMaxlength) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"超出文字限制")preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:actionCacel];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
    [self submitToServer];
}


#pragma mark - 上传数据到服务器前将图片转data（上传服务器用form表单：未写）
- (void)submitToServer{
    
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
//        [self PhassetgetBigImageArray:self.arrSelected callBack:^(NSArray *ary, bool isImg) {
//
//        }];
    }else
    {
        self.type = BGMediaTypeText;
        __weak __typeof(self)weakSelf = self;
        NSString * location = @"";
        if (self.showLocation) {
            location = self.city;
        }

        if ([BGUtils isBlankString:_noteTextView.text]) {
               
            [[BGHUDHelper sharedInstance]loading:ASLocalizedString(@"内容不能为空！")delay:1.0f execute:nil completion:nil];
           return;
        }
        

        [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在上传")];
        
        [self.bzoneLogic addDynamicType:self.type content:_noteTextView.text media:@[] cover_url:@"" no_name:self.hidName themeID:self.selectedTopicID address:location media_attr:@"" at:@"" shop_id:@"" shop_title:@"" Success:^(BOOL isFinished) {
            [[BGHUDHelper sharedInstance]syncStopLoading];
            if (isFinished) {
                if (weakSelf.postFinishBlock) {
                    weakSelf.postFinishBlock(isFinished);
                }
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

//-(void)initJZPlayerWithUrl:(NSURL *)url{
//    _jzPlayer = [[JZVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 300) contentURL:url];
//    _jzPlayer.delegate = self;
//    [self.view addSubview:_jzPlayer];
//    [_jzPlayer play];
//}

- (void)submitToserverWith:(NSArray * )imgary isImg:(BOOL)isImg
{
    
    if (imgary.count == 0 ) {
        
    }
    
    NSString *type = @"0";
    if (isImg) {
        type = @"0";
    }else{
        type = @"1";
    }
    
    //上传照片
//    [[BGHUDHelper sharedInstance]syncStopLoading];
    [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在上传数据中...")];
    
    //上传音频，没有图片时
    __weak __typeof(self)weakSelf = self;
    if ([type isEqualToString:@"1"]) {
        //上传视频
        self.type = BGMediaTypeVideo;
        
        PHAsset* phasset = self.arrSelected[0];
        
        PHVideoRequestOptions *optionForCache = [[PHVideoRequestOptions alloc]init];
        
        optionForCache.version = PHVideoRequestOptionsVersionOriginal;
        optionForCache.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        optionForCache.networkAccessAllowed = YES;
        
        [[PHImageManager defaultManager] requestAVAssetForVideo:phasset options:optionForCache resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            CMTime   time = [urlAsset duration];
            int seconds = ceil(time.value/time.timescale);
            NSLog(ASLocalizedString(@"视频时长%d"),seconds);
            
            
            self.selectedVideoDurationTime = seconds;
            if ((int)seconds <3) {
                [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"选取视频时长太小")];
                //关闭当前的模态视图
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                return;
            }else if((int)seconds >=self.videoDurationTime) {
                [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"选取视频时长太大")];
                //关闭当前的模态视图
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }];
                return;
            }else{
                [self uploadVideo];
                
            }
        }];
    }else{
        self.type = BGMediaTypeImage;
        
        NSLog(@"%@",self.bigImageArray);
        
        
        if([GlobalVariables sharedInstance].appModel.open_sts != 1)
        {
            NSMutableArray<MultipleFileUploadsModel *> *arr = [NSMutableArray array];

            for (int i =0 ; i<self.bigImageArray.count; i++) {
                MultipleFileUploadsModel *model = [[MultipleFileUploadsModel alloc] init];
                model.fileName = [NSString stringWithFormat:@"uploadpng%d.png",i];
                model.data =self.bigImageArray[i];
                [arr addObject:model];
            }
            
            
            [[BGHUDHelper sharedInstance]syncStopLoading];
            [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在上传图片...")];
            NSString * location = @"";
            if (self.showLocation) {
                location = self.city;
            }

            [self.multipleFileUploads uploadFile:arr done:^(NSArray<NSString *> * _Nonnull urlStrMArray) {
                
                [weakSelf.bzoneLogic addDynamicType:self.type content:_noteTextView.text media:urlStrMArray cover_url:@"" no_name:self.hidName themeID:self.selectedTopicID address:location media_attr:[NSString stringWithFormat:@"%lu",(unsigned long)urlStrMArray.count] at:@"" shop_id:@"" shop_title:@""  Success:^(BOOL isFinished) {
                    [[BGHUDHelper sharedInstance]syncStopLoading];
                    if (isFinished) {
                        if (weakSelf.postFinishBlock) {
                            weakSelf.postFinishBlock(isFinished);
                        }
                        [[BGHUDHelper sharedInstance]syncStopLoading];
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                }];

                
            }];
            
            return;
        }
        
        [_ossManager showUploadOfOssServiceOfDataMarray:self.bigImageArray andSTDynamicSelectType:STDynamicSelectPhoto andComplete:^(BOOL finished, NSMutableArray<NSString *> *urlStrMArray) {
            NSLog(@"%@",urlStrMArray);
            [[BGHUDHelper sharedInstance]syncStopLoading];
            [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在上传图片...")];
            NSString * location = @"";
            if (self.showLocation) {
                location = self.city;
            }
            [weakSelf.bzoneLogic addDynamicType:self.type content:_noteTextView.text media:urlStrMArray cover_url:@"" no_name:self.hidName themeID:self.selectedTopicID address:location media_attr:[NSString stringWithFormat:@"%lu",(unsigned long)urlStrMArray.count] at:@""shop_id:@"" shop_title:@"" Success:^(BOOL isFinished) {
                [[BGHUDHelper sharedInstance]syncStopLoading];
                if (isFinished) {
                    if (weakSelf.postFinishBlock) {
                        weakSelf.postFinishBlock(isFinished);
                    }
                    [[BGHUDHelper sharedInstance]syncStopLoading];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }];
    }
}

- (void)uploadVideo{
    
    //视频类型的动态
    __weak __typeof(self)weakSelf = self;
    
    UIImage *coverimg =self.imageArray[0];
    NSData *imageData = UIImagePNGRepresentation(coverimg);
    //        dispatch_group_t group = dispatch_group_create();
    __block NSString *coverUrl;
    //        __block NSString *videoUrl;
    //        __block NSString *audioUrl = @"";
    //        __block typeof(self)blockself =self;
    
    NSArray *coverArr  = [NSArray arrayWithObjects:imageData, nil];
    
    
    if([GlobalVariables sharedInstance].appModel.open_sts != 1)
    {
            NSMutableArray *uploadArr = [NSMutableArray array];
            //添加封面
            MultipleFileUploadsModel *photoModel = [[MultipleFileUploadsModel alloc] init];
            photoModel.fileName = @"photo.png";
            photoModel.data = imageData;
            [uploadArr addObject:photoModel];
            
            //添加视频
            MultipleFileUploadsModel *videoModel = [[MultipleFileUploadsModel alloc] init];
            videoModel.fileName = @"vidoe.mov";
            videoModel.data = self.bigImageArray[0];
            [uploadArr addObject:videoModel];
            
            [self.multipleFileUploads uploadFile:uploadArr done:^(NSArray<NSString *> * _Nonnull urlArr) {
                
                [[BGHUDHelper sharedInstance]syncStopLoading];
                if(urlArr.count < 2)
                {
                    [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"上传失败")];
                }
                else
                {
                             NSString *videoUrl;
                               if([urlArr[0] containsString:@".png"])
                               {
                                   coverUrl = urlArr[0];
                                   videoUrl = urlArr[1];
                               }
                               else
                               {
                                   coverUrl = urlArr[1];
                                   videoUrl = urlArr[0];
                               }
                               
                    
                                   NSString * location = @"";
                                   if (self.showLocation) {
                                       location = self.city;
                                   }
                                   
                                   
                                   
                                   [weakSelf.bzoneLogic addDynamicType:self.type content:_noteTextView.text media:@[videoUrl] cover_url:coverUrl no_name:self.hidName themeID:self.selectedTopicID address:location media_attr:[NSString stringWithFormat:@"%ld",(long)self.selectedVideoDurationTime] at:@"" shop_id:@"" shop_title:@""  Success:^(BOOL isFinished) {
                                       
                                       if (isFinished) {
                                           if (weakSelf.postFinishBlock) {
                                               weakSelf.postFinishBlock(isFinished);
                                           }
                                           [[BGHUDHelper sharedInstance]syncStopLoading];
                                           [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                       }
                                       
                                   }];
                    
                }
  
                    
                
            }];
            
            return;
    }
    
    [_ossManager showUploadOfOssServiceOfDataMarray:coverArr andSTDynamicSelectType:STDynamicSelectPhoto andComplete:^(BOOL finished, NSMutableArray<NSString *> *urlStrMArray) {
        NSLog(@"%@",urlStrMArray);
        
        coverUrl = urlStrMArray.firstObject;
        
        
        [[BGHUDHelper sharedInstance]syncStopLoading];
        [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在上传视频...")];
        NSLog(@"%@",self.bigImageArray);
        
//        NSData *data = self.bigImageArray.firstObject;
        
        [self.ossManager showUploadOfOssServiceOfDataMarray:self.bigImageArray
                                     andSTDynamicSelectType:STDynamicSelectVideo
                                                andComplete:^(BOOL finished,
                                                              NSMutableArray<NSString *> *urlStrMArrayVideo) {
            
            [[BGHUDHelper sharedInstance]syncStopLoading];
            
            if(urlStrMArrayVideo.count>0)
            {
                NSString * location = @"";
                if (self.showLocation) {
                    location = self.city;
                }
                
                
                
                [weakSelf.bzoneLogic addDynamicType:self.type content:_noteTextView.text media:@[urlStrMArrayVideo.firstObject] cover_url:coverUrl no_name:self.hidName themeID:self.selectedTopicID address:location media_attr:[NSString stringWithFormat:@"%ld",(long)self.selectedVideoDurationTime] at:@"" shop_id:@"" shop_title:@""  Success:^(BOOL isFinished) {
                    
                    if (isFinished) {
                        if (weakSelf.postFinishBlock) {
                            weakSelf.postFinishBlock(isFinished);
                        }
                        [[BGHUDHelper sharedInstance]syncStopLoading];
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                    
                }];
                
            }
        }];
    }];
}

#pragma mark - chat Emoji View Delegate
- (void)chatEmojiViewSelectEmojiIcon:(EmojiObj *)objIcon
{
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    int emojiID = [[objIcon.emojiName stringByTrimmingCharactersInSet:nonDigits] intValue];
    [self.noteTextView appendFace:emojiID];
    //    [self.chatBar updateChatBarConstraintsIfNeededShouldCacheText:YES];
}

- (void)chatEmojiViewTouchUpinsideDeleteButton
{
    //点击了删除表情
    if (self.noteTextView.text.length > 0)
    {
        NSRange range = self.noteTextView.selectedRange;
        NSInteger location = (NSInteger) range.location;
        if (location == 0)
        {
            return;
        }
        range.location = location - 1;
        range.length = 1;
        
        NSMutableAttributedString *attStr = [self.noteTextView.attributedText mutableCopy];
        [attStr deleteCharactersInRange:range];
        self.noteTextView.attributedText = attStr;
        self.noteTextView.selectedRange = range;
    }
}

- (void)chatEmojiViewTouchDownDeleteButton
{
    self.noteTextView.text = nil;
    //    [self.chatBar updateChatBarConstraintsIfNeededShouldCacheText:YES];
}

- (void)chatEmojiViewTouchUpinsideSendButton
{
    //表情键盘：点击发送表情
    if (self.noteTextView.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:ASLocalizedString(@"请先输入发送内容")];
        return;
    }
    else
    {
        
        
        //        [self willSendThisText:[self.noteTextView getSendTextStr]];
    }
}
#pragma mark - UITextViewDelegate

/*由于联想输入的时候，函数textView:shouldChangeTextInRange:replacementText:无法判断字数，
 因此使用textViewDidChange对TextView里面的字数进行判断
 */
- (void)textViewDidChange:(UITextView *)textView{
 
    if (textView == self.noteTextView) {
        self.contentNumL.text = [NSString stringWithFormat:@"%ld/%ld",self.noteTextView.text.length,self.textMaxlength];
        
        if (self.noteTextView.text.length > self.textMaxlength) {
//            textView.text = [textView.text substringToIndex:199];
           
            self.noteTextView.text = [textView.text substringToIndex:self.textMaxlength];
             self.contentNumL.text = [NSString stringWithFormat:@"%ld/%ld",self.noteTextView.text.length,self.textMaxlength];
            
            [FanweMessage alert:ASLocalizedString(@"提示")message:[NSString stringWithFormat:ASLocalizedString(@"正文不能多于%ld字"),self.textMaxlength] isHideTitle:NO destructiveAction:nil];
            
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.noteTextView) {
        if (self.noteTextView.text.length > self.textMaxlength) {
            [FanweMessage alert:ASLocalizedString(@"提示")message:[NSString stringWithFormat:ASLocalizedString(@"正文不能多于%ld字"),self.textMaxlength] isHideTitle:NO destructiveAction:nil];
            textView.text = [textView.text substringToIndex:self.textMaxlength];
            self.contentNumL.text = [NSString stringWithFormat:@"%ld/%ld",self.noteTextView.text.length,self.textMaxlength];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (textView == self.titleTextView) {
        
        return YES;
    }
    
    
    
    if ([text isEqualToString:@""])
    {
        NSRange selectRange = textView.selectedRange;
        if (selectRange.length > 0)
        {
            //用户长按选择文本时不处理
            return YES;
        }
        
        // 判断删除的是一个@中间的字符就整体删除
        NSMutableString *string = [NSMutableString stringWithString:textView.text];
        NSArray *matches = [self findAllAt];
        
        BOOL inAt = NO;
        NSInteger index = range.location;
        for (NSTextCheckingResult *match in matches)
        {
            NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
            if (NSLocationInRange(range.location, newRange))
            {
                inAt = YES;
                index = match.range.location;
                [string replaceCharactersInRange:match.range withString:@""];
                break;
            }
        }
        
        if (inAt)
        {
            textView.text = string;
            textView.selectedRange = NSMakeRange(index, 0);
            return NO;
        }
    }
    
    //判断是回车键就
    if ([text isEqualToString:@"\n"])
    {
        
        return NO;
    }
    
    return YES;
    
    
}

//- (void)textViewDidChange:(UITextView *)textView{
//    UITextRange *selectedRange = textView.markedTextRange;
//    NSString *newText = [textView textInRange:selectedRange];
//
//    if (newText.length < 1)
//    {
//        // 高亮输入框中的@
//        UITextView *textView = self.noteTextView;
//        NSRange range = textView.selectedRange;
//
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:textView.text];
//        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.string.length)];
//
//        NSArray *matches = [self findAllAt];
//
//        for (NSTextCheckingResult *match in matches)
//        {
//            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#CD49FF"] range:NSMakeRange(match.range.location, match.range.length - 1)];
//        }
//
//        textView.attributedText = string;
//        textView.selectedRange = range;
//    }
//
//    //获取高亮部分
//       UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
//       //如果在变化中是高亮部分在变，就不要计算字符了
//       if (selectedRange && pos) {
//           return;
//       }
//       NSString  *nsTextContent = textView.text;
//       NSInteger existTextNum = nsTextContent.length;
//       if (existTextNum >self.textMaxlength){
//           //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
//           NSString *s = [nsTextContent substringToIndex:self.textMaxlength];
//           [textView setText:s];
//       }
//       //不让显示负数
////       self.showWordsNumLab.text = [NSString stringWithFormat:@"%ld/100",(MAX_LIMIT_NUMS - existTextNum)];
//
//}

//- (void)textViewDidChangeSelection:(UITextView *)textView{
//
//    // 光标不能点落在@词中间
//    NSRange range = textView.selectedRange;
//    if (range.length > 0)
//    {
//        // 选择文本时可以
//        return;
//    }
//
//    NSArray *matches = [self findAllAt];
//
//    for (NSTextCheckingResult *match in matches)
//    {
//        NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
//        if (NSLocationInRange(range.location, newRange))
//        {
//            textView.selectedRange = NSMakeRange(match.range.location + match.range.length, 0);
//            break;
//        }
//    }
//}

#pragma mark - Private

- (NSArray<NSTextCheckingResult *> *)findAllAt
{
    // 找到文本中所有的@
    NSString *string = self.noteTextView.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}
#pragma mark -
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //停止定位
}



- (void)showFaceView:(BOOL)show
{
    if (show)
    {
        self.emojiView.hidden = NO;
        [UIView animateWithDuration:0.25f
                         animations:^{
            [self.emojiView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_bottom).offset(-kChatBarViewHeight);
            }];
            [self.emojiView layoutIfNeeded];
        }
                         completion:nil];
        
        [self.emojiView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kScreenH-kChatBarViewHeight);
        }];
        
        [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-kChatBarViewHeight-MG_BOTTOM_MARGIN);
        }];
        
        [UIView animateWithDuration:_animationDuration/4
                         animations:^{
            [self.toolView layoutIfNeeded];
        }completion:nil];
        
    }
    else if (self.emojiView.superview)
    {
        self.emojiView.hidden = YES;
        [self.emojiView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.and.left.mas_equalTo(self);
            make.height.mas_equalTo(kChatBarViewHeight);
            make.top.mas_equalTo(self.view.mas_bottom);
        }];
        [self.emojiView layoutIfNeeded];
        
    }
}



-(void)clickAddImgBtn:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *actionImg = [UIAlertAction actionWithTitle:ASLocalizedString(@"图片")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addNewImg];
        if (self.pickerCollectionView.hidden == YES) {
            self.pickerCollectionView.hidden = NO;
        }
        
        [self updatePickerViewFrameY:self.addImgBtn.bottom+10];
        
        self.centerView.frame = CGRectMake(0, self.pickerCollectionView.bottom+20, kScreenW, 163);
    }];
    
    UIAlertAction *actionVideo = [UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addNewVideo];
        if (self.pickerCollectionView.hidden == YES) {
            self.pickerCollectionView.hidden = NO;
        }
        [self updatePickerViewFrameY:self.addImgBtn.bottom+10];
        
        self.centerView.frame = CGRectMake(0, self.pickerCollectionView.bottom+20, kScreenW, 163);
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:ASLocalizedString(@"取消")style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:actionCancel];
    [alert addAction:actionImg];
    [alert addAction:actionVideo];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - setter
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



- (UITextView *)titleTextView{
    if (!_titleTextView) {
        _titleTextView=({
            UITextView *textview=[[UITextView alloc]init];
            textview.backgroundColor=[UIColor whiteColor];
            textview.font=[UIFont systemFontOfSize:15];
            textview.zw_placeHolder=ASLocalizedString(@"标题(选填)");
            textview.textContainerInset=UIEdgeInsetsMake(10, 10, 10, 10);
            //            textview.delegate = self;
            textview;
        });
    }
    return _titleTextView;
    
}

- (ChatBarTextView *)noteTextView{
    if (!_noteTextView) {
        _noteTextView = ({
            ChatBarTextView *textview=[[ChatBarTextView alloc]init];
            textview.backgroundColor=[UIColor whiteColor];
            textview.font = [UIFont systemFontOfSize:15];
            textview.delegate = self;
            textview.zw_placeHolder= [NSString stringWithFormat:ASLocalizedString(@"想和大家分享些什么呢?"),self.textMaxlength] ;
            textview.textContainerInset=UIEdgeInsetsMake(10, 10, 10, 10);
//            textview.delegate = self;
            textview;
        });
    }
    return _noteTextView;
}



-(UILabel *)contentNumL{
    if (!_contentNumL) {
        _contentNumL = [UILabel new];
        _contentNumL.font = [UIFont systemFontOfSize:15];
        _contentNumL.textColor = [UIColor colorWithHexString:@"666666"];
        _contentNumL.textAlignment = NSTextAlignmentRight;
    }
    return _contentNumL;
}

- (ChatEmojiView *)emojiView
{
    if (!_emojiView)
    {
        ChatEmojiView *emojiView = [[ChatEmojiView alloc] init];
        emojiView.hidden = YES;
        emojiView.delegate = self;
        emojiView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:(_emojiView = emojiView)];
    }
    return _emojiView;
}

-(MultipleFileUploads *)multipleFileUploads
{
    if(_multipleFileUploads ==nil)
    {
        _multipleFileUploads = [[MultipleFileUploads alloc] init];
    }
    return _multipleFileUploads;
}

-(UIButton *)addImgBtn{
    if (!_addImgBtn) {
        _addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImgBtn setBackgroundImage:[UIImage imageNamed:@"mine_edit_addPhoto"] forState:UIControlStateNormal];
        [_addImgBtn addTarget:self action:@selector(clickAddImgBtn:) forControlEvents:UIControlEventTouchUpInside];
        _addImgBtn.backgroundColor = kClearColor;
    }
    return _addImgBtn;
}

@end
