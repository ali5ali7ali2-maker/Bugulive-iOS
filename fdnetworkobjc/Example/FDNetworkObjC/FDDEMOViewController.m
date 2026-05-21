//
//  FDDEMOViewController.m
//  FDNetworkObjC
//
//  Created by fandongtongxue on 04/11/2020.
//  Copyright (c) 2020 fandongtongxue. All rights reserved.
//

#import "FDDEMOViewController.h"
#import <FDNetworkObjC/FDNetworkObjC.h>

@interface FDDEMOViewController ()

@end

@implementation FDDEMOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"v0200f0a0000bptlivl1mik40uaur8gg" ofType:@"mp4"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [[FDOSSManager defaultManager] setup:^{
        [[FDOSSManager defaultManager] UPLOAD:data progress:^(float percent) {
            
        } success:^(NSString * _Nonnull resultStr) {
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
