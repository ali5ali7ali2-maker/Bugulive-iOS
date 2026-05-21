//
//  BogoShopFillInfoExtCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import "BogoShopFillInfoExtCell.h"
#import <YYKit/YYKit.h>
#import "FDUIKitObjC.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <Masonry/Masonry.h>
#import "BogoShopKit.h"
#import "BogoShopInfoModel.h"
#import "UIButton+WebCache.h"
#import "BogoRefundDetailModel.h"

@interface BogoShopFillInfoExtCell ()

@property(nonatomic, strong) UIScrollView *scrollView;

@end

@implementation BogoShopFillInfoExtCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(60);
        make.height.mas_equalTo(@(88));
    }];
    UIButton *btn = [self newButtonWithFrame:CGRectMake(10, 0, 88, 88) isNeedDelete:NO];
    [self.scrollView addSubview:btn];
    
    [self.btnListArr addObject:btn];
    
    self.scrollView.contentSize = CGSizeMake(108, 0);
}

- (void)setIsSee:(BOOL)isSee{
    _isSee = isSee;
}

- (void)setModel:(BogoShopInfoModel *)model{
    _model = model;
    NSArray *urlArray = [model.banner componentsSeparatedByString:@","];
    for (NSString *url in urlArray) {
        if (url.length && ![url containsString:@","]) {
            [self addButton];
        }
    }
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            if (button.tag - kBogoShopFillInfoExtCellBaseTag < urlArray.count) {
                NSString *url = urlArray[button.tag - kBogoShopFillInfoExtCellBaseTag];
                [button sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
                if (!_isSee) {
                    [self addDeleteBtnToSuperView:button];
                }
                button.userInteractionEnabled = !_isSee;
            }
        }
    }
}

- (void)setRefundModel:(BogoRefundDetailModel *)refundModel{
    _refundModel = refundModel;
    for (UIButton *button in self.btnListArr) {
        [button removeFromSuperview];
    }
    [self.btnListArr removeAllObjects];
    
    UIButton *btn = [self newButtonWithFrame:CGRectMake(10, 0, 88, 88) isNeedDelete:NO];
    [self.scrollView addSubview:btn];
    
    [self.btnListArr addObject:btn];
    
    self.scrollView.contentSize = CGSizeMake(108, 0);
    
    NSArray *urlArray = [refundModel.refund_img componentsSeparatedByString:@","];
    NSMutableArray <NSString *>*tempArray = [NSMutableArray arrayWithArray:urlArray];
    while ([tempArray.lastObject isEqualToString:@","]) {
        [tempArray removeLastObject];
    }while ([tempArray.lastObject isEqualToString:@""]) {
        [tempArray removeLastObject];
    }
    for (NSInteger i = 0; i < tempArray.count - 1; i++) {
        NSString *url = tempArray[i];
        [self addButton];
    }
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            if (button.tag - kBogoShopFillInfoExtCellBaseTag < tempArray.count) {
                NSString *url = tempArray[button.tag - kBogoShopFillInfoExtCellBaseTag];
                [button sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
                if (!_isSee) {
                    [self addDeleteBtnToSuperView:button];
                }
//                button.userInteractionEnabled = !_isSee;
            }
        }
    }
}

- (void)addButton{
    
    CGFloat viewWidth = 88;
    
    NSLog(@"contentSize123  %f",self.scrollView.contentSize.width);
    if (!self.isSee) {
        if (self.scrollView.contentSize.width > 2 * (viewWidth + 20 + 5)) {
            
            self.isMax = YES;
            
            return;
        }
    }
    NSLog(@"%f",self.scrollView.contentSize.width);
    UIButton *btn = [self newButtonWithFrame:CGRectMake(self.scrollView.contentSize.width + 10, 0, viewWidth, viewWidth) isNeedDelete:YES];
    [self.scrollView addSubview:btn];
    
    [self.btnListArr addObject:btn];
    
    self.scrollView.contentSize = CGSizeMake( self.scrollView.contentSize.width + 98 +  10, 0);
    
    NSLog(@"contentSize123456  %f",self.scrollView.contentSize.width);
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scrollView.backgroundColor = FD_WhiteColor;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (void)buttonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(extCell:didClickImageBtn:)]) {
        [self.delegate extCell:self didClickImageBtn:sender];
    }
}

- (UIButton *)newButtonWithFrame:(CGRect)frame isNeedDelete:(BOOL)isNeedDelete{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:@"bogo_shop_refund_normal" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    button.imageView.clipsToBounds = YES;
    button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
//    [button setImage:[UIImage imageNamed:@"bogo_shop_refund_normal" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
//    [button setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5f"]];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = self.btnListArr.count + kBogoShopFillInfoExtCellBaseTag;
    
//    if (isNeedDelete) {
//        [self addDeleteBtnToSuperView:button];
//    }
    
    return button;
}

- (void)addDeleteBtnToSuperView:(UIButton *)sender{
    UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(sender.width - 20 + 2, -2, 20, 20)];
    [delBtn addTarget:self action:@selector(delBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [delBtn setImage:[UIImage imageNamed:@"bogo_shop_delBtn" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
//    delBtn.backgroundColor = [UIColor redColor];
    delBtn.enabled = !_isSee;
    [sender addSubview:delBtn];
}

- (void)delBtnAction:(UIButton *)sender{
    UIButton *superView = (UIButton *)sender.superview;
    [sender removeFromSuperview];
    [superView setImage:[UIImage imageNamed:@"bogo_shop_refund_normal" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    
    
    
//    for (UIView *subView in self.btnListArr) {
//        if (subView.left > superView.right) {
//            subView.left = subView.left - 98 -10;
//        }
//    }
    
    
    
    [self.btnListArr removeObject:superView];
    [superView removeFromSuperview];
    
    
    
//    if (self.btnListArr.count == 2) {
//        [self addButton];
//    }
    
    for (int i = 0; i < self.btnListArr.count; i++) {
        UIView *subView = self.btnListArr[i];
        subView.left = 10 + ((98 + 10) *i) ;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width - 98 - 10, 0);
    
    NSLog(@"contentSizeDel123 %f",self.scrollView.contentSize.width);
    
    if (self.isMax) {
        [self addButton];
    }
    
    self.isMax = NO;
    
    
    if (self.btnListArr.count == 1) {
        self.scrollView.contentSize = CGSizeMake(108, 0);
    }
    
    
    
    
//    [self addButton];
    if (self.delegate && [self.delegate respondsToSelector:@selector(extCell:didClickImageDelBtn:)]) {
        [self.delegate extCell:self didClickImageDelBtn:superView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSMutableArray *)btnListArr{
    if (!_btnListArr) {
        _btnListArr = [NSMutableArray array];
    }
    return _btnListArr;
}

@end
