//
//  BGEditInfoController.m
//  BuguLive
//
//  Created by 丁凯 on 2017/6/12.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGEditInfoController.h"
#import "BGEditTCell.h"
#import "UserModel.h"
#import "GetHeadImgViewController.h"
#import "ChangeNameViewController.h"
#import "SexViewController.h"
#import "emotionView.h"
#import "birthdayView.h"
#import "areaView.h"
#import "BDView.h"

#import "BGOssManager.h"

#import "BRDatePickerView.h"
#import "BGEditInfoController.h"
#import "CountryPopupView.h"
@interface BGEditInfoController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,changeNameDelegate,changeSexDelegate,changeEmotionStatuDelegate,LZDateDelegate,AreaDelegate,OssUploadImageDelegate>

{
    BGOssManager      *_ossManager;
    NSString          *_uploadFilePath;
    NSString          *_urlString;
    NSString          *_timeString;//时间戳的字符串
    NSString * _urlStr;
    
   UIButton                     *_rightButton;             //保存
   UITableView                  *_tableView;
   NSMutableArray               *_dataArray;
   
   BGEditTCell                  *_TXCell;
   BGEditTCell                  *_NCCell;
   BGEditTCell                  *_ZHCell;
   BGEditTCell                  *_XBCell;
   BGEditTCell                  *_GXQMCell;
   BGEditTCell                  *_RZCell;
   BGEditTCell                  *_SRCell;
   BGEditTCell                  *_QGZTCell;
   BGEditTCell                  *_JXCell;
   BGEditTCell                  *_ZYCell;
   BGEditTCell *_GJCell; // 新增国家Cell

   int                          _isNeedLoad;
   UserModel                    *_model;
   NSString                     *_sexString;              //性别的字符串
   emotionView                  *_emotionViewVC;          //情感的view
   areaView                     *_areaViewVC;             //地区的view
   BDView                       *_datePicker;
   NSString                     *_provinceString;         //省份
   NSString                     *_cityString;             //城市
   UIView                       *_halfClearView;          //底部透明的view
   NSString                     *_nick_info;
    
    BRDatePickerView            *_datePickerView;
}

@end

@implementation BGEditInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    _urlStr = @"";
    if (self.BuguLive.appModel.open_sts == 1)
    {
        _ossManager = [[BGOssManager alloc]initWithDelegate:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isNeedLoad)
    {
        [self loadNetData];
    }
}

- (void)initFWUI
{
    [super initFWUI];
    _dataArray = [[NSMutableArray alloc]init];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.navigationItem.title = ASLocalizedString(@"编辑资料");
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-40, 5, 40, 30)];
    [_rightButton setTitle:ASLocalizedString(@"保存")forState:UIControlStateNormal];
    [_rightButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightButton addTarget:self action:@selector(saveEditButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-kNavigationBarHeight) style:UITableViewStylePlain];
//    [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-kNavigationBarHeight)];
    _tableView.backgroundColor = kBackGroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"BGEditTCell" bundle:nil] forCellReuseIdentifier:@"BGEditTCell"];
    [self.view addSubview:_tableView];
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
       if (![[self getVersionsNum] isEqualToString:self.BuguLive.appModel.region_versions] || ![[self getMyAreaDataArr] count])
       {
         [self loadMyAreaData];
       }
   });
}

#pragma mark 创建或者销毁halfClearView
- (void)isCreatHaldClearViewWithCount:(int)count
{
    if (count == 1)//创建_halfClearView
    {
        if (!_halfClearView)
        {
            _halfClearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
            _halfClearView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            [[UIApplication sharedApplication].keyWindow addSubview:_halfClearView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            tap.delegate = self;
            [_halfClearView addGestureRecognizer:tap];
        }
    }else//销毁_halfClearView
    {
        [_halfClearView removeFromSuperview];
        _halfClearView = nil;
        _emotionViewVC = nil;
        _areaViewVC    = nil;
        _datePicker    = nil;
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [self isCreatHaldClearViewWithCount:0];
}

#pragma mark comeBack
- (void)backClick
{
    if ([GlobalVariables sharedInstance].isUserInfoCheck) {
        WeakSelf
        [FanweMessage alertController:ASLocalizedString(@"当前资料未保存，是否放弃编辑")viewController:self destructiveAction:^{
            [[AppDelegate sharedAppDelegate]popViewController];
        } cancelAction:^{
            
        }];
        
        return;
    }
    
    [[AppDelegate sharedAppDelegate]popViewController];
}

- (void)initFWData
{
    [super initFWData];
    [self showMyHud];
    [self loadNetData];
}

#pragma mark 网络加载
- (void)loadNetData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"user_edit" forKey:@"act"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             _model = [UserModel mj_objectWithKeyValues:[responseJson objectForKey:@"user"]];
             _urlString = _model.head_image;
             _nick_info = [responseJson toString:@"nick_info"];
             _sexString = _model.sex;
             [_tableView reloadData];
         }else
         {
             [BGHUDHelper alert:[responseJson toString:@"error"]];
         }
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [self hideMyHud];
     }];
}
#pragma mark -- dataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ETab_Count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == ERZSection)
    {
        return 0;
    }else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ERZSection || indexPath.section == EJXSection)
    {
        return 0;
    }else
    {
        return 45*kAppRowHScale;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == ETXSection || section == ENCSection || section == ESRSection)
    {
        return kRealValue(10);
//        10*kAppRowHScale;
    }else
    {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(10))];
    view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
