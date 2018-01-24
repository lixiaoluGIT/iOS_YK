//
//  YKSuitVC.h
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSuitVC : UIViewController
{
    NSMutableArray* _dataArray;
    int _selectRow;
    NSMutableArray* _mulitSelectArray;
}

@property (nonatomic,assign)BOOL isFromeProduct;
@end
