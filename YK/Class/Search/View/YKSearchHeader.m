//
//  YKSearchHeader.m
//  YK
//
//  Created by LXL on 2017/11/15.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSearchHeader.h"
#import "CBSegmentView.h"

@interface YKSearchHeader()
{
    CBSegmentView *sliderSegmentView1 ;
    CBSegmentView *sliderSegmentView2 ;
}

@property (nonatomic,strong)NSString *categoryID;
@property (nonatomic,strong)NSString *sortId;

@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *SortLabel;

@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UIView *back1View;
@property (weak, nonatomic) IBOutlet UIView *back2View;

@end
@implementation YKSearchHeader

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCategoryList:(NSMutableArray *)CategoryList CategoryIdList:(NSMutableArray *)CategoryIdList sortIdList:(NSMutableArray *)sortIdList sortList:(NSMutableArray *)sortList{
    
    self.sortId = @"";
    self.categoryID = @"";
    
    WeakSelf(weakSelf)
    sliderSegmentView1 = [[CBSegmentView alloc]initWithFrame: _back1View.frame];
    [self addSubview:sliderSegmentView1];
    [sliderSegmentView1 setTitleArray:CategoryList categoryIds:CategoryIdList withStyle:CBSegmentStyleZoom];
    sliderSegmentView1.titleChooseReturn = ^(NSString *catrgoryId) {
        weakSelf.categoryID = catrgoryId;
        if (weakSelf.filterBlock) {
            weakSelf.filterBlock(weakSelf.categoryID, weakSelf.sortId);
        }
    };
    
    sliderSegmentView2 = [[CBSegmentView alloc]initWithFrame:_back2View.frame];
    [self addSubview:sliderSegmentView2];
    [sliderSegmentView2 setTitleArray:sortList categoryIds:sortIdList withStyle:CBSegmentStyleZoom];
    sliderSegmentView2.titleChooseReturn = ^(NSString *sortId) {
        weakSelf.sortId = sortId;
        if (weakSelf.filterBlock) {
            weakSelf.filterBlock(weakSelf.categoryID, weakSelf.sortId);
        }
    };
}



@end