//    [UIColor colorWithRed:245 green:245 blue:245 alpha:1];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BGEditTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BGEditTCell" forIndexPath:indexPath];
    switch (indexPath.section)
    {
        case ETXSection:
            _TXCell = cell;
            [_TXCell creatCellWithStr:_model.head_image andSection:ETXSection];
            return _TXCell;
        case ENCSection:
            _NCCell = cell;
            [_NCCell creatCellWithStr:_model.nick_name andSection:ENCSection];
            return _NCCell;
        case EZHSection:
            _ZHCell = cell;
            [_ZHCell creatCellWithStr:_model.user_id andSection:EZHSection];
            return _ZHCell;
        case EXBSection:
            _XBCell = cell;
            [_XBCell creatCellWithStr:_model.sex andSection:EXBSection];
            return _XBCell;
        case EGXQMSection:
            _GXQMCell = cell;
            [_GXQMCell creatCellWithStr:_model.signature andSection:EGXQMSection];
            return _GXQMCell;
        case ERZSection:
            _RZCell = cell;
            return _RZCell;
        case ESRSection:
            _SRCell = cell;
            [_SRCell creatCellWithStr:_model.birthday andSection:ESRSection];
            return _SRCell;
        case EQGZTSection:
            _QGZTCell = cell;
            [_QGZTCell creatCellWithStr:_model.emotional_state andSection:EQGZTSection];
            return _QGZTCell;
        case EJXSection:
            _JXCell = cell;
            [_JXCell creatCellWithStr:_model.city andSection:EJXSection];
            _JXCell.hidden = YES;
            return _JXCell;
        case EGJSection: // 新增国家Cell
            _GJCell = cell;
            [_GJCell creatCellWithStr:_model.country_name andSection:EGJSection];
            return _GJCell;
        case EZYSection:
            _ZYCell = cell;
            [_ZYCell creatCellWithStr:_model.job andSection:EZYSection];
            _ZYCell.lineView.hidden = YES;
            return _ZYCell;
        default:
            return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case ETXSection:
        {
            GetHeadImgViewController *headVC = [[GetHeadImgViewController alloc] init];
            WeakSelf
            headVC.clickHeadImageBlock = ^(UIImage *image) {
                [weakSelf saveHeadImageWithImage:image];
            };
            headVC.headImgView.image = _TXCell.headImgView.image;
            headVC.userId = _model.user_id;
            [[AppDelegate sharedAppDelegate] pushViewController:headVC animated:YES];
        }
            break;
        case ENCSection:
        {
            [self pushToChangeNameViewWithType:1 andStr:_model.nick_name];
        }
            break;
        case EZHSection:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = _model.user_id;
            [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"复制成功")];
        }
            break;
        case EXBSection:
        {
            _isNeedLoad = NO;
            if ([_model.is_edit_sex intValue] == 0)
            {
                [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"性别不可编辑")];
                return;
            }
            FDActionSheet *actionSheet = [[FDActionSheet alloc] initWithTitle:@"" message:@""];
            [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"男") type:FDActionTypeDefault CallBack:^{
                [self changeSexWithString:@"1"];
            }]];
            [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"女") type:FDActionTypeDefault CallBack:^{
                [self changeSexWithString:@"2"];
            }]];
            [actionSheet show:[UIApplication sharedApplication].keyWindow];
        }
            break;
        case EGXQMSection:
        {
            [self pushToChangeNameViewWithType:2 andStr:_model.signature];
        }
            break;
        case ESRSection:
        {
            [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYMD title:ASLocalizedString(@"生日") selectValue:SafeStr(_model.birthday) resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                _SRCell.rightLabel.text = selectValue;
                _model.birthday = selectValue;
            }];
        }
            break;
        case EQGZTSection:
        {
            [self isCreatHaldClearViewWithCount:1];
            if (!_emotionViewVC)
            {
                _emotionViewVC = [[emotionView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 160) withName:_model.emotional_state];
                _emotionViewVC.delegate = self;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEmotion:)];
                [_emotionViewVC addGestureRecognizer:tap];
                [_halfClearView addSubview:_emotionViewVC];
                [UIView animateWithDuration:0.5 animations:^{
                    CGRect rect = _emotionViewVC.frame;
                    rect.origin.y = kScreenH - 160;
                    _emotionViewVC.frame = rect;
                }];
            }
        }
            break;
        case EJXSection:
        {
            [self isCreatHaldClearViewWithCount:1];
            if (!_areaViewVC)
            {
                _areaViewVC = [[areaView alloc] initWithDelegate:self withCity:_model.city];
                _areaViewVC.frame = CGRectMake(0, kScreenH, kScreenW, 190);
                [_halfClearView addSubview:_areaViewVC];
                [UIView animateWithDuration:0.5 animations:^{
                    CGRect rect = _areaViewVC.frame;
                    rect.origin.y = kScreenH - 190;
                    _areaViewVC.frame = rect;
                }];
            }
        }
            break;
        case EGJSection: // 新增国家选项
        {
            // 处理国家选择逻辑
            [self showCountryPopup];
        }
            break;
        case EZYSection:
        {
            [self pushToChangeNameViewWithType:3 andStr:_model.job];
        }
            break;
        default:
            break;
    }
}
-(void)clickEmotion:(UITapGestureRecognizer *)sender{
    
}

