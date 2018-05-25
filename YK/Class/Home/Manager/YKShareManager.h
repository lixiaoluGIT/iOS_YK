//
//  YKShareManager.h
//  YK
//
//  Created by LXL on 2018/3/19.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKShareManager : NSObject

+ (YKShareManager *)sharedManager;
- (void)YKShareProductClothingId:(NSString *)ClothingId;
@end
