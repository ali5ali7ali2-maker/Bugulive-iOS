//
//  BogoClassicsHeaderView.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/25.
//

#import "BogoClassicsHeaderView.h"
#import "FDUIKitObjC.h"

@implementation BogoClassicsHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundView = ({
    UIView * view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = FD_WhiteColor;
    view;
    });
}

@end
