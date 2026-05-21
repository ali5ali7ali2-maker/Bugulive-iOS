//
//  musicCell.m
//  BuguLive
//
//  Created by zzl on 16/6/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "musicCell.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

@implementation musicCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.msonger.textColor = textColor5;
//    self.mprogress.progressTotal = 100;
//    self.mprogress.progressCounter = 1;
//    self.mprogress.theme.thickness = 8;
//    self.mprogress.theme.incompletedColor = [UIColor clearColor];
//    self.mprogress.theme.completedColor = kAppMainColor;
//    self.mprogress.theme.sliceDividerHidden = YES;
//    self.mprogress.label.hidden = NO;
//    self.mprogress.label.text =@"";
//    self.mprogress.label.textColor = kAppMainColor;
//    self.mprogress.label.font = [UIFont systemFontOfSize:10];
}


- (IBAction)clickMusic:(UIButton *)sender {
    if(self.clickPlay)
    {
        sender.selected = !sender.isSelected;
        self.clickPlay(sender.selected,self.model);
    }
}

//perct => 0-100,-1 表示隐藏
- (void)showProcess:(int)perct
{
    if( perct == -1 )
    {
        self.mprocessBase.hidden = YES;
    }
    else
    {
        self.mprocessBase.hidden = NO;
        self.mprogress.progressCounter = perct;
        self.mprogress.label.text = [NSString stringWithFormat:@"%d%%",perct];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(musiceModel *)model
{
    _model = model;
    self.mname.text = model.title;
    self.msonger.text = model.user_name;
    self.mlong.text = model.music_time;
}
@end
