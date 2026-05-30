//
//  MGLiveAddWishCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/5.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGLiveAddWishCell.h"

@implementation MGLiveAddWishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpView];
        [self resetView];
    }
    return self;
}

-(void)setUpView{
    UIImageView *iconImgView = [UIImageView new];
    [iconImgView setImage:kDefaultPreloadHeadImg];
    _iconImgView = iconImgView;
    
    UILabel *topicL = [UILabel new];
    topicL.text = ASLocalizedString(@"添加礼物和数量");
    topicL.font = [UIFont systemFontOfSize:14];
    topicL.textColor = [UIColor colorWithHexString:@"#333333"];
    _topicL = topicL;
    
    UITextField *textField = [UITextField new];
    textField.placeholder = ASLocalizedString(@"数量最多输入5个");
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentRight;
    _textField = textField;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"live_wish_gift_border"] forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithHexString:@"#CD49FF"] forState:UIControlStateNormal];
    [addBtn setTitle:ASLocalizedString(@"添加")forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    addBtn.userInteractionEnabled = NO;
//     setImage:[UIImage imageNamed:@"live_wish_delete"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(clickAdd:) forControlEvents:UIControlEventTouchUpInside];
    _addBtn = addBtn;
    
    _line = [UIView new];
    _line.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    [self.contentView addSubview:iconImgView];
    [self.contentView addSubview:topicL];
    [self.contentView addSubview:textField];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:addBtn];
}



-(void)resetView{
    
    _iconImgView.frame = CGRectMake(kRealValue(15), kRealValue(15), kRealValue(24), kRealValue(24));
    _topicL.frame = CGRectMake(_iconImgView.left + kRealValue(10),kRealValue(10), kScreenW / 2, kRealValue(20));
    if (self.wishType == MGWISHTYPE_ADD) {
        _iconImgView.hidden = YES;
        _textField.hidden = NO;
        _topicL.left = kRealValue(15);
    }else{
        _iconImgView.hidden = NO;
        _textField.hidden = YES;
        _topicL.left = _iconImgView.right + kRealValue(10);
    }
    
    _contentL.frame = CGRectMake(kScreenW / 2, kRealValue(15), kScreenW / 2, kRealValue(20));
    _textField.frame = CGRectMake(kScreenW / 2 - kRealValue(10), 0, kScreenW / 2, kRealValue(20));
    
    _addBtn.frame = CGRectMake(kScreenW - kRealValue(11) - kRealValue(56), kRealValue(25), kRealValue(56), kRealValue(25));
    _textField.centerY = _addBtn.centerY = self.contentL.centerY = self.iconImgView.centerY = self.topicL.centerY;
    _line.frame = CGRectMake(0, _topicL.bottom + kRealValue(12) , kScreenW, 1);
}


-(void)resetCellWithWishType:(MGADD_WISH)wishType WithModel:(MGLiveWishModel *)model{
    _wishType = wishType;
    
    self.model = model;
    if (wishType == MGWISHTYPE_ADD) {
        self.addBtn.hidden = YES;
    }else if (wishType == MGWISHTYPE_ADD_GIFT){
        self.addBtn.hidden = NO;
        [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
        self.topicL.text = model.name;
    }
    
    [self resetView];
}

-(void)clickAdd:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(protocolClickLiveAddWishModel:)]) {
        [self.delegate protocolClickLiveAddWishModel:self.model];
    }
}

-(void)textFieldDidChangeSelection:(UITextField *)textField{
 
    if (self.textFieldBlock) {
        self.textFieldBlock(textField.text);
    }
    
}


@end
