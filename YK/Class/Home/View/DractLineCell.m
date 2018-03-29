//
//  DractLineCell.m
//  ExcelViewDemol
//
//  Created by QZDelog on 16/11/24.
//  Copyright © 2016年 chedaye. All rights reserved.
//

#import "DractLineCell.h"


@implementation DractLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawForm];
    


}

- (void)drawForm
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置区域背景色
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddRect(context, CGRectMake(0, 10, WIDHT  , 100));
    CGContextFillPath(context);
    
    //先画外层大矩形框
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    //第一条线起点point
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, 15, 25 );
    //第一条线终点point
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity,  WIDHT- 15, 25 );
    //第二条线终点point
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, WIDHT - 15,  25 + 30*2 );
    //第二条线起点point
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, 15,  25 + 30*2 );
    //第一条线起点point
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, 15,  25 );
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    //画中间竖线
    for (int i =0; i<2; i++) {
        CGMutablePathRef verticalPath = CGPathCreateMutable();
        CGPathMoveToPoint(verticalPath, &CGAffineTransformIdentity, 15 + (WIDHT-15*2)/3 *(i+1), 25 );
        CGPathAddLineToPoint(verticalPath, &CGAffineTransformIdentity, 15 + (WIDHT-15*2)/3*(i+1),  25 + 30 *2);
        CGContextAddPath(context, verticalPath);
        CGContextStrokePath(context);
    }

    
    //画中间的横线
        CGMutablePathRef horizontalPath = CGPathCreateMutable();
        CGPathMoveToPoint(horizontalPath, &CGAffineTransformIdentity, 15, 25  + 30);
        CGPathAddLineToPoint(horizontalPath, &CGAffineTransformIdentity, WIDHT - 15, 25 + 30);
        CGContextAddPath(context, horizontalPath);
        CGContextStrokePath(context);
    
    //画标题文字
    NSArray * titleArr = @[ @"借款时间", @"金额", @"还款方式" ];
    NSArray *detailArr = @[@"2016-3-12",@"2万",@"信用卡"];
    for (int i = 0; i < 3; i++) {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        UIFont * font = [UIFont systemFontOfSize:14];
        NSDictionary * dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        [titleArr[i] drawInRect:CGRectMake(15 + 120*i ,  10 + 25, 120, 30) withAttributes:dic];
    }
    
    //画内容文字
    for (int i = 0; i < 3; i++) {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        UIFont * font = font = [UIFont systemFontOfSize:14];
        NSDictionary * dic = @{ NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle };
        
        [detailArr[i] drawInRect:CGRectMake(15 + 120*i, 10 + 50, 120, 30) withAttributes:dic];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
