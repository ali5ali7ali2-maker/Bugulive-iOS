//
//  BogoShopDetailHeaderView.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/7.
//

#import "BogoShopDetailHeaderView.h"
#import "FDUIKitObjC.h"

@interface BogoShopDetailHeaderView ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BogoShopDetailHeaderView


- (void)setNumber:(NSString *)number{
    [self.titleLabel setText:[NSString stringWithFormat:@"店铺在售%@件宝贝",number]];
}

@end
