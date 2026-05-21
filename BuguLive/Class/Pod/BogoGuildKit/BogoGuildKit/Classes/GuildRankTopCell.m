//
//  GuildRankTopCell.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/26.
//

#import "GuildRankTopCell.h"
#import "GuildDetailModel.h"
#import "UIImageView+WebCache.h"
#import "BogoGuildKit.h"
#import <YYKit/YYKit.h>

@interface GuildRankTopCell ()

@property (weak, nonatomic) IBOutlet UIImageView *firstIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstRankView;
@property (weak, nonatomic) IBOutlet UILabel *firstConteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondRankView;
@property (weak, nonatomic) IBOutlet UILabel *secondContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *secondScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thirdIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *thirdNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thirdRankView;
@property (weak, nonatomic) IBOutlet UILabel *thirdContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thirdSexImageView;

@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(nonatomic, assign) NSInteger timeCount;
@property(nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstSexViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondSexViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdSexViewConstraint;

@end

@implementation GuildRankTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.firstView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAction:)]];
    [self.secondView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAction:)]];
    [self.thirdView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAction:)]];
}

- (void)viewAction:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topCell:didClickViewAction:)]) {
        [self.delegate topCell:self didClickViewAction:sender];
    }
}

- (void)setType:(GuildRankSubViewControllerType)type{
    _type = type;
    if (type == GuildRankSubViewControllerTypeWeek) {
        self.timeImageView.hidden = NO;
        self.timeLabel.hidden = NO;
        NSDate *startDate = [NSDate date];
        NSInteger weekDay = startDate.weekday;
        
        NSString *endDateStr = [NSString stringWithFormat:@"%02ld%02ld%02ld",startDate.year,startDate.month,startDate.day];
        NSDateFormatter *formater = [[NSDateFormatter alloc]init];
        formater.dateFormat = @"yyyyMMdd";
        NSDate *originEndDate = [formater dateFromString:endDateStr];
        NSDate *endDate = [originEndDate dateByAddingTimeInterval:24*3600];
        
        NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
        NSInteger day = 8 - weekDay;
        NSInteger hour = timeInterval / 3600;
        NSInteger minute = (NSInteger)timeInterval / 60 % 60;
        NSInteger second = (NSInteger)timeInterval % 60;
        
        NSString *timeStr = [NSString stringWithFormat:ASLocalizedString(@"进行中，剩余 %02ld:%02ld:%02ld"),hour,minute,second];
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:timeStr];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#9152F8"] range:NSMakeRange(@"进行中，剩余".length, [NSString stringWithFormat:@"%ld",day].length)];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#9152F8"] range:NSMakeRange([NSString stringWithFormat:@"进行中，剩余%ld天 ",day].length, [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,second].length)];
//        [self.timeLabel setAttributedText:attr];
        self.timeLabel.text = ASLocalizedString(timeStr);
        self.timeCount = timeInterval + day*24*3600;
        [self.timer invalidate];
        self.timer = nil;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }else if (type == GuildRankSubViewControllerTypeDay){
        self.timeImageView.hidden = NO;
        self.timeLabel.hidden = NO;
        NSDate *startDate = [NSDate date];
        NSString *endDateStr = [NSString stringWithFormat:@"%02ld%02ld%02ld",startDate.year,startDate.month,startDate.day];
        NSDateFormatter *formater = [[NSDateFormatter alloc]init];
        formater.dateFormat = @"yyyyMMdd";
        NSDate *originEndDate = [formater dateFromString:endDateStr];
        NSDate *endDate = [originEndDate dateByAddingTimeInterval:24*3600];
        NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
        NSInteger hour = timeInterval / 3600;
        NSInteger minute = (int)timeInterval / 60 % 60;
        NSInteger second = (int)timeInterval % 60;
        
        NSString *timeStr = [NSString stringWithFormat:ASLocalizedString(@"进行中，剩余 %02ld:%02ld:%02ld"),hour,minute,second];
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:timeStr];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#9152F8"] range:NSMakeRange(@"进行中，剩余 ".length, [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,second].length)];
        [self.timeLabel setText:ASLocalizedString(timeStr)];
        
        self.timeCount = timeInterval;
        [self.timer invalidate];
        self.timer = nil;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    
}

