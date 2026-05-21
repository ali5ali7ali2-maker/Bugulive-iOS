//
//  BogoNewsLikesCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/7.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoNewsLikesCell.h"

@implementation BogoNewsLikesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.rightImgBtn.layer.cornerRadius = 4;
    self.rightImgBtn.layer.masksToBounds = YES;
    
    self.headImgView.layer.cornerRadius = 70 / 2;
    self.headImgView.layer.masksToBounds = YES;
    
}

- (void)resetContentWithModel:(BogoNewsHeadTypeModel *)model type:(NSInteger)type{
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    self.nickNameL.text = [NSString stringWithFormat:@"%@", model.nick_name];
    
    if (type == 0) {
        self.contentL.text = [NSString stringWithFormat:@"%@", model.content];
    }else{
        self.contentL.text = [NSString stringWithFormat:ASLocalizedString(@"评论了你:%@"), model.content];
    }
    
    self.timeL.text = [NSString stringWithFormat:@"%@", model.addtime];
    
    [self.rightImgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.img] forState:UIControlStateNormal];
    
    if (StrValid(model.cover_url)) {
        [self.rightImgBtn setImage:[UIImage imageNamed:@"bogo_news_likes_VideoPlay"] forState:UIControlStateNormal];
        self.contentImgView.hidden = YES;
//        self.rightImgBtn.hidden = NO;
        
    }else{
        [self.rightImgBtn setImage:[UIImage imageNamed:@"bogo_news_likes_normalImg"] forState:UIControlStateNormal];
        self.contentImgView.text = model.msg_content;
        self.contentImgView.hidden = NO;
//        self.rightImgBtn.hidden = YES;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
