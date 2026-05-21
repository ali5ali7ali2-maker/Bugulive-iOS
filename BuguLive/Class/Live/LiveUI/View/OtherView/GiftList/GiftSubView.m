//
//  GiftSubView.m
//  BuguLive
//
//  Created by xfg on 16/5/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GiftSubView.h"

#define kLabelHeight        15
#define kImgViewY           kHomeCateViewHeight-kLabelHeight-kImgViewWidth

@implementation GiftSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
//        self.layer.borderWidth = 0.5;
//        self.layer.borderColor = [kWhiteColor colorWithAlphaComponent:0.1].CGColor;
//        CAShapeLayer *dottedLineBorder  = [[CAShapeLayer alloc] init];
//        dottedLineBorder.frame = CGRectMake(0, 0, self.width, self.height);
//        [dottedLineBorder setLineWidth:0.5];
//        [dottedLineBorder setStrokeColor:[kWhiteColor colorWithAlphaComponent:0.1].CGColor];
//        [dottedLineBorder setFillColor:kClearColor.CGColor];
//        UIBezierPath *path = [UIBezierPath bezierPathWithRect:dottedLineBorder.frame];
//        dottedLineBorder.path = path.CGPath;
//        [self.layer addSublayer:dottedLineBorder];
        
        CGFloat subViewW = frame.size.width;
        CGFloat subViewH = frame.size.height;
        
        CGFloat marginY = kRealValue(15);
        
        _diamondsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(subViewW*0.4, subViewH-kDefaultMargin-10 - marginY, 11, 11)];
        _diamondsImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_diamondsImgView setImage:[UIImage imageNamed:@"com_diamond_1"]];
        [self addSubview:_diamondsImgView];
        
        _diamondsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_diamondsImgView.frame)+3, CGRectGetMinY(_diamondsImgView.frame)-3, subViewW*0.7-6, kLabelHeight)];
        _diamondsLabel.font = [UIFont systemFontOfSize:12.0];
        _diamondsLabel.textColor = kWhiteColor;
        [self addSubview:_diamondsLabel];
        
        _txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMinY(_diamondsImgView.frame)-kDefaultMargin - marginY, subViewW-10, kLabelHeight)];
        _txtLabel.font = [UIFont systemFontOfSize:13.0];
        _txtLabel.textAlignment = NSTextAlignmentCenter;
        _txtLabel.textColor = kWhiteColor;
        [self addSubview:_txtLabel];
        
        CGFloat min = MIN(subViewW, subViewH-kLabelHeight*2)*0.7;
        CGFloat imgViewWAndH = min - kRealValue(20);
        
        CGFloat widthMargin = 5;
        
        _imgView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake((subViewW-imgViewWAndH)/2- widthMargin /2, (subViewH-imgViewWAndH-kLabelHeight*2)/2 - marginY, imgViewWAndH + widthMargin, imgViewWAndH)];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
        
        //连
        _continueImgView = [[UIImageView alloc]initWithFrame:CGRectMake(subViewW-20, 5, 15, 15)];
        _continueImgView.contentMode = UIViewContentModeScaleAspectFit;
        _continueImgView.hidden = YES;
        [_continueImgView setImage:[UIImage imageNamed:@"lr_gift_list_continue"]];
        [self addSubview:_continueImgView];
        
        //是否是幸运礼物
        _luckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _luckBtn.frame =CGRectMake(self.width - kRealValue(39), 6, kRealValue(35), kRealValue(15));
        [_luckBtn setTitle:ASLocalizedString(@"动效") forState:UIControlStateNormal];
        [_luckBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _luckBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_luckBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _luckBtn.hidden = YES;
        [self addSubview:_luckBtn];
//        _luckLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width - kRealValue(39), 6, kRealValue(35), kRealValue(15))];
////        _luckLabel.layer.borderColor = kRedColor.CGColor;
//        _luckLabel.clipsToBounds = YES;
////        _luckLabel.layer.borderWidth = 1;
//        _luckLabel.font = [UIFont systemFontOfSize:12];
//        _luckLabel.text = ASLocalizedString(@"幸运");
//        _luckLabel.textAlignment = NSTextAlignmentCenter;
//        _luckLabel.textColor = kWhiteColor;
//        _luckLabel.layer.cornerRadius = kRealValue(15) / 2;
//        _luckLabel.backgroundColor = [UIColor colorWithHexString:@"#FF4081"];
////        _luckLabel.hidden = YES;
//        [self addSubview:_luckLabel];
        
        //用来被点击的按钮
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.frame = CGRectMake(1 + widthMargin / 2, 1 + widthMargin / 2, subViewW-2 - widthMargin, subViewH-2 - widthMargin);
        _bottomBtn.backgroundColor = [UIColor clearColor];
        [_bottomBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        _bottomBtn.layer.borderWidth = 0.5;
        _bottomBtn.layer.cornerRadius = 5;
        _bottomBtn.layer.borderColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.6].CGColor;

        [self addSubview:_bottomBtn];
        
        _luckyImgView = [UIImageView new];
        _luckyImgView.frame = CGRectMake(8, 8, 35, 15);
        _luckyImgView.image = [UIImage imageNamed:@"mg_gift_lucky"];
        _luckyImgView.hidden = YES;
        [self addSubview:_luckyImgView];
        
    }
    return self;
}

- (void)btnAction
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];animation.duration = 0.8;// 动画时间
    NSMutableArray *values = [NSMutableArray array];[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];// 这三个数字，我只研究了前两个，所以最后一个数字我还是按照它原来写1.0；前两个是控制view的大小的；
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.25, 1.25, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.imgView.layer addAnimation:animation forKey:nil];
    
    if (_delegate && [_delegate respondsToSelector:@selector(cateBtn:index_x:index_y:)])
    {
        [_delegate cateBtn:(int)self.tag index_x:self.index_x index_y:self.index_y];
    }
}

- (void)resetDiamondsFrame
{
    if (![BGUtils isBlankString:_diamondsLabel.text])
    {
        CGSize titleSize = [_diamondsLabel.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        CGFloat tmpX = (self.frame.size.width-3-CGRectGetWidth(_diamondsImgView.frame)-titleSize.width)/2;
        _diamondsImgView.frame = CGRectMake(tmpX, CGRectGetMinY(_diamondsImgView.frame), CGRectGetWidth(_diamondsImgView.frame), CGRectGetHeight(_diamondsImgView.frame));
        _diamondsLabel.frame = CGRectMake(CGRectGetMaxX(_diamondsImgView.frame)+3, CGRectGetMinY(_diamondsLabel.frame), CGRectGetWidth(_diamondsLabel.frame), CGRectGetHeight(_diamondsLabel.frame));
    }
}



@end
