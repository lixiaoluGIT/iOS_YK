//
//  SteyUtil.m
//  STEY
//
//  Created by winter on 2017/11/10.
//  Copyright © 2017年 beyondsoft. All rights reserved.
//

#import "SteyUtil.h"

@implementation SteyUtil
+ (NSData *)imageData:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    return data;
}
@end
