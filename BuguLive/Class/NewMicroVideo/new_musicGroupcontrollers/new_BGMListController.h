//
//  new_BGMListController.h
//  BuguLive
//
//  Created by bugu on 2019/5/25.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "new_bgmListView.h"
#import "new_BGMcategory.h"
//#import "Music_manager.h"
#import "new_bgmNavController.h"
@interface new_BGMListController : UIViewController
@property (nonatomic, strong)new_bgmNavController *nav;

@property (nonatomic, copy) NSString *type_id;

@end
