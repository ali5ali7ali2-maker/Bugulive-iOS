//
//  GuildDetailView.h
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import <UIKit/UIKit.h>
@class GuildDetailView;
@class GuildDetailModel;

NS_ASSUME_NONNULL_BEGIN

@protocol GuildDetailViewDelegate <NSObject>

@optional
- (void)detailView:(GuildDetailView *)detailView didClickJoinBtnAction:(UIButton *)sender;
- (void)detailView:(GuildDetailView *)detailView didClickEditBtnAction:(UIButton *)sender;
- (void)detailView:(GuildDetailView *)detailView didClickDeleteBtnAction:(UIButton *)sender;
- (void)detailView:(GuildDetailView *)detailView didClickQuitBtnAction:(UIButton *)sender;
- (void)detailView:(GuildDetailView *)detailView didClickMemberViewAction:(UIView *)sender;
- (void)detailView:(GuildDetailView *)detailView didClickRankViewAction:(UIView *)sender;
- (void)detailView:(GuildDetailView *)detailView didClickApplyViewAction:(UIView *)sender;

@end

@interface GuildDetailView : UIView

@property(nonatomic, weak) id<GuildDetailViewDelegate>delegate;

@property(nonatomic, strong) GuildDetailModel *model;

@end

NS_ASSUME_NONNULL_END
