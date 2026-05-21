//
//  PKUserTableViewCell.h
//  FanweApp
//
//  Created by 志刚杨 on 2018/7/18.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

typedef void(^clickPkBlock)(UserModel *user);

@interface PKUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *nickname;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImgView;

@property (nonatomic, strong)UserModel *user;
@property (weak, nonatomic) IBOutlet UIButton *pkBtn;

- (void)setClickPkBlock:(clickPkBlock)clickPkBlock;

@end
