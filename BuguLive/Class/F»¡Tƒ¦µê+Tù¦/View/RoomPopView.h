//
//  RoomPopView.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/3.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoomPopView : UIView

- (void)show:(UIView *)superView;

- (void)hide;


@property (nonatomic, copy) NSString            *vagueImgUrl;       // 模糊背景图片url
@property (nonatomic, strong) UIImageView       *vagueImgView;      // 模糊背景图片
- (void)vagueBackGround;


@end

NS_ASSUME_NONNULL_END
