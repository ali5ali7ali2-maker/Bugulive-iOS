//
//  STTableShowVideoCell.m
//  BuguLive
//
//  Created by 岳克奎 on 17/4/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableShowVideoCell.h"

@interface STTableShowVideoCell ()<QMUITextViewDelegate>


@end

@implementation STTableShowVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.delegate = self;
    self.textView.maximumTextLength = 100;
    self.textView.placeholder = ASLocalizedString(@"请输入内容");
    for (UIView *subView in self.contentView.subviews) {
        [subView setLocalizedString];
    }
    
    self.promptLab.text = ASLocalizedString(@"请选择封面");
    
}

#pragma mark - QMUITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoCell:didChangeText:)]) {
        [self.delegate videoCell:self didChangeText:textView.text];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changeVideoClick:(UIButton *)sender {
    if (_delegate &&[_delegate respondsToSelector:@selector(showSystemIPC:andMaxSelectNum:)]) {
        [_delegate showSystemIPC:YES andMaxSelectNum:1];
    }
}

- (IBAction)changeVideoCoverClick:(UIButton *)sender {
    if(_delegate &&[_delegate respondsToSelector:@selector(showSTTableShowVideoCell:andChangeVideoCoverClick:)]){
        [_delegate showSTTableShowVideoCell:self
                   andChangeVideoCoverClick:sender];
    }
}

-(void)setDelegate:(id<STTableShowVideoCellDelegate>)delegate{
    _delegate = delegate;
}
@end
