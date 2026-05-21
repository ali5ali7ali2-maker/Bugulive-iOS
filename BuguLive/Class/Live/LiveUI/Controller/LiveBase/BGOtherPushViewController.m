//
//  BGOtherPushViewController.m
//  BuguLive
//
//  Created by Mac on 2021/8/12.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGOtherPushViewController.h"
#import "BGMD5UTils.h"
#import "PublishLiveViewModel.h"

@interface BGOtherPushViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *rtmpLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property(nonatomic, strong) CurrentLiveInfo *currentLiveInfo;

@end

@implementation BGOtherPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =ASLocalizedString( @"开播设置");
//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = self.startBtn.bounds;
//    gl.startPoint = CGPointMake(0, 0);
//    gl.endPoint = CGPointMake(1, 1);
//    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#9E64FF"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#EF60F6"].CGColor];
//    gl.locations = @[@(0.0),@(1.0f)];
//    [self.startBtn.layer insertSublayer:gl atIndex:0];
    [self.startBtn setBackgroundColor:[UIColor colorWithHexString:@"#9E64FF"]];
    [self setupBackBtnWithBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self requestData];
}

- (void)requestData{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"get_video2" forKey:@"act"];
    NSString *MD5String = [NSString stringWithFormat:@"%@%@%@",TXYSdkAppId,[[IMAPlatform sharedInstance].host imUserId],self.room_id];
    if (![BGUtils isBlankString:MD5String])
    {
        [mDict setObject:[NSString stringWithFormat:@"%@",[BGMD5UTils getmd5WithString:MD5String]] forKey:@"sign"];
    }
    
    [mDict setObject:@"0" forKey:@"is_vod"]; // 0:观看直播;1:点播
//    if (!_privateKeyString.length)
//    {
//        if ([UIPasteboard generalPasteboard].string.length)
//        {
//            if ([[[UIPasteboard generalPasteboard].string componentsSeparatedByString:[GTMBase64 decodeBase64:@"8J+UkQ=="]] count] > 1)
//            {
//                _privateKeyString = [[[UIPasteboard generalPasteboard].string componentsSeparatedByString:[GTMBase64 decodeBase64:@"8J+UkQ=="]] objectAtIndex:1];
//            }
//        }
//    }
//
//    if (_privateKeyString.length)
//    {
//        [mDict setObject:_privateKeyString forKey:@"private_key"];
//        [UIPasteboard generalPasteboard].string = @"";
//    }
    
    [mDict setObject:self.room_id forKey:@"room_id"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson){
        FWStrongify(self)
        // status: status=1表示抗议正常进入直播间,status=0表示不能正常进入直播间,status=2表示关闭直播间
        if ([responseJson toInt:@"status"] == 1)
        {
            self.currentLiveInfo = [CurrentLiveInfo mj_objectWithKeyValues:responseJson];
            NSString *pushRtmp = self.currentLiveInfo.push_rtmp ?: @"";
            NSArray *rtmpArray = [pushRtmp componentsSeparatedByString:@"/"];
            NSString *content = rtmpArray.lastObject ?: @"";
            NSString *rtmp = pushRtmp;
            if (content.length > 0 && pushRtmp.length >= content.length)
            {
                rtmp = [pushRtmp substringToIndex:(pushRtmp.length - content.length)];
            }
            self.rtmpLabel.text = rtmp;
            self.contentLabel.text = content;
        }
        else {
            [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"获取直播信息失败")];
        }
        
    } FailureBlock:^(NSError *error) {
        [[BGHUDHelper sharedInstance] tipMessage:error.localizedDescription];
    }];
}

- (IBAction)copyRtmpBtnAction:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = self.rtmpLabel.text;
    [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"复制成功")];
}

- (IBAction)copyContentBtnAction:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = self.contentLabel.text;
    [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"复制成功")];
}

- (IBAction)startBtnAction:(UIButton *)sender {
    if (self.currentLiveInfo == nil) {
        return;
    }
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"video_cstatus" forKey:@"act"];
    [mDict setObject:self.currentLiveInfo.room_id forKey:@"room_id"];
    [mDict setObject:@"1" forKey:@"status"];
    [mDict setObject:self.currentLiveInfo.group_id forKey:@"group_id"];
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        //开始直播完成，进入直播页面
        [self dismissViewControllerAnimated:YES completion:^{
            [PublishLiveViewModel beginLiveCenter:self.currentLiveInfo.mj_keyValues];
        }];
    } FailureBlock:^(NSError *error) {
        [[BGHUDHelper sharedInstance] tipMessage:error.localizedDescription];
    }];
}

@end
