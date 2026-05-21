//
//  LivePayLeftPromptV.m
//  BuguLive
//
//  Created by 丁凯 on 2017/8/16.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "LivePayLeftPromptV.h"

@implementation LivePayLeftPromptV

- (void)addFirstLabWithStr:(NSString *)labeStr
{
    if (!self.firstLabel)
    {
        self.firstLabel                   = [[UILabel alloc] init];
        self.firstLabel.font              = [UIFont systemFontOfSize:15];
        self.firstLabel.textColor         = kWhiteColor;
        self.firstLabel.textAlignment     = NSTextAlignmentCenter;
        self.firstLabel.backgroundColor   = kGrayTransparentColor2;
        self.firstLabel.layer.cornerRadius= 11;
        self.firstLabel.layer.masksToBounds = YES;
        [self addSubview:self.firstLabel];
    }
    self.firstLabel.text = labeStr;
    [self relayoutMyselfViewFrame];
}

- (void)addSecondLabWithStr:(NSString *)labeStr
{
    if (!self.secondLabel)
    {
        self.secondLabel                   = [[UILabel alloc] init];
        self.secondLabel.font              = [UIFont systemFontOfSize:15];
        self.secondLabel.textColor         = kWhiteColor;
        self.secondLabel.textAlignment     = NSTextAlignmentCenter;
        self.secondLabel.backgroundColor   = kGrayTransparentColor2;
        self.secondLabel.layer.cornerRadius= 11;
        self.secondLabel.layer.masksToBounds = YES;
        [self addSubview:self.secondLabel];
    }
    self.secondLabel.text = labeStr;
    [self relayoutMyselfViewFrame];
}

- (void)addThreeLabWithStr:(NSString *)labeStr
{
    if (!self.threeLabel)
    {
        self.threeLabel                   = [[UILabel alloc] init];
        self.threeLabel.font              = [UIFont systemFontOfSize:15];
        self.threeLabel.textColor         = kWhiteColor;
        self.threeLabel.textAlignment     = NSTextAlignmentCenter;
        self.threeLabel.backgroundColor   = kGrayTransparentColor2;
        self.threeLabel.layer.cornerRadius= 11;
        self.threeLabel.layer.masksToBounds = YES;
        [self addSubview:self.threeLabel];
    }
    self.threeLabel.text = labeStr;
    [self relayoutMyselfViewFrame];
}

- (void)removeFirstLabel
{
    if (self.firstLabel)
    {
        [self.firstLabel removeFromSuperview];
        self.firstLabel = nil;
    }
    [self relayoutMyselfViewFrame];
}

- (void)removeSecondLabel
{
    if (self.secondLabel)
    {
        [self.secondLabel removeFromSuperview];
        self.secondLabel = nil;
    }
    [self relayoutMyselfViewFrame];
}

- (void)removeThreeLabel
{
    if (self.threeLabel)
    {
        [self.threeLabel removeFromSuperview];
        self.threeLabel = nil;
    }
    [self relayoutMyselfViewFrame];
}

- (void)relayoutMyselfViewFrame
{
    CGFloat currentY = kDefaultMargin;
    CGFloat maxWidth = 0.0;
    
    // إعداد قواميس خصائص الخط مرة واحدة لتقليل تكرار الكود
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    
    if (self.firstLabel)
    {
        CGFloat labelW = [self.firstLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:attributes
                                                            context:nil].size.width + kTicketContrainerViewHeight;
        
        self.firstLabel.frame = CGRectMake(0, currentY, labelW, kTicketContrainerViewHeight);
        currentY = CGRectGetMaxY(self.firstLabel.frame) + 8; // إضافة المسافة 8
        if (maxWidth < labelW) maxWidth = labelW;
    }
    
    if (self.secondLabel)
    {
        CGFloat labelW = [self.secondLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:attributes
                                                            context:nil].size.width + kTicketContrainerViewHeight;
        
        self.secondLabel.frame = CGRectMake(0, currentY, labelW, kTicketContrainerViewHeight);
        currentY = CGRectGetMaxY(self.secondLabel.frame) + 8;
        if (maxWidth < labelW) maxWidth = labelW;
    }
    
    if (self.threeLabel)
    {
        CGFloat labelW = [self.threeLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:attributes
                                                            context:nil].size.width + kTicketContrainerViewHeight;
        
        self.threeLabel.frame = CGRectMake(0, currentY, labelW, kTicketContrainerViewHeight);
        currentY = CGRectGetMaxY(self.threeLabel.frame) + 8;
        if (maxWidth < labelW) maxWidth = labelW;
    }
    
    self.myWidth = maxWidth;
    // حساب الارتفاع الإجمالي للملف، نقوم بطرح 8 الأخيرة لأنها مسافة زائدة بعد آخر عنصر
    self.myHeight = (currentY > kDefaultMargin) ? (currentY - 8) : 0;
    
    CGRect rect          = self.frame;
    rect.origin.x        = kDefaultMargin;
    // تم إصلاح الخطأ هنا، فبدلاً من self.origin.y أصبحت self.frame.origin.y (على الرغم من أننا لا نحتاج لتغيير الـ y طالما نأخذ الـ frame كامل)
    // rect.origin.y     = self.frame.origin.y; // لا نحتاج لكتابتها لأنها متضمنة في rect
    rect.size.width      = self.myWidth;
    rect.size.height     = self.myHeight;
    self.frame           = rect;
    self.backgroundColor = kClearColor;
}

- (void)updateMyFrameIsToUp:(BOOL)isUp andMyHeight:(CGFloat)myHeight
{
    [UIView animateWithDuration:0.6 animations:^{
        CGRect rect = self.frame;
        if (isUp == YES)
        {
            rect.origin.y -= myHeight;
        }
        else
        {
            rect.origin.y += myHeight;
        }
        self.frame = rect;
    }];
}

@end