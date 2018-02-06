//
//  YKAddAddressCell.m
//  YK
//
//  Created by LXL on 2017/11/16.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKAddAddressCell.h"
@interface YKAddAddressCell()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
@implementation YKAddAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.addBtn.layer.masksToBounds = YES;
//    self.addBtn.layer.cornerRadius = self.addBtn.frame.size.height/2;
    [self.addBtn setUserInteractionEnabled:NO];
}


@end