#pragma mark - 上传头像相关

-(void)saveHeadImageWithImage:(UIImage *)image{
    
//     [_TXCell creatCellWithStr:image andSection:0];
    [_TXCell.headImgView setImage:image];
    
    if (self.BuguLive.appModel.open_sts == 1)
    {
        if ([_ossManager isSetRightParameter])
        {
            [self saveImage:image withName:@"1.png"];
            [self showMyHud];
            _timeString = [_ossManager getObjectKeyString];
            [_ossManager asyncPutImage:_timeString localFilePath:_uploadFilePath];
        }
    }else
    { NSLog(@"image.size.height==%f,image.size.height==%f",image.size.height,image.size.height);
        NSData *data=UIImageJPEGRepresentation(image, 1);
        UIImage *image = [UIImage imageWithData:data];
        
        [self saveImage:image withName:@"image_head.jpg"];
        [self performSelector:@selector(uploadAvatar) withObject:nil afterDelay:0.8];
    }
}

#pragma mark 使用流文件上传头像
- (void)uploadAvatar
{
    [self showMyHud];
    NSString *imageFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *photoName=[imageFile stringByAppendingPathComponent:@"image_head.jpg"];
    NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file:%@",photoName]];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"avatar" forKey:@"ctl"];
    [parmDict setObject:@"uploadImage" forKey:@"act"];

    [parmDict setObject:_model.user_id forKey:@"id"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithDict:parmDict andFileUrl:fileUrl SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             _urlString = [responseJson toString:@"path"];
             _model.head_image = _urlString;
             [self hideMyHud];
             [self updateHeadImage];
         }else
         {
             [BGHUDHelper alert:[responseJson toString:@"error"]];
         }
     } FailureBlock:^(NSError *error)
     {
         [self hideMyHud];
     }];
}

- (void)updateHeadImage
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"do_update" forKey:@"act"];
    [parmDict setObject:_model.user_id forKey:@"id"];
    if (_urlString.length < 1 && [_urlString isEqualToString:@""])
    {
        [parmDict setObject:@"" forKey:@"normal_head_path"];
    }else
    {
        [parmDict setObject:_urlString forKey:@"normal_head_path"];
    }
    [parmDict setObject:@"1" forKey:@"type"];
    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         [self hideMyHud];
     } FailureBlock:^(NSError *error)
     {
         [self hideMyHud];
     }];
}


- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
    _uploadFilePath = fullPath;
    NSLog(@"uploadFilePath : %@", _uploadFilePath);
}

