//
//  dractLineTwoCell.m
//  ExcelViewDemol
//
//  Created by QZDelog on 16/11/24.
//  Copyright © 2016年 chedaye. All rights reserved.
//

#import "dractLineTwoCell.h"

@implementation dractLineTwoCell

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawForm];

    
}

//- (void)setTitleArr:(NSArray *)titleArr{
//    _titleArr = titleArr;
//    [self setTitle];
//}
- (void)setTitleRow:(NSInteger)row{
    
    UILabel *ba = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, WIDHT-40, 30)];
   
    if (row==0) {
        ba.backgroundColor = mainColor;
        [self addSubview:ba];
    }
    
    
    for (int i = 0; i < _titleArr.count; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20*WIDHT/414 + (WIDHT-20*2)/_titleArr.count*i, 0, 60, 30)];
        label.text = _titleArr[i];
        label.textColor = mainColor;
        label.font = PingFangSC_Regular(14);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        if (row==0) {
            label.textColor = [UIColor whiteColor];
            label.font = PingFangSC_Semibold(14);
        }
        
        
    }
}

- (void)drawForm
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置区域背景色
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddRect(context, CGRectMake(20, 0, WIDHT-40  ,70 ));
    CGContextFillPath(context);
    
    //先画外层大矩形框
    CGContextSetStrokeColorWithColor(context, mainColor.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    //第一条线起点point
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, 20, 0);
    //第一条线终点point
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity,  WIDHT- 20, 0 );
    //第二条线终点point
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, WIDHT - 20,   30 );
    //第二条线起点point
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, 20,  30 );
    //第一条线起点point
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, 20,  0 );
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
    //画中间竖线
    for (int i = 1; i < _titleArr.count; i++) {
        CGMutablePathRef verticalPath = CGPathCreateMutable();
        CGPathMoveToPoint(verticalPath, &CGAffineTransformIdentity, 15 + (WIDHT-15*2)/_titleArr.count*i,0 );
        CGPathAddLineToPoint(verticalPath, &CGAffineTransformIdentity, 15 + (WIDHT-15*2)/_titleArr.count*i,  30);
        CGContextAddPath(context, verticalPath);
        CGContextStrokePath(context);
    }
//    //画标题文字
//
//    for (int i = 0; i < _titleArr.count; i++) {
//
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20*WIDHT/414 + (WIDHT-20*2)/_titleArr.count*i, 0, 60, 30)];
//        label.text = _titleArr[i];
//        label.textColor = mainColor;
//        label.font = PingFangSC_Regular(14);
//        label.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:label];
////        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
////        paragraphStyle.alignment = NSTextAlignmentCenter;
////
////        UIFont * font = [UIFont systemFontOfSize:14];
////        NSDictionary * dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
////        [_titleArr[i] drawInRect:CGRectMake( 15*WIDHT/414 + (WIDHT-15*2)/_titleArr.count*i, 5 , 60, 30) withAttributes:dic];
//    }
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
