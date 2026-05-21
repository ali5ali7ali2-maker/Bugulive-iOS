//
//  MGLiveWishCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/5.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGLiveWishModel.h"
#import <QMUIButton.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MGLiveWishCellDelegate <NSObject>

-(void)protocolMGLiveWishClickType:(MGADD_WISH)wishType;
-(void)protocolLiveWishClickDelteModel:(MGLiveWishModel *)model;

@end

@interface MGLiveWishCell : UITableViewCell

@property(nonatomic, strong) UIImageView *bgImgView;
@property(nonatomic, strong) UILabel     *titleL;
@property(nonatomic, strong) UIImageView *iconImgView;
@property(nonatomic, strong) UILabel     *topicL;
@property(nonatomic, strong) UILabel     *numL;
@property(nonatomic, strong) UILabel     *contentL;
@property(nonatomic, strong) UIButton    *deleteBtn;


//底部相关
@property(nonatomic, strong) UIButton *generateBtn;//生成心愿按钮
@property(nonatomic, strong) QMUIButton *addWishBtn;
@property(nonatomic, strong) UIView *bottomView;

@property(nonatomic, strong) MGLiveWishModel *model;

@property(nonatomic, weak) id<MGLiveWishCellDelegate> delegate;

-(void)resetModelArr:(MGLiveWishModel *)model indexPath:(NSInteger)indexPath;

@end

NS_ASSUME_NONNULL_END
