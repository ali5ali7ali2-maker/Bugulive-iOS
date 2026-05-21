//
//  GiftSubView.h
//  BuguLive
//
//  Created by xfg on 16/5/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GiftSubViewDelegate <NSObject>
@required

- (void)cateBtn:(int)indexTag index_x:(NSInteger)index_x index_y:(NSInteger)index_y;

@end

@interface GiftSubView : UIView

@property (nonatomic, weak) id<GiftSubViewDelegate>delegate;
@property (nonatomic, strong) UIButton              *bottomBtn;
@property (nonatomic, strong) FLAnimatedImageView   *imgView;
@property (nonatomic, strong) UIImageView           *diamondsImgView;
@property (nonatomic, strong) UILabel               *diamondsLabel;     //需要钻石数量
@property (nonatomic, strong) UILabel               *txtLabel;
@property (nonatomic, strong) UIImageView           *continueImgView;   //连
@property (nonatomic, strong) UIImageView *luckyImgView;//幸运
//@property (nonatomic, strong) UILabel *luckLabel;//幸
@property (nonatomic, strong) UIButton *luckBtn;//幸
//二维数组坐标
@property (nonatomic, assign) NSInteger index_x;
@property (nonatomic, assign) NSInteger index_y;
- (void)resetDiamondsFrame;

@end
