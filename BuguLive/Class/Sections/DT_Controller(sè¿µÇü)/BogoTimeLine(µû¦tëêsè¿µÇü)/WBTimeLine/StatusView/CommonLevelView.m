//
//  CommonlevelImageView.m
//  UniversalApp
//
//  Created by bogokj on 2019/12/19.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "CommonLevelView.h"
//#import "LevelListModel.h"
//#import "BogoIncomeLevelListModel.h"

@interface CommonLevelView ()



@end

@implementation CommonLevelView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setLevel:(NSString *)level{
    _level = level;
    if (![self.subviews containsObject:self.levelImageView]) {
        [self addSubview:self.levelImageView];
    }
    
    if (![self.subviews containsObject:self.levelLabel]) {
        [self addSubview:self.levelLabel];
    }
    
    [self.levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.top.bottom.equalTo(self);
    }];
    
    if (level.integerValue) {
        [self.levelLabel setText:level];
        self.hidden = NO;
    }else{
        self.hidden = YES;
    }
    if (_type == CommonLevelViewTypeWealth) {
//        for (LevelListModel *model in KGlobalVariable.appmodel.level_list) {
//            if ([model.level_name isEqualToString:level]) {
//                [self.levelImageView sd_setImageWithURL:[NSURL URLWithString:model.chat_icon]];
//            }
//        }
    }else{
//        for (BogoIncomeLevelListModel *model in KGlobalVariable.appmodel.income_level_list) {
//            if ([model.level_name isEqualToString:level]) {
//                [self.levelImageView sd_setImageWithURL:[NSURL URLWithString:model.chat_icon]];
//            }
//        }
//        BogoIncomeLevelListModel *model = KGlobalVariable.appmodel.income_level_list.firstObject;
//        [self.levelImageView sd_setImageWithURL:[NSURL URLWithString:model.chat_icon]];
    }
}

+ (void)getNewLevelImageWithLevel:(NSString *)level AndFinishNewLevelImageBlock:(finishNewLevelImageBlock)finishNewLevelImageBlock{
//    for (LevelListModel *model in KGlobalVariable.appmodel.level_list) {
//        if ([model.level_name isEqualToString:level]) {
//            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:model.chat_icon] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//                UIImage *watermarkedImage = nil;
//                UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
//                [image drawAtPoint: CGPointZero];
//                [level drawAtPoint: CGPointMake(25 * 3, 13) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//                watermarkedImage = UIGraphicsGetImageFromCurrentImageContext();
//                UIGraphicsEndImageContext();
//                if (finishNewLevelImageBlock) {
//                    finishNewLevelImageBlock(watermarkedImage);
//                }
//            }];
//        }
//    }
    
}

- (UIImageView *)levelImageView{
    if (!_levelImageView) {
        _levelImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _levelImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _levelImageView;
}

- (UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _levelLabel.textColor = kWhiteColor;
        _levelLabel.font = [UIFont systemFontOfSize:10];
        _levelLabel.textAlignment = NSTextAlignmentRight;
    }
    return _levelLabel;
}

@end
