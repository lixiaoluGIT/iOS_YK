//
//  YKCodeView.m
//  YK
//
//  Created by edz on 2018/11/13.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKCodeView.h"
#import "UIView+MBLayout.h"
#import "UIColor+Extend.h"
#import "UITextField+GTExtend.h"

@interface YKCodeView ()<UITextFieldDelegate,GTTextFieldDelegate>
/** */
@property (nonatomic, weak) UITextField *codeTextField;
@property (nonatomic, weak) UILabel *label1;
@property (nonatomic, weak) UILabel *label2;
@property (nonatomic, weak) UILabel *label3;
@property (nonatomic, weak) UILabel *label4;
/** */
@property (nonatomic, copy) OnFinishedEnterCode onFinishedEnterCode;
@end

@implementation YKCodeView

- (instancetype)initWithFrame:(CGRect)frame onFinishedEnterCode:(OnFinishedEnterCode)onFinishedEnterCode {
    if (self = [super initWithFrame:frame]) {
        CGFloat labWidth = kSuitLength_H(38);
        CGFloat labHeight = kSuitLength_H(38);
        CGFloat spacing = kSuitLength_H(14);
        CGFloat margin = (self.width-labWidth*4-spacing*3)/2.;
        
        if (onFinishedEnterCode) {
            _onFinishedEnterCode = [onFinishedEnterCode copy];
        }
        
        for (NSInteger i = 0; i<4; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin+(labWidth+spacing)*i, 0, labWidth, labHeight)];
            label.tag = 100+i;
            label.backgroundColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [label setCornerWithRadius:1.f borderWidth:.1 borderColor:[UIColor disabledColor]];
            [self addSubview:label];
            if (i == 0) {
                _label1 = label;
            }else if (i == 1) {
                _label2 = label;
            }else if (i == 2) {
                _label3 = label;
            }else {
                _label4 = label;
            }
        }
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, labWidth, labHeight)];
        textField.delegate = self;
        textField.textAlignment = NSTextAlignmentCenter;
        [textField setCornerWithRadius:1.f borderWidth:.5 borderColor:[UIColor appBaseColor]];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:textField];
        _codeTextField = textField;
        
        [textField becomeFirstResponder];
    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!self.label1.text.length) {
        self.label1.text = string;
        [self.label1 setCornerWithRadius:1.f borderWidth:.5 borderColor:[UIColor appBaseColor]];
        _codeTextField.left = _label2.left;
    }else if (!self.label2.text.length) {
        self.label2.text = string;
        [self.label2 setCornerWithRadius:1.f borderWidth:.5 borderColor:[UIColor appBaseColor]];
        _codeTextField.left = _label3.left;
    }else if (!self.label3.text.length) {
        self.label3.text = string;
        [self.label3 setCornerWithRadius:1.f borderWidth:.5 borderColor:[UIColor appBaseColor]];
        _codeTextField.left = _label4.left;
    }else if (!self.label4.text.length) {
        self.label4.text = string;
        [self.label4 setCornerWithRadius:1.f borderWidth:.5 borderColor:[UIColor appBaseColor]];
        _codeTextField.left = _label4.left;
        
        [_codeTextField resignFirstResponder];
        
        if (_onFinishedEnterCode) {
            NSString *code = [NSString stringWithFormat:@"%@%@%@%@",_label1.text,_label2.text,_label3.text,_label4.text];
            _onFinishedEnterCode(code);
        }
        
    }
    return NO;
}

- (void)textFieldDidDeleteBackward:(UITextField *)textField {
    if (self.label4.text.length) {
        self.label4.text = @"";
        [self.label4 setCornerWithRadius:1. borderWidth:.5 borderColor:[UIColor disabledColor]];
        [self.codeTextField setCornerWithRadius:5. borderWidth:.5 borderColor:[UIColor disabledColor]];
        self.codeTextField.left = self.label4.left;
    }else if (self.label3.text.length) {
        self.label3.text = @"";
        [self.label3 setCornerWithRadius:1. borderWidth:.5 borderColor:[UIColor disabledColor]];
        [self.codeTextField setCornerWithRadius:5. borderWidth:.5 borderColor:[UIColor disabledColor]];
        self.codeTextField.left = self.label3.left;
    }else if (self.label2.text.length) {
        self.label2.text = @"";
        [self.label2 setCornerWithRadius:1. borderWidth:.5 borderColor:[UIColor disabledColor]];
        [self.codeTextField setCornerWithRadius:5. borderWidth:.5 borderColor:[UIColor disabledColor]];
        self.codeTextField.left = self.label2.left;
    }else if (self.label1.text.length) {
        self.label1.text = @"";
        [self.label1 setCornerWithRadius:1. borderWidth:.5 borderColor:[UIColor appBaseColor]];
        [self.codeTextField setCornerWithRadius:5. borderWidth:.5 borderColor:[UIColor appBaseColor]];
        self.codeTextField.left = self.label1.left;
    }
}

- (void)resetDefaultStatus {
    self.label1.text = self.label2.text = self.label3.text = self.label4.text = @"";
    [self.label1 setCornerWithRadius:1. borderWidth:.5 borderColor:[UIColor appBaseColor]];
    [self.label2 setCornerWithRadius:1. borderWidth:.5 borderColor:[UIColor disabledColor]];
    [self.label3 setCornerWithRadius:1. borderWidth:.5 borderColor:[UIColor disabledColor]];
    [self.label4 setCornerWithRadius:1. borderWidth:.5 borderColor:[UIColor disabledColor]];
    [self.codeTextField setCornerWithRadius:1. borderWidth:.5 borderColor:[UIColor appBaseColor]];
    self.codeTextField.left = self.label1.left;
    [self codeBecomeFirstResponder];
}

- (void)codeBecomeFirstResponder {
    [self.codeTextField becomeFirstResponder];
}

@end
