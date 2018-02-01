//
//  YKProductDetailButtom.m
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKProductDetailButtom.h"
@interface YKProductDetailButtom()
@property (weak, nonatomic) IBOutlet UIImageView *yidai;

@property (weak, nonatomic) IBOutlet UIImageView *kefu;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@end
@implementation YKProductDetailButtom

- (void)awakeFromNib {
    [super awakeFromNib];
    [_addBtn setBackgroundColor:mainColor];
}

- (IBAction)addToShoppingCart:(id)sender {
    if (self.AddToCartBlock) {
        self.AddToCartBlock();
    }
}

- (IBAction)kefu:(id)sender {
    if (self.KeFuBlock) {
        self.KeFuBlock();
    }
}
- (IBAction)toYidai:(id)sender {
    if (self.ToSuitBlock) {
        self.ToSuitBlock();
    }
}

@end
