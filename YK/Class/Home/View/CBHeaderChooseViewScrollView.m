//
//  CBHeaderChooseViewScrollView.m
//  JZLConstructApp
//
//  Created by Apple on 17/4/5.
//  Copyright © 2017年 com.jzl. All rights reserved.
//

#import "CBHeaderChooseViewScrollView.h"
#import "CBNoHightlightedBtn.h"

@interface CBHeaderChooseViewScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) CBNoHightlightedBtn* selectedBtn;

@property (nonatomic, strong) UIView* sliderView;

@property (nonatomic, strong) NSMutableArray *btnArray;

@end

#define CBColorA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
//②屏幕尺寸
#define CBScreenH [UIScreen mainScreen].bounds.size.height
#define CBScreenW [UIScreen mainScreen].bounds.size.width

@implementation CBHeaderChooseViewScrollView

{
    UIColor *titleColor;
    UIColor *titleSelectedColor;
    CGFloat titleFontSize;
    NSArray *titleArray;
    CGFloat headerH;
}

#pragma mark - 懒加载

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray=[NSMutableArray array];
    }
    return _btnArray;
}

#pragma mark - UI

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator=NO;
        self.delegate=self;
        self.layer.borderColor=CBColorA(204, 204, 204, 1).CGColor;
        self.layer.borderWidth=0;
//        self.auto
        headerH=self.frame.size.height;
    }
    return self;
}

//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setUpTitleArray :(NSArray <NSString *> *)array titleColor :(UIColor *)color titleSelectedColor:(UIColor *)selectedColor titleFontSize :(CGFloat)size{
    titleColor=color;
    if (color==nil) {
        titleColor=CBColorA(102, 102, 102, 1);
    }
    
    titleSelectedColor=selectedColor;
    if (selectedColor==nil) {
        titleSelectedColor=CBColorA(199, 13, 23, 1);
    }
    
    titleFontSize=size;
    if (size==0) {
        titleFontSize=13;
    }
    
    titleArray=array;
    if (array.count!=0) {
        [self setUpUI];
    }
}

//UI
- (void)setUpUI{
    
    if (titleArray.count==0) {
        return;
    }
    
    for (NSInteger i=0; i<titleArray.count; i++) {
        CBNoHightlightedBtn*btn=[CBNoHightlightedBtn buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [self.btnArray addObject:btn];
        btn.tag=i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(14));
        
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setTitleColor:titleSelectedColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor whiteColor]];
        
        if (i==0) {
            btn.selected=YES;
            self.selectedBtn=btn;
        }
    }
    
    //    滑块
    UIView*sliderView=[[UIView alloc]init];
//    [self addSubview:sliderView];
    sliderView.backgroundColor=titleSelectedColor;
    self.sliderView=sliderView;
    
    NSMutableDictionary*dic=[NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:titleFontSize] forKey:NSFontAttributeName];
    CGSize textSize = [titleArray[0] boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    self.sliderView.jzl_width=textSize.width;
    self.sliderView.jzl_height=2;
    self.sliderView.jzl_y=headerH-2;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //    按钮
    CGFloat btnH=headerH-2;
    CGFloat totalX=25;
    
    for (NSInteger i=0; i<self.btnArray.count; i++) {
        
        CGRect btnRect=[titleArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, btnH) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:titleFontSize],NSFontAttributeName, nil] context:nil];
        
        CBNoHightlightedBtn *btn=self.btnArray[i];
        btn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(14));
        
        btn.jzl_size=btnRect.size;
        btn.jzl_x=totalX;
        btn.jzl_y=1;
        btn.jzl_height=btnH;
        totalX=totalX+btnRect.size.width+35;
    }
    
    if (totalX-10<CBScreenW) {
        self.contentSize=CGSizeMake(CBScreenW, 0);
    }else{
        self.contentSize=CGSizeMake(totalX-10, 0);
    }
    
    NSMutableDictionary*dic=[NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:titleFontSize] forKey:NSFontAttributeName];
    CGSize textSize = [titleArray[self.selectedBtn.tag] boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    self.sliderView.jzl_width=textSize.width;
    self.sliderView.jzl_centerX=self.selectedBtn.jzl_centerX;
}

//通知改变字体
- (void)changeFontSize{
    [self layoutSubviews];
}
//按钮点击事件
- (void)btnClick:(CBNoHightlightedBtn *)btn{
    if (self.btnChooseClickReturn!=nil) {
        self.btnChooseClickReturn(btn.tag);
    }
    self.selectedBtn.selected=NO;
    btn.selected=YES;
    self.selectedBtn=btn;
    self.sliderView.jzl_width=btn.titleLabel.jzl_width;
    [UIView animateWithDuration:0.2 animations:^{
        self.sliderView.jzl_centerX=btn.jzl_centerX;
    }];
    //    设置scrollview的滑动
    CGFloat offset=btn.center.x-CBScreenW*0.5;
    
    if (offset<0) {
        offset=0;
    }
    
    CGFloat maxOffset=self.contentSize.width-CBScreenW;
    
    if (offset>maxOffset) {
        offset=maxOffset;
    }
    [self setContentOffset:CGPointMake(offset, 0) animated:YES];
}

@end


@implementation UIView (JZLViewFrame)

- (UIViewController *)jzl_currentVc{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

+ (instancetype)jzl_viewLoadWithXib{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (CGFloat)jzl_x{
    return self.frame.origin.x;
}

- (void)setJzl_x:(CGFloat)jzl_x{
    CGRect frame=self.frame;
    frame.origin.x=jzl_x;
    self.frame=frame;
}

- (CGFloat)jzl_y{
    return self.frame.origin.y;
}

- (void)setJzl_y:(CGFloat)jzl_y{
    CGRect frame=self.frame;
    frame.origin.y=jzl_y;
    self.frame=frame;
}

- (CGFloat)jzl_width{
    return self.frame.size.width;
}

- (void)setJzl_width:(CGFloat)jzl_width{
    CGRect frame=self.frame;
    frame.size.width=jzl_width;
    self.frame=frame;
}

- (CGFloat)jzl_height{
    return self.frame.size.height;
}

- (void)setJzl_height:(CGFloat)jzl_height{
    CGRect frame=self.frame;
    frame.size.height=jzl_height;
    self.frame=frame;
}

- (CGFloat)jzl_right{
    return CGRectGetMaxX(self.frame);
}

- (void)setJzl_right:(CGFloat)jzl_right{
    CGRect frame=self.frame;
    frame.origin.x=jzl_right-frame.size.width;
    self.frame=frame;
}

- (CGFloat)jzl_bottom{
    return CGRectGetMaxY(self.frame);
}

- (void)setJzl_bottom:(CGFloat)jzl_bottom{
    CGRect frame=self.frame;
    frame.origin.y=jzl_bottom-frame.size.height;
    self.frame=frame;
}

- (CGFloat)jzl_centerX{
    return self.center.x;
}

- (void)setJzl_centerX:(CGFloat)jzl_centerX{
    CGPoint center=self.center;
    center.x=jzl_centerX;
    self.center=center;
}

- (CGFloat)jzl_centerY{
    return self.center.y;
}

- (void)setJzl_centerY:(CGFloat)jzl_centerY{
    CGPoint center=self.center;
    center.y=jzl_centerY;
    self.center=center;
}

- (CGSize)jzl_size{
    return self.frame.size;
}

- (void)setJzl_size:(CGSize)jzl_size{
    CGRect frame=self.frame;
    frame.size=jzl_size;
    self.frame=frame;
}
@end



