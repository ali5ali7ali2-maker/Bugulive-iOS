//
//  BogoWithDrawBindAlipayPopView.h
//  UniversalApp
//
//  Created by Mac on 2021/6/12.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "FDPopView.h"
@class BogoWithDrawBindAlipayPopView;
#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BogoWithDrawBindAlipayPopViewDelegate <NSObject>

- (void)bindPopView:(BogoWithDrawBindAlipayPopView *)bindPopView didClickSubmitBtn:(UIButton *)sender;

@end

@interface BogoWithDrawBindAlipayPopView : FDPopView

@property(nonatomic, weak) id<BogoWithDrawBindAlipayPopViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet QMUITextField *nameTextField;
@property (weak, nonatomic) IBOutlet QMUITextField *accountTextField;

@end

NS_ASSUME_NONNULL_END
