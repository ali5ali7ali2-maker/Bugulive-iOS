//
//  BogoImagePickerViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/28.
//

#import "BogoImagePickerViewController.h"

@interface BogoImagePickerViewController ()



@end

@implementation BogoImagePickerViewController

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<TZImagePickerControllerDelegate>)delegate{
    if (self = [super initWithMaxImagesCount:maxImagesCount delegate:delegate]) {
        self.needShowStatusBar = ![UIApplication sharedApplication].statusBarHidden;
        self.view.backgroundColor = [UIColor whiteColor];
        self.oKButtonTitleColorNormal   =  [UIColor greenColor];
        self.oKButtonTitleColorDisabled =  [UIColor blackColor];
        self.naviBgColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.naviTitleColor = [UIColor blackColor];
        self.barItemTextColor = [UIColor blackColor];
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
