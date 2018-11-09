//
//  YKCartHeader.h
//  YK
//
//  Created by edz on 2018/11/9.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKCartHeader : UITableViewCell

@property (nonatomic,assign)BOOL isHadCC;
@property (nonatomic,copy)void (^btnAction)(BOOL isHadCC);
@end
