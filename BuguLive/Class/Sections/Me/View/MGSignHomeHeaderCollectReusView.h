//
//  MGSignHomeHeaderCollectReusView.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/21.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGSignHomeHeaderCollectReusView : UICollectionReusableView

@property(nonatomic, strong) UIButton *closeBtn;
@property(nonatomic, copy) void (^clickCloseBlock)(BOOL isClose);

@end

NS_ASSUME_NONNULL_END
