//
//  UIAlertController+UIColor_Helper.h
//  Signal
//
//  Created by Si Te Feng on 9/10/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helper)

+ (UIColor *)transluscentWhite;
+ (UIColor *)defaultBackgroundGray;
+ (UIColor*)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;
+ (UIColor*)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha;

@end
