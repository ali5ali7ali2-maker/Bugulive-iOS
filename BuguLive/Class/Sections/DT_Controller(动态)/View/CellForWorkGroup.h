//
//  CellForQAList.h
//  github:  https://github.com/samuelandkevin
//
//  Created by samuelandkevin on 16/8/29.
//  Copyright © 2016年 HKP. All rights reserved.
//  原创视图

#import <UIKit/UIKit.h>
//#import "YHWorkGroup.h"
#import "HKPBotView.h"

#import "MGGroupUserInfo.h"
#import "MGGroupBottomCellView.h"

#import "VideoFrame.h"
#import "BzoneLogic.h"

@class CellForWorkGroup;
@protocol CellForWorkGroupDelegate <NSObject>

- (void)onAvatarInCell:(CellForWorkGroup *)cell;
- (void)onMoreInCell:(CellForWorkGroup *)cell;
- (void)onCommentInCell:(CellForWorkGroup *)cell;
- (void)onLikeInCell:(CellForWorkGroup *)cell;
- (void)onShareInCell:(CellForWorkGroup *)cell;
- (void)onTopicInCell:(CellForWorkGroup *)cell;
- (void)onFollowInCell:(CellForWorkGroup *)cell;

//视频被点击
- (void)onTouchActionVideo:(CellForWorkGroup *)cell withFullScreen:(BOOL)isFull;
@optional
- (void)onDeleteInCell:(CellForWorkGroup *)cell;

@end

@interface CellForWorkGroup : UITableViewCell<MGBotViewDelegate>

@property (nonatomic,strong) MGGroupUserInfo *model;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic, weak) id<CellForWorkGroupDelegate> delegate;
//@property (nonatomic,strong)HKPBotView  *viewBottom;

@property (nonatomic, strong) MGGroupBottomCellView *bottomView;
@property (nonatomic, strong) VideoFrame *ClVideoview;

@property(nonatomic, strong) QMUIButton *liksBtn;
@property(nonatomic, strong) QMUIButton *commentBtn;

@property(nonatomic, assign) MGDTHOMETYPE homeType;



@end
