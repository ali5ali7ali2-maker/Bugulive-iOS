//
//  BogoLogoutTextItmeCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/29.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoLogoutTextItmeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UIView *dotView;

@property(nonatomic, assign) NSInteger indexRow;

@end

NS_ASSUME_NONNULL_END
