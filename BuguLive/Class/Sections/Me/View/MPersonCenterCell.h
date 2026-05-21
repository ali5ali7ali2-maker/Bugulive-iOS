//
//  MPersonCenterCell.h
//  BuguLive
//
//  Created by 丁凯 on 2017/8/23.
//  Copyright © 2017年 xfg. All rights reserved.


#import <UIKit/UIKit.h>

@interface MPersonCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView   *leftImgView;
@property (weak, nonatomic) IBOutlet UILabel       *lefLabel;
@property (weak, nonatomic) IBOutlet UILabel       *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView   *rightImgView;
@property (nonatomic,strong) UIView               *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewRightConstraint;


- (void)creatCellWithImgStr:(NSString *)imgStr andLeftStr:(NSString *)leftStr andRightStr:(NSString *)rightStr andSection:(int)section;


@end