#pragma mark 代理回调
- (void)uploadImageWithUrlStr:(NSString *)imageUrlStr withUploadStateCount:(int)stateCount
{
    [self hideMyHud];
    if (stateCount == 0)
    {
        _urlString = [NSString stringWithFormat:@"./%@",_timeString];
    }else
    {
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"oss上传头像失败")];
    }
    _model.head_image = _urlString;
}

#pragma mark -- 日历确定按钮点击事件
- (void)handleToSelectTime
{
    _SRCell.rightLabel.text = _datePicker.timeLabel.text;
    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished) {
       [self isCreatHaldClearViewWithCount:0];
    }];
}

#pragma mark 修改情感状态
- (void)changeEmotionStatuWithString:(NSString *)emoyionString
{
    _model.emotional_state = _QGZTCell.rightLabel.text = emoyionString;
//    [self isCreatHaldClearViewWithCount:0];
    
    [GlobalVariables sharedInstance].isUserInfoCheck = YES;
}

#pragma mark 修改性别
- (void)changeSexWithString:(NSString *)sexString
{
    _sexString = sexString;
    if ([sexString isEqualToString:@"1"])
    {
      _XBCell.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
    }else if ([sexString isEqualToString:@"2"])
    {
      _XBCell.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
    }
    
    [GlobalVariables sharedInstance].isUserInfoCheck = YES;
//    isUserInfoCheck
}

#pragma mark 修改生日
- (void)confrmCallBack:(NSInteger)Year month:(NSInteger)month day:(NSInteger)day andtag:(int)tagIndex
{
    if (tagIndex == 12)
    {
       _SRCell.rightLabel.text = [NSString stringWithFormat:@"%d-%d-%d",(int)Year,(int)month,(int)day];
    }
    [self isCreatHaldClearViewWithCount:0];
    [GlobalVariables sharedInstance].isUserInfoCheck = YES;
}

#pragma mark 地区的代理
- (void)confrmCallBack:(NSString *)provice withCity:(NSString *)city andtagIndex:(int)tagIndex
{
    if (tagIndex == 12)
    {
        _provinceString = provice;
        _cityString = city;
        if (city.length < 1 || provice.length < 1)
        {
            _JXCell.rightLabel.text = @"";
        }else
        {
          _model.city = _JXCell.rightLabel.text = [NSString stringWithFormat:@"%@ %@",provice,city];
        }
    }
    [self isCreatHaldClearViewWithCount:0];
    [GlobalVariables sharedInstance].isUserInfoCheck = YES;
}

#pragma mark 修改昵称之类的
- (void)pushToChangeNameViewWithType:(int)type andStr:(NSString *)str
{
    _isNeedLoad = NO;
    ChangeNameViewController *nameVC =[[ChangeNameViewController alloc]init];
    if (type == 1)
    {
        nameVC.nickInfo = _nick_info;
    }
    nameVC.textFiledName = str;
    nameVC.viewType = [NSString stringWithFormat:@"%d",type];
    nameVC.delegate = self;
    [self.navigationController pushViewController:nameVC animated:YES];
}

- (void)changeNameWithString:(NSString *)name withType:(NSString *)type
{
    if ([type isEqualToString:@"1"])
    {
        _NCCell.rightLabel.text = name;
        _model.nick_name = name;
    }else if ([type isEqualToString:@"2"])
    {
        _GXQMCell.rightLabel.text = name;
        _model.signature = name;
    }else if ([type isEqualToString:@"3"])
    {
        _ZYCell.rightLabel.text = name;
        _model.job = name;
    }
    [GlobalVariables sharedInstance].isUserInfoCheck = YES;
}

