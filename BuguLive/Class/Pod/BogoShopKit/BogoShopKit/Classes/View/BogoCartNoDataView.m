//
//  BogoCartNoDataView.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/23.
//

#import "BogoCartNoDataView.h"
#import <YYKit/YYKit.h>

@interface BogoCartNoDataView ()

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *goBtn;

@end

@implementation BogoCartNoDataView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.goBtn.layer.borderWidth = 1;
    self.goBtn.layer.borderColor = [UIColor colorWithHexString:@"#F46628"].CGColor;
}

- (IBAction)goBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(noDataView:didClickGoBtnAction:)]) {
        [self.delegate noDataView:self didClickGoBtnAction:sender];
    }
}

@end
