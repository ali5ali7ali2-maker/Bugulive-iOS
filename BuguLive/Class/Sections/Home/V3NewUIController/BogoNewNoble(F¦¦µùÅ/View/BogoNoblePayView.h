//
//  BogoNoblePayView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BogoNobleListModel.h"

#import "BogoNoblePayModel.h"

@protocol BogoNoblePayDelegate <NSObject>

-(void)protocolBuySuccessWithModel:(BogoNobleListTypeModel *)payModel;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BogoNoblePayView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UIView *shadowView;

@property(nonatomic, strong) BogoNobleListTypeModel *model;
@property(nonatomic, strong) BogoNoblePayModel *payModel;
@property(nonatomic, strong) BogoNoblePayListModel *paySelectModel;


@property(nonatomic, strong) id<BogoNoblePayDelegate> delegate;

- (void)show:(UIView *)superView;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
