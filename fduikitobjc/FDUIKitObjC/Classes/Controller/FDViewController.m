//
//  FDViewController.m
//  FDUIKitObjC
//
//  Created by 范东 on 2020/3/9.
//

#import "FDViewController.h"
#import "FDUIColorDefine.h"

@interface FDViewController ()

@end

@implementation FDViewController

- (instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = FD_WhiteColor;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = FD_WhiteColor;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
