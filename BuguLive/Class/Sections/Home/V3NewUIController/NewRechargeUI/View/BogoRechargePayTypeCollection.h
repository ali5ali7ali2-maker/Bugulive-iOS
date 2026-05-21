//
//  BogoRechargePayTypeCollection.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGBaseView.h"
#import "AccountRechargeModel.h"
#import "BogoRechargePayTypeCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface BogoRechargePayTypeCollection : BGBaseView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) NSMutableArray *listArr;

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) AccountRechargeModel *model;

@property(nonatomic, strong) PayTypeModel *selectModel;


@end

NS_ASSUME_NONNULL_END
