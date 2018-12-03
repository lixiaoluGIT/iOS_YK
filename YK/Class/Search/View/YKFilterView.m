//
//  YKFilterView.m
//  YK
//
//  Created by edz on 2018/10/29.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKFilterView.h"
#import "YKTag.h"
#import "YKChooser.h"

@interface YKFilterView()<MoreTagsChooserDelegate>

{
    NSMutableArray *selectedTags;//选中的标签
    
    NSMutableArray *types;//品类
    NSMutableArray *seasons;//季节
    NSMutableArray *colors;//颜色
    NSMutableArray *openTimes;//上新时间
    NSMutableArray *hotTags;//热门标签
    NSMutableArray *styles;//风格
    NSMutableArray *elements;//元素
}
@property (nonatomic, strong) NSMutableDictionary *moreMDic;  // 标签字典数据
@property (nonatomic, strong) NSMutableDictionary *houseMoreMDic;  // 选衣筛选更多
@property (nonatomic, strong) UIView *effectView; // 透明遮罩黑涂层
// 标签选择器页面
@property (nonatomic, strong) YKChooser *chooser;
@end

@implementation YKFilterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    selectedTags = [NSMutableArray array];
    
    
    types = [NSMutableArray array];
    seasons = [NSMutableArray array];
    colors = [NSMutableArray array];
    openTimes = [NSMutableArray array];
    hotTags = [NSMutableArray array];
    styles = [NSMutableArray array];
    elements = [NSMutableArray array];

    //    _constructionAreaMArray = [NSMutableArray array];
    _moreMDic = [NSMutableDictionary dictionary];
    
    self.backgroundColor = [UIColor clearColor];
    
    _effectView = [[UIView alloc] init];
    
    _effectView.frame = CGRectMake(0, 0, 0, HEIGHT);
    
    _effectView.backgroundColor = [UIColor blackColor];
    
    _effectView.alpha = 0.6;
    
    [self addSubview:_effectView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [_effectView addGestureRecognizer:singleTap];
    
    [self addSubview:self.menuTableView];
    
    _chooser = [[YKChooser alloc]initWithBottomHeight:500 maxSelectCount:100 delegate:self WithView:self];
    _chooser.backgroundColor = [UIColor whiteColor];
    
}

- (void)setHouseFilterOutPutDto:(GetNewFilterOutPutDto *)houseFilterOutPutDto{
    _houseFilterOutPutDto = houseFilterOutPutDto;
}

// 点击非选择区域, 回收选项标签
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    //组装数据
    //遍历标签数组，拿到选中的key
    
    //品类
    NSMutableArray *postTypes = [NSMutableArray array];
    for (YKTag *tag in [YKSearchManager sharedManager].categorys) {
        [postTypes addObject:@(tag.objId)];
    }
    
    //季节
    NSMutableArray *postSeasons = [NSMutableArray array];
    for (YKTag *tag in [YKSearchManager sharedManager].seasons) {
        [postSeasons addObject:@(tag.objId)];
    }
    //颜色
    NSMutableArray *postColors = [NSMutableArray array];
    for (YKTag *tag in [YKSearchManager sharedManager].colors) {
        [postColors addObject:@(tag.objId)];
    }
    //上新时间
    
    NSMutableArray *postOpenTimes = [NSMutableArray array];
    for (YKTag *tag in [YKSearchManager sharedManager].times) {
        [postOpenTimes addObject:@(tag.objId)];
    }
    //热门标签
    NSMutableArray *postHotTags = [NSMutableArray array];
    for (YKTag *tag in [YKSearchManager sharedManager].categorys) {
        [postHotTags addObject:@(tag.objId)];
    }
    //风格
    NSMutableArray *postStyles = [NSMutableArray array];
    for (YKTag *tag in [YKSearchManager sharedManager].styles) {
        [postStyles addObject:@(tag.objId)];
    }
    //元素
    NSMutableArray *postElements = [NSMutableArray array];
    for (YKTag *tag in [YKSearchManager sharedManager].elements) {
        [postElements addObject:@(tag.objId)];
    }
    
 NSLog(@"%@%@%@%@%@%@%@",postTypes,postColors,postStyles,postSeasons,postHotTags,postElements,postOpenTimes);
    //
    if (self.moreSelectedCallback) {
        self.moreSelectedCallback(postTypes, postSeasons, postOpenTimes, postColors, postHotTags, postStyles, postElements);
    }
    
    
    if (self.didSelectedCallback) {
        self.didSelectedCallback(@"888", @"888", self.tag);
    }
    
    [self hideDropDown];
    
}

