//
//  CustomTagCollectionView.h
//  BuguLive
//
//  Created by voidcat on 2024/9/24.
//  Copyright © 2024 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface CustomTagCollectionView : UIView

@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, copy) void (^didSelectItemBlock)(NSInteger index);
@property (nonatomic, strong) UICollectionView *collectionView;

- (void)reloadData;

@end


NS_ASSUME_NONNULL_END
