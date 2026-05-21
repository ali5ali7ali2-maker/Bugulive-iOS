//
//  GuiZuBottomView.h
//  BuguLive
//
//  Created by bugu on 2019/12/2.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuiZuBottomView : UIView

@property (nonatomic, copy) dispatch_block_t buyBlock;

- (void)setDataWithGift:(NSString *)gift money:(NSString *)money day:(NSString *)day;


@end

NS_ASSUME_NONNULL_END
