//
//  new_bgmcategoryCell.h
//  BuguLive
//
//  Created by bugu on 2019/5/25.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface new_bgmcategoryModel :NSObject
@property (nonatomic, copy)NSString *type_id/*分类id*/,
                                    *type_name/*分类名称*/,
                                    *icon/*分类图标*/;
@end
@interface new_bgmcategoryCell : UICollectionViewCell
@property (nonatomic, strong)new_bgmcategoryModel *model;
@end
