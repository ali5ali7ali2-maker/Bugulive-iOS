//
//  HPContributionCell.m
//  BuguLive
//
//  Created by 丁凯 on 2017/7/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "HPContributionCell.h"

@implementation HPContributionCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = kBackGroundColor;
    self.imgView1.layer.cornerRadius = 24/2.0f;
    self.imgView2.layer.cornerRadius = 24/2.0f;
    self.imgView3.layer.cornerRadius = 24/2.0f;
    
    self.imgView1.layer.masksToBounds = YES;
    self.imgView2.layer.masksToBounds = YES;
    self.imgView3.layer.masksToBounds = YES;
    self.BuguLive = [GlobalVariables sharedInstance];
    self.myNameLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@贡献榜"),self.BuguLive.appModel.ticket_name];
//    self.myNameLabel.textColor = kAppGrayColor3;
}

- (void)setCellWithArray:(NSMutableArray *)imageArray
{
    if (imageArray.count > 2)
    {
        if ([imageArray[2] length])
        {
            if ([imageArray[2] isEqualToString:@"is_noble_ranking_stealth"]) {
                
                [self.imgView3 sd_setImageWithURL:nil placeholderImage:kDefaultNobleMysteriousHeadImg];
            }else{
                [self.imgView3 sd_setImageWithURL:[NSURL URLWithString:imageArray[2]] placeholderImage:[UIImage imageNamed:@"ic_me_qiuzhan"]];
            }
            
        }
    }
    
    if (imageArray.count > 1)
    {
        if ([imageArray[1] length])
        {
            if ([imageArray[1] isEqualToString:@"is_noble_ranking_stealth"]) {
                
                [self.imgView2 sd_setImageWithURL:nil placeholderImage:kDefaultNobleMysteriousHeadImg];
            }else{
                [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:imageArray[1]] placeholderImage:[UIImage imageNamed:@"ic_me_qiuzhan"]];
            }
            
        }
    }
    
    if (imageArray.count > 0)
    {
        if ([imageArray[0] length])
        {
            if ([imageArray[0] isEqualToString:@"is_noble_ranking_stealth"]) {
                
                [self.imgView1 sd_setImageWithURL:nil placeholderImage:kDefaultNobleMysteriousHeadImg];
            }else{
                if(imageArray.count > 2)
                {
                    [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:imageArray[1]] placeholderImage:[UIImage imageNamed:@"ic_me_qiuzhan"]];
                }
            }
//            [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:[UIImage imageNamed:@"ic_me_qiuzhan"]];
        }
    }
    
}


@end
