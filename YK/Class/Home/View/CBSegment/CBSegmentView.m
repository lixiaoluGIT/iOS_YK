//
//  CBSegmentView.m
//  CBSegment
//
//  Created by 陈彬 on 2017/9/9.
//  Copyright © 2017年 com.bingo.com. All rights reserved.
//

#import "CBSegmentView.h"

@interface CBSegmentView ()<UIScrollViewDelegate>
/**
 *  configuration.
 */
{
    CGFloat _HeaderH;
    UIColor *_titleColor;
    UIColor *_titleSelectedColor;
    CBSegmentStyle _SegmentStyle;
    CGFloat _titleFont;
    NSArray *categoryId;
}
/**
 *  The bottom red slider.
 */
@property (nonatomic, weak) UIView *slider;

@property (nonatomic, strong) NSMutableArray *titleWidthArray;

@property (nonatomic, weak) UIButton *selectedBtn;

@end

#define CBColorA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define CBScreenH [UIScreen mainScreen].bounds.size.height
#define CBScreenW [UIScreen mainScreen].bounds.size.width
@implementation CBSegmentView

#pragma mark - delayLoading
- (NSMutableArray *)titleWidthArray {
    if (!_titleWidthArray) {
        _titleWidthArray = [NSMutableArray new];
    }
    return _titleWidthArray;
}

- (NSArray *)categotyIds {
    if (!_categotyIds) {
        _categotyIds = [NSMutableArray new];
    }
    return _categotyIds;
}

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.layer.borderColor = [UIColor colorWithHexString:@"f5f5f5"].CGColor;
        self.layer.borderWidth = 0;
        
        _HeaderH = frame.size.height;
        _SegmentStyle = CBSegmentStyleSlider;
        _titleColor = mainColor;
        _titleSelectedColor = [UIColor whiteColor];
        _titleFont = 14;
        [self setContentSize:CGSizeMake(WIDHT, 0)];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

//- (void)setTitleArray:(NSArray<NSString *> *)titleArray {
//    [self setTitleArray:titleArray withStyle:0];
//}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray categoryIds:(NSArray *)categoryIds withStyle:(CBSegmentStyle)style {
    _categotyIds = categoryIds;
    [self setTitleArray:titleArray categoryIds:(NSArray *)categoryIds titleFont:0 titleColor:nil titleSelectedColor:nil withStyle:style];
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray categoryIds:(NSArray *)categoryIds titleFont:(CGFloat)font
           titleColor:(UIColor *)titleColor
   titleSelectedColor:(UIColor *)selectedColor
            withStyle:(CBSegmentStyle)style {
    
//     if (style == CBSegmentStyleZoom) {
////         self.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
////         self.layer.borderWidth = 1;
//
//     }
//    set style
    if (style != 0) {
        _SegmentStyle = style;
    }
    if (font != 0) {
        _titleFont = font;
    }
    if (titleColor) {
        _titleColor = titleColor;
    }
    if (selectedColor) {
        _titleSelectedColor = selectedColor;
    }
    
    if (style == CBSegmentStyleSlider) {
//        UIView *slider = [[UIView alloc]init];
//        slider.frame = CGRectMake(0, _HeaderH-2, 0, 2);
//        slider.backgroundColor = _titleSelectedColor;
//        [self addSubview:slider];
//        self.slider = slider;
//        self.layer.borderColor = [UIColor colorWithHexString:@"f5f5f5"].CGColor;
//        self.layer.borderWidth = 1;
    }
    
    [self.titleWidthArray removeAllObjects];
    CGFloat totalWidth = 15;
    CGFloat btnSpace = 15;
    if (style == CBSegmentStyleZoom) {
        if (WIDHT==320) {
            totalWidth = 8;
            btnSpace = 8;
        }
        if (WIDHT==375) {
            totalWidth = 10;
            btnSpace = 10;
        }
        if (WIDHT==414) {
            totalWidth = 12;
            btnSpace = 12;
        }
        
    }
    for (NSInteger i = 0; i<titleArray.count; i++) {
//        cache title width
        CGFloat titleWidth = [self widthOfTitle:titleArray[i] titleFont:_titleFont];
        [self.titleWidthArray addObject:[NSNumber numberWithFloat:titleWidth]];
//        creat button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        CGFloat btnW = titleWidth+20;
        
        if (WIDHT==320) {
            btnW = titleWidth+14;
        }
        if (WIDHT==375) {
            btnW = titleWidth+18;
        }
        if (WIDHT==414) {
            btnW = titleWidth+20;
        }
       
        btn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        btn.frame =  CGRectMake(totalWidth,10, btnW, _HeaderH-20);
        btn.contentMode = UIViewContentModeCenter;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_titleColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectedColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:_titleFont]];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        
