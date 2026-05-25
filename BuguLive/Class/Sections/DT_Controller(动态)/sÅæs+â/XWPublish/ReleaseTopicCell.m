//
//  ReleaseTopicCell.m
//  BuguLive
//
//  Created by bugu on 2019/11/28.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "ReleaseTopicCell.h"

@implementation ReleaseTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
  
    self.topicLabel = [[UILabel alloc]init];
    self.topicLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.topicLabel.font = [UIFont systemFontOfSize:14];
    
    self.numLabel = [[UILabel alloc]init];
    self.numLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.numLabel.font = [UIFont systemFontOfSize:14];
    
    self.topicLabel.text = @"#xxxxxxx#";
    
    self.numLabel.text = @"xxxxxxx";
    
    [self.contentView addSubview: self.topicLabel];
    [self.contentView addSubview: self.numLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self);
    }];
}

- (void)setTopic:(MGDynamicTopicModel *)topic
{
    self.topicLabel.text = [NSString stringWithFormat:@"#%@#",topic.name];
    self.numLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@人讨论"),topic.num];
}

@end
