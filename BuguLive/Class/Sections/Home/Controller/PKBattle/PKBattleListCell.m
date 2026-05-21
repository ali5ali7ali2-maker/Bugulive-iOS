//
//  PKBattleListCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/31.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "PKBattleListCell.h"

@implementation PKBattleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.leftImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.leftImgView.clipsToBounds = YES;
    self.rightImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.leftImgView.clipsToBounds = YES;
    
    self.pkLineView.layer.cornerRadius = self.pkLineHeightConstraint.constant / 2;
    self.pkLineView.layer.masksToBounds = YES;
    
    self.leftImgView.layer.cornerRadius = 4;
    self.leftImgView.layer.masksToBounds = YES;
    
    self.rightImgView.layer.cornerRadius = 4;
    self.rightImgView.layer.masksToBounds = YES;
    
    self.leftAddressBtn.spacingBetweenImageAndTitle = 3;
    self.leftAddressBtn.imagePosition = QMUIButtonImagePositionLeft;
    self.rightAddressBtn.spacingBetweenImageAndTitle = 3;
    self.rightAddressBtn.imagePosition = QMUIButtonImagePositionLeft;
    
    self.leftImgView.userInteractionEnabled = YES;
    self.rightImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapLeft = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLeftTap:)];
    [self.leftImgView addGestureRecognizer:tapLeft];
    
    UITapGestureRecognizer *tapRight = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickRightTap:)];
    [self.rightImgView addGestureRecognizer:tapRight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)clickLeftTap:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBattleModel:LeftOrRight:)]) {
        [self.delegate clickBattleModel:self.model LeftOrRight:YES];
    }
}

-(void)clickRightTap:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBattleModel:LeftOrRight:)]) {
        [self.delegate clickBattleModel:self.model LeftOrRight:NO];
    }
}

- (void)setModel:(PKBattleListModel *)model{
    _model = model;
    
    self.leftNameL.text = model.name1;
    
    if (StrValid(model.city1)) {
        [self.leftAddressBtn setImage:[UIImage imageNamed:@"bogo_pk_battle_address"] forState:UIControlStateNormal];
        [self.leftAddressBtn setTitle:model.city1 forState:UIControlStateNormal];
    }
    
    if (StrValid(model.city1)) {
        [self.rightAddressBtn setImage:[UIImage imageNamed:@"bogo_pk_battle_address"] forState:UIControlStateNormal];
        [self.rightAddressBtn setTitle:model.city2 forState:UIControlStateNormal];
    }
    
    if (StrValid(model.live_image1)) {
        [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:model.live_image1] completed:nil];
    }else{
        [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image1] completed:nil];
    }
    
    if (StrValid(model.live_image2)) {
        [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:model.live_image2] completed:nil];
    }else{
        [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image2] completed:nil];
    }
    
    self.rightNameL.text = model.name2;
    
    if (model.pk_ticket1.intValue == model.pk_ticket2.intValue) {
        self.leftWidthConstraint.constant = (kScreenW - 12 * 2) / 2;
        self.rightWidthConstraint.constant = (kScreenW - 12 * 2) / 2;
//        self.leftPKWidth.constant = 0.5;
//        self.rightPKWidth.constant = 0.5;
//        [self.leftPKView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(kScreenW * 0.5);
//        }];
//        [self.leftPKView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(kScreenW * 0.5);
//        }];
    }else{
//        self.leftPKWidth.multiplier = 0.7;
//        model.pk_ticket1.floatValue / (model.pk_ticket1.floatValue + model.pk_ticket2.floatValue) ;
//        self.rightPKWidth.constant = 0.3;
////        model.pk_ticket2.floatValue / (model.pk_ticket1.floatValue + model.pk_ticket2.floatValue) ;
//
//        [self.leftPKView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(kScreenW * 0.2);
//        }];
//        [self.leftPKView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(kScreenW * 0.7);
//        }];
        
        
        CGFloat leftWidthScale = model.pk_ticket1.floatValue / (model.pk_ticket1.floatValue + model.pk_ticket2.floatValue);
        CGFloat rightWidthScale = model.pk_ticket2.floatValue / (model.pk_ticket1.floatValue + model.pk_ticket2.floatValue);
        self.leftWidthConstraint.constant = (kScreenW - 12 * 2) * leftWidthScale;
        self.rightWidthConstraint.constant = (kScreenW - 12 * 2) * rightWidthScale;
        
    }
    
    
    

    self.leftTicketL.text = [NSString stringWithFormat:@"%@",model.pk_ticket1];
    self.rightTicketL.text = [NSString stringWithFormat:@"%@",model.pk_ticket2];
    
//    [self.rightPKView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.leftPKView.mas_right).offset(-20);
//        make.width.mas_equalTo(kScreenW * 0.2);
//    }];
    
//    [self.leftPKView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kScreenW * 0.2);
//    }];
//
//    [self.rightPKView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kScreenW * 0.7);
//    }];
    
    [self setLeftPKView:self.leftPKView];
    [self setRightPKView:self.rightPKView];
}

- (void)setLeftPKView:(UIView *)leftPKView{
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#0A86EB"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#3BA7EF"].CGColor];
//    gradientLayer.locations = @[@0.3, @0.5, @1.0];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(1.0, 0);
//    gradientLayer.frame = leftPKView.bounds;
//    [leftPKView.layer addSublayer:gradientLayer];
}

- (void)setRightPKView:(UIView *)rightPKView{
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF72AF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#F61275"].CGColor];
//    gradientLayer.locations = @[@0.3, @0.5, @1.0];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(1.0, 0);
//    gradientLayer.frame = rightPKView.bounds;
//    [rightPKView.layer addSublayer:gradientLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