//刷数据和界面
- (void)initDataSourseWithType:(NSString *)type AndSelectTag:(NSInteger)tag{
  
    //组装标签界面模型
    self.houseMoreMDic = [NSMutableDictionary dictionary];
    [self.houseMoreMDic setObject:self.houseFilterOutPutDto.categoryList forKey:@"品类"];
    [self.houseMoreMDic setObject:self.houseFilterOutPutDto.seasonList forKey:@"季节"];
    [self.houseMoreMDic setObject:self.houseFilterOutPutDto.colourList forKey:@"颜色"];
    [self.houseMoreMDic setObject:self.houseFilterOutPutDto.timeList forKey:@"上新时间"];
//    [self.houseMoreMDic setObject:self.houseFilterOutPutDto.labelList forKey:@"热门标签"];
    [self.houseMoreMDic setObject:self.houseFilterOutPutDto.styleList forKey:@"风格"];
    [self.houseMoreMDic setObject:self.houseFilterOutPutDto.elementList forKey:@"元素"];
    
 
        _dicMDataSource = self.houseMoreMDic;
        if (_dicMDataSource.count != 0) {
            [self refreshHouseDataWithData:_dicMDataSource WithTag:tag];
        }
    
}

- (void)refreshHouseDataWithData:(id)array WithTag:(NSInteger)tag{
   
        NSMutableDictionary *orignDataMDic = [NSMutableDictionary dictionary];
        NSMutableArray *keyTitleArray = [NSMutableArray array];
        
        if (_dicMDataSource.count != 0) {
            
            [keyTitleArray addObjectsFromArray:_dicMDataSource.allKeys];
            
            for (NSString *str in _dicMDataSource.allKeys) {
                
                NSArray *tags = (NSArray *)[_dicMDataSource objectForKey:str];
                
                NSInteger index = tags.count;
                
                NSMutableArray *testTags0 = [NSMutableArray arrayWithCapacity:tags.count];
                
                if ([str isEqualToString:@"品类"]) {
                    
                    for(NSInteger i = 0; i < index; i++){
                        
                        category *ca = tags[i];
                        NSString *str = [NSString string];
                        
                        str = ca.categoryName;
                        
                        YKTag *tag = [[YKTag alloc]initWithId:ca.categoryId name:str];
                        
                        [testTags0 addObject:tag];
                    }
                    
                    
                } else if ([str isEqualToString:@"季节"]) {
                    
                    for(NSInteger i = 0; i < index; i++){
                        
                        season *se = tags[i];
                        
                        NSString *str = [NSString string];
                        
                        str = se.seasonName;
                        
                       YKTag *tag = [[YKTag alloc]initWithId:se.seasonId name:str];
                        
                        [testTags0 addObject:tag];
                    }
                    
                } else if ([str isEqualToString:@"颜色"]) {
                    for(NSInteger i = 0; i < index; i++){
                        
                        color *co = tags[i];
                        
                        NSString *str = [NSString string];
                        
                        str = co.colourName;
                        
                       YKTag *tag = [[YKTag alloc]initWithId:co.colourId name:str];
                        
                        [testTags0 addObject:tag];
                        
                    }
                } else if ([str isEqualToString:@"上新时间"]) {
                    
                    for(NSInteger i = 0; i < index; i++){
                        
                        updateDay *up = tags[i];

                        NSString *str = [NSString string];
                        
                        str = up.label;
                        //
//                        YKTag *tag;
//                        if (i==0) {
//                           tag = [[YKTag alloc]initWithId:1 name:@"7天内"];
//                        }
//                        if (i==1) {
//                            tag = [[YKTag alloc]initWithId:1 name:@"30天内"];
//                        }
                        
                        YKTag *tag = [[YKTag alloc]initWithId:(up.day) name:str];
                        
                        [testTags0 addObject:tag];
                    }
                    
                } else if ([str isEqualToString:@"热门标签"]) {
                    for(NSInteger i = 0; i < index; i++){
                        
                        Tag *t = tags[i];
                        
                        NSString *str = [NSString string];
                        
                        str = t.labelName;
                        
                       YKTag *tag = [[YKTag alloc]initWithId:t.labelId name:str];
                        
                        [testTags0 addObject:tag];
                    }
                } else if ([str isEqualToString:@"风格"]) {
                    for(NSInteger i = 0; i < index; i++){
                        
                        style *st = tags[i];
                        
                        NSString *str = [NSString string];
                        
                        str = st.styleName;
                        
                      YKTag *tag = [[YKTag alloc]initWithId:st.styleId name:str];
                        
                        [testTags0 addObject:tag];
                        
                    }
                } else if ([str isEqualToString:@"元素"]) {
                    for(NSInteger i = 0; i < index; i++){
                        
                        element *el = tags[i];
                        
                        NSString *str = [NSString string];
                        
                        str = el.elementName;
                        
                        YKTag *tag = [[YKTag alloc]initWithId:el.elementId name:str];
                        
                        [testTags0 addObject:tag];
                        
                    }
                }
                
                
                [orignDataMDic setObject:testTags0 forKey:str];
                
            
        }
        
        _chooser.currentTag = 20003 - 20000;
        
        NSArray *arrTemp;
        
        arrTemp = @[@"品类", @"季节", @"上新时间",@"颜色",@"风格",@"元素"];
        
            NSLog(@"选中的biao qian%@",selectedTags);
        [_chooser refreshWithTags:orignDataMDic keyTitleArr:arrTemp selectedTags:selectedTags nTags:types nSaleStatus:seasons nBuildTypes:colors nRoomTypes:openTimes nDayToOpen:hotTags nYears:styles nAreas:elements];
        
    }
    
}
// 获取下拉列表高度
-(void)setMenuHeight:(CGFloat)menuHeight{
    _menuHeight = menuHeight;
    
}

