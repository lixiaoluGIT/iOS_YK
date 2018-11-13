//
//  UIColor+Extend.h
//  codeView
//
//  Created by Thinkive on 2017/11/19.
//  Copyright © 2017年 Thinkive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extend)

+ (UIColor *)colorWithHex:(NSString *)colorStr;

+ (UIColor *)appBaseColor;

+ (UIColor *)themeRedColor;

+ (UIColor *)disabledColor;

@end
