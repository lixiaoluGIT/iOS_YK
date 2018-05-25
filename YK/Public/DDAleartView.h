//
//  DDAleartView.h
//  YK
//
//  Created by LXL on 2018/3/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#ifndef DDAleartView_h
#define DDAleartView_h


#endif /* DDAleartView_h */
@interface DDAleartView : UIView

- (void)showWithImage:(UIImage *)imgge title:(NSString *)title detailTitle:(NSString *)detailTitle notitle:(NSString *)notitle yestitle:(NSString *)yestitle color:(UIColor *)aleartColor type:(NSInteger)type cancelBlock:(void (^)(void))cancelBlock ensureBlock:(void (^)(void))ensureBlock;

@end
