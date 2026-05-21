//
//  BogoWithDrawTypeCell.h
//  UniversalApp
//
//  Created by Mac on 2021/6/12.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoWithDrawTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authImageView;

@end

NS_ASSUME_NONNULL_END
