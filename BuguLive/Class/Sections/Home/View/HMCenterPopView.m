//
//  HMCenterPopView.m
//  BuguLive
//
//  Created by 范东 on 2019/1/16.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "HMCenterPopView.h"
#import "ReleaseDynamicVC.h"
#import "BogoRoomUIViewController.h"
#import "PublishVoiceViewController.h"
@interface HMCenterPopView()

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, copy) clickPopViewBtnBlock clickPopViewBtnBlock;

@end

@implementation HMCenterPopView
- (IBAction)startLiveBtnAction:(id)sender {
    [self hide];
    if (self.clickPopViewBtnBlock) {
        self.clickPopViewBtnBlock(HMCenterPopViewBtnTypeLive);
    }
}

- (IBAction)startVideoBtnAction:(id)sender {
    [self hide];
    if (self.clickPopViewBtnBlock) {
        self.clickPopViewBtnBlock(HMCenterPopViewBtnTypeVideo);
    }
}

- (IBAction)closeBtnAction:(id)sender {
    [self hide];
    if (self.clickPopViewBtnBlock) {
        self.clickPopViewBtnBlock(HMCenterPopViewBtnTypeClose);
    }
}

- (IBAction)voiceRoom:(id)sender {
    NSLog(@"点击了语音房间");
    [self hide];
    /*
    BogoRoomUIViewController *vc = [BogoRoomUIViewController new];
    [[AppDelegate sharedAppDelegate]presentViewController:vc animated:YES completion:nil];
     */

    if (self.clickPopViewBtnBlock) {
        self.clickPopViewBtnBlock(HMCenterPopViewBtnTypeDynamic);
    }
    
    ReleaseDynamicVC *pushVC = [ReleaseDynamicVC new];

//    __weak __typeof(self)weakSelf = self;
//    pushVC.postFinishBlock = ^(BOOL isFinish) {
//        if (isFinish) {
//            [weakSelf.logic loadListDataWithAct:self.homeType];
//        }
//    };
    [[AppDelegate sharedAppDelegate]presentViewController:pushVC animated:YES completion:nil];
    
//    PublishVoiceViewController *vc = [PublishVoiceViewController new];
//    [[AppDelegate sharedAppDelegate]presentViewController:vc animated:YES completion:nil];


}


- (IBAction)startDynamicBtnAction:(UIButton *)sender {
    [self hide];
    
    
    if (self.clickPopViewBtnBlock) {
        self.clickPopViewBtnBlock(HMCenterPopViewBtnTypeDynamic);
    }
    

}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, kScreenH, kScreenW, 200);
    
    
    [self.voice setTitle:ASLocalizedString(@"动态") forState:UIControlStateNormal];
    
    self.liveBtn.imagePosition = QMUIButtonImagePositionTop;
    self.videoBtn.imagePosition = QMUIButtonImagePositionTop;
    self.dynamicBtn.imagePosition = QMUIButtonImagePositionTop;
    self.voice.imagePosition = QMUIButtonImagePositionTop;
}

- (void)show:(UIView *)superView{
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
        self.y = kScreenH - 200;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
        self.y = kScreenH;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)setClickPopViewBtnBlock:(clickPopViewBtnBlock)clickPopViewBtnBlock{
    _clickPopViewBtnBlock = clickPopViewBtnBlock;
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _shadowView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
        _shadowView.alpha = 0;
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
