//
//  YKCodeView.h
//  YK
//
//  Created by edz on 2018/11/13.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKCodeView : UIView
typedef void(^OnFinishedEnterCode)(NSString *code);

- (instancetype)initWithFrame:(CGRect)frame onFinishedEnterCode:(OnFinishedEnterCode)onFinishedEnterCode;

- (void)resetDefaultStatus;

- (void)codeBecomeFirstResponder;
@end
