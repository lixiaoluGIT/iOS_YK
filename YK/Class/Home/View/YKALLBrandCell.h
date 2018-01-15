//
//  YKALLBrandCell.h
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKALLBrandCell : UITableViewCell
@property (nonatomic) NSString *brandId;
@property (nonatomic,strong)NSString *brandName;
- (void)initWithDictionary:(NSDictionary *)dic;
@end
