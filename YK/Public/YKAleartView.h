//
//  YKAleartView.h
//  YK
//
//  Created by LXL on 2017/12/19.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKAleartView : UIView

- (void)showWithtitle:(NSString *)title notitle:(NSString *)notitle yestitle:(NSString *)yestitle cancelBlock:(void (^)(void))cancelBlock ensureBlock:(void (^)(void))ensureBlock;
@end