//        if (style == CBSegmentStyleZoom) {
        [btn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        btn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
//        btn.backgroundColor = mainColor;
//            btn.layer.borderWidth = 1;
        
//        }
        [btn addTarget:self action:@selector(titleButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        totalWidth = totalWidth+btnW+btnSpace;

        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
            if (_SegmentStyle == CBSegmentStyleSlider) {
                self.slider.cb_Width = titleWidth;
                self.slider.cb_CenterX = btn.cb_CenterX;
                self.selectedBtn.transform = CGAffineTransformMakeScale(1,1);
                self.selectedBtn.backgroundColor = mainColor;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else if (_SegmentStyle == CBSegmentStyleZoom) {
                self.selectedBtn.transform = CGAffineTransformMakeScale(1,1);
                self.selectedBtn.backgroundColor = mainColor;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    totalWidth = totalWidth+btnSpace;
    if (style == CBSegmentStyleZoom) {
        if (WIDHT==375) {
            self.contentSize = CGSizeMake(totalWidth*1.3, 0);
        }else {
            self.contentSize = CGSizeMake(totalWidth*1.13, 0);
        }
    }else {
        self.contentSize = CGSizeMake(totalWidth*1.03, 0);
    }
}

//  button click
- (void)titleButtonSelected:(UIButton *)btn {
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    if (self.selectedBtn == btn) {

        return;
    }
//    else {
//        self.selectedBtn.selected = NO;
//        self.selectedBtn = btn;
//        btn.selected = YES;
//    }
//    btn.selected = !btn.selected;
//    self.selectedBtn = btn;

//    if (_SegmentStyle == CBSegmentStyleSlider) {
//
//            NSNumber* sliderWidth = self.titleWidthArray[btn.tag];
//            [UIView animateWithDuration:0.2 animations:^{
//                self.slider.cb_Width = sliderWidth.floatValue;
//                self.slider.cb_CenterX = btn.cb_CenterX;
//                self.selectedBtn.transform = CGAffineTransformIdentity;
//                btn.transform = CGAffineTransformMakeScale(1, 1);
//            }];
//
//
////        if (!btn.selected) {
////            self.slider.backgroundColor = [UIColor clearColor];
////        }else {
////            self.slider.backgroundColor = mainColor;
////        }
//    }else if (_SegmentStyle == CBSegmentStyleZoom) {
   
            [UIView animateWithDuration:0.2 animations:^{
                self.selectedBtn.transform = CGAffineTransformIdentity;
                
                btn.transform = CGAffineTransformMakeScale(1, 1);
                btn.backgroundColor = mainColor;
                [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                
                self.selectedBtn.backgroundColor = [UIColor whiteColor];
                self.selectedBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
//                self.selectedBtn.layer.borderWidth = 1;
                [self.selectedBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
//                self.selectedBtn set
            }];
            
        
//    }
    self.selectedBtn = btn;
    //TODO:需分屏幕
    

    if (_categotyIds.count>5) {//数量太少不让滑动
        CGFloat offsetX = btn.cb_CenterX - self.frame.size.width*0.5;
        if (offsetX<0) {
            offsetX = 0;
        }
        if (offsetX>self.contentSize.width-self.frame.size.width) {
            if (WIDHT==320) {
                offsetX = self.contentSize.width-self.frame.size.width;
            }
            if (WIDHT==375) {
                offsetX = self.contentSize.width-self.frame.size.width;
            }
            if (WIDHT==414) {
                offsetX = self.contentSize.width-self.frame.size.width;
            }
            
        }
        
      
   
//        if (btn.tag!=self.categotyIds.count-1&&btn.tag!=self.categotyIds.count-2) {
//            [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
//        }else {
            if (WIDHT!=414) {
                [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
            }else {
                [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
            }
//        }
        
        
    }
    
    if (self.titleChooseReturn) {
        if (btn.selected) {
            self.titleChooseReturn(_categotyIds[btn.tag]);
        }else {
            self.titleChooseReturn(@"");
        }
        
    }


}
//  cache title width
- (CGFloat)widthOfTitle:(NSString *)title titleFont:(CGFloat)titleFont {
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, _HeaderH)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:titleFont] forKey:NSFontAttributeName]
                                            context:nil].size;
    return titleSize.width;
}

@end

@implementation UIView (CBViewFrame)

- (void)setCb_Width:(CGFloat)cb_Width {
    CGRect frame = self.frame;
    frame.size.width = cb_Width;
    self.frame = frame;
}

- (CGFloat)cb_Width {
    return self.frame.size.width;
}

- (void)setCb_Height:(CGFloat)cb_Height {
    CGRect frame = self.frame;
    frame.size.height = cb_Height;
    self.frame = frame;
}

- (CGFloat)cb_Height {
    return self.frame.size.height;
}

- (void)setCb_CenterX:(CGFloat)cb_CenterX {
    CGPoint center = self.center;
    center.x = cb_CenterX;
    self.center = center;
}

- (CGFloat)cb_CenterX {
    return self.center.x;
}

- (void)setCb_CenterY:(CGFloat)cb_CenterY {
    CGPoint center = self.center;
    center.y = cb_CenterY;
    self.center = center;
}

- (CGFloat)cb_CenterY {
    return self.center.y;
}
@end