#pragma mark - 控制下拉收回选项标签页面
//显示下拉列表
- (void)showDropDownWithTag:(NSInteger)tag{   // 显示下拉列表
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 0, WIDHT, screen_height);
            _effectView.frame = CGRectMake(0, 0, screen_width, screen_height);
            _effectView.alpha = 0.6;
            
            // 点击了筛选
            [_chooser showInView];
            
            _chooser.myCollectionView.contentOffset = CGPointMake(0, 0);
        }];
       
        
    });
    
}

// 隐藏下拉列表
- (void)hideDropDown{
    // AnimateTime
    [UIView animateWithDuration:0.25 animations:^{
        
        self.frame = CGRectMake(screen_width, self.frame.origin.y, 0, screen_height);
        
        _effectView.frame = CGRectMake(screen_width, 0, screen_width, screen_height);
        
        [_chooser dismiss];
        _effectView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
       
        
    }];
    
}

//重置按钮的回调
- (void)resetmoreTagsChooser:(YKChooser *)sheet selectedTags:(NSArray *)sTags ytypes:(NSArray *)ytypes yseasons:(NSArray *)yseasons yopenTimes:(NSArray *)yopenTimes ycolors:(NSArray *)ycolors yhotTags:(NSArray *)yhotTags ystyles:(NSArray *)ystyles yelements:(NSArray *)yelements{
    
    [selectedTags removeAllObjects];
    [selectedTags addObjectsFromArray:sTags];//选中的所有标签
    
    [types removeAllObjects];
    [seasons removeAllObjects];
    [colors removeAllObjects];
    [openTimes removeAllObjects];
    [hotTags removeAllObjects];
    [styles removeAllObjects];
    [elements removeAllObjects];
    
    [types addObjectsFromArray:sTags];//选中的元素
    [seasons addObjectsFromArray:yseasons];//选中的季节
    [colors addObjectsFromArray:ycolors];//选中的颜色
    [openTimes addObjectsFromArray:yopenTimes];//选中的上新时间
    [hotTags addObjectsFromArray:yhotTags];//选中的热门标签
    [styles addObjectsFromArray:ystyles];//选中的风格
    [elements addObjectsFromArray:yelements];//选中的元素
    
    NSLog(@"清空了所有的选中标签");
}

