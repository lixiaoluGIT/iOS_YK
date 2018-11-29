//
//  newHouseMoreChooser.m
//  CoolBroker
//
//  Created by edz on 2018/10/9.
//  Copyright © 2018年 bxs. All rights reserved.
//

#import "YKChooser.h"

//@implementation newHouseMoreChooser

#import "NSArray+YLBoundsCheck.h"
#import "YLWaterFlowLayout.h"
#import "YLCollectionReusableView.h"
//#import "YLTag.h"
#import "YKTag.h"

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 屏幕尺寸
#define kFrameWidth [UIScreen mainScreen].bounds.size.width
#define kFrameHeight [UIScreen mainScreen].bounds.size.height

static NSString *headerIdentifier = @"YLCollectionReusableView";
//static NSString *footerIdentifier = @"YLCollectionReusableView";
static NSString *cellIdentifier = @"YLTagsCollectionViewCell";

static NSTimeInterval const kSheetAnimationDuration = 0.25;
static CGFloat const kBottomBtnHeight = 44.f;
static CGFloat const kBottomGap = 24.f;
static CGFloat const kYGap = 10.f;

@interface YKChooser()<UICollectionViewDataSource,UICollectionViewDelegate,YLWaterFlowLayoutDelegate, UITextFieldDelegate>
{
    
}

// 标签部分
@property (nonatomic, strong) NSMutableArray   *tagTitleArr;  // 存储更多中的标签分类标题

@property (nonatomic,strong) UIView            *bottomView;   // 背景页面

@property (nonatomic,strong) UIButton          *ensureBtn;    // 确认按钮
@property (nonatomic,strong) UIButton          *resetBtn;    // 重置按钮

@property (nonatomic,strong) NSMutableArray   *orignalMArrayTags;   // 所有标签  --  数组

@property (nonatomic,strong) NSMutableDictionary   *orignalMDicTags;   // 所有标签  --  字典

@property (nonatomic,strong) NSMutableArray    *selectedTags;   // 选中的标签：所有数据标签
@property (nonatomic,strong) NSMutableArray *types;//品类数组
@property (nonatomic,strong) NSMutableArray *seasons;//季节数组
@property (nonatomic,strong) NSMutableArray *colors;//颜色数组
@property (nonatomic,strong) NSMutableArray *openTimes;//上新时间数组
@property (nonatomic,strong) NSMutableArray *hotTags;//热门标签数组
@property (nonatomic,strong) NSMutableArray *styles;//风格数组
@property (nonatomic,strong) NSMutableArray *elements;//元素数组

@property (nonatomic,strong) YLWaterFlowLayout *layout;

//面积, 总价, 租金部分
@property (nonatomic, strong) UILabel *titleL; // 类型的标题



@property (nonatomic, strong) UIView *effectView;  // 当键盘输入时后面的背景遮罩

@end


@implementation YKChooser

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

//初始化
-(instancetype)initWithBottomHeight:(CGFloat)bHeight
                     maxSelectCount:(CGFloat)maxCount
                           delegate:(id<MoreTagsChooserDelegate>)aDelegate WithView:(UIView *)view
{
    if(self = [super initWithFrame:CGRectMake(0, 0, kFrameWidth-kSuitLength_H(60), _bottomHeight)]){
        _orignalMDicTags = [NSMutableDictionary dictionary];
        _orignalMArrayTags = [NSMutableArray array];
        _selectedTags = [NSMutableArray array];
        
        _types = [NSMutableArray array];
        _seasons = [NSMutableArray array];
        _colors = [NSMutableArray array];
        _openTimes = [NSMutableArray array];
        _hotTags = [NSMutableArray array];
        _styles = [NSMutableArray array];
        _elements = [NSMutableArray array];
        
        _tagTitleArr = [NSMutableArray array];
        
        self.alpha = 0.f;
        //        self.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.5];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.bottomHeight = bHeight;
        self.maxSelectCount = maxCount;
        self.delegate = aDelegate;
        
        
        
        [self addSubview:self.bottomView];
        
     
        
        [view addSubview:self];
        
    }
    return self;
}

