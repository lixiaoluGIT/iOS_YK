//
//  YKFashionRecView.h
//  YK
//
//  Created by edz on 2018/11/7.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKFashionRecView : UIView

@property (nonatomic,strong)NSArray *imageArray;
@property (nonatomic,copy)void (^toDetailBlock)(NSString *linkUrl);

@end
