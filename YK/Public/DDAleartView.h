//
//  DDAleartView.h
//  dongdongcar
//
//  Created by apple on 17/6/26.
//  Copyright © 2017年 softnobug. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDAleartView : UIView

- (void)showWithImage:(UIImage *)imgge title:(NSString *)title detailTitle:(NSString *)detailTitle notitle:(NSString *)notitle yestitle:(NSString *)yestitle color:(UIColor *)aleartColor type:(NSInteger)type cancelBlock:(void (^)())cancelBlock ensureBlock:(void (^)())ensureBlock;

@end
