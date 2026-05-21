//
//  BGRoomSetPwdCell.m
//  UniversalApp
//
//  Created by bugu on 2020/3/23.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BGRoomSetPwdCell.h"
@interface BGRoomSetPwdCell ()
@end
@implementation BGRoomSetPwdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}



- (void)initUI {
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _passwordView = [RoomPasswordView getView];
    [_passwordView.txtPassword addTarget:self action:@selector(pwChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_passwordView];
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.centerY.equalTo(self).offset(0);
        make.height.equalTo(@40);
    }];
    
}
- (void)pwChange:(UITextField *)textField {
    if (_pwdTextChangeBlock) {
        _pwdTextChangeBlock(textField.text);
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];

}


@end