//赋值
-(void)refreshWithTags:(id)tags
           keyTitleArr:(NSArray *)keyTitleArr
          selectedTags:(NSArray *)selectedTags nTags:(NSArray *)nTags
           nSaleStatus:(NSArray *)nSaleStatus
           nBuildTypes:(NSArray *)nBuildTypes
            nRoomTypes:(NSArray *)nRoomTypes
            nDayToOpen:(NSArray *)nDayToOpen
                nYears:(NSArray *)nYears
                nAreas:(NSArray *)nAreas
{
    
    [_orignalMDicTags removeAllObjects];
    [_orignalMArrayTags removeAllObjects];
    
    [_selectedTags removeAllObjects];
    
    [_types removeAllObjects];
    [_seasons removeAllObjects];
    [_colors removeAllObjects];
    [_openTimes removeAllObjects];
    [_hotTags removeAllObjects];
    [_styles removeAllObjects];
    [_elements removeAllObjects];
    
    [_tagTitleArr removeAllObjects];
    
    if ([tags count] <= 0) {
        return;
    }
    
    if ([tags isKindOfClass:[NSString class]]) {
        return ;
    }

    //数据是字典
    if ([tags isKindOfClass:[NSDictionary class]] || [tags isKindOfClass:[NSMutableDictionary class]])  {
        
        //字典数据
        _orignalMDicTags = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)tags];
        //选中的所有数据
        [_selectedTags addObjectsFromArray:selectedTags];
        //选中的类别数据
        [_types addObjectsFromArray:nSaleStatus];
        [_seasons addObjectsFromArray:nBuildTypes];
        [_openTimes addObjectsFromArray:nRoomTypes];
        [_colors addObjectsFromArray:nDayToOpen];
        [_hotTags addObjectsFromArray:nYears];
        [_styles addObjectsFromArray:nAreas];
        [_elements addObjectsFromArray:nTags];

        [_tagTitleArr addObjectsFromArray:keyTitleArr];
        
        
        NSDictionary *dicTemp = (NSDictionary *)tags;
        
        NSArray *keysArray = [dicTemp allKeys];
        
        for (NSString *strTemp in keysArray) {
            
            NSArray *valueArray = [dicTemp objectForKey:strTemp];
            
            for(YKTag *tag in valueArray){
                tag.selected = [_selectedTags containsObject:tag];
            }
            
        }
        
    }
    
    NSArray *subviews = [[NSArray alloc] initWithArray:self.bottomView.subviews];
    
    for (UIView *subview in subviews) {
        
        [subview removeFromSuperview];
        
    }
    
    self.myCollectionView = nil;
    self.ensureBtn = nil;
    self.resetBtn = nil;
  
    [self.bottomView addSubview:self.myCollectionView];
    [self.myCollectionView reloadData];
    [self.layout reCalculateFrames];
    [self.bottomView addSubview:self.ensureBtn];
    [self.bottomView addSubview:self.resetBtn];
    
    if (_selectedTags.count!=0) {
        [_resetBtn setBackgroundColor:mainColor];
        [_resetBtn.titleLabel setTextColor:[UIColor whiteColor]];
    }else {
        _resetBtn.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        [_resetBtn.titleLabel setTextColor:blackTextColor];
    }
        
}

#pragma mark - 懒加载

-(UIView *)bottomView
{
    if(!_bottomView){
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.frame = CGRectMake(kSuitLength_H(60),0 , kFrameWidth-kSuitLength_H(60), screen_height);
    }
    return _bottomView;
}

