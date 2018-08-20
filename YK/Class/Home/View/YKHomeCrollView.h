//
//  YKHomeCrollView.h
//  YK
//
//  Created by edz on 2018/8/20.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKHomeCrollView : UITableViewCell

- (void)initWithType:(NSInteger)type productList:(NSArray *)productList OnResponse:(void (^)(void))onResponse;

@property (nonatomic,copy)void (^toAllBlock)(void);

@end
