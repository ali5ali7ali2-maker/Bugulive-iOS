//
//  BogoSearchTableView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BogoSearchTableHeadView.h"
#import "NewestItemCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface BogoSearchListView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) BogoSearchTableHeadView *headView;

@property(nonatomic, strong) NSMutableArray *listArr;

@end

NS_ASSUME_NONNULL_END