//确认按钮的回调

- (void)moreTagsChooser:(YKChooser *)sheet selectedTags:(NSArray *)yTags ytypes:(NSArray *)ytypes yseasons:(NSArray *)yseasons yopenTimes:(NSArray *)yopenTimes ycolors:(NSArray *)ycolors yhotTags:(NSArray *)yhotTags ystyles:(NSArray *)ystyles yelements:(NSArray *)yelements{
    
    [selectedTags removeAllObjects];
    [selectedTags addObjectsFromArray:yTags];//选中的所有标签
    
    [types removeAllObjects];
    [seasons removeAllObjects];
    [colors removeAllObjects];
    [openTimes removeAllObjects];
    [hotTags removeAllObjects];
    [styles removeAllObjects];
    [elements removeAllObjects];
    
    [types addObjectsFromArray:ytypes];//选中的品类
    [seasons addObjectsFromArray:yseasons];//选中的季节
    [colors addObjectsFromArray:ycolors];//选中的颜色
    [openTimes addObjectsFromArray:yopenTimes];//选中的上新时间
    [hotTags addObjectsFromArray:yhotTags];//选中的热门标签
    [styles addObjectsFromArray:ystyles];//选中的风格
    [elements addObjectsFromArray:yelements];//选中的元素
    
    
    //组装数据
    //遍历标签数组，拿到选中的key
    
    //品类
    NSMutableArray *postTypes = [NSMutableArray array];
    for (YKTag *tag in types) {
        [postTypes addObject:@(tag.objId)];
    }
    
    //季节
    NSMutableArray *postSeasons = [NSMutableArray array];
    for (YKTag *tag in seasons) {
       [postSeasons addObject:@(tag.objId)];
    }
    //颜色
    NSMutableArray *postColors = [NSMutableArray array];
    for (YKTag *tag in colors) {
        [postColors addObject:@(tag.objId)];
    }
    //上新时间
    
    NSMutableArray *postOpenTimes = [NSMutableArray array];
    for (YKTag *tag in openTimes) {
        [postOpenTimes addObject:@(tag.objId)];
    }
    //热门标签
    NSMutableArray *postHotTags = [NSMutableArray array];
    for (YKTag *tag in hotTags) {
        [postHotTags addObject:@(tag.objId)];
    }
    //风格
    NSMutableArray *postStyles = [NSMutableArray array];
    for (YKTag *tag in styles) {
        [postStyles addObject:@(tag.objId)];
    }
    //元素
    NSMutableArray *postElements = [NSMutableArray array];
    for (YKTag *tag in styles) {
        [postElements addObject:@(tag.objId)];
    }
    
    NSLog(@"%@%@%@%@%@%@%@",postTypes,postColors,postStyles,postSeasons,postHotTags,postElements,postOpenTimes);
//
    if (self.moreSelectedCallback) {
        self.moreSelectedCallback(postTypes, postSeasons, postOpenTimes, postColors, postHotTags, postStyles, postElements);
    }
    
    
    if (self.didSelectedCallback) {
        self.didSelectedCallback(@"888", @"888", self.tag);
    }
    
    [self hideDropDown];
}

@end
