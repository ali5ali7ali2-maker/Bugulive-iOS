//
//  BogoShopKit.m
//  BogoShopKit-BogoShopKit
//
//  Created by Mac on 2021/7/3.
//

#import "BogoShopKit.h"

@implementation BogoShopKit

+(NSBundle *)getBundleWithFName:(NSString *)fName bName:(NSString *)bName{
    NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
    if (!bundleUrl) {
        return [NSBundle mainBundle];
    }
    bundleUrl = [bundleUrl URLByAppendingPathComponent:fName];
    bundleUrl = [bundleUrl URLByAppendingPathExtension:@"framework"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleUrl];
    NSURL *url = [bundle URLForResource:bName withExtension:@"bundle"];
    return [NSBundle bundleWithURL:url];
}

+ (UIImage *)getImageWithName:(NSString *)name type:(NSString *)type{
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
    associateBundleURL = [associateBundleURL URLByAppendingPathComponent:@"BogoShopKit"];
    associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
    NSBundle *associateBundle = [NSBundle bundleWithURL:associateBundleURL];
    associateBundleURL = [associateBundle URLForResource:@"BogoShopKit" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:associateBundleURL];
    NSInteger scale = [[UIScreen mainScreen] scale];
    NSString *imgName = [NSString stringWithFormat:@"%@@%zdx.%@",name,scale,type];
    UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:imgName ofType:nil]];
    if (!image) {
        NSString *imgNewName = [NSString stringWithFormat:@"%@.%@",name,type];
        UIImage *newImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:imgNewName ofType:nil]];
        return newImage;
    }
    return image;
}

@end
