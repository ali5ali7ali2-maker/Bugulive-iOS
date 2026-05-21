//
//  BogoLiveMessageCoupleView.h
//  UniversalApp
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoTitleGradientLayerView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (UIImage*)convertViewToImage;

@end

NS_ASSUME_NONNULL_END
