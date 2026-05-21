#import <Foundation/Foundation.h>


@interface BogoShopBannerModel: NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger show_id;
@property (nonatomic, assign) NSInteger show_position;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *url;
@end
