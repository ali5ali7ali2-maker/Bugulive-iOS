//
//  TYCyclePagerViewCell.h
//  BogoShopKit
//
//  Created by Mac on 2021/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYCyclePagerViewCell : UICollectionViewCell

@property(nonatomic, copy) NSString *qrCode;
@property(nonatomic, strong) UIImageView *imageView;

- (UIImage*)convertViewToImage;

@end

NS_ASSUME_NONNULL_END