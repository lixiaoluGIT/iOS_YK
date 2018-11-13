//
//  UIFont+MBExtend.m
//  SocketRocket
//
//  Created by July Cattery on 17/4/20.
//  Copyright © 2017年 loovee. All rights reserved.
//

#import "UIFont+MBExtend.h"

@implementation UIFont (MBExtend)

+ (UIFont *)fontWithFontName:(NSString *)name size:(CGFloat)size {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        return [UIFont fontWithName:name size:size];
    }else {
        return [UIFont systemFontOfSize:size];
    }
}

@end
