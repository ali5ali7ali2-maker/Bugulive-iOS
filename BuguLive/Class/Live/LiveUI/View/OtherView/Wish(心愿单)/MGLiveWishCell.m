//
//  MGLiveWishCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/5.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGLiveWishCell.h"

@implementation MGLiveWishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpView];
        [self resetView];
    }
    return self;
}

-(void)setUpView{
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kRealValue(11), 0, kScreenW - kRealValue(11 * 2), kRealValue(125))];
//    bgImgView.userInteractionEnabled = YES;
    [bgImgView setImage:[UIImage imageNamed:@"live_wish_bgView"]];
    self.bgImgView = bgImgView;
    [self.contentView addSubview:bgImgView];
    
    UILabel *titleL = [UILabel new];
    titleL.text = ASLocalizedString(@"心愿一");
    titleL.font = [UIFont systemFontOfSize:14];
    titleL.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleL = titleL;
    
    UIImageView *iconImgView = [UIImageView new];
    [iconImgView setImage:[UIImage imageNamed:@"live_wish_gift_addBGView"]];
    _iconImgView = iconImgView;
    
    UILabel *topicL = [UILabel new];
    topicL.text = ASLocalizedString(@"添加礼物和数量");
    topicL.font = [UIFont systemFontOfSize:14];
    topicL.textColor = [UIColor colorWithHexString:@"#333333"];
    _topicL = topicL;
    
    UILabel *numL = [UILabel new];
    numL.text = ASLocalizedString(@"9999个");
    numL.font = [UIFont systemFontOfSize:14];
    numL.textColor = [UIColor colorWithHexString:@"#CD49FF"];
    numL.hidden = YES;
    _numL = numL;
    
    UILabel *contenL = [UILabel new];
    contenL.text = ASLocalizedString(@"报答方式(选填):编辑8个字以内");
    contenL.font = [UIFont systemFontOfSize:14];
    contenL.textColor = [UIColor colorWithHexString:@"#666666"];
    _contentL = contenL;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"live_wish_delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn = deleteBtn;
    
    [bgImgView addSubview:titleL];
    [bgImgView addSubview:numL];
    [bgImgView addSubview:iconImgView];
    [bgImgView addSubview:topicL];
    [bgImgView addSubview:contenL];
    [self.contentView addSubview:deleteBtn];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, bgImgView.bottom, kScreenW, kRealValue(158))];

    [view addSubview:self.addWishBtn];
    [view addSubview:self.generateBtn];
    
    self.addWishBtn.frame = CGRectMake(0, kRealValue(10), kRealValue(160), kRealValue(47));
    self.generateBtn.frame = CGRectMake(0, self.addWishBtn.bottom + kRealValue(15), kRealValue(205), kRealValue(40));
    
    self.generateBtn.centerX = self.addWishBtn.centerX = kScreenW / 2;
    _bottomView = view;
    _bottomView.hidden = YES;
    [self.contentView addSubview:_bottomView];
}



-(void)resetModelArr:(MGLiveWishModel *)model indexPath:(NSInteger)indexPath{
    if (!model) {
        [self.contentView removeAllSubViews];
        [self setUpView];
        [self resetView];
        return;
    }
    _model = model;
    
    NSString *title = ASLocalizedString(@"心愿一");
    if (indexPath == 0) {
        title = ASLocalizedString(@"心愿一");
    }else if (indexPath == 1) {
        title = ASLocalizedString(@"心愿二");
    }else if (indexPath == 2){
        title = ASLocalizedString(@"心愿三");
    }
    
    _numL.hidden = NO;
    _deleteBtn.hidden = NO;
    _titleL.text = title;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.g_icon] placeholderImage:nil];
    _topicL.text = model.g_name;
    _numL.text = [NSString stringWithFormat:ASLocalizedString(@"%@"),model.g_num];
    _contentL.text = model.txt;
    
    [self resetView];
}

-(void)resetView{
    _titleL.frame = CGRectMake(kRealValue(15), kRealValue(15), kScreenW * 0.4, 20);
    _iconImgView.frame = CGRectMake(_titleL.left, _titleL.bottom + kRealValue(10), kRealValue(65), kRealValue(65));
    _topicL.frame = CGRectMake(_iconImgView.right + kRealValue(5), _iconImgView.top + kRealValue(10), self.bgImgView.width - _iconImgView.width - kRealValue(10 * 3), kRealValue(20));
    [_topicL sizeToFit];
    _contentL.frame = CGRectMake(_topicL.left, _topicL.bottom + kRealValue(15), self.bgImgView.width - _iconImgView.width - kRealValue(10 * 3), kRealValue(20));
    _numL.frame = CGRectMake(_topicL.right + kRealValue(10), 0, kRealValue(100), kRealValue(20));
    _numL.centerY = _topicL.centerY;
    
    _deleteBtn.frame = CGRectMake(self.bgImgView.width - kRealValue(40), kRealValue(25), kRealValue(40), kRealValue(40));
}



-(void)clickDelete:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(protocolLiveWishClickDelteModel:)])
    {
        [self.delegate protocolLiveWishClickDelteModel:self.model];
    }
}

-(void)clickAddWish:(UIButton *)sender{
    
    if([self.delegate respondsToSelector:@selector(protocolMGLiveWishClickType:)])
    {
        [self.delegate protocolMGLiveWishClickType:MGWISHTYPE_ADD];
    }
}

-(void)generateWish:(UIButton *)sender{
    
    if([self.delegate respondsToSelector:@selector(protocolMGLiveWishClickType:)])
    {
        [self.delegate protocolMGLiveWishClickType:MGWISHTYPE_GENERATE];
    }
}

-(QMUIButton *)addWishBtn{
    if (!_addWishBtn) {
        _addWishBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_addWishBtn setTitle:ASLocalizedString(@"添加心愿")forState:UIControlStateNormal];
        _addWishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_addWishBtn setTitleColor:[UIColor colorWithHexString:@"#CD49FF"] forState:UIControlStateNormal];
        _addWishBtn.imagePosition = QMUIButtonImagePositionLeft;
        [_addWishBtn setImage:[UIImage imageNamed:@"live_wish_add"] forState:UIControlStateNormal];
        _addWishBtn.spacingBetweenImageAndTitle = 2;
        [_addWishBtn addTarget:self action:@selector(clickAddWish:) forControlEvents:UIControlEventTouchUpInside];
        [_addWishBtn setBackgroundImage:[UIImage imageNamed:@"live_wish_add_border"] forState:UIControlStateNormal];
    }
    return _addWishBtn;
}


-(UIButton *)generateBtn{
    if (!_generateBtn) {
        _generateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_generateBtn setTitle:ASLocalizedString(@"生成心愿")forState:UIControlStateNormal];
        [_generateBtn setBackgroundImage:[UIImage imageNamed:@"live_wish_add_generate"] forState:UIControlStateNormal];
        [_generateBtn addTarget:self action:@selector(generateWish:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _generateBtn;
}

@end
