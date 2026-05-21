//
//  BMPopBaseView.m
//  BuguLive
//
//  Created by 丁凯 on 2017/5/17.
//  Copyright © 2017年 xfg. All rights reserved.

#import "BMPopBaseView.h"

@implementation BMPopBaseView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self suitAbleScreen];
}

//UI控件适应不同的屏幕
- (void)suitAbleScreen
{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    self.bmButtomView.layer.cornerRadius = 3;
    self.bmButtomView.backgroundColor = kAppMainColor;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    //    self.buttomWidth.constant = self.buttomWidth.constant*kScaleWidth;
    //    self.buttomHeight.constant = self.buttomHeight.constant*kScaleWidth;
    //    self.titleLabelWidth.constant = self.titleLabelWidth.constant*kScaleWidth;
    //    self.titleLabelHeight.constant = self.titleLabelHeight.constant*kScaleWidth;
    //    self.titlelabelSpaceLeft.constant = self.titlelabelSpaceLeft.constant*kScaleWidth;
    //    self.closeBtnH.constant = self.closeBtnH.constant*kScaleWidth;
    //    self.closeBtnW.constant = self.closeBtnW.constant*kScaleWidth;
    //    self.titleLabelH.constant = self.titleLabelH.constant*kScaleWidth;
}



- (void)updateUIframeWithWidth:(CGFloat)Width andHeight:(CGFloat)Height andTitleStr:(NSString *)titleStr andmyEunmType:(BMPopViewType)myEunmType
{
    self.titleLabel.text = titleStr;
    self.buttomWidth.constant = Width;
    self.buttomHeight.constant = Height;
    [self updateUIWithType:myEunmType];
}

- (void)updateUIWithType:(BMPopViewType)myEunmType
{
    switch (myEunmType)
    {
        case BMCreatRoom://创建房间
        {
            
        }
            break;
        case BMRoomInfo://房间信息
        {
            
        }
            break;
        case BMInputPassWord://输密码
        {
            
        }
            break;
        case BMEachDaytask://每日任务
        {
            self.popType = BMEachDaytask;
            
            
            
            //            CGRect rect = self.bmButtomView.frame;
            //            rect.origin.x = kScreenW/2 - 532/4.0f*kScaleWidth;
            //            rect.origin.y = kScreenH/2 - 466*kScaleHeight/2;
            //            rect.size.width = 532/2.0f*kScaleWidth;
            //            rect.size.height = 466*kScaleHeight;
            //            self.bmButtomView.frame = rect;
            self.bmButtomView.center = self.center;
            self.bmButtomView.backgroundColor = kClearColor;
//            kClearColor;
            self.bmButtomView.clipsToBounds = NO;
            self.closeBtn.hidden = YES;
            self.closeButton.hidden = YES;
            
            //弹窗头图片
            UIImageView *popupHeadImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.buttomWidth.constant, kRealValue(101))];
            popupHeadImg.image = [UIImage imageNamed:@"bm_dailyTask_headView"];
            popupHeadImg.contentMode = UIViewContentModeTop;
            popupHeadImg.backgroundColor = kClearColor;
            [self.bmButtomView addSubview:popupHeadImg];
            
            //关闭按钮       kAppSpaceColor2
            UIButton *closeBtn = [self createCloseButton];
            [closeBtn setFrame: CGRectMake(CGRectGetMaxX(self.bmButtomView.frame) - 8, CGRectGetMinY(self.bmButtomView.frame) - 90, 37, 37)];
            [self addSubview:closeBtn];
            
//            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.buttomWidth.constant, self.buttomHeight.constant)];
//            [imgView setImage:[UIImage imageNamed:@"bm_daily_task_BgImgView"]];
//            [self.bmButtomView addSubview:imgView];
            
            //每日任务表
            self.dQTableView = [[DailyQuestTablView alloc]initWithFrame:CGRectMake(kRealValue(10), CGRectGetMaxY(popupHeadImg.frame), self.buttomWidth.constant - kRealValue(12), self.buttomHeight.constant-CGRectGetMaxY(popupHeadImg.frame) - 10 * 2)];
            self.dQTableView.backgroundColor = kWhiteColor;
            self.dQTableView .layer.cornerRadius = 3;
            
            UIImageView *tableImgView = [UIImageView new];
//            tableImgView.image = [UIImage imageNamed:@"bm_daily_task_BgImg"];
            tableImgView.backgroundColor = kWhiteColor;
            tableImgView.frame = self.dQTableView.frame;
            tableImgView.width = self.dQTableView.width + 10;
            tableImgView.left = self.dQTableView.left - 10;
            tableImgView.height = self.dQTableView.height + 15;
//            [BGUtils viewShadowPathWithView:tableImgView Color:<#(UIColor *)#> shadowOpacity:<#(CGFloat)#> shadowRadius:<#(CGFloat)#> shadowPathType:<#(LeShadowPathType)#> shadowPathWidth:<#(CGFloat)#>]
            //TODO:uiview 单边圆角或者单边框
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:tableImgView.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10,10)];//圆角大小
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = tableImgView.bounds;
            maskLayer.path = maskPath.CGPath;
            tableImgView.layer.mask = maskLayer;
            
            [self.bmButtomView addSubview:tableImgView];
            [self.bmButtomView addSubview:self.dQTableView];
            
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 创建关闭按钮
- (UIButton *)createCloseButton
{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"bm_personCenter_colse"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clsoeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    return closeBtn;
}

#pragma mark 点击事件（移除view）
- (IBAction)clsoeBtnClick:(UIButton *)sender
{
    if (self.popType == BMEachDaytask)
    {
        self.hidden = YES;
    }else
    {
        [self removeFromSuperview];
    }
    
}


@end
