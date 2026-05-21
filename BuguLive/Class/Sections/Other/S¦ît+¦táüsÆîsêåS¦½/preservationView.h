//
//  preservationView.h
//  UniversalApp
//
//  Created by xu on 2020/9/12.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "videoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface preservationView : UIView

@property(nonatomic, strong) videoListModel *model;
///
@property (nonatomic, strong) NSString *url;
///
@property (nonatomic, assign) BOOL is_Small;

///
@property (nonatomic, strong) UIImage *imageStr;
@end

NS_ASSUME_NONNULL_END
