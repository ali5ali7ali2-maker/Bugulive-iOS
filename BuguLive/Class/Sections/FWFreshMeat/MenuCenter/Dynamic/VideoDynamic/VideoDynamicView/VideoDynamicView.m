//
//  VideoDynamicView.m
//  BuguLive
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "VideoDynamicView.h"
#import "UIImage+STCommon.h"
#import "DTTopicModel.h"



@implementation VideoDynamicView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initModel];
        
        [self  showSetSubView];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
}
-(void)showSetSubView
{
    if (!self.tableView)
    {
        [self tableView];
//        self.tableView.tableFooterView = self.footerView;
    }
    [self registerCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataSoureMArray = @[].mutableCopy;
}

- (void)setVideoURL:(NSURL *)videoURL{
    _videoURL = videoURL;
    
    self.dataSoureMArray = @[].mutableCopy;
    
    AVURLAsset *asset1 = [AVURLAsset assetWithURL:videoURL];
    CMTime  time = [asset1 duration];
    int seconds = ceil(time.value/time.timescale);
    
    if (seconds > 5) seconds = 5;
    for (int i = 0;i< seconds;i++) {
        UIImage *thumbnailImage = [UIImage st_thumbnailImageForVideo:videoURL atTime:i];
        [self.dataSoureMArray addObject:thumbnailImage];
    }
    self.recordSelectIndex = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)initModel{
    
    self.actionArr = [NSMutableArray array];
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"publish" forKey:@"ctl"];
    [parmDict setObject:@"get_video_type" forKey:@"act"];
    [parmDict setObject:@"xr" forKey:@"itype"];
    
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWWeakify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             
             NSArray *arr = [responseJson valueForKey:@"info"];
             if ([arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic  in arr) {
                    MGBaseModel *model =[MGBaseModel mj_objectWithKeyValues: dic];
                    [self.actionArr addObject:model];
                }
             }
             
             [self.tableView reloadData];
         }
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

-(void)registerCell{
    // 视频封面显示cell
    [self.tableView registerNib:[UINib nibWithNibName:@"STTableShowVideoCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"STTableShowVideoCell"];
    // 动态文本显示cell
    [self.tableView registerNib:[UINib nibWithNibName:@"STTableTextViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"STTableTextViewCell"];
    //商品 显示cell
    [self.tableView registerNib:[UINib nibWithNibName:@"STTableLeftRightCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"STTableLeftRightCell"];
    //地理坐标 显示cell
    [self.tableView registerNib:[UINib nibWithNibName:@"STTableLeftRightLabCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"STTableLeftRightLabCell"];
    //提交功能 cell
    [self.tableView registerNib:[UINib nibWithNibName:@"STTableCommitBtnCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"STTableCommitBtnCell"];
//    [self.tableView registerClass:[STVideoCateCell class] forCellReuseIdentifier:NSStringFromClass([STVideoCateCell class])];
    self.tableView.tableFooterView = self.footerView;

}
#pragma mark --  Row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (self.dataSoureMArray.count == 0)
    //    {
    //        return 0;
    //    }
    if (section == 1) {
        return 2;
    }
    return 1;
}
#pragma mark -- cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0  && indexPath.row == 0)
    {
        STTableShowVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTableShowVideoCell"
                                                                     forIndexPath:indexPath];
        //[cell setDelegate:self];
        //[cell.bgImgView setImage:[UIImage boxblurImage:self.dataSoureMArray[_recordSelectIndex] withBlurNumber:1]];
//        cell.bgImgView.hidden = NO;
        if (self.dataSoureMArray.count > 0) {
            [cell.videoCoverImgView setImage:self.dataSoureMArray[_recordSelectIndex]];
        }
        cell.videoCoverImgView.hidden = NO;
        cell.separatorView.hidden = NO;
        cell.changeCoverBtn.hidden = NO;
//        cell.changeVideoBtn.hidden = NO;
//        cell.changeVideoLab.hidden = NO;
//        cell.changeVideoIconImgeView.hidden = NO;
//        [cell.changeVideoIconImgeView setImage:[UIImage imageNamed:@"st_videoDynamic_changeVideo"]];
        cell.promptLab.hidden = NO;
        cell.promptLab.text = ASLocalizedString(@"请选择封面");
        [cell setDelegate:self];
        return cell;
    }
//    if(indexPath.section == 1  && indexPath.row == 0)
//    {
//        STTableTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTableTextViewCell"
//                                                                    forIndexPath:indexPath];
//        cell.separatorView.hidden = NO;
//        [cell setDelegate:self];
//        return cell;
//    }
    if(indexPath.section == 1  && indexPath.row == 3)
    {
        STVideoCateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([STVideoCateCell class])];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"com_arrow_right_1"]];
        return cell;
    }
    if(indexPath.section == 1  && indexPath.row == 0)
    {
        STTableLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTableLeftRightCell"
                                                                     forIndexPath:indexPath];
        cell.hidden = YES;
     cell.separatorView.hidden = NO;
//     STBMKCenter *stBMKCenter = [STBMKCenter shareManager];
     cell.rightLab.hidden = NO;
//     cell.leftLab.hidden = NO;
//     cell.leftLab.text = ASLocalizedString(@"所在位置");
//     if (!stBMKCenter.districtStr ||stBMKCenter.districtStr.length<2) {
//         cell.rightLab.text = ASLocalizedString(@"不显示");
//     }else{
//         cell.rightLab.text = stBMKCenter.districtStr;
//     }
//     cell.separatorView.backgroundColor = [UIColor groupTableViewBackgroundColor];
     return cell;
    }
    if(indexPath.section == 1  && indexPath.row == 1)
    {
     STTableLeftRightLabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTableLeftRightLabCell"
                                                                     forIndexPath:indexPath];
     cell.separatorView.hidden = NO;
     STBMKCenter *stBMKCenter = [STBMKCenter shareManager];
     cell.rightLab.hidden = NO;
//     cell.leftLab.hidden = NO;
//     cell.leftLab.text = ASLocalizedString(@"所在位置");
     if (!stBMKCenter.districtStr ||stBMKCenter.districtStr.length<2) {
         cell.rightLab.text = ASLocalizedString(@"不显示");
     }else{
         cell.rightLab.text = stBMKCenter.districtStr;
     }
//     cell.separatorView.backgroundColor = [UIColor groupTableViewBackgroundColor];
     return cell;
    }
    if(indexPath.section == 2  && indexPath.row == 0)
    {
        STTableCommitBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTableCommitBtnCell"
                                                                     forIndexPath:indexPath];
        cell.commitBtn.backgroundColor = kAppMainColor;
        cell.commitBtn.layer.cornerRadius = 3;
        cell.commitBtn.layer.masksToBounds = YES;
        [cell.commitBtn setTitle:ASLocalizedString(@"发布")forState:UIControlStateNormal];
        [cell.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        return cell;
    }
    return nil;
}

#pragma mark ---section

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark -- row height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1  && indexPath.row == 0)
    {
        return 0.01;
    }
    
    if(indexPath.section == 0)
    {
        return 168;
    }
//    if(indexPath.section == 1)
//    {
//        return 150;
//    }
    if(indexPath.section == 1)
    {
        return 55;
    }
    if(indexPath.section == 2)
    {
        return 55;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 0)
    {
        if (_delegate &&[_delegate respondsToSelector:@selector(showMyVideoView)])
        {
            [_delegate showMyVideoView];
        }
    }
    
    if(indexPath.section == 1  && indexPath.row == 3)
    {
     //进入视频分类
      STVideoCateCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        if (_delegate && [_delegate respondsToSelector:@selector(goVCOnVideoDynamicView:STTableShowVideoCell:andChooseCateClick:)]) {
            [_delegate goVCOnVideoDynamicView:self STTableShowVideoCell:cell andChooseCateClick:cell.cateBtn];
        }
    }
    //选择商品
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        STTableLeftRightCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicView:didSelectGood:)]) {
            [self.delegate dynamicView:self didSelectGood:cell];
        }
    }
    //百度地图定位
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"定位中...")];
        //加载地图
        [self startLocation];
    }
}

