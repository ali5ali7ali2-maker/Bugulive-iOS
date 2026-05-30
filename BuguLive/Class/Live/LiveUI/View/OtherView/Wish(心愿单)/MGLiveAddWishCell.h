//
//  MGLiveAddWishCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/5.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGLiveWishModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MGLiveAddWishCellDelegate <NSObject>
//点击添加礼物
-(void)protocolClickLiveAddWishModel:(MGLiveWishModel *)model;

@end

@interface MGLiveAddWishCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic, strong) UIImageView *iconImgView;
@property(nonatomic, strong) UILabel     *topicL;
@property(nonatomic, strong) UILabel     *contentL;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UIView *line;
@property(nonatomic, strong) UIButton *addBtn;

@property(nonatomic, strong) MGLiveWishModel *model;
@property(nonatomic, weak) id<MGLiveAddWishCellDelegate> delegate;

@property(nonatomic, assign) MGADD_WISH wishType;

-(void)resetCellWithWishType:(MGADD_WISH)wishType WithModel:(MGLiveWishModel *)model;

@property(nonatomic, copy) void (^textFieldBlock)(NSString *str);

@end

NS_ASSUME_NONNULL_END
