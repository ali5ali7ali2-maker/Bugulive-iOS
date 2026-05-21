//
//  BogoCommodityModelEditHeaderView.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/16.
//

#import "BogoCommodityModelEditHeaderView.h"
#import "FDUIKitObjC.h"

@interface BogoCommodityModelEditHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation BogoCommodityModelEditHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundView = ({
    UIView * view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = FD_WhiteColor;
    view;
    });
}

- (void)setIsSee:(BOOL)isSee{
    _isSee = isSee;
    self.deleteBtn.hidden = _isSee;
}

- (IBAction)deleteBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didClickDeleteBtn:)]) {
        [self.delegate headerView:self didClickDeleteBtn:sender];
    }
}

@end
