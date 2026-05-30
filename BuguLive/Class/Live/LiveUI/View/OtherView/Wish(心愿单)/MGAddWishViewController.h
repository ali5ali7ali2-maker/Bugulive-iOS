//
//  MGAddWithViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/5.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BaseViewController.h"
#import "MGLiveAddWishCell.h"
#import "MGLiveWishModel.h"
#import "MGLiveWishListCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MGLiveAddWishDelegate <NSObject>
//完成心愿添加
-(void)protocolClickFinisheAddWishModel:(MGLiveWishModel *)model;

@end

@interface MGAddWishViewController : UIViewController

@property(nonatomic, assign) MGADD_WISH wishType;

-(instancetype)initWithWishType:(MGADD_WISH)wishType;

@property(nonatomic, copy) void (^clickGiftCellBlcok)(MGLiveWishModel *wishModel);
@property (nonatomic,strong) NSString *roomId;

@end

NS_ASSUME_NONNULL_END
