//
//  STTableLeftRightLabCell.h
//  BuguLive
//
//  Created by 岳克奎 on 17/4/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableBaseCell.h"

@interface STTableLeftRightCell : STTableBaseCell
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property(nonatomic, strong) QMUIButton *leftBtn;

@end
