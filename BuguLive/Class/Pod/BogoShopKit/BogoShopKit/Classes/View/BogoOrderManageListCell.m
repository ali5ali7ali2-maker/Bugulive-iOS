//
//  BogoOrderManageListCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/17.
//

#import "BogoOrderManageListCell.h"
#import "BogoOrderManageListModel.h"
#import "UIImageView+WebCache.h"
#import <YYKit/YYKit.h>
#import "FDFoundationObjC.h"

@interface BogoOrderManageListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *idLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *commodityImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *modelLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *countLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *timeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *rightBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *middleBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *leftBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation BogoOrderManageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
}

- (void)setModel:(BogoOrderManageListModel *)model{
    _model = model;
    self.leftBtn.hidden = YES;
    self.middleBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    [self.idLabel setText:[NSString stringWithFormat:@"ID:%@",model.so_id]];
    [self.commodityImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_icon]];
    [self.titleLabel setText:model.goods_title];
    [self.modelLabel setText:model.attr_name];
    [self.countLabel setText:[NSString stringWithFormat:@"x%@",model.number]];
    [self.timeLabel setText:[NSDate fd_getTimeFromTimestamp:model.add_time.doubleValue]];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.money.floatValue / 100]];
    // 0:下单未支付,
    // 1:已经支付(用户)--未发货(商家),
    // 2:未收货(用户)--已经发货(商家),
    // 3:已收货,
    // 4:取消订单,
    // 5:删除订单（用户）,
    // 6:删除订单（商家）,
    // 7:删除订单（用户和商家）,
    // 11:申请退款(用户)--未退款(商家),
    // 12:未确认退款(用户)--已退款(商家),
    // 13:确认已退款 （退款备用）,
    // 14:拒绝退款（商家）,
    // 15:未确认退款(用户)--已退款(平台),
    // 16:拒绝退款(平台),
    if (_listType == BogoOrderManageViewControllerTypeShop) {
        switch (model.status.integerValue) {
            case 0:
                [self.statusLabel setText:@"等待买家付款"];
                break;
            case 1:
                [self.statusLabel setText:@"等待发货"];
                self.rightBtn.hidden = NO;
//                self.middleBtn.hidden = NO;
                [self.rightBtn setTitle:@"发货" forState:UIControlStateNormal];
//                [self.middleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                break;
            case 2:
                [self.statusLabel setText:@"等待买家确认收货"];
                if (self.model.express_number.length) {
                    self.rightBtn.hidden = NO;
                    [self.rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                }
                break;
            case 3:
                [self.statusLabel setText:@"已完成"];
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                break;
            case 4:
                [self.statusLabel setText:@"已取消"];
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                break;
            case 5:
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        if (model.status.integerValue == 1 || model.status.integerValue == 2 || model.status.integerValue == 3 || model.status.integerValue == 11) {
            if (model.refund_status.integerValue == 11 || model.refund_status.integerValue == 17) {
                [self.statusLabel setText:@"退款待处理"];
                self.rightBtn.hidden = NO;
                self.middleBtn.hidden = NO;
                self.leftBtn.hidden = YES;
                [self.middleBtn setTitle:@"拒绝" forState:UIControlStateNormal];
                [self.rightBtn setTitle:@"同意退款" forState:UIControlStateNormal];
            }else if (model.refund_status.integerValue == 12) {
                [self.statusLabel setText:@"退款中"];
                self.middleBtn.hidden = YES;
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = YES;
            }else if (model.refund_status.integerValue == 13){
                self.rightBtn.hidden = NO;
                self.middleBtn.hidden = YES;
                self.leftBtn.hidden = YES;
                [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [self.statusLabel setText:@"退款已完成"];
            }else if (model.refund_status.integerValue == 14){
                [self recoverShopStatus];
            }else if (model.refund_status.integerValue == 18){
                [self recoverShopStatus];
            }
        }
    }else{
        switch (model.status.integerValue) {
            case 0:
                [self.statusLabel setText:@"等待付款"];
                self.rightBtn.hidden = NO;
                self.middleBtn.hidden = NO;
                [self.rightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
                [self.middleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                break;
            case 1:
                [self.statusLabel setText:@"等待卖家发货"];
                [self.rightBtn setTitle:@"退款" forState:UIControlStateNormal];
                self.rightBtn.hidden = NO;
                break;
            case 2:
                [self.statusLabel setText:@"卖家已发货"];
                if (self.model.express_number.length) {
                    self.rightBtn.hidden = NO;
                    self.middleBtn.hidden = NO;
                    self.leftBtn.hidden = NO;
                    [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    [self.middleBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [self.leftBtn setTitle:@"退款" forState:UIControlStateNormal];
                }else{
                    self.rightBtn.hidden = NO;
                    self.middleBtn.hidden = NO;
                    self.leftBtn.hidden = YES;
                    [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    [self.middleBtn setTitle:@"退款" forState:UIControlStateNormal];
                }
                break;
            case 3:
                [self.statusLabel setText:@"已完成"];
                self.rightBtn.hidden = NO;
                self.middleBtn.hidden = YES;
                self.leftBtn.hidden = YES;
                [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                break;
            case 4:
                [self.statusLabel setText:@"已取消"];
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                break;
            case 5:
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                break;
            case 11:
                break;
            case 12:
                [self.statusLabel setText:@"已退款"];
                break;
            case 13:
                [self.statusLabel setText:@"退款已完成"];
                break;
            case 14:
                [self.statusLabel setText:@"卖家拒绝退款"];
                if (self.model.express_number.length) {
                    self.rightBtn.hidden = NO;
                    self.middleBtn.hidden = NO;
                    self.leftBtn.hidden = NO;
                    [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    [self.middleBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [self.leftBtn setTitle:@"退款" forState:UIControlStateNormal];
                }else{
                    self.rightBtn.hidden = NO;
                    self.middleBtn.hidden = NO;
                    self.leftBtn.hidden = YES;
                    [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    [self.middleBtn setTitle:@"退款" forState:UIControlStateNormal];
                }
                break;
            default:
                break;
        }
        if (model.status.integerValue == 1 || model.status.integerValue == 2 || model.status.integerValue == 3 || model.status.integerValue == 11) {
            if (model.refund_status.integerValue == 11 || model.refund_status.integerValue == 17) {
                [self.statusLabel setText:@"退款申请中"];
                self.rightBtn.hidden = NO;
                self.middleBtn.hidden = YES;
                self.leftBtn.hidden = YES;
                [self.rightBtn setTitle:@"取消退款" forState:UIControlStateNormal];
            }else if (model.refund_status.integerValue == 12) {
                [self.statusLabel setText:@"退款中"];
                self.middleBtn.hidden = YES;
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:@"完成退款" forState:UIControlStateNormal];
            }else if (model.refund_status.integerValue == 13){
                self.rightBtn.hidden = NO;
                self.middleBtn.hidden = YES;
                self.leftBtn.hidden = YES;
                [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [self.statusLabel setText:@"退款已完成"];
            }else if (model.refund_status.integerValue == 14){
                [self recoverUserStatus];
            }else if (model.refund_status.integerValue == 18){
                [self recoverUserStatus];
            }
        }
    }
    self.rightBtn.layer.borderWidth = 1;
    self.middleBtn.layer.borderWidth = 1;
    self.leftBtn.layer.borderWidth = 1;
    if (self.rightBtn.hidden == NO) {
        self.rightBtn.layer.borderColor = [UIColor colorWithHexString:@"#F42416"].CGColor;
        [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"#F42416"] forState:UIControlStateNormal];
        if ([self.rightBtn.titleLabel.text isEqualToString:@"取消退款"] || [self.rightBtn.titleLabel.text isEqualToString:@"完成退款"] | [self.rightBtn.titleLabel.text isEqualToString:@"删除订单"] || [self.rightBtn.titleLabel.text isEqualToString:@"查看物流"]) {
            self.rightBtn.layer.borderColor = [UIColor colorWithHexString:@"#777777"].CGColor;
            [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
        }
    }
    if (self.middleBtn.hidden == NO) {
        self.middleBtn.layer.borderColor = [UIColor colorWithHexString:@"#777777"].CGColor;
        [self.middleBtn setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
    }
    if (self.leftBtn.hidden == NO) {
        self.leftBtn.layer.borderColor = [UIColor colorWithHexString:@"#777777"].CGColor;
        [self.middleBtn setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
    }
    
//    if (model.status.integerValue == 3) {
//        self.rightBtn.layer.borderColor = [UIColor colorWithHexString:@"#777777"].CGColor;
//    }
    
    
    
}

- (void)recoverUserStatus{
    switch (self.model.status.integerValue) {
        case 1:
            [self.statusLabel setText:@"等待卖家发货"];
            [self.rightBtn setTitle:@"退款" forState:UIControlStateNormal];
            self.rightBtn.hidden = NO;
            break;
        case 2:
            [self.statusLabel setText:@"卖家已发货"];
            if (self.model.express_number.length) {
                self.rightBtn.hidden = NO;
                self.middleBtn.hidden = NO;
                self.leftBtn.hidden = NO;
                [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                [self.middleBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [self.leftBtn setTitle:@"退款" forState:UIControlStateNormal];
            }else{
                self.rightBtn.hidden = NO;
                self.middleBtn.hidden = NO;
                self.leftBtn.hidden = YES;
                [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                [self.middleBtn setTitle:@"退款" forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }
}

- (void)recoverShopStatus{
    switch (self.model.status.integerValue) {
        case 1:
            [self.statusLabel setText:@"等待发货"];
            self.rightBtn.hidden = NO;
//                self.middleBtn.hidden = NO;
            [self.rightBtn setTitle:@"发货" forState:UIControlStateNormal];
//                [self.middleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            break;
        case 2:
            [self.statusLabel setText:@"等待买家确认收货"];
            if (self.model.express_number.length) {
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }
}

- (IBAction)btnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listCell:didClickBtn:)]) {
        [self.delegate listCell:self didClickBtn:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