-(UICollectionView *)myCollectionView
{
    if(!_myCollectionView){
        _layout = [[YLWaterFlowLayout alloc]init];
        _layout.rowHeight = kSuitLength_V(66.f / 2);
        _layout.currentTag = self.currentTag;
        _layout.delegate = self;
        
    
        _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kYGap, kFrameWidth-kSuitLength_H(60), 0)
                                              collectionViewLayout:_layout];
        
        //        _myCollectionView.alpha = 0;
        
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        [_myCollectionView registerClass:[YLCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
        //        [_myCollectionView registerClass:[YLCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
        [_myCollectionView registerClass:[newMoreCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        _myCollectionView.dataSource = self;
        _myCollectionView.delegate = self;
        _myCollectionView.showsVerticalScrollIndicator = NO;
        //support set collectionview's contentInset
        //        _myCollectionView.contentInset = UIEdgeInsetsMake(30, 20, 30, 20);
    }
    return _myCollectionView;
}

-(UIButton *)ensureBtn
{
    if(!_ensureBtn){
        _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ensureBtn.backgroundColor = YKRedColor;
       
        _ensureBtn.alpha = 0;
        
        _ensureBtn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(14));
        [_ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ensureBtn setTitleColor:[blackTextColor colorWithAlphaComponent:0.6] forState:UIControlStateHighlighted];
        [_ensureBtn setTitle:@"保存筛选" forState:UIControlStateNormal];
        [_ensureBtn addTarget:self action:@selector(ensureAction) forControlEvents:UIControlEventTouchUpInside];
        _ensureBtn.frame = CGRectMake(screen_width - kSuitLength_H(270.f / 2) - kSuitLength_H(35.f / 2)-kSuitLength_H(60), _myCollectionView.frame.origin.y + _myCollectionView.frame.size.height +kSuitLength_V(5), kSuitLength_H(270.f / 2), kBottomBtnHeight);
    }
    return _ensureBtn;
}

-(UIButton *)resetBtn
{
    if(!_resetBtn){
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetBtn.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        //        _resetBtn.layer.cornerRadius = kBottomBtnHeight / 2;
        //        _resetBtn.layer.masksToBounds = YES;
        
        _resetBtn.alpha = 0;
        
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:kSuitLength_H(30.f / 2)];
        [_resetBtn setTitleColor:blackTextColor forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[blackTextColor colorWithAlphaComponent:0.6] forState:UIControlStateHighlighted];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn setImage:[UIImage imageNamed:@"更换"] forState:UIControlStateNormal];
        [_resetBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [_resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
        _resetBtn.frame = CGRectMake(kSuitLength_H(35.f / 2), _myCollectionView.frame.origin.y + _myCollectionView.frame.size.height +kSuitLength_V(5), kSuitLength_H(270.f / 2), kBottomBtnHeight);
    }
    return _resetBtn;
}

// 标题 titleL
- (UILabel *)titleL{
    
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        
        _titleL.frame = CGRectMake(kSuitLength_H(44.f / 2), kSuitLength_V(19.5 / 2), kSuitLength_H(190.f / 2), kSuitLength_V(42.f / 2));
        
        _titleL.textColor = blackTextColor;
        _titleL.textAlignment = NSTextAlignmentLeft;
        
        _titleL.font = kFont(kSuitLength_H(30.f / 2));
        
        
        
    }
    return _titleL;
    
}





#pragma mark---UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
  return _tagTitleArr.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

        for (NSInteger i = 0; i < _tagTitleArr.count; i ++) {
            
            if (section == i) {
                
                NSString *str = _tagTitleArr[i];
                
                NSArray *tags = (NSArray *)[_orignalMDicTags objectForKey:str];
                
                NSInteger index = tags.count;
                
                return index;
            }
        }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.currentTag != 3) {
        
        if (self.tagTitleArr.count != 0 || self.orignalMArrayTags.count != 0) {
            
            newMoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                                        forIndexPath:indexPath];
            
            
            NSArray *tags = (NSArray *)[_orignalMArrayTags yl_objectAtIndex:indexPath.section];
            
            YKTag *tag = [tags yl_objectAtIndex:indexPath.row];
            [cell refreshWithObject:tag];
            return cell;
            
        }
        
    } else {
        
        if (self.tagTitleArr.count != 0 || self.orignalMDicTags.count != 0) {
            
            newMoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                                        forIndexPath:indexPath];
            
            
            
            
            NSString *str = _tagTitleArr[indexPath.section];
            
            NSArray *tags = (NSArray *)[_orignalMDicTags objectForKey:str];
            
            YKTag *tag = [tags yl_objectAtIndex:indexPath.row];
            
            if (indexPath.section==0) {//品类
                if (tag.selected) {
                    if (![_types containsObject:tag]) {
                        [_types addObject:tag];
                    }
                }
            }
            if (indexPath.section==1) {//季节
                if (tag.selected) {
                    if (![_seasons containsObject:tag]) {
                        [_seasons addObject:tag];
                    }
                }
            }
            if (indexPath.section==3) {//颜色
                if (tag.selected) {
                    if (![_colors containsObject:tag]) {
                        [_colors addObject:tag];
                    }
                }
            }
            if (indexPath.section==2) {//上新时间
                if (tag.selected) {
                    if (![_openTimes containsObject:tag]) {
                        [_openTimes addObject:tag];
                    }
                }
            }
            if (indexPath.section==4) {//热门标签
                if (tag.selected) {
                    if (![_hotTags containsObject:tag]) {
                        [_hotTags addObject:tag];
                    }
                }
            }
            if (indexPath.section==5) {//风格
                if (tag.selected) {
                    if (![_styles containsObject:tag]) {
                        [_styles addObject:tag];
                    }
                }
            }
            if (indexPath.section==6) {//元素
                if (tag.selected) {
                    if (![_elements containsObject:tag]) {
                        [_elements addObject:tag];
                    }
                }
            }
            
            [cell refreshWithObject:tag];
            
            return cell;
            
            
            
        }
        
    }
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        YLCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        
        if (self.tagTitleArr.count != 0) {
            [header setTitle:[NSString stringWithFormat:@"%@", [self.tagTitleArr objectAtIndex:indexPath.section]]];
        }
        
        return header;
    }
    
    //    else{
    //        YLCollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
    //        [footer setTitle:[NSString stringWithFormat:@"Section Footer %li",(long)indexPath.section]];
    //        return footer;
    //    }
    return nil;
}

