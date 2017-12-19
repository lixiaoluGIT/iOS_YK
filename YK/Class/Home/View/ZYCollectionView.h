//
//  ZYCollectionView.h
//  赵杨图片轮播
//
//  Created by 轶辉 on 16/10/11.
//  Copyright © 2016年 YiHui. All rights reserved.
//

#import <UIKit/UIKit.h>

// item图片的点击协议

@protocol ZYCollectionViewDelegate <NSObject>
- (void)ZYCollectionViewClick:(NSInteger)index;
@end

@interface ZYCollectionView : UIView
@property (nonatomic, strong) NSArray  * imagesArr;
@property (nonatomic, copy)   NSString * placeHolderImageName;
@property (nonatomic, weak)   id<ZYCollectionViewDelegate>delegate;
@end
