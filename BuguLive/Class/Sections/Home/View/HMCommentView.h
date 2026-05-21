//
//  HMCommentView.h
//  BuguLive
//
//  Created by 范东 on 2019/1/2.
//  Copyright © 2019 xfg. All rights reserved.
//  评论列表

#import "BGBaseView.h"
#import "SmallVideoListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^operateCommentSuccessBlock)(NSString *commentCount);

@interface HMCommentView : BGBaseView

@property (nonatomic, strong) SmallVideoListModel *model;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 展示全部平评论列表

 @param superView 父视图
 */
- (void)show:(UIView *)superView;

/**
 隐藏全部评论
 */
- (void)hide;

- (void)setOperateCommentSuccessBlock:(operateCommentSuccessBlock)operateCommentSuccessBlock;

@end

NS_ASSUME_NONNULL_END
