//
//  YKReturnView.m
//  YK
//
//  Created by LXL on 2017/11/29.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKReturnView.h"

@interface YKReturnView()

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@end
@implementation YKReturnView

- (void)awakeFromNib {
    [super awakeFromNib];
    _timeLable.text = @"请选择";
}

- (void)setTime:(NSString *)time{
    _time = time;
    _timeLable.text = time;
}

@end
