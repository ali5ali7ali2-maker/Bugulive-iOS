//
//  CommonLevelView.h
//  UniversalApp
//
//  Created by bogokj on 2019/12/19.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishNewLevelImageBlock)(UIImage *levelImage);

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CommonLevelViewType) {
    CommonLevelViewTypeWealth,//财富等级
    CommonLevelViewTypeStar,//明星等级
};

@interface CommonLevelView : UIView

@property(nonatomic, assign) CommonLevelViewType type;

@property(nonatomic, strong) NSString *level;

@property (strong, nonatomic) UIImageView *levelImageView;
@property (strong, nonatomic) UILabel *levelLabel;

+ (void)getNewLevelImageWithLevel:(NSString *)level AndFinishNewLevelImageBlock:(finishNewLevelImageBlock)finishNewLevelImageBlock;

@end

NS_ASSUME_NONNULL_END
