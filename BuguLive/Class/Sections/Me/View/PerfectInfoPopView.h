//
//  PerfectInfoPopView.h
//  BuguLive
//
//  Created by Mac on 2021/9/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "FDPopView.h"
@class PerfectInfoPopView;

NS_ASSUME_NONNULL_BEGIN

@protocol PerfectInfoPopViewDelegate <NSObject>

- (void)infoPopView:(PerfectInfoPopView *)infoPopView didClickEditBtn:(UIButton *)sender;

@end

@interface PerfectInfoPopView : FDPopView

@property(nonatomic, weak) id<PerfectInfoPopViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
