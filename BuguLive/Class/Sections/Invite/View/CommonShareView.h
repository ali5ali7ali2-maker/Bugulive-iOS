//
//  RoomShareView.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/5.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "FDUIKitObjC.h"
@class CommonShareView;

#define kRoomShareViewBaseBtnTag  101

NS_ASSUME_NONNULL_BEGIN

@protocol CommonShareViewDelegate <NSObject>

- (void)shareView:(CommonShareView *)shareView didClickBtn:(QMUIButton *)sender;

@end

@interface CommonShareView : FDPopView

@property(nonatomic, weak) id<CommonShareViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
