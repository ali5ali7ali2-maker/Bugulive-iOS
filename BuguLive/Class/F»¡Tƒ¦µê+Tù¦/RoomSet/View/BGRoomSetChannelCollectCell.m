//
//  BGRoomSetChannelCollectCell.m
//  UniversalApp
//
//  Created by bugu on 2020/3/23.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BGRoomSetChannelCollectCell.h"
#import "HallTypeModel.h"
#import "RoomModel.h"

@implementation BGRoomSetChannelCollectCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _titleLabel= ({
                   UILabel * label = [[UILabel alloc]init];
                   label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
                   label.font = [UIFont systemFontOfSize:16];
                   label.text = @"闲聊";
                   label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 4;
        label.clipsToBounds = YES;
                   label;
               });
    [self addSubview:_titleLabel];
    _titleLabel.frame = self.bounds;
    
}

-(void)setModel:(VideoClassifiedModel *)model{
    _model = model;
    [self setSelected:model.isSelected];
    [self.titleLabel setText:model.title];
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.titleLabel.backgroundColor = [UIColor qmui_colorWithHexString:@"#AE2CF1"];
        self.titleLabel.textColor = kWhiteColor;
    }
    else{
       
        
        self.titleLabel.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}
@end
