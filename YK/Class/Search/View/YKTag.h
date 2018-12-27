//
//  YKTag.h
//  YK
//
//  Created by edz on 2018/10/29.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKTag : NSObject
@property(nonatomic,assign)NSInteger objId;//id
@property(nonatomic,assign)NSInteger parentId;//父类id
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)BOOL selected;///< default is NO

- (instancetype)initWithId:(NSInteger)oId parentId:(NSInteger)parentId name:(NSString *)name;

@end
