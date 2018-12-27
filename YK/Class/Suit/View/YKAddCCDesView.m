//
//  YKAddCCDesView.m
//  YK
//
//  Created by edz on 2018/8/30.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKAddCCDesView.h"

@implementation YKAddCCDesView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)but:(id)sender {
    if (self.buyBlock) {
        self.buyBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
