//
//  YKSelectColedgeCell.m
//  YK
//
//  Created by edz on 2018/6/5.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKSelectColedgeCell.h"

@interface YKSelectColedgeCell()
@property (weak, nonatomic) IBOutlet UILabel *colledgeName;

@end
@implementation YKSelectColedgeCell

- (void)initWithDic:(NSDictionary *)dic{
    NSString *name = dic[@"schoolName"];
    if([name rangeOfString:@"#"].location !=NSNotFound)//
    {
        name = [name stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    _colledgeName.text = name;
    _colledge = name;
    _colledgeId = dic[@"schoolId"];
}

@end
