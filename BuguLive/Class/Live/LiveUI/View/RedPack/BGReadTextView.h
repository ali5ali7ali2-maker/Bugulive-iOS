//
//  BGReadTextView.h
//  BuguLive
//
//  Created by 志刚杨 on 2021/12/25.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGReadTextView : UIView
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@property (weak, nonatomic) IBOutlet UILabel *labDes;
@property (weak, nonatomic) IBOutlet UILabel *labName;
+( BGReadTextView *)instanceView;
@end

NS_ASSUME_NONNULL_END
