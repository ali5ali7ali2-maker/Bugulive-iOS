//
//  SHomeSVideoV.h
//  BuguLive
//
//  Created by 丁凯 on 2017/8/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XRWaterfallLayout.h"
#import "XRImage.h"

@class SHomeSVideoV;
@protocol videoDeleGate <NSObject>

- (void)pushToVideoDetailWithArr:(NSArray *)arr andView:(SHomeSVideoV *)homeSVideoV;
// 播放一组视频，并指定播放位置
- (void)pushToVideoDetailWithArr:(NSArray *)videos index:(NSInteger)index IsPushed:(BOOL)isPushed requestDict:(NSDictionary *)dict;

-(void)didVideoCollectionViewScrollView:(UIScrollView *)scrollView;

@end

@interface SHomeSVideoV : BGBaseView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XRWaterfallLayoutDelegate>

@property ( nonatomic,strong) UICollectionView                 *videoCollectionV;
//@property ( nonatomic,strong) UICollectionViewFlowLayout       *myCollectionLayout;

@property ( nonatomic,strong) XRWaterfallLayout       *myCollectionLayout;

@property ( nonatomic,strong) NSMutableArray                   *dataArray;
@property ( nonatomic,assign) int                              currentPage;
@property ( nonatomic,assign) int                              has_next;
@property ( nonatomic,copy) NSString                           *user_id;
@property ( nonatomic,weak) id<videoDeleGate>                  VDelegate;

@property (nonatomic, strong) NSMutableArray<XRImage *> *images;


- (instancetype)initWithFrame:(CGRect)frame andUserId:(NSString *)userId;

-(void)refreshHeader;

@end
