//
//  BogoCommodityDetailCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/16.
//

#import "BogoCommodityDetailCell.h"
#import <YYKit/YYKit.h>
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "BogoCommodityDetailModel.h"
#import "UIButton+WebCache.h"
 
static CGFloat const kViewHeight = 140 + 140 + 20;

static NSInteger const kImgNum = 30;

@interface BogoCommodityDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic, assign) CGFloat offsetY;



@property(nonatomic, strong) UIButton *lastAddBtn;

@end

@implementation BogoCommodityDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIButton *button = [self newButtonWithFrame:CGRectMake(10, 60 + 100 + 10, FD_ScreenWidth - 20, 140) isNeedDelete:NO];
    button.tag = 100;
    [self.contentView addSubview:button];
    [self.buttonArray addObject:button];
    _offsetY = 200;
    self.textView.text = @"";
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    
    NSInteger imgNum = kImgNum;
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData: [model.detail dataUsingEncoding:NSUnicodeStringEncoding] options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error: nil];
//    NSString *contentStr = model.detail;
    
    _model = model;
    for (UIView *subView in self.buttonArray) {
        [subView removeFromSuperview];
    }
    
    _offsetY = 50;
    [self.buttonArray removeAllObjects];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 50 + 10, FD_ScreenWidth - 10 * 2, 100)];
    self.textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.textView.attributedText = attributedString;
    self.textView.delegate = self;
    [self.contentView addSubview:self.textView];
    [self.buttonArray addObject:self.textView];
    _offsetY = self.textView.bottom + 10;
    
    CGFloat viewHeight = kViewHeight;
    
    if (model.info_images.length < 15) {
        if (self.buttonArray.count != imgNum) {
            UIButton *newButton = [self newButtonWithFrame:CGRectMake(10, self.textView.bottom + 10, FD_ScreenWidth - 20, viewHeight) isNeedDelete:NO];
            newButton.tag = kBogoCommodityDetailCellBaseTag + self.buttonArray.count;
            [self.contentView addSubview:newButton];
            [self.buttonArray addObject:newButton];
            _offsetY = _offsetY + viewHeight;
        }
        return;
    }
    
    _model = model;
    NSArray *imageUrlArray = [model.info_images componentsSeparatedByString:@","];
    self.imgWHRadioArr = [NSMutableArray array];
//    NSMutableArray *imgWHRadioArr = [NSMutableArray array];
    NSMutableArray *imgArr = [NSMutableArray array];//有效的图片
    
    for (NSInteger i = 0; i < imageUrlArray.count; i++) {
        NSString *url = imageUrlArray[i];
        NSLog(@"详情图url:%@",url);
        if (url.length && ![url containsString:@","]) {
            [imgArr addObject:url];
        }
    }
    
    for (NSInteger i = 0; i < imageUrlArray.count; i++) {
        NSString *url = imageUrlArray[i];
//        NSLog(@"详情图url:%@",url);
        if (url.length && ![url containsString:@","]) {
//            [imgArr addObject:url];
            
            UIButton *button = [self newButtonWithFrame:CGRectMake(10, _offsetY + 10, FD_ScreenWidth - 20, viewHeight) isNeedDelete:!_isSee];
            button.tag = kBogoCommodityDetailCellBaseTag + self.buttonArray.count;
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            button.imageView.clipsToBounds = YES;
            
            if (model.viewHeightArr.count > 0 && model.viewHeightArr.count > i - 1) {
                button.top = _offsetY + 10;
                button.height = [[model.viewHeightArr objectAtIndex:i - 1] floatValue];
            }
            
            [button sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                CGSize size = image.size;
                CGFloat radio = size.height / size.width *(FD_ScreenWidth - 20);
                
                button.height = radio;
                
                NSString *radioStr = [NSString stringWithFormat:@"%lf",radio];
                [self.imgWHRadioArr addObject:radioStr];
                if (self.imgWHRadioArr.count == imgArr.count) {
           
                    if (model.viewHeightArr.count != imgArr.count) {
                        [self resetAllButtonHeight];
                    }
                }
            }];
//            [button sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            [self.contentView addSubview:button];
            [self.buttonArray addObject:button];
            _offsetY = _offsetY + 10 + button.height;
        }
    }
    
    
    
    
    if (!_isSee) {
        if (self.buttonArray.count != imgNum) {
            UIButton *newButton = [self newButtonWithFrame:CGRectMake(10, _offsetY - 20, FD_ScreenWidth - 20, viewHeight) isNeedDelete:NO];
            newButton.tag = kBogoCommodityDetailCellBaseTag + self.buttonArray.count;
            [self.contentView addSubview:newButton];
            [self.buttonArray addObject:newButton];
            _offsetY = _offsetY + 10 + viewHeight;
        }
    }
}

