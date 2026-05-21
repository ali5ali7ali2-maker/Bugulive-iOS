//
//  BogoShopFillInfoHeaderView.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import "BogoShopFillInfoHeaderView.h"
#import "FDUIKitObjC.h"

@implementation BogoShopFillInfoHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundView = ({
    UIView * view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = FD_WhiteColor;
    view;
    });
}

@end
