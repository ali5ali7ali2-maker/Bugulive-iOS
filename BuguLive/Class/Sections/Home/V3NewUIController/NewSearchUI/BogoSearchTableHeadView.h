//
//  BogoSearchTableHeadView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoSearchTableHeadView : UICollectionReusableView<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UILabel *titleL;
@property(nonatomic, strong) NSMutableArray *listArr;

@end

NS_ASSUME_NONNULL_END
