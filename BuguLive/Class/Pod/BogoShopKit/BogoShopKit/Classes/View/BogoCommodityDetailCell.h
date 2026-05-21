//
//  BogoCommodityDetailCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/16.
//

#import "FDTableViewCell.h"
@class BogoCommodityDetailCell;
@class BogoCommodityDetailModel;

#define kBogoCommodityDetailCellBaseTag 100

NS_ASSUME_NONNULL_BEGIN

@protocol BogoCommodityDetailCellDelegate <NSObject>

- (void)detailCell:(BogoCommodityDetailCell *)detailCell didClickAddBtn:(UIButton *)sender;
- (void)detailCell:(BogoCommodityDetailCell *)detailCell didClickDelBtn:(UIButton *)sender;
- (void)detailCell:(BogoCommodityDetailCell *)detailCell contentStr:(UITextView *)sender;

- (void)detailCell:(BogoCommodityDetailCell *)detailCell resetContentViewHeight:(CGFloat)viewHeight;

@end

@interface BogoCommodityDetailCell : FDTableViewCell<UITextViewDelegate>

@property(nonatomic, weak) id<BogoCommodityDetailCellDelegate>delegate;

@property(nonatomic, strong) NSMutableArray *buttonArray;

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, strong) NSMutableArray *imgWHRadioArr;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property(nonatomic, assign) BOOL isSee;

- (void)addButton;

- (void)resetAllButtonHeight;

@end

NS_ASSUME_NONNULL_END
