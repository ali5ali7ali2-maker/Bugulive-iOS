//
//  BogoCartBottomView.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/23.
//

#import "FDView.h"
@class BogoCartBottomView;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BogoCartBottomViewType) {
    BogoCartBottomViewTypeNormal,
    BogoCartBottomViewTypeEdit,
    BogoCartBottomViewTypeOrderSubmit
};

@protocol BogoCartBottomViewDelegate <NSObject>

@optional
- (void)bottomView:(BogoCartBottomView *)bottomView didClickSelectBtn:(UIButton *)sender;
- (void)bottomView:(BogoCartBottomView *)bottomView didClickAccountBtn:(UIButton *)sender;
- (void)bottomView:(BogoCartBottomView *)bottomView didClickDeleteBtn:(UIButton *)sender;

@end

@interface BogoCartBottomView : FDView

@property(nonatomic, weak) id<BogoCartBottomViewDelegate>delegate;

@property(nonatomic, assign) BogoCartBottomViewType type;

@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *num;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *selectBtn;

@end

NS_ASSUME_NONNULL_END
