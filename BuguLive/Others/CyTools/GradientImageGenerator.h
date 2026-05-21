#import <UIKit/UIKit.h>

@interface GradientImageGenerator : NSObject

+ (UIImage *)gradientImageWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

@end
