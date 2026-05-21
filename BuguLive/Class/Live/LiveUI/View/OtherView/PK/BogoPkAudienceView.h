//
//  BogoPkAudienceView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/22.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BogoPkProgressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoPkAudienceView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *leftCollectionView;
@property(nonatomic, strong) UICollectionView *rightCollectionView;

@property(nonatomic, strong) UIImageView *pkImgView;

@property(nonatomic, strong) UIImageView *leftBGImgView;
@property(nonatomic, strong) UIImageView *rightBGImgView;



@property(nonatomic, strong) UIImageView *leftWinImg;
@property(nonatomic, strong) UIImageView *rightWinImg;

@property(nonatomic, strong) NSMutableArray *leftArr;
@property(nonatomic, strong) NSMutableArray *rightArr;

@property(nonatomic, strong) BogoPkProgressModel *model;

@property(nonatomic, copy) NSString *room_id;

@end

NS_ASSUME_NONNULL_END
