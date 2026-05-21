//
//  FDTableView.m
//  FDUIKitObjC
//
//  Created by 范东 on 2020/3/9.
//

#import "FDTableView.h"

@implementation FDTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

@end
