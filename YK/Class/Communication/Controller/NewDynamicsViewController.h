//
//  NewDynamicsViewController.h
//  LooyuEasyBuy
//
//  Created by LXL on 2018/5/3.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefresh.h"
//#import "XMChatBar.h"


@interface NewDynamicsViewController : UIViewController
{
    CGFloat lastContentOffset;
    UIButton *publicBtn;
    BOOL isReporting;
}

@property(nonatomic,copy)NSString * dynamicsUserId;
@property(nonatomic,strong)UITableView * dynamicsTable;
@property(nonatomic,strong)NSMutableArray * layoutsArr;
@property(nonatomic,copy)NSString * toUserName;
@property(nonatomic,assign)NSIndexPath * commentIndexPath;
@property(nonatomic,strong)UITextField * commentInputTF;

@property(nonatomic,strong)UIView *background;



@end
