//
//  BogoWithDrawTopCell.m
//  UniversalApp
//
//  Created by Mac on 2021/6/12.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoWithDrawTopCell.h"
#import "FDUIKitObjC.h"

@interface BogoWithDrawTopCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation BogoWithDrawTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, FD_ScreenWidth - 20, 100);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:158/255.0 green:100/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:239/255.0 green:96/255.0 blue:246/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.bgView.layer addSublayer:gl];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
