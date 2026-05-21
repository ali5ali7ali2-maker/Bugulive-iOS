//
//  BGOtherPushPopView.m
//  BuguLive
//
//  Created by Mac on 2021/8/13.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGOtherPushPopView.h"
#import "CurrentLiveInfo.h"

@interface BGOtherPushPopView ()

@property (weak, nonatomic) IBOutlet UILabel *rtmpLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation BGOtherPushPopView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake((kScreenW - 290 ) / 2, kScreenH, 290, 300);
}

- (void)setLiveInfo:(CurrentLiveInfo *)liveInfo{
    _liveInfo = liveInfo;
    NSString *pushRtmp = liveInfo.push_rtmp ?: @"";
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

- (IBAction)copyRtmpBtnAction:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = self.rtmpLabel.text;
    [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"复制成功")];
}

- (IBAction)copyContentBtnAction:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = self.contentLabel.text;
    [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"复制成功")];
}

- (IBAction)closeBtnAction:(UIButton *)sender {
    [self hide];
}

@end
