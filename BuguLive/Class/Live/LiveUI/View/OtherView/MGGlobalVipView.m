//
//  MGGlobalVipView.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/6/18.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "MGGlobalVipView.h"

@implementation MGGlobalVipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height / 2;
    }
    return self;
}

-(void)setUpView{
    
    
    self.backgroundColor = kClearColor;
    
    self.bgImgView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.bgImgView.image = [UIImage imageNamed:@"mg_open_live_GlobalImg"];
    
    self.contentL = [UILabel new];
    self.contentL.frame = self.bounds;
    self.contentL.left = 65;
    self.contentL.textColor = [UIColor colorWithHexString:@"#844A15"];
    self.contentL.width = self.width - 65;
    self.contentL.font = [UIFont systemFontOfSize:15];
    
    self.iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 4, 40, 32)];
    self.iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:self.bgImgView];
    [self addSubview:self.iconImgView];
    [self addSubview:self.contentL];
}

- (void)setModel:(CustomMessageModel *)model{
    _model = model;
    if (model.type == MSG_OPEN_VIP_TYPE) {
        [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.noble_icon]];
        NSString *contentStr = [NSString stringWithFormat:ASLocalizedString(@"%@开通了%@贵族"),model.sender.nick_name,model.noble_name];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:contentStr];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ffffff"] range:NSMakeRange(0, model.sender.nick_name.length)];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ffffff"] range:NSMakeRange([NSString stringWithFormat:ASLocalizedString(@"%@开通了"),model.sender.nick_name].length, model.noble_name.length)];
        self.contentL.attributedText = attr;
    }else if(model.type == MSG_OPEN_GUARD_SUCCESS){
        
//        BogoGuardianModel *guardModel = [BogoGuardianModel modelWithDictionary:model.dicData];
        self.bgImgView.image = nil;
        self.backgroundColor = [[UIColor colorWithHexString:@"#9B00E0"]colorWithAlphaComponent:0.6];
        
        NSString *guardian_img = model.guardian_img;
        NSString *guardian_name = model.guardian_name;
        
        NSString *hostName = model.sender.host_nickname;
        
        [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:guardian_img]];

        NSString *contentStr = [NSString stringWithFormat:ASLocalizedString(@"%@成为了%@的%@守护"),model.sender.nick_name,hostName,guardian_name];
//        [NSString stringWithFormat:@"%@开通了%@守护",model.sender.nick_name,guardian_name];
        self.contentL.textColor = kWhiteColor;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:contentStr];

//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#E9BD15"] range:NSMakeRange(model.sender.nick_name.length, ASLocalizedString(@"成为了").length)];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#E9BD15"] range:NSMakeRange(model.sender.nick_name.length + ASLocalizedString(@"成为了").length + hostName.length, @"的".length)];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#E9BD15"] range:NSMakeRange(contentStr.length - @"守护".length - guardian_name.length, @"守护".length + guardian_name.length)];
        self.contentL.attributedText = attr;
        
        
        
        CGSize wardListBtnSize = [contentStr  textSizeIn:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:15]];
        self.contentL.width = wardListBtnSize.width;
        self.width = wardListBtnSize.width + 15 * 2 + 45;
        
    }
    else{
        self.contentL.text = [NSString stringWithFormat:@"%@  %@",model.sender.nick_name,model.sender.text];
    }
    
    
}

-(void)setAnnimateImage{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i < 14; i ++) {
        [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"marquee_lucky_bg%d",i]]];
    }
    
    self.bgImgView.image = arr.firstObject;

    self.bgImgView.animationImages = arr;

    //动画的总时长(一组动画坐下来的时间 6张图片显示一遍的总时间)

    self.bgImgView.animationDuration = 2;

    self.bgImgView.animationRepeatCount = 0;//动画进行几次结束

    [self.bgImgView startAnimating];//开始动画

    // [imageView stopAnimating];//停止动画

    self.bgImgView.userInteractionEnabled = YES;
    
}

@end
