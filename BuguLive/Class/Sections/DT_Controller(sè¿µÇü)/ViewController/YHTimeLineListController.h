//
//  YHQAListController.h
//  github:  https://github.com/samuelandkevin
//
//  Created by samuelandkevin on 16/8/29.
//  Copyright © 2016年 HKP. All rights reserved.
//  问答列表

#import <UIKit/UIKit.h>
#import "MGDynamicTopicModel.h"
#import "BzoneLogic.h"

@protocol MGTimeLineDidScrollViewDelegate <NSObject>

-(void)protocolTimeLineDidScrollView:(UIScrollView *)scrollView offset:(CGFloat)offset;

-(void)didDynamicCollectionViewScrollView:(UIScrollView *)scrollView;

-(void)reloadDynamicData;

@end

@interface YHTimeLineListController : BGBaseViewController

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger curPageIndex;

@property(nonatomic, assign) MGDTHOMETYPE homeType;

@property(nonatomic, weak) id<MGTimeLineDidScrollViewDelegate>timeLineDelegate;

-(instancetype)initWithIndexAct:(MGDTHOMETYPE)act withUID:(NSString *)toUid;
-(void)handleSearchEvent;

@property(nonatomic, strong) MGDynamicTopicModel *topic;/**<话题*/

@property(nonatomic, strong) NSString *toUid;

@property(nonatomic, weak) id<MGTimeLineDidScrollViewDelegate> vDelegate;

-(void)reloadDynamicData;

@end
