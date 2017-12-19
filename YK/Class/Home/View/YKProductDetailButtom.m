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
@end
@implementation YKProductDetailButtom

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)addToShoppingCart:(id)sender {
    if (self.AddToCartBlock) {
        self.AddToCartBlock();
    }
}


@end
