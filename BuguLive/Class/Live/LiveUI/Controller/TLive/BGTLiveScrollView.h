//
//  BGTLiveScrollView.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/6/29.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGTLiveScrollView : UIScrollView

@property(nonatomic, strong) UIImageView *firstImgView;
@property(nonatomic, strong) UIImageView *secondImgView;
@property(nonatomic, strong) UIImageView *lastImgView;

@property(nonatomic, assign) NSString *roomID;


//向上向下
@property(nonatomic, assign) BOOL isFromeTop;
@property(nonatomic, assign) NSInteger nowIndex;

@end

NS_ASSUME_NONNULL_END
