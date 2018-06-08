//
//  YKCommunicationImageView.h
//  YK
//
//  Created by edz on 2018/6/7.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKCommunicationImageView : UIScrollView

@property (nonatomic, strong) NSArray *picPathStringsArray;

@property (nonatomic, strong) UIViewController * superView;
@property (nonatomic, assign) int customImgWidth;
@property (nonatomic, strong) UIScrollView *scrollView;

+ (CGSize)getContainerSizeWithPicPathStringsArray:(NSArray *)picPathStringsArray;
@end
