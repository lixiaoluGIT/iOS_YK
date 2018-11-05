//
//  YKFilterView.h
//  YK
//
//  Created by edz on 2018/10/29.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "GetNewFilterOutPutDto.h"

@interface YKFilterView : UIView


//商圈回调,返回所点的角标以及点击的内容
@property(nonatomic, copy) void(^didSelectedCallback)(NSString *circleId, NSString * content, NSInteger tag);
//均价回调
@property(nonatomic, copy) void(^priceSelectedCallback)(NSInteger high, NSInteger low);
//更多回调
@property(nonatomic, copy) void(^moreSelectedCallback)(NSArray *tags, NSInteger DaysToOpenLow,NSInteger DaysToOpenhigh,NSArray *roomTypes,NSArray *SaleStatus,NSInteger AreaLow,NSInteger AreaHigh,NSArray *YearLimits,NSArray *BuildingType);

/// 数据源 数据, 下拉列表的内容数组.
@property(nonatomic, strong) NSMutableArray * arrMDataSource;
/// 数据源 数据, 下拉列表的内容字典
@property(nonatomic, strong) NSMutableDictionary * dicMDataSource;
// 数据源  下拉列表的所有数据

@property (nonatomic, strong) NSMutableArray *businessCircles;  // 新房商圈名字数组
@property (nonatomic, strong) NSMutableArray *housePrices;  // 新房均价数组(存着模型)

// tableview以及cell的背景色, 如果不设置默认白色
@property(nonatomic, strong) UIColor * tabColor;
// 文字的颜色, 默认黑色
@property(nonatomic, strong) UIColor * txtColor;

@property (nonatomic, assign) CGFloat menuHeight;

// 传递数据

- (void) setDataWithSelectType:(NSString *)type AndSelectTag:(NSInteger)tag;
- (void)setDataSource:(id)dataSource Tag:(NSInteger)tag;

- (void)showDropDownWithTag:(NSInteger)tag; // 显示下拉菜单
- (void)hideDropDown; // 隐藏下拉菜单

/*******************************************************************************/
//newhouse新房页面
@property(nonatomic, strong) GetNewFilterOutPutDto *houseFilterOutPutDto;
//初始化数据
- (void)initDataSourseWithType:(NSString *)type AndSelectTag:(NSInteger)tag;
//切换城市和住宅类型时刷新商圈和均价数组
- (void)resetDataWithbusinessCircles:(NSMutableArray *)businessCircles housePrices:(NSMutableArray *)housePrices;

@property (assign, nonatomic) NSIndexPath *selIndex;//商圈类型单选，当前选中的行
//商圈
@property (nonatomic, strong) UITableView * menuTableView;
@end
