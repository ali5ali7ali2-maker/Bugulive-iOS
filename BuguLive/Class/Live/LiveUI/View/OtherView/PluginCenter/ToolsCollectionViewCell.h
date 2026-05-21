//
//  ToolsCollectionViewCell.h
//  BuguLive
//
//  Created by xfg on 2017/6/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QMUIButton.h>

@interface ToolsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView   *toolImgView;
@property (nonatomic, strong) UILabel      *toolLabel;

@property(nonatomic, strong) QMUIButton *toolBtn;

@end
