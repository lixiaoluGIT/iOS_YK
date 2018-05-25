//
//  YKBaseScrollView.h
//  YK
//
//  Created by LXL on 2018/3/13.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

// item图片的点击协议

@protocol YKBaseScrollViewDelete <NSObject>
- (void)YKBaseScrollViewImageClick:(NSInteger)index;
@end

@interface YKBaseScrollView : UIView
@property (nonatomic, weak) id<YKBaseScrollViewDelete>delegate;
@property (nonatomic, strong) NSArray  * imagesArr;
@property (nonatomic, strong) NSArray  * imageClickUrls;
@end


