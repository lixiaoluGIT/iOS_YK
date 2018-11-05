//
//  YKTag.m
//  YK
//
//  Created by edz on 2018/10/29.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKTag.h"

@implementation YKTag

- (instancetype)initWithId:(NSInteger)oId name:(NSString *)name
{
    if(self = [super init]){
        self.objId = oId;
        self.name = name;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if(!object || ![object isKindOfClass:[self class]]){
        return NO;
    }
    YKTag *otherTag = (YKTag *)object;
    return self.objId == otherTag.objId && [self.name isEqualToString:otherTag.name];
}

- (NSString *)description
{
    return self.name;
}

@end
