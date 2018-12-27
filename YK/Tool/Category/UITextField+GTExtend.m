//
//  UITextField+GTExtend.m
//  GTFund
//
//  Created by Thinkive on 2017/9/14.
//  Copyright © 2017年 Thinkive. All rights reserved.
//

#import "UITextField+GTExtend.h"
#import <objc/runtime.h>

NSString * const GTTextFieldDidDeleteBackwardNotification = @"textfield_did_notification";

@implementation UITextField (GTExtend)

+ (void)load {
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(yx_deleteBackward));
    method_exchangeImplementations(method1, method2);
}

- (void)yx_deleteBackward {
    [self yx_deleteBackward];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)])
    {
        id <GTTextFieldDelegate> delegate  = (id<GTTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GTTextFieldDidDeleteBackwardNotification object:self];
}

@end
