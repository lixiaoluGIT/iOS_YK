//
//  YKScrollView.h
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKScrollView : UITableViewCell

@property (nonatomic,strong)NSMutableArray *brandArray;//数据源
@property (nonatomic,copy)void (^clickALLBlock)(void);
@property (nonatomic,copy)void (^toDetailBlock)(NSString *brandId,NSString *brandName);
- (void)resetUI;
@end
