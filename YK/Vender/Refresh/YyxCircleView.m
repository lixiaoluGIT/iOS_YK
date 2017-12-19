//
//  CircleView.m
//  Demo8
//
//  Created by Leon on 11/15/13.
//  Copyright (c) 2013 Leon. All rights reserved.
//

#import "YyxCircleView.h"

@implementation YyxCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setProgress:(double)progress{
    if (progress >= 1) {
        progress = 1;
    }
    _progress = progress;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextSetLineWidth(context, 0.7);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
   
    CGFloat startAngle =  M_PI * 1.5;
    CGFloat step = - M_PI *self.progress;
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, self.bounds.size.width/2-2, startAngle, startAngle+step, 1);
    CGContextStrokePath(context);
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, self.bounds.size.width/2-2, startAngle, startAngle-step, 0);
    CGContextStrokePath(context);
    
    
    CGContextSetLineWidth(context, 3.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context,self.frame.size.width,self.frame.size.height);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, 0, self.frame.size.height);
    CGContextAddLineToPoint(context,self.frame.size.width,0);
    CGContextStrokePath(context);
     
    
}

@end
