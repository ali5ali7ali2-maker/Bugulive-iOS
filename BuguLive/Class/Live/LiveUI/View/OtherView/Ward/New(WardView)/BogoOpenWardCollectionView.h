//
//  BogoOpenWardCollectionView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/10/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BogoWardModel.h"

typedef enum : NSUInteger {
    BOGO_OPENWARD_Collection_TYPE_GUARDIANS,
    BOGO_OPENWARD_Collection_TYPE_TIME,
    BOGO_OPENWARD_Collection_TYPE_PRIVITE,
} BOGO_OPENWARD_Collection_TYPE;

NS_ASSUME_NONNULL_BEGIN

@interface BogoOpenWardCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, assign) BOGO_OPENWARD_Collection_TYPE type;

-(void)refreshType:(BOGO_OPENWARD_Collection_TYPE)type array:(NSArray *)dataArray;

-(void)refreshTypeNameWithArray:(NSArray *)dataArray;


@property(nonatomic, copy) void (^selectRowBlock)(BogoWardModel *model);
@property(nonatomic, copy) void (^selectTimeCollectionViewRowBlock)(BogoWardPayTimeModel *timeModel);

@end

NS_ASSUME_NONNULL_END
