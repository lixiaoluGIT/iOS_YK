//
//  NSString+textStringToSize.h
//  logisticsInfo
//
//  Created by My Mac on 2017/6/8.
//  Copyright © 2017年 MyMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (textStringToSize)

//对象方法
-(CGSize) sizeOfTextWithMaxSize:(CGSize)maxSize font:(UIFont *)font;

//类方法
+(CGSize) sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font;


@end
