//
//  BogoCommodityManagementSearchBar.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/13.
//

#import "BogoCommodityManagementSearchBar.h"
#import <YYKit/YYKit.h>

#import "FDUIKitObjC.h"

@interface BogoCommodityManagementSearchBar ()

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation BogoCommodityManagementSearchBar

- (void)awakeFromNib{
    [super awakeFromNib];
//    self.backView.layer.borderColor = [UIColor colorWithHexString:@"c0c0c0"].CGColor;
//    self.backView.layer.borderWidth = 1;
    self.frame = CGRectMake(0, 0, FD_ScreenWidth, 70);
}

- (IBAction)searchBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:didClickSearchBtn:)]) {
        [self.delegate searchBar:self didClickSearchBtn:sender];
    }
}

@end
