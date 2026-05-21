//
//  WardViewTopCell.h
//  BuguLive
//
//  Created by 范东 on 2019/1/28.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WardPopViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface WardViewTopCell : UITableViewCell

@property (nonatomic, strong) WardPopViewModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameToTopContraist;
@property (weak, nonatomic) IBOutlet UIImageView *guardImgView;


@end

NS_ASSUME_NONNULL_END