#pragma mark---YLWaterFlowLayoutDelegate
- (CGFloat)waterFlowLayout:(YLWaterFlowLayout *)layout widthAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.currentTag == 3) {
        
        CGFloat width = kSuitLength_H(147 / 2);
        
        return width;
        
    } else {
        
        //        for (NSInteger i = 0; i < _tagTitleArr.count; i ++) {
        //
        //            if (indexPath.section == i) {
        //
        //                NSString *str = _tagTitleArr[i];
        
        for (NSArray *tags in _orignalMArrayTags) {
            
            YKTag *tag = [tags yl_objectAtIndex:indexPath.row];
            
            CGSize size = CGSizeMake(kFrameWidth - layout.sectionInset.left - layout.sectionInset.right,CGFLOAT_MAX);
            
            
            
            CGRect textRect = [tag.name
                               boundingRectWithSize:size
                               options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                               context:nil];
            CGFloat width = textRect.size.width + 15;
            
            return width;
            
        }
        //            }
        //
        //        }
        //
        return 0;
        
    }
    
    //    return kSuitLength_H(147 / 2);
    
}

#pragma mark---UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *str = _tagTitleArr[indexPath.section];
    
    NSArray *tags = (NSArray *)[_orignalMDicTags objectForKey:str];
    
    YKTag *tag = [tags yl_objectAtIndex:indexPath.row];
