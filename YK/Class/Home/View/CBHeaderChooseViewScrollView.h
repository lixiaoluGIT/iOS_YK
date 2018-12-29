//
//  CBHeaderChooseViewScrollView.h
//  JZLConstructApp
//
//  Created by Apple on 17/4/5.
//  Copyright © 2017年 com.jzl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnChooseClickBlock)(NSInteger x);

@interface CBHeaderChooseViewScrollView : UIScrollView

@property (nonatomic, copy)btnChooseClickBlock btnChooseClickReturn;

- (void)setUpTitleArray :(NSArray <NSString *> *)array titleColor :(UIColor *)color titleSelectedColor:(UIColor *)selectedColor titleFontSize :(CGFloat)size;

@end

@interface UIView (JZLViewFrame)

@property(nonatomic,assign)CGFloat jzl_height;

@property(nonatomic,assign)CGFloat jzl_width;

@property(nonatomic,assign)CGFloat jzl_x;

@property(nonatomic,assign)CGFloat jzl_y;

@property(nonatomic,assign)CGFloat jzl_right;

@property(nonatomic,assign)CGFloat jzl_bottom;

@property(nonatomic,assign)CGFloat jzl_centerX;

@property(nonatomic,assign)CGFloat jzl_centerY;

@property(nonatomic,assign)CGSize jzl_size;

@end
