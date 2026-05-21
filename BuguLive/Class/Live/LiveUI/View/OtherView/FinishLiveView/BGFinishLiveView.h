//
//  BGFinishLiveView.h
//  BuguLive
//
//  Created by bugu on 2019/12/10.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGFinishLiveView : BGBaseView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UIView *hostContrainerView;
@property (weak, nonatomic) IBOutlet UIView *hostCostView;
@property (weak, nonatomic) IBOutlet UIView *hostTicketView;

@property (weak, nonatomic) IBOutlet UIView *audienTicketContrainerView;
@property (weak, nonatomic) IBOutlet UILabel *audienceNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBtnConstraint;

@property (weak, nonatomic) IBOutlet UILabel *hostLight;
@property (weak, nonatomic) IBOutlet UILabel *hostFanIncrease;


@property (weak, nonatomic) IBOutlet UILabel *audienceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *audienceNumLabel2;


@property (weak, nonatomic) IBOutlet UILabel *audienceLight;
@property (weak, nonatomic) IBOutlet UILabel *liveTimeL;
@property (weak, nonatomic) IBOutlet UILabel *consumStrLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberTitleStr;

@property (weak, nonatomic) IBOutlet UIButton *shareFollowBtn;
@property (weak, nonatomic) IBOutlet UIButton *backHomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *screenshotShareBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *acIndicator;

@property (nonatomic, copy) FWVoidBlock shareFollowBlock;
@property (nonatomic, copy) FWVoidBlock backHomeBlock;
@property (nonatomic, copy) FWVoidBlock screenshotShareBlock;
@property (weak, nonatomic) IBOutlet UILabel *ticketNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pkLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *delLiveVideoBtn;

@property (weak, nonatomic) IBOutlet UILabel *liveTimeStrLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *audienceBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewToTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

- (IBAction)shareFollowAction:(id)sender;
- (IBAction)backHomeAction:(id)sender;


- (IBAction)screenshotShareBtnAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
