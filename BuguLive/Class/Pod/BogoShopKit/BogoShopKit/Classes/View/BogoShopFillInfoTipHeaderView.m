//
//  BogoShopFillInfoTipHeaderView.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/13.
//

#import "BogoShopFillInfoTipHeaderView.h"
#import "FDUIKitObjC.h"

@interface BogoShopFillInfoTipHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BogoShopFillInfoTipHeaderView

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundView = ({
    UIView * view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = FD_WhiteColor;
    view;
    });
}

@end
