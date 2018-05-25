//
//  YKBrandDetailHeader.h
//  YK
//
//  Created by LXL on 2017/11/23.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKBrand.h"

@interface YKBrandDetailHeader : UITableViewCell

@property (nonatomic,strong)YKBrand *brand;
@property (nonatomic,strong)NSString *labelText;
@property (nonatomic,assign)CGFloat Lheight;
- (CGFloat)lableHeight;

@end
