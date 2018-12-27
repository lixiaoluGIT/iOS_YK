//
//  YKBuyTypeCell.h
//  YK
//
//  Created by Macx on 2018/12/26.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKBuyTypeCell : UITableViewCell
 @property (nonatomic,copy)void (^selectPayBlock)(payMethod payMethod);

@end
