//
//  BogoTimeLineListViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/18.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGBaseViewController.h"

#import "MGDynamicTopicModel.h"
#import "BzoneLogic.h"

@protocol BogoTimeLineDidScrollViewDelegate <NSObject>

-(void)protocolTimeLineDidScrollView:(UIScrollView *)scrollView offset:(CGFloat)offset;

-(void)didDynamicCollectionViewScrollView:(UIScrollView *)scrollView;

-(void)reloadDynamicData;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BogoTimeLineListViewController : BGBaseViewController

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger curPageIndex;

@property(nonatomic, assign) MGDTHOMETYPE homeType;

@property(nonatomic, weak) id<BogoTimeLineDidScrollViewDelegate>timeLineDelegate;

-(instancetype)initWithIndexAct:(MGDTHOMETYPE)act withUID:(NSString *)toUid isHomePageFrame:(CGRect)homePageFrame;
-(void)handleSearchEvent;

@property(nonatomic, strong) MGDynamicTopicModel *topic;/**<话题*/

@property(nonatomic, strong) NSString *toUid;

@property(nonatomic, assign) CGRect homePageFrame;

@property(nonatomic, weak) id<BogoTimeLineDidScrollViewDelegate> vDelegate;

@property(nonatomic, assign) BOOL showConcertBtn;//个人主页的隐藏掉关注按钮

-(void)reloadDynamicData;

@end

NS_ASSUME_NONNULL_END
