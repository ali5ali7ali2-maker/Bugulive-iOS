//
//  CellForReplyTableViewCell.h
//  MarryU
//
//  Created by 志刚杨 on 2017/6/29.
//  Copyright © 2017年 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYDReplyModel.h"

@interface CellForReplyTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *avatar;
@property(nonatomic, strong) UILabel *nicename;
@property(nonatomic, strong) UILabel *body;
@property(nonatomic, strong) UILabel *addtime;
@property(nonatomic, strong) UILabel *city;
@property(nonatomic, strong) UILabel *age;

@property(nonatomic, strong) UIButton *deleteBtn;

@property(nonatomic, strong) UIView *line;

@property(nonatomic, strong) MGGroupUserInfo *model;


@property (nonatomic,strong)NSLayoutConstraint *cstHeightlbContent;


@property(nonatomic, copy) void (^clickDeleteBlock)(BOOL isDelete);

-(void)setModel:(MGGroupUserInfo *)model;

@end
