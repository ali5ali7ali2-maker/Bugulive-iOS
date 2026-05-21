//
//  PKPopView.h
//  BuguLive
//
//  Created by 范东 on 2019/1/24.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGBaseView.h"
@class PKTimeModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickSetTimeBlcok)();
typedef void(^clickTimeCellBlock)(PKTimeModel *model);
typedef void(^clickPkBtnBlock)(NSString *pk_list_id);
typedef void(^clickEndPkBtnBlock)();

typedef NS_ENUM(NSInteger, PKPopViewType) {
    PKPopViewTypeInvication,//发出pk邀请
    PKPopViewTypeDetail,//查看pk详情
    PKPopViewSelectTime,//选择PK时间
};

@interface PKPopView : BGBaseView

@property (nonatomic, strong) PKTimeModel *pkTimeModel;

@property (nonatomic, copy) NSString *otherId;

- (instancetype)initWithType:(PKPopViewType)type;

//- (void)show:(UIView *)superView;
//
//- (void)hide;

- (void)setClickSetTimeBlcok:(clickSetTimeBlcok)clickSetTimeBlcok;

- (void)setClickTimeCellBlock:(clickTimeCellBlock)clickTimeCellBlock;

- (void)setClickPkBtnBlock:(clickPkBtnBlock)clickPkBtnBlock;

- (void)setClickEndPkBtnBlock:(clickEndPkBtnBlock)clickEndPkBtnBlock;

@end

NS_ASSUME_NONNULL_END
