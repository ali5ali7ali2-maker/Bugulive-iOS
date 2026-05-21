//
//  SignHeaderCollectReusView.h
//  BuguLive
//
//  Created by bugu on 2019/11/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignHeaderCollectReusView : UICollectionReusableView
- (void)setDataWithsignin_continue:(NSString *)signin_continue signin_count:(NSString *)signin_count;
@end

NS_ASSUME_NONNULL_END
