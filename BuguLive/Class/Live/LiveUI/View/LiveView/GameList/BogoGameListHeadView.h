//
//  BogoGameListHeadView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGDynamicTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoGameListHeadView : FDPopView

<UICollectionViewDelegate,UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong) NSArray *listArr;

@property(nonatomic, strong) WKWebView *webView;

-(void)resetTopicModel:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