//    
    if (indexPath.section==0) {//品类
        if(![_types containsObject:tag]){
            tag.selected = YES;
            [_types addObject:tag];
        }else{
            tag.selected = NO;
            [_types removeObject:tag];
        }
    }
    if (indexPath.section==1) {//季节
        if(![_seasons containsObject:tag]){
            tag.selected = YES;
            [_seasons addObject:tag];
        }else{
            tag.selected = NO;
            [_seasons removeObject:tag];
        }
    }
  
    if (indexPath.section==2) {//上新时间
        
        if(![_selectedTags containsObject:tag]){
            
            NSMutableArray *a = _selectedTags.copy;
            for (YKTag *ct in a) {
                for (YKTag *ctt in _openTimes) {
                    if ([ct.name isEqual:ctt.name]) {
                        ct.selected = NO;
                        [_selectedTags removeObject:ct];
                    }
                }
            }
            
            tag.selected = YES;
            [_selectedTags addObject:tag];
            
        }else{
            tag.selected = NO;
            [_selectedTags removeObject:tag];
        }
        
        if(![_openTimes containsObject:tag]){
            
            for (YKTag *t in _openTimes) {//当前section选中的tag
                t.selected = NO;
                [_openTimes removeObject:t];
                for (YKTag *tt in tags) {
                    if ([tt.name isEqual:t.name]) {
                        tt.selected = t.selected;
                    }
                    
                }
            }
            tag.selected = YES;
            [_openTimes addObject:tag];
        }else{
            tag.selected = NO;
            [_openTimes removeObject:tag];
        }
        if (_selectedTags.count!=0) {
            [_resetBtn setBackgroundColor:mainColor];
            [_resetBtn.titleLabel setTextColor:[UIColor whiteColor]];
        }else {
            _resetBtn.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
            [_resetBtn.titleLabel setTextColor:blackTextColor];
        }
        [collectionView reloadData];
        return;
    }
    
    if (indexPath.section==3) {//颜色
        if(![_colors containsObject:tag]){
            tag.selected = YES;
            [_colors addObject:tag];
        }else{
            tag.selected = NO;
            [_colors removeObject:tag];
        }
    }
    
    if (indexPath.section==4) {//热门标签
        
        if(![_selectedTags containsObject:tag]){
            //取消之前的选中
            NSMutableArray *a = _selectedTags.copy;
            for (YKTag *ct in a) {//所有的选中
                for (YKTag *ctt in _hotTags) {//面积的选中
                    if ([ct.name isEqual:ctt.name]) {
                        ct.selected = NO;
                        [_selectedTags removeObject:ct];//去掉面积之前的选中
                    }
                }
            }
            
            tag.selected = YES;
            [_selectedTags addObject:tag];
            
        }else{
            //取消选中
            tag.selected = NO;
            [_selectedTags removeObject:tag];
        }
        
        
        if(![_hotTags containsObject:tag]){
            for (YKTag *t in _hotTags) {//当前section选中的tag
                t.selected = NO;
                [_hotTags removeObject:t];
                for (YKTag *tt in tags) {
                    if ([tt.name isEqual:t.name]) {
                        tt.selected = t.selected;
                    }
                    
                }
            }
            
            tag.selected = YES;
            [_hotTags addObject:tag];
        }else{
            tag.selected = NO;
            [_hotTags removeObject:tag];
        }
        if (_selectedTags.count!=0) {
            [_resetBtn setBackgroundColor:mainColor];
            [_resetBtn.titleLabel setTextColor:[UIColor whiteColor]];
        }else {
            _resetBtn.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
            [_resetBtn.titleLabel setTextColor:blackTextColor];
        }
        [collectionView reloadData];
        return;
    }
    if (indexPath.section==5) {//风格
        
        
        if(![_selectedTags containsObject:tag]){
            //取消之前的选中
            NSMutableArray *a = _selectedTags.copy;
            for (YKTag *ct in a) {//所有的选中
                for (YKTag *ctt in _styles) {//面积的选中
                    if ([ct.name isEqual:ctt.name]) {
                        ct.selected = NO;
                        [_selectedTags removeObject:ct];//去掉面积之前的选中
                    }
                }
            }
            
            tag.selected = YES;
            [_selectedTags addObject:tag];
            
        }else{
            //取消选中
            tag.selected = NO;
            [_selectedTags removeObject:tag];
        }
        
        
        if(![_styles containsObject:tag]){
            for (YKTag *t in _styles) {//当前section选中的tag
                t.selected = NO;
                [_styles removeObject:t];
                for (YKTag *tt in tags) {
                    if ([tt.name isEqual:t.name]) {
                        tt.selected = t.selected;
                    }
                    
                }
            }
            
            tag.selected = YES;
            [_styles addObject:tag];
        }else{
            tag.selected = NO;
            [_styles removeObject:tag];
        }
        if (_selectedTags.count!=0) {
            [_resetBtn setBackgroundColor:mainColor];
            [_resetBtn.titleLabel setTextColor:[UIColor whiteColor]];
        }else {
            _resetBtn.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
            [_resetBtn.titleLabel setTextColor:blackTextColor];
        }
        [collectionView reloadData];
        return;
    }
    
    if (indexPath.section==6) {//元素
        
        if(![_selectedTags containsObject:tag]){
            //取消之前的选中
            NSMutableArray *a = _selectedTags.copy;
            for (YKTag *ct in a) {//所有的选中
                for (YKTag *ctt in _elements) {//面积的选中
                    if ([ct.name isEqual:ctt.name]) {
                        ct.selected = NO;
                        [_selectedTags removeObject:ct];//去掉面积之前的选中
                    }
                }
            }
            
            tag.selected = YES;
            [_selectedTags addObject:tag];
            
        }else{
            //取消选中
            tag.selected = NO;
            [_selectedTags removeObject:tag];
        }
        
        
        if(![_elements containsObject:tag]){
            for (YKTag *t in _elements) {//当前section选中的tag
                t.selected = NO;
                [_elements removeObject:t];
                for (YKTag *tt in tags) {
                    if ([tt.name isEqual:t.name]) {
                        tt.selected = t.selected;
                    }
                    
                }
            }
            
            tag.selected = YES;
            [_elements addObject:tag];
        }else{
            tag.selected = NO;
            [_elements removeObject:tag];
        }
        if (_selectedTags.count!=0) {
            [_resetBtn setBackgroundColor:mainColor];
            [_resetBtn.titleLabel setTextColor:[UIColor whiteColor]];
        }else {
            _resetBtn.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
            [_resetBtn.titleLabel setTextColor:blackTextColor];
        }
        [collectionView reloadData];
        return;
    }
    
    
    if(![_selectedTags containsObject:tag]){
        
        tag.selected = YES;
        [_selectedTags addObject:tag];
        
    }else{
        tag.selected = NO;
        [_selectedTags removeObject:tag];
    }
    //            NSLog(@"选中的==%@",_selectedTags);
    
    if (_selectedTags.count!=0) {
        [_resetBtn setBackgroundColor:mainColor];
        [_resetBtn.titleLabel setTextColor:[UIColor whiteColor]];
    }else {
        _resetBtn.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        [_resetBtn.titleLabel setTextColor:blackTextColor];
    }
    [collectionView reloadData];
}



