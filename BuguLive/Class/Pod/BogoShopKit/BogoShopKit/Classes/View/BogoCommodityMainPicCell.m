//
//  BogoCommodityMainPicCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/14.
//

#import "BogoCommodityMainPicCell.h"
#import "BogoCommodityDetailModel.h"
#import "UIButton+WebCache.h"
#import "BogoShopKit.h"
#import "FDUIKitObjC.h"

@interface BogoCommodityMainPicCell ()

@property (weak, nonatomic) IBOutlet UIButton *firstImageView;
@property (weak, nonatomic) IBOutlet UIButton *secondImageView;
@property (weak, nonatomic) IBOutlet UIButton *thirdImageView;
@property (weak, nonatomic) IBOutlet UIButton *fourthImageView;
@property (weak, nonatomic) IBOutlet UIButton *fifthImageView;

@end

@implementation BogoCommodityMainPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    if (model.images.length < 5) {
        return;
    }
    NSArray<NSString *> *imageUrlArray = [model.images componentsSeparatedByString:@","];
    if (imageUrlArray.count) {
        if (imageUrlArray.firstObject.length) {
            [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlArray.firstObject] forState:UIControlStateNormal];
        }
        if (!_isSee && imageUrlArray.firstObject.length) {
            
            [self addDeleteBtnToView:self.firstImageView];
        }
        if (imageUrlArray.count > 1) {
            if (imageUrlArray[1].length) {
                [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlArray[1]] forState:UIControlStateNormal];
            }
            if (!_isSee && imageUrlArray[1].length) {
                
                [self addDeleteBtnToView:self.secondImageView];
            }
            
            if (imageUrlArray.count > 2) {
                
                if (imageUrlArray[2].length) {
                    [self.thirdImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlArray[2]] forState:UIControlStateNormal];
                }
                if (!_isSee && imageUrlArray[2].length) {
                    
                    [self addDeleteBtnToView:self.thirdImageView];
                }
                if (imageUrlArray.count > 3) {
                    
                    if (imageUrlArray[3].length) {
                        [self.fourthImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlArray[3]] forState:UIControlStateNormal];
                    }
                    if (!_isSee && imageUrlArray[3].length) {

                        
                        [self addDeleteBtnToView:self.fourthImageView];
                    }
                    if (imageUrlArray.count > 4) {
                        if (imageUrlArray[4].length) {
                            [self.fifthImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlArray[4]] forState:UIControlStateNormal];
                        }
                        if (!_isSee && imageUrlArray[4].length) {
                            
                            [self addDeleteBtnToView:self.fifthImageView];
                        }
                    }
                }
            }
        }
    }
}

- (IBAction)picBtnAction:(id)sender {
    if (_isSee) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(picCell:didClickPicBtn:)]) {
        [self.delegate picCell:self didClickPicBtn:sender];
    }
}

- (void)addDeleteBtnToView:(UIButton *)superView{
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    deleteBtn.fd_centerX = superView.width -10;
    deleteBtn.fd_centerY = 10;
    [deleteBtn setImage:[UIImage imageNamed:@"删除-1" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:deleteBtn];
}

- (void)deleteBtnAction:(UIButton *)sender{
    if (_isSee) {
        return;
    }
    UIButton *superView = (UIButton *)sender.superview;
    [sender removeFromSuperview];
    [superView setImage:[UIImage imageNamed:@"添加主图" inBundle:kShopKitBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(picCell:didClickPicDeleteBtn:)]) {
        [self.delegate picCell:self didClickPicDeleteBtn:superView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
