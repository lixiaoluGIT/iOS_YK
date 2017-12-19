//
//  YKMineBagCell.m
//  YK
//
//  Created by LXL on 2017/11/16.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKMineBagCell.h"
@interface YKMineBagCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Leftmargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TightMargin;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@end
@implementation YKMineBagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat margin = 45*WIDHT/414;
    CGFloat gap = 65*WIDHT/414;
    self.Leftmargin.constant = margin;
    self.TightMargin.constant = margin;
    self.gap1.constant = gap;
    self.gap2.constant = gap;
    self.gap3.constant = gap;
    
    //self.userInteractionEnabled = NO;
//    self.image1.userInteractionEnabled = YES;
//    self.lable1.userInteractionEnabled = YES;
//    self.image2.userInteractionEnabled = YES;
//    self.label2.userInteractionEnabled = YES;
//    self.image3.userInteractionEnabled = YES;
//    self.label3.userInteractionEnabled = YES;
//    self.image4.userInteractionEnabled = YES;
//    self.label4.userInteractionEnabled = YES;

    
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click1)];
    [self.image1 addGestureRecognizer:tap1];
    [self.lable1 addGestureRecognizer:tap1];
    tap1.numberOfTouchesRequired = 1; //手指数
    tap1.numberOfTapsRequired = 1; //tap次数
    
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click2)];
    [self.image2 addGestureRecognizer:tap2];
    [self.label2 addGestureRecognizer:tap2];
    tap2.numberOfTouchesRequired = 1; //手指数
    tap2.numberOfTapsRequired = 1; //tap次数
    
    UITapGestureRecognizer *tap3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click3)];
    [self.image3 addGestureRecognizer:tap3];
    [self.label3 addGestureRecognizer:tap3];
    tap3.numberOfTouchesRequired = 1; //手指数
    tap3.numberOfTapsRequired = 1; //tap次数
    UITapGestureRecognizer *tap4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click4)];
    [self.image4 addGestureRecognizer:tap4];
    [self.label4 addGestureRecognizer:tap4];
    tap4.numberOfTouchesRequired = 1; //手指数
    tap4.numberOfTapsRequired = 1; //tap次数

}

- (void)click1{
    if (self.scanBlock) {
        self.scanBlock(100);
    }
}
- (void)click2{
    if (self.scanBlock) {
        self.scanBlock(101);
    }
}
- (void)click3{
    if (self.scanBlock) {
        self.scanBlock(102);
    }
}
- (void)click4{
    if (self.scanBlock) {
        self.scanBlock(103);
    }
}
- (IBAction)btn3:(id)sender {
    [self click3];
}

- (IBAction)btn1:(id)sender {
    [self click1];
}
- (IBAction)btn2:(id)sender {
    [self click2];
}
- (IBAction)btn4:(id)sender {
    [self click4];
}

@end