#pragma mark---animation method
- (void)showInView
{
    
 
    [self endEditing:YES];
 
    
    CGRect frame = self.bottomView.frame;
  
    
    frame.origin.y = 0;
    
    frame.size.height = screen_height;
   
//    self.myCollectionView.backgroundColor = [UIColor redColor];
//    self.bottomView.backgroundColor = [UIColor yellowColor];
        if (self.myCollectionView.contentSize.height + kSuitLength_V(10) +  kBottomBtnHeight>= frame.size.height) {
            self.myCollectionView.frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height - (kSuitLength_V(10) +  kBottomBtnHeight));
            self.bottomView.frame = frame;
            self.bottomView.frame = CGRectMake(0, 0, WIDHT-kSuitLength_H(60), HEIGHT);
        } else {
            
            self.myCollectionView.frame = CGRectMake(0, frame.origin.y, frame.size.width, self.myCollectionView.contentSize.height);
            self.bottomView.frame = CGRectMake(0, frame.origin.y, frame.size.width, self.myCollectionView.contentSize.height + kSuitLength_V(10) +  kBottomBtnHeight);
            
        }
        
//        _ensureBtn.layer.cornerRadius = kBottomBtnHeight / 2;
        _ensureBtn.layer.masksToBounds = YES;
        
//        _resetBtn.layer.cornerRadius = kBottomBtnHeight / 2;
        _resetBtn.layer.masksToBounds = YES;
        
 
    
        _resetBtn.frame = CGRectMake(0, self.bottomView.frame.origin.y + self.bottomView.frame.size.height - kBottomBtnHeight,  (screen_width-kSuitLength_H(60))/2, kBottomBtnHeight);

        _ensureBtn.frame = CGRectMake(_resetBtn.frame.size.width + _resetBtn.frame.origin.x, self.bottomView.frame.origin.y + self.bottomView.frame.size.height - kBottomBtnHeight , (screen_width-kSuitLength_H(60))/2, kBottomBtnHeight);
    
    //    self.frame = self.bottomView.frame;
    
    _ensureBtn.alpha = 1.f;
    _resetBtn.alpha = 1.f;
    
    self.alpha = 1.f;
    
//   self.frame = self.bottomView.frame;
    self.frame = CGRectMake(kSuitLength_H(60), 0, WIDHT-kSuitLength_H(60), HEIGHT);
//    self.bottomView.backgroundColor = [UIColor redColor];
}

- (void)dismiss
{
    
    [self endEditing:YES];
    
    self.effectView.frame = CGRectMake(0, 0, screen_width, 0);
    
    CGRect frame = self.bottomView.frame;
    //    frame.origin.y = kFrameHeight;
    //    [UIView animateWithDuration:kSheetAnimationDuration
    //                          delay:0.f
    //                        options:UIViewAnimationOptionCurveEaseInOut
    //                     animations:^{
    //                         self.bottomView.frame = frame;
    //                         self.alpha = 0;
    //                     } completion:^(BOOL finished) {
    //                         [self removeFromSuperview];
    //                     }];
    
    frame.origin.y = 0;
    [UIView animateWithDuration:kSheetAnimationDuration
                     animations:^{
                         self.bottomView.frame = frame;
                         
                         
                         //                         [self removeFromSuperview];
                         
                     } completion:^(BOOL finished) {
                         self.alpha = 0.f;
                         [self.myCollectionView setContentOffset:CGPointMake(0 , 0)];
                     }];
    
}


