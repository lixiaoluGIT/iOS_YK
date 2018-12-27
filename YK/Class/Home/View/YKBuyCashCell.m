//
//  YKBuyCashCell.m
//  YK
//
//  Created by Macx on 2018/12/26.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKBuyCashCell.h"

@interface YKBuyCashCell()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end
@implementation YKBuyCashCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPrice:(NSString *)price{
    _price = price;
    _priceLabel.text = [NSString stringWithFormat:@"¥ %@",price];
}

@end
