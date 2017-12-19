//
//  ChangeFontWithButton.m
//  yoli
//
//  Created by 冷求慧 on 16/11/24.
//  Copyright © 2016年 Leng. All rights reserved.
//

#import "ChangeFontWithButton.h"

@implementation ChangeFontWithButton
-(void)setCusFont:(UIFont *)cusFont{
    if (cusFont) {
        self.titleLabel.font=[cusFont fontWithSize:cusFont.pointSize*titleRatio];
//        NSLogLeng(@"传进来Button的大小:%f 最终字体的大小:%f",cusFont.pointSize,self.titleLabel.font.pointSize);
    }
}
@end
