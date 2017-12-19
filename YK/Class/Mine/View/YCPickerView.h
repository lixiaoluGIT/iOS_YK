//
//  YCPickerView.h
//  YCPickerView
//
//  Created by 袁灿 on 16/2/29.
//  Copyright © 2016年 yuancan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyBasicBlock)(id result);

@interface YCPickerView : UIView

@property (nonatomic, assign) BOOL isDelayPicker; //延迟到精确时间picker
@property (retain, nonatomic) NSArray *arrPickerData;
@property (retain, nonatomic) UIPickerView *pickerView;

@property (nonatomic, copy) MyBasicBlock selectBlock;
@property (nonatomic,copy)void (^ensureBlock)(NSString *str,NSInteger row);

- (void)popPickerView;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
@end
