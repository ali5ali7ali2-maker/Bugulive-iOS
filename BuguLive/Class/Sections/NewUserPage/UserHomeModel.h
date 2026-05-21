//
//  UserHomeModel.h
//
//
//  Created by JSONConverter on 2021/09/17.
//  Copyright © 2021年 JSONConverter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserHomeModelUser;
@class UserHomeModelNew_item;
@class UserHomeModelItem;
@class UserHomeModelCuser_list;

@interface UserHomeModel: NSObject
@property (nonatomic, copy) NSString *act;
@property (nonatomic, copy) NSString *ctl;
@property (nonatomic, strong) NSArray<UserHomeModelCuser_list *> *cuser_list;
@property (nonatomic, assign) NSInteger has_admin;
@property (nonatomic, assign) NSInteger has_black;
@property (nonatomic, assign) NSInteger has_focus;
@property (nonatomic, assign) NSInteger is_forbid;
@property (nonatomic, assign) NSInteger show_admin;
@property (nonatomic, assign) NSInteger show_tipoff;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) UserHomeModelUser *user;
@property(nonatomic, strong) NSDictionary *video;
@end

@interface UserHomeModelUser: NSObject
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *emotional_state;
@property (nonatomic, copy) NSString *family_chieftain;
@property (nonatomic, copy) NSString *family_id;
@property (nonatomic, copy) NSString *fans_count;
@property (nonatomic, copy) NSString *focus_count;
@property (nonatomic, copy) NSString *head_image;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *is_agree;
@property (nonatomic, copy) NSString *is_authentication;
@property (nonatomic, assign) NSInteger is_noble_mysterious;
@property (nonatomic, assign) NSInteger is_noble_stealth;
@property (nonatomic, assign) NSInteger is_open_shop;
@property (nonatomic, copy) NSString *is_open_young;
@property (nonatomic, copy) NSString *is_remind;
@property (nonatomic, copy) NSString *is_robot;
@property (nonatomic, assign) NSInteger is_shop;
@property (nonatomic, assign) NSInteger is_vip;
//@property (nonatomic, strong) UserHomeModelItem *item;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *luck_num;
@property (nonatomic, copy) NSString *moments;
@property (nonatomic, copy) NSString *mysterious_name;
@property (nonatomic, copy) NSString *mysterious_picture;
@property (nonatomic, copy) NSString *n_coin;
@property (nonatomic, copy) NSString *n_diamonds;
@property (nonatomic, copy) NSString *n_fans_count;
@property (nonatomic, copy) NSString *n_focus_count;
@property (nonatomic, copy) NSString *n_podcast_goods;
@property (nonatomic, copy) NSString *n_podcast_order;
@property (nonatomic, copy) NSString *n_podcast_pai;
@property (nonatomic, copy) NSString *n_shop_goods;
@property (nonatomic, copy) NSString *n_shopping_cart;
@property (nonatomic, copy) NSString *n_show_podcast_order;
@property (nonatomic, copy) NSString *n_show_shopping_cart;
@property (nonatomic, copy) NSString *n_show_user_order;
@property (nonatomic, copy) NSString *n_show_user_pai;
@property (nonatomic, copy) NSString *n_svideo_count;
@property (nonatomic, copy) NSString *n_ticket;
@property (nonatomic, copy) NSString *n_use_diamonds;
@property (nonatomic, copy) NSString *n_useable_ticket;
@property (nonatomic, copy) NSString *n_user_order;
@property (nonatomic, copy) NSString *n_user_pai;
@property (nonatomic, copy) NSString *n_video_count;
//@property (nonatomic, strong) NSArray *new_item;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *no_ticket;
@property (nonatomic, copy) NSString *noble_avatar;
@property (nonatomic, assign) NSInteger noble_barrage;
@property (nonatomic, assign) NSInteger noble_car;
@property (nonatomic, copy) NSString *noble_car_url;
@property (nonatomic, assign) NSInteger noble_experience;
@property (nonatomic, assign) NSInteger noble_gift;
@property (nonatomic, copy) NSString *noble_icon;
@property (nonatomic, assign) NSInteger noble_is_avatar;
@property (nonatomic, assign) NSInteger noble_maybe;
@property (nonatomic, assign) NSInteger noble_medal;
@property (nonatomic, copy) NSString *noble_name;
@property (nonatomic, assign) NSInteger noble_silence;
@property (nonatomic, assign) NSInteger noble_special_effects;
@property (nonatomic, assign) NSInteger noble_stealth;
@property (nonatomic, copy) NSString *noble_time;
@property (nonatomic, assign) NSInteger noble_vip_type;
@property (nonatomic, copy) NSString *nobleid;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *room_title;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *shop_status;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *star_box;
@property (nonatomic, assign) NSInteger ticket;
@property (nonatomic, copy) NSString *use_diamonds;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString *user_level;
@property (nonatomic, copy) NSString *v_explain;
@property (nonatomic, copy) NSString *v_icon;
@property (nonatomic, copy) NSString *v_type;
@property (nonatomic, copy) NSString *video_count;
@property (nonatomic, copy) NSString *vip_expire_time;
@property (nonatomic, copy) NSString *weibo_count;
@end


@interface UserHomeModelCuser_list: NSObject
@property (nonatomic, copy) NSString *head_image;
@property (nonatomic, copy) NSString *is_noble_mysterious;
@property (nonatomic, assign) NSInteger is_noble_ranking_stealth;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *noble_time;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, assign) NSInteger use_ticket;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString *user_level;
@property (nonatomic, copy) NSString *v_icon;
@property (nonatomic, copy) NSString *v_type;
@end
