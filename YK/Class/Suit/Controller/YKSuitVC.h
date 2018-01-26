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
    NSMutableArray * _mulitSelectArray;//选中预定的商品数组
    NSMutableArray *selectDeArray;//选中删除的商品数组
}

@property (nonatomic,assign)BOOL isFromeProduct;
@end
