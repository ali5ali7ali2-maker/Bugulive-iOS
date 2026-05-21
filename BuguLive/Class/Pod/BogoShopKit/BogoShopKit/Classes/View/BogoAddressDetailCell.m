//
//  BogoAddressDetailCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "BogoAddressDetailCell.h"
#import <QMUIKit/QMUIKit.h>

@interface BogoAddressDetailCell ()<QMUITextViewDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet QMUITextView *textView;

@end

@implementation BogoAddressDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.delegate = self;
}

- (void)textViewDidChange:(QMUITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell:didTextChange:)]) {
        [self.delegate detailCell:self didTextChange:textView];
    }
}

- (void)setDetailText:(NSString *)detailText{
    _detailText = detailText;
    [self.textView setText:detailText];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
