//
//  BogoSearchHeaderView.h
//  BuguLive
//
//  Created by Mac on 2021/9/27.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BogoSearchHeaderView;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoSearchHeaderViewDelegate <NSObject>

- (void)headerView:(BogoSearchHeaderView *)headerView didClickAllBtn:(UIButton *)sender;

@end

typedef NS_ENUM(NSInteger, BogoSearchHeaderViewType) {
    BogoSearchHeaderViewTypeUser,
    BogoSearchHeaderViewTypeVideo,
    BogoSearchHeaderViewTypeDynamic,
};

@interface BogoSearchHeaderView : UIView

@property(nonatomic, assign) BogoSearchHeaderViewType type;

@property(nonatomic, weak) id<BogoSearchHeaderViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet QMUIButton *allBtn;


@end

NS_ASSUME_NONNULL_END
