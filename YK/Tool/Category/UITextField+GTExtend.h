//
//  UITextField+GTExtend.h
//  GTFund
//
//  Created by Thinkive on 2017/9/14.
//  Copyright © 2017年 Thinkive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTTextFieldDelegate <UITextFieldDelegate>

@optional
- (void)textFieldDidDeleteBackward:(UITextField *)textField;
@end

@interface UITextField (GTExtend)

@property (weak, nonatomic) id <GTTextFieldDelegate> delegate;

@end

/**
 *  监听删除按钮
 *  object:UITextField
 */
extern NSString * const GTTextFieldDidDeleteBackwardNotification;