#pragma mark---other methods
// 点击了更多的确认
-(void)ensureAction
{
    if([_delegate respondsToSelector:@selector(moreTagsChooser:selectedTags:ytypes:yseasons:yopenTimes:ycolors:yhotTags:ystyles:yelements:)]){
        
        [_delegate moreTagsChooser:self selectedTags:_selectedTags ytypes:_types yseasons:_seasons yopenTimes:_openTimes ycolors:_colors yhotTags:_hotTags ystyles:_styles yelements:_elements];
    }
    [self dismiss];
}

// 点击了更多的重置
-(void)resetAction
{
    
    [self.selectedTags removeAllObjects];
    
    if (self.currentTag != 3) {
        
        for (NSArray *tags in _orignalMArrayTags) {
            
            for(YKTag *tag in tags){
                tag.selected = NO;
            }
            
        }
        
    } else {
        
        [_selectedTags removeAllObjects];
        [_types removeAllObjects];
        [_seasons removeAllObjects];
        [_colors removeAllObjects];
        [_openTimes removeAllObjects];
        [_hotTags removeAllObjects];
        [_styles removeAllObjects];
        [_elements removeAllObjects];
        
        
        for (NSString *str in _tagTitleArr) {
            
            NSArray *tags = (NSArray *)[_orignalMDicTags objectForKey:str];
            
            for(YKTag *tag in tags){
                tag.selected = NO;
            }
            
        }
        
    }
    
    if([_delegate respondsToSelector:@selector(resetmoreTagsChooser:selectedTags:ytypes:yseasons:yopenTimes:ycolors:yhotTags:ystyles:yelements:)]){
        
        [_delegate resetmoreTagsChooser:self selectedTags:_selectedTags ytypes:_types yseasons:_seasons yopenTimes:_openTimes ycolors:_colors yhotTags:_hotTags ystyles:_styles yelements:_elements];
    }
    
    if (_selectedTags.count!=0) {
        [_resetBtn setBackgroundColor:mainColor];
        [_resetBtn.titleLabel setTextColor:[UIColor whiteColor]];
    }else {
        _resetBtn.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        [_resetBtn.titleLabel setTextColor:blackTextColor];
    }
    [self.myCollectionView reloadData];
    
    //    [self dismiss];
}

@end

#pragma mark---标签cell
@implementation newMoreCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        _textLabel = [[UILabel alloc]init];
        //此处可以根据需要自己使用自动布局代码实现
        _textLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _textLabel.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
        _textLabel.font = PingFangSC_Regular(12);
        _textLabel.layer.borderWidth = 1.f;
//        _textLabel.layer.cornerRadius = kSuitLength_H(5);
        _textLabel.layer.masksToBounds = YES;
        _textLabel.textColor = blackTextColor;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.layer.borderColor = [UIColor colorWithHexString:@"#F3F4F6"].CGColor;
        [self.contentView addSubview:_textLabel];
        
        //对勾图标
        _image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"选择"]];
        _image.frame = CGRectMake(frame.size.width-kSuitLength_H(12), frame.size.height-kSuitLength_H(12), kSuitLength_H(12), kSuitLength_H(12));
//        _image.hidden = YES;
        [self.contentView addSubview:_image];
    }
    return self;
}

- (void)refreshWithObject:(NSObject *)obj
{
    if([obj isKindOfClass:[YKTag class]]){
        YKTag *tag = (YKTag *)obj;
        UIColor *borderColor = tag.selected ? [UIColor colorWithHexString:@"#fafafa"] : [UIColor colorWithHexString:@"#fafafa"];
        UIColor *titleColor = tag.selected ? YKRedColor :HEXCOLOR(0x666666);
        
        _textLabel.layer.borderColor = borderColor.CGColor;
        _textLabel.textColor = titleColor;
        _textLabel.text = tag.name;
        _textLabel.backgroundColor = borderColor;
        
         _image.hidden = !tag.selected ;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    UIColor *borderColor = selected ? mainColor : HEXCOLOR(0xdddddd);
    UIColor *titleColor = selected ?grayTextColor : YKRedColor;
    _image.hidden = selected;
    _textLabel.layer.borderColor = borderColor.CGColor;
    _textLabel.textColor = titleColor;
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
//    UIColor *borderColor = highlighted ? HEXCOLOR(0xffb400) : HEXCOLOR(0xdddddd);
//    UIColor *titleColor = highlighted ? HEXCOLOR(0xffb400) : grayTextColor;
//    _textLabel.layer.borderColor = borderColor.CGColor;
//    _textLabel.textColor = titleColor;
}


@end
