//
//  YKInputCodeView.h
//  YK
//
//  Created by edz on 2018/11/27.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKInputCodeView : UIView
@property (nonatomic,copy)void (^loginSuccess)(NSString *invitCode);
@end