- (void)timerAction{
    if (self.type == GuildRankSubViewControllerTypeWeek) {
        self.timeCount --;
        NSInteger day = self.timeCount / 3600 / 24;
        NSInteger hour = (self.timeCount - day*24*3600) / 3600;
        NSInteger minute = (self.timeCount - day*24*3600) / 60 % 60;
        NSInteger second = (self.timeCount - day*24*3600) % 60;
        
        NSString *timeStr = [NSString stringWithFormat:ASLocalizedString(@"进行中，剩余%ld天 %02ld:%02ld:%02ld"),day,hour,minute,second];
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:timeStr];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#9152F8"] range:NSMakeRange(@"进行中，剩余".length, [NSString stringWithFormat:@"%ld",day].length)];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#9152F8"] range:NSMakeRange([NSString stringWithFormat:@"进行中，剩余%ld天 ",day].length, [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,second].length)];
//        [self.timeLabel setAttributedText:attr];
        self.timeLabel.text = ASLocalizedString(timeStr);
    }else if (self.type == GuildRankSubViewControllerTypeDay){
        self.timeCount --;
        NSInteger day = self.timeCount / 3600 / 24;
        NSInteger hour = (self.timeCount - day*24*3600) / 3600;
        NSInteger minute = (self.timeCount - day*24*3600) / 60 % 60;
        NSInteger second = (self.timeCount - day*24*3600) % 60;
        
        NSString *timeStr = [NSString stringWithFormat:ASLocalizedString(@"进行中，剩余%ld天 %02ld:%02ld:%02ld"),hour,minute,second];
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:timeStr];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#9152F8"] range:NSMakeRange(@"进行中，剩余 ".length, [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,second].length)];
        [self.timeLabel setText:ASLocalizedString(timeStr)];
    }
}

- (void)reset{
    [self.firstIconImageView setImage:nil];
    [self.firstNameLabel setText:@""];
    [self.firstConteLabel setText:@""];
    [self.firstScoreLabel setText:@""];
    [self.secondIconImageView setImage:nil];
    [self.secondNameLabel setText:@""];
    [self.secondContentLabel setText:@""];
    [self.secondScoreLabel setText:@""];
    [self.thirdIconImageView setImage:nil];
    [self.thirdNameLabel setText:@""];
    [self.thirdContentLabel setText:@""];
    [self.thirdScoreLabel setText:@""];
    self.firstSexImageView.image = nil;
    self.secondSexImageView.image = nil;
    self.thirdSexImageView.image = nil;
}

