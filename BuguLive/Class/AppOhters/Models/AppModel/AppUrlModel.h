//
//  AppUrlModel.h
//  BuguLive
//
//  Created by xfg on 16/8/23.
//  Copyright © 2016年 xfg. All rights reserved.
//  h5地址

#import <Foundation/Foundation.h>

@interface AppUrlModel : NSObject

@property (nonatomic ,strong) NSString *url_my_grades;          // 我的等级
@property (nonatomic ,strong) NSString *url_about_we;           // 帮助与反馈
@property (nonatomic ,strong) NSString *url_help_feedback;      // 关于我们
@property (nonatomic ,strong) NSString *url_auction_record;     // 竞拍记录
@property (nonatomic ,strong) NSString *url_user_pai;           // 我的竞拍
@property (nonatomic ,strong) NSString *url_user_order;         // 我的订单
@property (nonatomic ,strong) NSString *url_podcast_order;      // 星店订单
@property (nonatomic ,strong) NSString *url_podcast_pai;        // 竞拍管理
@property (nonatomic ,strong) NSString *url_podcast_goods;      // 商品管理
@property (nonatomic ,strong) NSString *url_auction_agreement;  // 竞拍页面充值页面的协议
@property (nonatomic ,strong) NSString *url_shopping_cart;      // 购物车

@property (nonatomic ,strong) NSString *members_url;      // 购物车
@property(nonatomic, strong) NSString *pay_car;
@property (nonatomic, copy) NSString *guartian_details;
@property (nonatomic, copy) NSString *guartian_special_effects;//守护特权
@property(nonatomic, strong) NSString *luck_num_url;
@property(nonatomic, copy) NSString *invite_rewards;
@property(nonatomic, copy) NSString *pay_noble;

@property(nonatomic, strong) NSString *shop_url;
@property(nonatomic, strong) NSString *emcee_center_url;//主播中心

@property(nonatomic, strong) NSString *shop_product_url;
@property(nonatomic, strong) NSString *shop_manage_url;//管理小店


@property(nonatomic, strong) NSString *url_recharge_agreement;//充值协议字段url链接

@property(nonatomic, copy) NSString *download_url;
@property(nonatomic, strong) NSString *withdrawal_account_url;
@property(nonatomic, strong) NSString *emcee_income_log_url;



//新增
@property(nonatomic, strong) NSString *silver_coin_url;

@property(nonatomic, strong) NSString *agent_invitation_url;
@property(nonatomic, strong) NSString *pk_reward_url;

@property(nonatomic, strong) NSString *daily_task_url;
@property(nonatomic, strong) NSString *fan_group_url;
@property(nonatomic, strong) NSString *fan_group_list_url;

@property(nonatomic, strong) NSString *guard_url;
@property(nonatomic, strong) NSString *game_list_url;

@property(nonatomic, strong) NSString *visitor_url;//访客
@property(nonatomic, strong) NSString *close_friend_url;//密友
@property(nonatomic, strong) NSString *video_ranking_url;//富豪

//@property(nonatomic, strong) NSString *withdrawal_account_url;//修改提现
@property(nonatomic, strong) NSString *report_url;
//@property(nonatomic, strong) NSString *emcee_income_log_url;@end
@property(nonatomic, strong) NSString *game_list;
//房间流水传参
@property(nonatomic, strong) NSString *room_flow;
@property(nonatomic, strong) NSString *month_statistics_log;

@property(nonatomic, strong) NSString *fruitMachine_game_url;
@property(nonatomic, strong) NSString *greedy_game_url;
@end
