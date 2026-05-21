//
//  Classification_Alertview.h
//  iphoneLive
//
//  Created by bugu on 2018/12/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClassificationDelegate2 <NSObject>
- (void)didSelectWithAlert:(id)obj;
@end
@interface Classification_Alertview : UIView
@property (nonatomic,strong)UIScrollView *scrollview;
@property (nonatomic,weak)id<ClassificationDelegate2>delegate;
- (void)setClassWithAry:(NSArray *)ary;
- (void)selectWithIndex:(NSInteger )index;
@end