- (void)setFamilyDataArray:(NSArray<GuildDetailModelFamily_info *> *)familyDataArray{
    _familyDataArray = familyDataArray;
    [self reset];
    if (familyDataArray.count > 0) {
        [self.firstIconImageView sd_setImageWithURL:[NSURL URLWithString:familyDataArray[0].head_image]];
        [self.firstNameLabel setText:familyDataArray[0].family_name];
//        [self.firstConteLabel setText:familyDataArray[0].family_manifesto];
        [self.firstScoreLabel setText:[NSString stringWithFormat:ASLocalizedString(@"%@积分"),familyDataArray[0].sums]];
        
        NSString *rankImageName = [NSString stringWithFormat:@"level%@",familyDataArray[0].family_level];
        self.firstRankView.image = kBogoGuildKitBundleImageNamed(rankImageName);
        if (familyDataArray.count > 1) {
            [self.secondIconImageView sd_setImageWithURL:[NSURL URLWithString:familyDataArray[1].head_image]];
            [self.secondNameLabel setText:familyDataArray[1].family_name];
//            [self.secondContentLabel setText:familyDataArray[1].family_manifesto];
            [self.secondContentLabel setText:[NSString stringWithFormat:ASLocalizedString(@"%@积分"),familyDataArray[1].sums]];
            NSString *rankImageName = [NSString stringWithFormat:@"level%@",familyDataArray[1].family_level];
            self.secondRankView.image = kBogoGuildKitBundleImageNamed(rankImageName);
            if (familyDataArray.count > 2) {
                [self.thirdIconImageView sd_setImageWithURL:[NSURL URLWithString:familyDataArray[2].head_image]];
                [self.thirdNameLabel setText:familyDataArray[2].family_name];
//                [self.thirdContentLabel setText:familyDataArray[2].family_manifesto];
                [self.thirdScoreLabel setText:[NSString stringWithFormat:ASLocalizedString(@"%@积分"),familyDataArray[2].sums]];
                NSString *rankImageName = [NSString stringWithFormat:@"level%@",familyDataArray[2].family_level];
                self.thirdRankView.image = kBogoGuildKitBundleImageNamed(rankImageName);
            }
        }
        self.firstSexViewConstraint.constant = 0;
        self.secondSexViewConstraint.constant = 0;
        self.thirdSexViewConstraint.constant = 0;
    }
}

- (void)setUserDataArray:(NSArray<GuildDetailModelLists *> *)userDataArray{
    _userDataArray = userDataArray;
    [self reset];
    if (userDataArray.count > 0) {
        [self.firstIconImageView sd_setImageWithURL:[NSURL URLWithString:userDataArray[0].head_image]];
        [self.firstNameLabel setText:userDataArray[0].nick_name];
        [self.firstConteLabel setText:userDataArray[0].signature];
        [self.firstScoreLabel setText:[NSString stringWithFormat:ASLocalizedString(@"%@积分"),userDataArray[0].sums]];
        NSString *rankImageName = [NSString stringWithFormat:@"level%@",userDataArray[0].user_level];
        self.firstRankView.image = kBogoGuildKitBundleImageNamed(rankImageName);
        self.firstSexImageView.image = kBogoGuildKitBundleImageNamed(userDataArray[0].sex.integerValue == 1 ? @"guild_男" : @"guild_女");
        if (userDataArray.count > 1) {
            [self.secondIconImageView sd_setImageWithURL:[NSURL URLWithString:userDataArray[1].head_image]];
            [self.secondNameLabel setText:userDataArray[1].nick_name];
            [self.secondContentLabel setText:userDataArray[1].signature];
            [self.secondContentLabel setText:[NSString stringWithFormat:ASLocalizedString(@"%@积分"),userDataArray[1].sums]];
            NSString *rankImageName = [NSString stringWithFormat:@"level%@",userDataArray[1].user_level];
            self.secondRankView.image = kBogoGuildKitBundleImageNamed(rankImageName);
            self.secondSexImageView.image = kBogoGuildKitBundleImageNamed(userDataArray[1].sex.integerValue == 1 ? @"guild_男" : @"guild_女");
            if (userDataArray.count > 2) {
                [self.thirdIconImageView sd_setImageWithURL:[NSURL URLWithString:userDataArray[2].head_image]];
                [self.thirdNameLabel setText:userDataArray[2].nick_name];
                [self.thirdContentLabel setText:userDataArray[2].signature];
                [self.thirdScoreLabel setText:[NSString stringWithFormat:ASLocalizedString(@"%@积分"),userDataArray[2].sums]];
                NSString *rankImageName = [NSString stringWithFormat:@"level%@",userDataArray[2].user_level];
                self.thirdRankView.image = kBogoGuildKitBundleImageNamed(rankImageName);
                self.thirdSexImageView.image = kBogoGuildKitBundleImageNamed(userDataArray[2].sex.integerValue == 1 ? @"guild_男" : @"guild_女");
            }
        }
        self.firstSexViewConstraint.constant = 14;
        self.secondSexViewConstraint.constant = 14;
        self.thirdSexViewConstraint.constant = 14;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
