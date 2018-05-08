//
//  YKCommunityVC.h
//  YK
//
//  Created by LXL on 2018/3/7.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKCommunityVC : UIViewController

@property(nonatomic,copy)NSString * dynamicsUserId;
@property(nonatomic,strong)UITableView * dynamicsTable;
@property(nonatomic,strong)NSMutableArray * layoutsArr;
@property(nonatomic,copy)NSString * toUserName;
@property(nonatomic,assign)NSIndexPath * commentIndexPath;
@property(nonatomic,strong)UITextField * commentInputTF;

@end
