//
//  ZYCollectionViewCell.h
//  赵杨图片轮播
//
//  Created by 轶辉 on 16/10/11.
//  Copyright © 2016年 YiHui. All rights reserved.
//



/*
 加载的是网络图片，如果加载的是本地图片，直接修改一下imagesUrl的setter方法就好
 */

#import <UIKit/UIKit.h>

@interface ZYCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, copy) NSString * placeHolderImageName;
@property (nonatomic, copy) NSString * imagesUrl;
@end
