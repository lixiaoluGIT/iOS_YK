//
//  YKChooser.h
//  YK
//
//  Created by edz on 2018/10/29.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MoreTagsChooserDelegate;

@interface YKChooser : UIView
@property(nonatomic,weak)id<MoreTagsChooserDelegate>delegate;
@property(nonatomic,assign) CGFloat    bottomHeight;   ///< 指定白色背景高度
@property(nonatomic,assign) NSInteger  maxSelectCount; ///< 最多可选择数量

@property (nonatomic,strong) UICollectionView  *myCollectionView;

@property (nonatomic, assign) NSInteger currentTag;

-(instancetype)initWithBottomHeight:(CGFloat)bHeight
                     maxSelectCount:(CGFloat)maxCount
                           delegate:(id<MoreTagsChooserDelegate>)aDelegate WithView:(UIView *)view;

/**
 刷新
 
 @param tags 原数据。包含多个数组对象的数组，决定有几个section
 @param selectedTags 已选择的数据:总数据
 
 */
//@property(nonatomic, copy) void(^moreSelectedCallback)(NSArray *tags, NSInteger DaysToOpenLow,NSInteger DaysToOpenhigh,NSArray *roomTypes,NSArray *SaleStatus,NSInteger AreaLow,NSInteger AreaHigh,NSArray *YearLimits,NSArray *BuildingType);

-(void)refreshWithTags:(id)tags
           keyTitleArr:(NSArray *)keyTitleArr
          selectedTags:(NSArray *)selectedTags
                 nTags:(NSArray *)nTags
           nSaleStatus:(NSArray *)nSaleStatus
           nBuildTypes:(NSArray *)nBuildTypes
            nRoomTypes:(NSArray *)nRoomTypes
            nDayToOpen:(NSArray *)nDayToOpen
                nYears:(NSArray *)nYears
                nAreas:(NSArray *)nAreas;

- (void)showInView;
- (void)dismiss;

@end


//代理
@protocol MoreTagsChooserDelegate <NSObject>

//选中的传过去
- (void)moreTagsChooser:(YKChooser *)sheet
           selectedTags:(NSArray *)sTags
                  nTags:(NSArray *)nTags
            nSaleStatus:(NSArray *)nSaleStatus
            nBuildTypes:(NSArray *)nBuildTypes
             nRoomTypes:(NSArray *)nRoomTypes
             nDayToOpen:(NSArray *)nDayToOpen
                 nYears:(NSArray *)nYears
                 nAreas:(NSArray *)nAreas;

//重置传空值
- (void)resetmoreTagsChooser:(YKChooser *)sheet
                selectedTags:(NSArray *)sTags
                       nTags:(NSArray *)nTags
                 nSaleStatus:(NSArray *)nSaleStatus
                 nBuildTypes:(NSArray *)nBuildTypes
                  nRoomTypes:(NSArray *)nRoomTypes
                  nDayToOpen:(NSArray *)nDayToOpen
                      nYears:(NSArray *)nYears
                      nAreas:(NSArray *)nAreas;
@end

#pragma mark---标签cell
@interface newMoreCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *textLabel;

- (void)refreshWithObject:(NSObject *)obj;
@end
