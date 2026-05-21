//
//  TiUIMenuViewCell.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/2.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiUIMenuViewCell.h"

@interface TiUIMenuViewCell ()

@property(nonatomic,strong)UILabel *textLabel;

@end

@implementation TiUIMenuViewCell

-(UILabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.userInteractionEnabled = YES;
        _textLabel.font = TI_Font_Default_Size_Medium;
        _textLabel.textColor = TI_Color_Default_Text_Black;
    }
    return _textLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self);
        }];
    }
    return self;
}

-(void)setMenuMode:(TIMenuMode *)menuMode{
    if (menuMode) {
        _menuMode = menuMode;
        
        self.textLabel.text = menuMode.name;
         
        BOOL highlighted = menuMode.selected;
        
        if (highlighted)
        {
            self.textLabel.textColor = TI_Color_Default_Background_Pink;
        }
        else
        {
            self.textLabel.textColor = TI_Color_Default_Text_Black; 
        }
    }
}
 

@end
