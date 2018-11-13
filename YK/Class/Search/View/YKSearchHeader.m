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
    CBSegmentView *sliderSegmentView3 ;
}

@property (nonatomic,strong)NSString *categoryID;
@property (nonatomic,strong)NSString *sortId;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;

@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *SortLabel;


@property (weak, nonatomic) IBOutlet UIView *back1View;
@property (weak, nonatomic) IBOutlet UIView *back2View;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;

@end
@implementation YKSearchHeader

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAll)];
//    [self addGestureRecognizer:tap];
    
//    [self.allBtn setUserInteractionEnabled:YES];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(WIDHT/2, 0, WIDHT/2, 70);
//    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(clickAll) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    _SortLabel.font = PingFangSC_Medium(kSuitLength_H(16));
    _TypeLabel.font = PingFangSC_Medium(kSuitLength_H(16));
    
}
- (IBAction)clickALl:(id)sender {
    if (self.clickALLBlock) {
        self.clickALLBlock();
    }
}
- (void)clickAll{
    if (self.clickALLBlock) {
        self.clickALLBlock();
    }
}
- (void)setCategoryList:(NSMutableArray *)CategoryList CategoryIdList:(NSMutableArray *)CategoryIdList sortIdList:(NSMutableArray *)sortIdList sortList:(NSMutableArray *)sortList{
    
    self.sortId = @"";
    self.categoryID = @"";
    
    WeakSelf(weakSelf)
    sliderSegmentView1 = [[CBSegmentView alloc]initWithFrame: CGRectMake(0, kSuitLength_H(10), WIDHT, kSuitLength_H(40))];
    [self addSubview:sliderSegmentView1];
    [sliderSegmentView1 setTitleArray:CategoryList categoryIds:CategoryIdList withStyle:CBSegmentStyleZoom];
    sliderSegmentView1.titleChooseReturn = ^(NSString *catrgoryId) {
        weakSelf.categoryID = catrgoryId;
        if (weakSelf.filterBlock) {
            weakSelf.filterBlock(weakSelf.categoryID, weakSelf.sortId);
        }
    };
    
    UILabel *line1 = [[UILabel alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    line1.frame = CGRectMake(0, sliderSegmentView1.bottom, WIDHT, 1);
    [self addSubview:line1];
    
    sliderSegmentView2 = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, sliderSegmentView1.frame.size.height + sliderSegmentView1.frame.origin.y, WIDHT, kSuitLength_H(40))];
    [self addSubview:sliderSegmentView2];
    [sliderSegmentView2 setTitleArray:sortList categoryIds:sortIdList withStyle:CBSegmentStyleZoom];
    sliderSegmentView2.titleChooseReturn = ^(NSString *sortId) {
        weakSelf.sortId = sortId;
        if (weakSelf.filterBlock) {
            weakSelf.filterBlock(weakSelf.categoryID, weakSelf.sortId);
        }
    };
    
    UILabel *line2 = [[UILabel alloc]init];
    line2.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    line2.frame = CGRectMake(0, sliderSegmentView2.bottom, WIDHT, 1);
    [self addSubview:line2];
    //季节
    NSArray *seasons = [NSArray array];
    seasons = @[@"不限",@"春",@"夏",@"秋",@"冬"];
    
    NSArray *ids = [NSArray array];
    ids = @[@"0",@"1",@"2",@"3",@"4"];
    
    sliderSegmentView3 = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, sliderSegmentView2.frame.size.height + sliderSegmentView2.frame.origin.y, WIDHT, kSuitLength_H(40))];
    [self addSubview:sliderSegmentView3];
    [sliderSegmentView3 setTitleArray:seasons categoryIds:ids withStyle:CBSegmentStyleZoom];
    sliderSegmentView3.titleChooseReturn = ^(NSString *sortId) {
        weakSelf.sortId = sortId;
        if (weakSelf.filterBlock) {
            weakSelf.filterBlock(weakSelf.categoryID, weakSelf.sortId);
        }
    };
    
    UILabel *line3 = [[UILabel alloc]init];
    line3.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    line3.frame = CGRectMake(0, sliderSegmentView3.bottom, WIDHT, 1);
    [self addSubview:line3];
}



@end
