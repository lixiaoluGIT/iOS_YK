//
//  YKActivityDetailVC.h
//  YK
//
//  Created by edz on 2018/6/14.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKBaseVC.h"
#import "YKActivity.h"

@interface YKActivityDetailVC : YKBaseVC

@property (nonatomic,strong)YKActivity *activity;
@property(nonatomic,strong)UITableView * dynamicsTable;
@property(nonatomic,strong)NSMutableArray * layoutsArr;
@end
