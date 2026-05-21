//
//  JXCategorySubTitleCell.m
//  ObjcExample
//
//  Created by gaokun on 2021/1/21.
//

#import "CustomCategoryCell.h"
#import "JXCategorySubTitleCellModel.h"

@implementation CustomCategoryCell

- (void)initializeViews {
    [super initializeViews];

    // 初始化背景视图和颜色
    _backgroundView1 = [[UIView alloc] init];
    [self.contentView insertSubview:_backgroundView1 atIndex:0];
    _selectedBackgroundColor = [UIColor colorWithHexString:@"#AE2CF1"];
    _unselectedBackgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    _subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.clipsToBounds = YES;
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.subTitleLabel];
    _backgroundView1.backgroundColor = _unselectedBackgroundColor;
    [_backgroundView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel).offset(-8);
        make.right.equalTo(self.titleLabel).offset(8);
        make.top.equalTo(self.titleLabel).offset(-8);
        make.bottom.equalTo(self.titleLabel).offset(8);

    }];
    
    ViewRadius(_backgroundView1, (18+16)/2);
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundView.frame = self.contentView.bounds;

    JXCategorySubTitleCellModel *myCellModel = (JXCategorySubTitleCellModel *)self.cellModel;
    CGFloat positionMargin = myCellModel.subTitleWithTitlePositionMargin;
    [NSLayoutConstraint deactivateConstraints:self.subTitleLabel.constraints];
    switch (myCellModel.positionStyle) {
        case JXCategorySubTitlePositionStyle_Top: {
            [self.subTitleLabel.bottomAnchor constraintEqualToAnchor:self.titleLabel.topAnchor constant:positionMargin].active = YES;
            [self subTitleLeftRightConstraint:myCellModel];
            break;
        }
        case JXCategorySubTitlePositionStyle_Left: {
            self.titleLabelCenterX.active = NO;
            [self.titleLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:0].active = YES;
            [self.subTitleLabel.rightAnchor constraintEqualToAnchor:self.titleLabel.leftAnchor constant:positionMargin].active = YES;
            [self subTitleTopBottomConstraint:myCellModel];
            break;
        }
        case JXCategorySubTitlePositionStyle_Bottom: {
            [self.subTitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:positionMargin].active = YES;
            [self subTitleLeftRightConstraint:myCellModel];
            break;
        }
        case JXCategorySubTitlePositionStyle_Right: {
            self.titleLabelCenterX.active = NO;
            [self.titleLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:0].active = YES;
            
            [self.subTitleLabel.leftAnchor constraintEqualToAnchor:self.titleLabel.rightAnchor constant:positionMargin].active = YES;
            [self subTitleTopBottomConstraint:myCellModel];
            break;
        }
    }
    [self.subTitleLabel.widthAnchor constraintEqualToConstant:ceilf(myCellModel.subTitleSize.width)].active = YES;
    [self.subTitleLabel.heightAnchor constraintEqualToConstant:ceilf(myCellModel.subTitleSize.height)].active = YES;
}

- (void)reloadData:(JXCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    JXCategorySubTitleCellModel *myCellModel = (JXCategorySubTitleCellModel *)cellModel;
    if (myCellModel.isSelected) {
        self.subTitleLabel.font = myCellModel.subTitleSelectedFont;
    }else {
        self.subTitleLabel.font = myCellModel.subTitleFont;
    }
    
    
    if (myCellModel.isSelected) {
        self.backgroundView1.backgroundColor = self.selectedBackgroundColor;
    } else {
        self.backgroundView1.backgroundColor = self.unselectedBackgroundColor;
    }
    

    NSString *titleString = myCellModel.subTitle ? myCellModel.subTitle : @"";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleString];
    self.subTitleLabel.attributedText = attributedString;
    self.subTitleLabel.textColor = myCellModel.subTitleCurrentColor;
}



- (void)subTitleLeftRightConstraint:(JXCategorySubTitleCellModel *)cellModel {
    CGFloat alignMargin = cellModel.subTitleWithTitleAlignMargin;
    switch (cellModel.alignStyle) {
        case JXCategorySubTitleAlignStyle_Left: {
            [self.subTitleLabel.leftAnchor constraintEqualToAnchor:self.titleLabel.leftAnchor constant:alignMargin].active = YES;
            break;
        }
        case JXCategorySubTitleAlignStyle_Right: {
            [self.subTitleLabel.rightAnchor constraintEqualToAnchor:self.titleLabel.rightAnchor constant:alignMargin].active = YES;
            break;
        }
        default:
            self.subTitleLabelCenterX = [self.subTitleLabel.centerXAnchor constraintEqualToAnchor:self.titleLabel.centerXAnchor constant:alignMargin];
            self.subTitleLabelCenterX.active = YES;
            break;
    }
}

- (void)subTitleTopBottomConstraint:(JXCategorySubTitleCellModel *)cellModel {
    CGFloat alignMargin = cellModel.subTitleWithTitleAlignMargin;
    switch (cellModel.alignStyle) {
        case JXCategorySubTitleAlignStyle_Top: {
            [self.subTitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.topAnchor constant:alignMargin].active = YES;
            break;
        }
        case JXCategorySubTitleAlignStyle_Bottom: {
            [self.subTitleLabel.bottomAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:alignMargin].active = YES;
            break;
        }
        default:
            [self.subTitleLabel.centerYAnchor constraintEqualToAnchor:self.titleLabel.centerYAnchor constant:alignMargin].active = YES;
            break;
    }
}

@end
