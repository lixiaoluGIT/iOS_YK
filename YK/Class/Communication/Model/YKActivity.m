//
//  YKActivity.m
//  YK
//
//  Created by edz on 2018/6/14.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKActivity.h"

@implementation YKActivity

- (void)initWithDic:(NSDictionary *)dic{
    _activityId = dic[@"activityId"];
    _activityTitle = dic[@"activityTitle"];
    _activityExplain = dic[@"activityExplain"];
    _exampleDiagram = dic[@"exampleDiagram"];
}

@end