- (void)submitAction{
    
    [self endEditing:YES];
    
    if (_delegate &&[_delegate respondsToSelector:@selector(submitData)])
    {
        [_delegate submitData];
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
            STTableLeftRightLabCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            cell.rightLab.text = [address objectForKey:@"City"];
            
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
    if (buttonIndex != self.actionArr.count) {
        self.videoModel = self.actionArr[buttonIndex];
        STTableLeftRightLabCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
        cell.rightLab.text = self.videoModel.title;
    }
    
}

#pragma mark *********************** Deleagte 协议方法  *****************************
#pragma mark ---------- STTableTextViewCellDeleagte 协议方法
-(void)showSTTableTextViewCell:(STTableTextViewCell *)stTableTextViewCell
{
    _recordTextViewStr = stTableTextViewCell.textView.text;
    
    NSLog(@"-----text view  text ---- %@--------",_recordTextViewStr);
}

//STTableShowVideoCell
#pragma mark ---------- STTableShowVideoCell
- (void)videoCell:(STTableShowVideoCell *)videoCell didChangeText:(NSString *)text{
    _recordTextViewStr = text;
}

-(void)showSystemIPC:(BOOL)isSystemIPC andMaxSelectNum:(int)maxSelectNum
{
    if (_delegate &&[_delegate respondsToSelector:@selector(showMyVideoView)])
    {
        [_delegate showMyVideoView];
    }
}
#pragma mark -------- 去封面选择页面
-(void)showSTTableShowVideoCell:(STTableShowVideoCell *)stTableShowVideoCell andChangeVideoCoverClick:(UIButton *)changeVideoCoverClick
{
    if (_delegate &&[_delegate respondsToSelector:@selector(showOnVideoDynamicView:STTableShowVideoCell:andChangeVideoCoverClick:)])
    {
        [_delegate showOnVideoDynamicView:self
                     STTableShowVideoCell:stTableShowVideoCell
                 andChangeVideoCoverClick:changeVideoCoverClick];
    }
}

-(void)setDelegate:(id<VideoDynamicViewDelegate>)delegate
{
    _delegate = delegate;
}


- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 140)];
        UIButton * btn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:@"短视频发布按钮"] forState:UIControlStateNormal];
            //        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
            [btn setTitle:ASLocalizedString(@"发布")forState:UIControlStateNormal];
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 20;
            btn;
        });
        [_footerView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(100);
            make.left.equalTo(_footerView).offset(50);
            make.right.equalTo(_footerView).offset(-50);
            make.height.mas_equalTo(@40);
        }];
    }
    return _footerView;
}


@end













