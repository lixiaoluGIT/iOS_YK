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
    
    //去除!
    for (int i = 0; i<[_timeLable.text length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [_timeLable.text substringWithRange:NSMakeRange(i, 1)];
//        NSLog(@"string is %@",s);
        if ([s isEqualToString:@"!"]) {
            NSRange range = NSMakeRange(i, 1);
            //将字符串中的“m”转化为“w”
            _timeLable.text =   [_timeLable.text stringByReplacingCharactersInRange:range withString:@" "];
            
        }
    }
    
}

@end
