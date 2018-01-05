//
//  CBSegmentView.h
//  CBSegment
//
//  Created by 陈彬 on 2017/9/9.
//  Copyright © 2017年 com.bingo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^titleChooseBlock)(NSString *x);

typedef NS_ENUM(NSInteger, CBSegmentStyle) {
    /**
     * By default, there is a slider on the bottom.
     */
    CBSegmentStyleSlider = 0,
    /**
     * This flag will zoom the selected text label.
     */
    CBSegmentStyleZoom   = 1,
};

@interface CBSegmentView : UIScrollView

@property (nonatomic, copy) titleChooseBlock titleChooseReturn;
@property (nonatomic,strong)NSArray *categotyIds;//catId
/**
 * Set segment titles and titleColor.
 *
 * @param titleArray The titles segment will show.
 */
- (void)setTitleArray:(NSArray<NSString *> *)titleArray;

/**
 * Set segment titles and titleColor.
 *
 * @param titleArray The titles segment will show.
 * @param style The segment style.
 */
- (void)setTitleArray:(NSArray<NSString *> *)titleArray categoryIds:(NSArray *)categoryIds withStyle:(CBSegmentStyle)style ;

/**
 * Set segment titles and titleColor.
 *
 * @param titleArray The titles segment will show.
 * @param titleColor The normal title color.
 * @param selectedColor The selected title color.
 * @param style The segment style.
 */
- (void)setTitleArray:(NSArray<NSString *> *)titleArray
            titleFont:(CGFloat)font
           titleColor:(UIColor *)titleColor
   titleSelectedColor:(UIColor *)selectedColor
            withStyle:(CBSegmentStyle)style;

@end

@interface UIView (CBViewFrame)

@property (nonatomic, assign) CGFloat cb_Width;

@property (nonatomic, assign) CGFloat cb_Height;

@property (nonatomic, assign) CGFloat cb_CenterX;

@property (nonatomic, assign) CGFloat cb_CenterY;

@end
