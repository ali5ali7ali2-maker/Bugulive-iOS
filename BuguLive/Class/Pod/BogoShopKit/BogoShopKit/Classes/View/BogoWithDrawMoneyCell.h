//
//  BogoWithDrawMoneyCell.h
//  UniversalApp
//
//  Created by Mac on 2021/6/12.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class BogoWithDrawResponseModel;
#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoWithDrawMoneyCell : UITableViewCell

//@property(nonatomic, strong) BogoWithDrawResponseModel *model;

@property (weak, nonatomic) IBOutlet QMUITextField *textField;

@end

NS_ASSUME_NONNULL_END
