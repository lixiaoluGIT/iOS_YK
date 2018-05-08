//
//  NewDynamicsLayout.h
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/27.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynamicsModel.h"

#define kDynamicsNormalPadding 14//间距
#define kDynamicsPortraitWidthAndHeight 40//头像宽高
#define kDynamicsPortraitNamePadding 10//头像昵称间距
#define kDynamicsNameDetailPadding 8
#define kDynamicsNameHeight 17//昵称高度
#define kDynamicsMoreLessButtonHeight 30//查看全文
#define kDynamicsSpreadButtonHeight 20
#define kDynamicsGrayBgHeight 51
#define kDynamicsGrayPicHeight 45
#define kDynamicsGrayPicPadding 3
#define kDynamicsThumbTopPadding 10


#define kDynamicsLineSpacing 5

typedef void(^ClickUserBlock)(NSString * userID);
typedef void(^ClickUrlBlock)(NSString * url);
typedef void(^ClickPhoneNumBlock)(NSString * phoneNum);

@interface NewDynamicsLayout : NSObject

@property(nonatomic,strong)DynamicsModel * model;

@property(nonatomic,strong)YYTextLayout * detailLayout;
@property(nonatomic,assign)CGSize photoContainerSize;
@property(nonatomic,strong)YYTextLayout * dspLayout;
@property(nonatomic,strong)YYTextLayout * thumbLayout;
@property(nonatomic,strong)NSMutableArray * commentLayoutArr;
@property(nonatomic,assign)CGFloat thumbHeight;
@property(nonatomic,assign)CGFloat commentHeight;
@property(nonatomic,assign)CGFloat thumbCommentHeight;
@property(nonatomic,copy)ClickUserBlock clickUserBlock;
@property(nonatomic,copy)ClickUrlBlock clickUrlBlock;
@property(nonatomic,copy)ClickPhoneNumBlock clickPhoneNumBlock;

@property(nonatomic,assign)CGFloat height;

- (instancetype)initWithModel:(DynamicsModel *)model;
- (void)resetLayout;

@end
