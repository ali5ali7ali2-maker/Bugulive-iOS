//
//  new_BGMcategory.h
//  BuguLive
//
//  Created by bugu on 2019/5/25.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "new_bgmcategoryCell.h"
@protocol new_bgmcategoryDelegate <NSObject>

- (void)itemSelect:(new_bgmcategoryModel *)model;
@end
//音乐分类模块
@interface new_BGMcategory : UIView<UICollectionViewDelegate ,UICollectionViewDataSource>
@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, weak)id<new_bgmcategoryDelegate>delegate;
@property (nonatomic, strong)UICollectionView *collectionview;
@end
