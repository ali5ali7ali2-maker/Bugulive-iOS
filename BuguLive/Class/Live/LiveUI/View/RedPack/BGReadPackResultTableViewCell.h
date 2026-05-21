//
//  BGReadPackTableViewCell.h
//  BuguLive
//
//  Created by 志刚杨 on 2021/12/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGReadPackResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *labNickname;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labCount;

@end

NS_ASSUME_NONNULL_END
