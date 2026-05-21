//
//  BogoVirsualDetailListCell.m
//  BuguLive
//
//  Created by Mac on 2021/1/23.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoVirsualDetailListCell.h"
#import "BogoShopWithDrawListModel.h"

#import <YYKit/YYKit.h>
//#import "WBStatusHelper.h"

@interface BogoVirsualDetailListCell ()



@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UILabel *statuL;


@end

@implementation BogoVirsualDetailListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoShopWithDrawListModel *)model{
    _model = model;
    self.titleLabel.text = model.content;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.create_time];
    NSString *dateString = [formatter stringFromDate:date];
    self.timeLabel.text = dateString;
    
//    0审核中；1成功；2驳回】
    if ([model.status isEqualToString:@"0"] ) {
        
        self.statuL.textColor = [UIColor colorWithHexString:@"777777"];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"666666"];
        
        self.statuL.text = @"申请中";
        self.contentLabel.text = [NSString stringWithFormat:@"-%@",model.money];
        
    }else if ([model.status isEqualToString:@"1"]){
        self.statuL.textColor = [UIColor greenColor];
        
        self.statuL.text = @"审核成功";
        self.contentLabel.text = [NSString stringWithFormat:@"-%@",model.money];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }else if ([model.status isEqualToString:@"2"]){
        self.statuL.textColor = [UIColor redColor];
        self.statuL.text = @"审核失败";
        self.contentLabel.text = [NSString stringWithFormat:@"+%@",model.money];
        self.contentLabel.textColor = [UIColor redColor];
    }
    
//    NSString *prefix = @"";
//    NSString *colorHex = @"";
//    switch (self.type) {
//        case BogoVirsualDetailViewControllerTypeRecharge:
//        case BogoVirsualDetailViewControllerTypeProfit:
//            prefix = @"+";
//            colorHex = @"#F39300";
//            break;
//        case BogoVirsualDetailViewControllerTypeConsume:
//        case BogoVirsualDetailViewControllerTypeWithDraw:
//            prefix = @"-";
//            colorHex = @"#F42416";
//            break;
//        default:
//            break;
//    }
//    self.contentLabel.textColor = [UIColor colorWithHexString:colorHex];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
