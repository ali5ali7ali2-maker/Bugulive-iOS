//
//  BogoLimitedTimeSpikeTopCell.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/8.
//

#import "BogoLimitedTimeSpikeTopCell.h"
#import <YYKit/YYKit.h>

@interface BogoLimitedTimeSpikeTopCell ()

@end

@implementation BogoLimitedTimeSpikeTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.openLabel.backgroundColor = [UIColor colorWithHexString:selected ? @"#F42416" : @"ffffff"];
    self.openLabel.textColor = [UIColor colorWithHexString:selected ? @"ffffff" : @"#777777"];
}

- (void)setModel:(BogoLimitedTimeSpikeModel *)model{

    _model = model;
    
    CGFloat time1 = [model.time doubleValue];
    NSDate *date1=[NSDate dateWithTimeIntervalSince1970:time1];
    
    NSTimeInterval time2 =[date1 timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:model.currentTime.doubleValue]];
    int min=((int)time2)/60;
    
    NSLog(@"minmin%d",min);
    
    if (min < 0) {
        self.openLabel.text = @"抢购中";
        if (min < -60) {
            self.openLabel.text = @"已开抢";
        }
    }else{
        self.openLabel.text = @"即将开始";
    }
    
    if (min < 0) {
        
        if (self.returnTimeBlock) {
            self.returnTimeBlock(model);
        }
    }
    
}




@end
