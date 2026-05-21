//
//  BogoPosterImgView.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/10/23.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShareModel.h"
#import "userPageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoPosterImgView : UIView

@property (nonatomic, strong)UIImageView *backImageView;

@property(nonatomic, strong) ShareModel *model;
///
@property (nonatomic, strong) NSString *url;
///
@property (nonatomic, assign) BOOL is_Small;

///
@property (nonatomic, strong) UIImage *imageStr;

@property(nonatomic, strong) userPageModel *userModel;

@end

NS_ASSUME_NONNULL_END