-(void)resetAllButtonHeight{
    
    self.model.viewHeightArr = [NSMutableArray array];
    
    CGFloat viewTop = self.textView.bottom + 10;
    
    for (int i = 0; i < self.imgWHRadioArr.count; i ++) {
        CGFloat viewHeight = [[self.imgWHRadioArr objectAtIndex:i] floatValue];
        UIButton *button = [self.contentView viewWithTag:kBogoCommodityDetailCellBaseTag + i + 1];
        button.top = viewTop;
        button.height = viewHeight;
        viewTop = button.top + viewHeight;
    }
    self.model.viewHeightArr = self.imgWHRadioArr;
    
//    if (!_isSee) {
//        if (self.buttonArray.count != 10) {
//            UIButton *newButton = [self newButtonWithFrame:CGRectMake(10, _offsetY, FD_ScreenWidth - 20, kViewHeight) isNeedDelete:NO];
//            newButton.tag = kBogoCommodityDetailCellBaseTag + self.buttonArray.count;
//            [self.contentView addSubview:newButton];
//            [self.buttonArray addObject:newButton];
////            _offsetY = _offsetY + 10 + viewHeight;
//        }
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell:resetContentViewHeight:)]) {
        [self.delegate detailCell:self resetContentViewHeight:viewTop];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell:contentStr:)]) {
        [self.delegate detailCell:self contentStr:textView];
    }
}

- (void)addButton{
    if (self.buttonArray.count == kImgNum) {
        [[FDHUDManager defaultManager] show:[NSString stringWithFormat:@"最多只能添加%ld张图片",kImgNum] ToView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    UIButton *button = [self newButtonWithFrame:CGRectMake(10, _offsetY + 10, FD_ScreenWidth - 20, kViewHeight) isNeedDelete:YES];
    _offsetY = _offsetY + 10 + kViewHeight;
    button.tag = kBogoCommodityDetailCellBaseTag + self.buttonArray.count;
    [self.contentView addSubview:button];
    [self.buttonArray addObject:button];
}

- (void)buttonAction:(UIButton *)sender{
    if (_isSee) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell:didClickAddBtn:)]) {
        [self.delegate detailCell:self didClickAddBtn:sender];
    }
}

- (void)delBtnAction:(UIButton *)sender{
    if (_isSee) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell:didClickDelBtn:)]) {
        [self.delegate detailCell:self didClickDelBtn:sender];
    }
    UIButton *superView = (UIButton *)sender.superview;
    [self.buttonArray removeObject:superView];
    [superView removeFromSuperview];
}

- (UIButton *)newButtonWithFrame:(CGRect)frame isNeedDelete:(BOOL)isNeedDelete{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"添加宝贝详情" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5f"]];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    if (isNeedDelete) {
        UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(button.width - 35, 0, 34, 34)];
        [delBtn addTarget:self action:@selector(delBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [delBtn setImage:[UIImage imageNamed:@"删除" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [button addSubview:delBtn];
    }
    return button;
}

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc]init];
    }
    return _buttonArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
