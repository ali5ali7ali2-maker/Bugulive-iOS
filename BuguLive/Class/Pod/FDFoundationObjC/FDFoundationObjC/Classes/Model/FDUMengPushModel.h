//
//  FDUMengPushModel.h
//  FDFoundationObjC
//
//  Created by fandongtongxue on 2020/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDUMengPushAPSAlertModel : NSObject

//    body = "\U6d4b\U8bd5\U901a\U77e5\U5185\U5bb9";
//    subtitle = "\U6d4b\U8bd5\U901a\U77e5\U526f\U6807\U9898";
//    title = "\U6d4b\U8bd5\U901a\U77e5\U4e3b\U6807\U9898";

@property(nonatomic, copy) NSString *body;
@property(nonatomic, copy) NSString *subtitle;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *custom;

@end

@interface FDUMengPushAPSModel : NSObject

//alert =         {
//    body = "\U6d4b\U8bd5\U901a\U77e5\U5185\U5bb9";
//    subtitle = "\U6d4b\U8bd5\U901a\U77e5\U526f\U6807\U9898";
//    title = "\U6d4b\U8bd5\U901a\U77e5\U4e3b\U6807\U9898";
//};
//"mutable-content" = 1;
//sound = default;
//url = "https://www.baidu.com";

@property(nonatomic, strong) FDUMengPushAPSAlertModel *alert;
//@property(nonatomic, copy) NSString *mutable-content;
@property(nonatomic, copy) NSString *sound;
@property(nonatomic, copy) NSString *url;

@end

@interface FDUMengPushModel : NSObject

//aps =     {
//    alert =         {
//        body = "\U6d4b\U8bd5\U901a\U77e5\U5185\U5bb9";
//        subtitle = "\U6d4b\U8bd5\U901a\U77e5\U526f\U6807\U9898";
//        title = "\U6d4b\U8bd5\U901a\U77e5\U4e3b\U6807\U9898";
//    };
//    "mutable-content" = 1;
//    sound = default;
//    url = "https://www.baidu.com";
//};
//d = um9of1o156773751288810;
//p = 0;

@property(nonatomic, strong) FDUMengPushAPSModel *aps;
@property(nonatomic, copy) NSString *d;
@property(nonatomic, copy) NSString *p;

@end

NS_ASSUME_NONNULL_END
