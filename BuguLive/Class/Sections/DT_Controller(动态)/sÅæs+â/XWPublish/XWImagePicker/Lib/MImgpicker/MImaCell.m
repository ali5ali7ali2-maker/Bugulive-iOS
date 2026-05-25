//
//  MImaCell.m
//  QQImagePicker
//
//  Created by mark on 15/9/11.
//  Copyright (c) 2015年 mark. All rights reserved.
//

#import "MImaCell.h"

@implementation MImaCell
{

    MBoolBlock _boolBlock;
}
- (void)awakeFromNib {
    // Initialization code
    [self.btnCheckMark setImage:[UIImage imageNamed:@"ico_check_select@2x.png"] forState:UIControlStateSelected];
}

- (void)setBtnSelectedHandle:(MBoolBlock)block {

    _boolBlock = block;
}

- (IBAction)actionBtn:(id)sender {
    if ([self.delegate arrayIsfulled] && !self.btnCheckMark.selected) {
        return;
    }
    self.btnCheckMark.selected = !self.btnCheckMark.selected;
    (!_boolBlock) ?: _boolBlock(self.btnCheckMark.selected);
}

- (void)setBigImgViewWithImage:(UIImage *)img{
    if (_BigImgView) {
        return;
    }
    _BigImgView = [[UIImageView alloc]initWithImage:img];
    _BigImgView.frame = _imavHead.frame;
    [self insertSubview:_BigImgView atIndex:0];
}

- (UILabel *)video_timer
{
    if (!_video_timer)
    {
        __weak typeof(self)weakself =self;
        _video_timer =[[UILabel alloc]init];
        [self addSubview:_video_timer];
        [_video_timer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.bottom.centerX.equalTo(weakself);
            make.height.equalTo(@20);
        }];
        _video_timer.textColor = kWhiteColor;
        _video_timer.font =[UIFont systemFontOfSize:13.];
        _video_timer.textAlignment =2;
    }
    return _video_timer;
}

@end
