//
//  RoomFaceView.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/27.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomPopView.h"
@class RoomFaceView;
@class RoomFaceModel;

NS_ASSUME_NONNULL_BEGIN
@protocol RoomFaceViewDelegate <NSObject>

- (void)faceView:(RoomFaceView *)faceView didSelectFace:(RoomFaceModel *)model;

@end

@interface RoomFaceView : RoomPopView

@property(nonatomic, weak) id<RoomFaceViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
