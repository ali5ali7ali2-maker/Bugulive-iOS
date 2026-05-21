//
//  MGSaveHeadImgViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/6/11.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGSaveHeadImgViewController : BaseViewController

-(instancetype)initWithHeadImageWithImage:(UIImage *)image;


@property(nonatomic, strong) UIImage *headImage;

@end

NS_ASSUME_NONNULL_END
