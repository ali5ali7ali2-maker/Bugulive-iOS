//
//  VoicePeopleTagView.m
//  BuguLive
//
//  Created by voidcat on 2024/9/24.
//  Copyright © 2024 xfg. All rights reserved.
//

#import "VoicePeopleTagView.h"

@interface VoicePeopleTagView ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *peopleImg;
@property (weak, nonatomic) IBOutlet UILabel *peopleNam;

@end

@implementation VoicePeopleTagView

- (void)awakeFromNib {
    [super awakeFromNib];
   
    //设置view
    [self setupView];
    
    //圆角+边框 #AAD2F0
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:170/255.0 green:210/255.0 blue:240/255.0 alpha:1].CGColor;
    
    
}

- (void)setPeopleName:(NSString *)peopleName
{
    _peopleName = peopleName;
    _peopleImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"人数%@",peopleName]];
    _peopleNam.text = [NSString stringWithFormat:ASLocalizedString(@"%@ People"),peopleName];
    
}
- (void)setCellSelected:(BOOL)cellSelected
{
    _cellSelected = cellSelected;
    
    if (cellSelected) {
        self.layer.borderColor = [UIColor colorWithRed:170/255.0 green:210/255.0 blue:240/255.0 alpha:1].CGColor;
        self.selectBtn.hidden = NO;
    } else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.selectBtn.hidden = YES;
    }
}

#pragma mark - View
- (void)setupView {
    
}


@end
