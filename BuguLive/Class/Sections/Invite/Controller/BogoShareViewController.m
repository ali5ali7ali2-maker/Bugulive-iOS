//
//  BogoShareViewController.m
//  UniversalApp
//
//  Created by Mac on 2021/8/9.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoShareViewController.h"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import <TYCyclePagerView/TYPageControl.h>
#import "TYCyclePagerViewCell.h"
#import "CommonShareView.h"
#import <SDWebImage/SDWebImage.h>
#import "BogoNetworkKit.h"
#import "BogoShopKit.h"

@interface BogoShareBgModel : NSObject

@property (nonatomic, assign) NSInteger addtime;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger status;

@end

@implementation BogoShareBgModel

@end

@interface BogoShareViewController ()<TYCyclePagerViewDataSource,TYCyclePagerViewDelegate,CommonShareViewDelegate>

@property(nonatomic, strong) TYCyclePagerView *pageView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) CommonShareView *shareView;
@property(nonatomic, assign) NSInteger currentIndex;

@end

@implementation BogoShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.pageView];
    [self.view addSubview:self.shareView];
    [self requesrData];
}

- (void)requesrData{
    //    /mapi/index.php?ctl=invite_vue&act=share_bg&uid=166238
    [[BogoNetwork shareInstance] POSTV3:@"" param:@{@"ctl":@"invite_vue",@"act":@"share_bg"} success:^(BogoNetworkResponseModel * _Nonnull result) {
        for (NSDictionary *dict in result.data) {
            BogoShareBgModel *model = [BogoShareBgModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.pageView reloadData];
    } failure:^(NSString * _Nonnull error) {
        [[BGHUDHelper sharedInstance] tipMessage:error];
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.pageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kScreenHeight - 133 - FD_Bottom_SafeArea_Height - kTopHeight);
    self.shareView.frame = CGRectMake(0, kScreenHeight - 133 - FD_Bottom_SafeArea_Height - kTopHeight, kScreenW, 133 + FD_Bottom_SafeArea_Height);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [[BGHUDHelper sharedInstance] tipMessage:error.localizedDescription];
    }else{
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"保存图片成功")];
    }
}

#pragma mark - CommonShareViewDelegate
- (void)shareView:(CommonShareView *)shareView didClickBtn:(QMUIButton *)sender{
    switch (sender.tag - kRoomShareViewBaseBtnTag) {
        case UMSocialPlatformType_UnKnown:
            //保存图片
        {
            TYCyclePagerViewCell *cell = (TYCyclePagerViewCell *)[self.pageView curIndexCell];
            UIImage *image = [cell convertViewToImage];
            if (image) {
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
        }
            break;
        default:
        {
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            UMShareImageObject *imageObject = [[UMShareImageObject alloc]init];
            TYCyclePagerViewCell *cell = (TYCyclePagerViewCell *)[self.pageView curIndexCell];
            
            
//            if (sender.tag - kRoomShareViewBaseBtnTag == UMSocialPlatformType_WechatSession ||sender.tag - kRoomShareViewBaseBtnTag == UMSocialPlatformType_WechatTimeLine) {
//                if (![WXApi isWXAppInstalled]) {
//                    [[BGHUDHelper sharedInstance] tipMessage:@"未安装微信"];
//                    return;
//                }
//            }
            
            
            
            UIImage *image = [cell convertViewToImage];
            imageObject.shareImage = image;
            messageObject.shareObject = imageObject;
            [[UMSocialManager defaultManager] shareToPlatform:sender.tag - kRoomShareViewBaseBtnTag messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
                if (error) {
                    [[BGHUDHelper sharedInstance] tipMessage:@"当前分享方式不可用，请使用其他方式分享"];
                }else{
                    [[BGHUDHelper sharedInstance] tipMessage:NSLocalizedString(@"分享成功",nil)];
                }
            }];
        }
            break;
    }
}

#pragma mark - TYCyclePagerViewDataSource,TYCyclePagerViewDelegate
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index{
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    if (index < self.dataArray.count) {
        BogoShareBgModel *model = self.dataArray[index];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        NSString *url = [NSString stringWithFormat:@"%@&invite_code=%@",[GlobalVariables sharedInstance].appModel.h5_url.download_url,[IMAPlatform sharedInstance].host.imUserId];
        cell.qrCode = url;
    }
    return cell;
}


- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame) - 120, CGRectGetHeight(pageView.frame) - 80);
    layout.itemSpacing = 30;
    layout.layoutType = TYCyclePagerTransformLayoutLinear;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    self.currentIndex = toIndex;
}

- (TYCyclePagerView *)pageView{
    if (!_pageView) {
        _pageView = [[TYCyclePagerView alloc]initWithFrame:CGRectZero];
        _pageView.layer.borderWidth = 0;
        _pageView.isInfiniteLoop = YES;
        _pageView.dataSource = self;
        _pageView.delegate = self;
        _pageView.collectionView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        [_pageView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    }
    return _pageView;
}

- (CommonShareView *)shareView{
    if (!_shareView) {
        _shareView = [[CommonShareView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 133 - FD_Bottom_SafeArea_Height - kTopHeight, kScreenW, 133 + FD_Bottom_SafeArea_Height)];
        _shareView.delegate = self;
    }
    return _shareView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