#pragma mark 保存的按钮
- (void)saveEditButton
{
    
    [self updateHeadImage];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"user_center" forKey:@"ctl"];
    [dict setObject:@"user_save" forKey:@"act"];
    if (_NCCell.rightLabel.text.length > 0)//名字
    {
        [dict setObject:_NCCell.rightLabel.text forKey:@"nick_name"];
    }
    
    if (_GJCell.rightLabel.text.length > 0)//名字
    {
        [dict setObject:[_GJCell qmui_getBoundObjectForKey:@"num_code"] forKey:@"country_code"];
    }
    
    if (_sexString.length > 0)//性别
    {
        [dict setObject:_sexString forKey:@"sex"];
    }
    if (_GXQMCell.rightLabel.text.length > 0)//个性签名
    {
        [dict setObject:_GXQMCell.rightLabel.text forKey:@"signature"];
    }
    if (_SRCell.rightLabel.text.length > 0)//生日
    {
        [dict setObject:_SRCell.rightLabel.text forKey:@"birthday"];
    }
    if (_QGZTCell.rightLabel.text.length > 0)//情感状态
    {
        [dict setObject:_QGZTCell.rightLabel.text forKey:@"emotional_state"];
    }
    if (_provinceString.length > 0)//省份
    {
        [dict setObject:_provinceString forKey:@"province"];
    }
    if (_cityString.length > 0)//城市
    {
        [dict setObject:_cityString forKey:@"city"];
    }
    if (_ZYCell.rightLabel.text.length > 0)//工作
    {
        [dict setObject:_ZYCell.rightLabel.text forKey:@"job"];
    }
    FWWeakify(self)
    [self showMyHud];
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"编辑成功")];
             [GlobalVariables sharedInstance].isUserInfoCheck = NO;
             [self.navigationController popViewControllerAnimated:YES];
         }else
         {
             [BGHUDHelper alert:[responseJson toString:@"error"]];
         }
         
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [self hideMyHud];
     }];
}

#pragma mark  =============================================家乡数据的获取和存储============================================================
- (NSString *)getVersionsNum
{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"versions.plist"];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    return [dict1 objectForKey:@"versions"];
}

- (NSMutableArray *)getMyAreaDataArr
{
    //获取Documents目录
    NSString *docPath2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath2 = [docPath2 stringByAppendingPathComponent:@"Province.plist"];
    return [NSMutableArray arrayWithContentsOfFile:filePath2];
}

- (void)loadMyAreaData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"region_list" forKey:@"act"];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             //存版本
             NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
             NSString *filePath = [cachePath stringByAppendingPathComponent:@"versions.plist"];
             NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
             [dict1 setObject:[responseJson toString:@"region_versions"] forKey:@"versions"];
             [dict1 writeToFile:filePath atomically:YES];

             NSArray *areaArray = [responseJson objectForKey:@"region_list"];
             if (areaArray)
             {
                 if (areaArray.count > 0  && [areaArray isKindOfClass:[NSArray class]])
                 {
                     //获取Documents目录
                     NSString *docPath2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                     //还要指定存储文件的文件名称,仍然使用字符串拼接
                     NSString *filePath2 = [docPath2 stringByAppendingPathComponent:@"Province.plist"];
                     NSLog(@"filePath2==%@",filePath2);
                     [areaArray writeToFile:filePath2 atomically:YES];
                 }
             }
         }
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

- (void)showCountryPopup {
    //支持半透明
    [self requestCountryListiSHot:@"0" WithSuccessBlock:^(NSArray *countryList) {

        CountryPopupView *popupView = [[CountryPopupView alloc] initWithFrame:self.view.bounds countries:countryList];
        popupView.delegate = self;
        [self.view addSubview:popupView];
        
    } failureBlock:^(NSError *error) {
        
    }];
    

}

#pragma mark - CountryPopupViewDelegate

- (void)countryPopupView:(CountryPopupView *)popupView didSelectCountry:(NSDictionary *)country {
    NSLog(@"Selected country: %@", country[@"name"]);
    _GJCell.rightLabel.text = country[@"name"];
    [_GJCell qmui_bindObject:SafeStr(country[@"num_code"]) forKey:@"num_code"];
    // 处理选择的国家
}

//请求国家列表 https://mapi.toplive.cc/mapi/index.php/ctl/index/act/get_country_list
-(void)requestCountryListiSHot:(NSString *)is_hot WithSuccessBlock:(void (^)(NSArray *countryList))successBlock failureBlock:(void (^)(NSError *error))failureBlock{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"index" forKey:@"ctl"];
    [dict setValue:@"get_country_list" forKey:@"act"];
    [dict setValue:is_hot forKey:@"is_hot"];
    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"104responseJson%@",responseJson);
        if ([responseJson toInt:@"status"] == 1) {
            NSMutableArray *countryList = [NSMutableArray arrayWithArray:[responseJson objectForKey:@"data"]];
            //增加一个更多
            if(is_hot.intValue == 1)
            {
                NSDictionary *moreDict = @{@"id":@"-1",@"name":ASLocalizedString(@"更多")};
                [countryList addObject:moreDict];
            }

            if (countryList.count > 0) {
                successBlock(countryList);
            }
        }
    } FailureBlock:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}


@end
