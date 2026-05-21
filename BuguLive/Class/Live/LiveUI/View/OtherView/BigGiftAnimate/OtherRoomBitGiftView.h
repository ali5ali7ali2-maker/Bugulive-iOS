//
//  OtherRoomBitGiftView.h
//  FanweApp
//
//  Created by xfg on 2017/7/12.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseView.h"

@interface OtherRoomBitGiftView : BGBaseView

@property (nonatomic, strong) MenuButton *largeGiftBtn;

- (void)judgeGiftViewWith:(NSString *)str finishBlock:(FWVoidBlock)finishBlock;

@end
