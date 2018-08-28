//
//  YKHomeActivityView.h
//  YK
//
//  Created by edz on 2018/8/27.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKHomeActivityView : UITableViewCell

@property (nonatomic,strong)NSArray *imageArray;
@property (nonatomic,copy)void (^toDetailBlock)(NSString *linkUrl);
@end
