//
//  VideoDynamicView.h
//  BuguLive
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableBaseView.h"
#import "STTableTextViewCell.h"
#import "STTablePhotoCell.h"
#import "STTableLeftRightLabCell.h"
#import "STTableCommitBtnCell.h"
#import "STTableShowVideoCell.h"
#import "STVideoCateCell.h"
#import "STTableLeftRightCell.h"

#import "MGBaseModel.h"

#import <CoreLocation/CoreLocation.h>

@class VideoDynamicView;
@protocol VideoDynamicViewDelegate <NSObject>
@optional
-(void)showSystemIPC:(BOOL)isSystemIPC andMaxSelectNum:(int)maxSelectNum;

- (void)showMyVideoView;
- (void)submitData;

//去封面编辑页面
-(void)showOnVideoDynamicView:(VideoDynamicView *)videoDynamicView STTableShowVideoCell:(STTableShowVideoCell *)stTableShowVideoCell andChangeVideoCoverClick:(UIButton *)changeVideoCoverClick;


-(void)goVCOnVideoDynamicView:(VideoDynamicView *)videoDynamicView STTableShowVideoCell:(STVideoCateCell *)cell andChooseCateClick:(QMUIButton *)btn;

- (void)dynamicView:(VideoDynamicView *)dynamicView didSelectGood:(STTableLeftRightCell *)cell;

@end

@interface VideoDynamicView : STTableBaseView <STTableTextViewCellDeleagte,STTablePhotoCellDelegate,STTableShowVideoCellDelegate,UIActionSheetDelegate>

@property(nonatomic,strong)NSString *recordTextViewStr;
@property(nonatomic,weak)id<VideoDynamicViewDelegate>delegate;
@property(nonatomic,assign)NSInteger    recordSelectIndex;

@property(nonatomic, strong) NSMutableArray *actionArr;
@property(nonatomic, strong) MGBaseModel *videoModel;

@property(nonatomic, strong) CLLocationManager *locationManager;

@property(nonatomic, strong) NSURL *videoURL;

@property(nonatomic, strong) UIView *footerView;

@end
