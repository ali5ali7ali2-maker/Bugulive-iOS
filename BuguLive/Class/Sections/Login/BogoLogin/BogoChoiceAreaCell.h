//
//  BogoChoiceAreaCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/25.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BogoChoiceAreaModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoChoiceAreaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countryL;

@property (weak, nonatomic) IBOutlet UILabel *numL;


@property(nonatomic, strong) BogoChoiceAreaModel *model;

@end

NS_ASSUME_NONNULL_END
