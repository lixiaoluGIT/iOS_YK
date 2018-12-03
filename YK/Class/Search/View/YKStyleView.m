//
//  YKStyleView.m
//  YK
//
//  Created by edz on 2018/6/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKStyleView.h"
#import "YKScrollBtnView.h"
@interface YKStyleView(){
    __block YKScrollBtnView *btn;
}
@property (nonatomic,strong)NSMutableArray *btnArray;
@end
@implementation YKStyleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTitle];
        _btnArray = [NSMutableArray array];
    }
    return self;
}

- (void)addTitle{
//    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huangxian"]];
//    image.left = 15;
//    image.top = 24;
//    [image sizeToFit];
//    [self addSubview:image];
//
//    UILabel *title = [[UILabel alloc]init];
//    title.top = 24;
//    title.left = image.right + 6;
//    title.width = 100;
//    title.height =18;
//    title.text = @"风格选择";
//    title.textColor = mainColor;
//    title.font = PingFangSC_Medium(kSuitLength_H(16));
//    [self addSubview:title];
}

- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

- (void)setStyleArray:(NSMutableArray *)styleArray{
    WeakSelf(weakSelf)
    _styleArray = styleArray;
    //滚动图
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, WIDHT/4)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:scrollView];
    
    NSUInteger num;
    if (_styleArray.count>=4) {
        num = 4;
    }else {
        num = _styleArray.count;
    }
    for (int i = 0; i<_styleArray.count; i++) {
      __weak YKScrollBtnView *btn=  [[NSBundle mainBundle] loadNibNamed:@"YKScrollBtnView" owner:self options:nil][0];
                NSString *s = [NSString stringWithFormat:@"%@",styleArray[i][@"labelImg"]];
                [btn.image sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:s]] placeholderImage:[UIImage imageNamed:@"首页品牌图"]];
                btn.title.text = [NSString stringWithFormat:@"%@",styleArray[i][@"labelName"]];
                btn.styleId = styleArray[i][@"labelId"];
                btn.clickDetailBlock = ^(NSString *brandId,NSString *brandName){
                    [weakSelf btnViewClick:btn];
                };
                btn.image.contentMode = UIViewContentModeScaleAspectFit;
                btn.image.clipsToBounds = YES;
        
                CGFloat w = WIDHT/4;
                btn.frame = CGRectMake(w*i,0,w,w);
        btn.tag = i;
        [scrollView addSubview:btn];
        [_btnArray addObject:btn];
        
    }
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake((_btnArray.count/4+1)*WIDHT, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    //线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, WIDHT/4+kSuitLength_H(13), WIDHT, kSuitLength_H(10))];
    line.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [self addSubview:line];
}

- (void)btnViewClick:(YKScrollBtnView *)btnView{

    for (YKScrollBtnView *btn in _btnArray) {
        if (btn.tag == btnView.tag) {
            btnView.isSelect  = !btnView.isSelect;
            if (btnView.isSelect) {
                 btn.styleId = _styleArray[btnView.tag][@"labelId"];
                btnView.title.textColor = [UIColor whiteColor];
                btnView.title.backgroundColor = mainColor;
                //拼接x
                 btnView.title.text = [btnView.title.text stringByAppendingFormat:@" x"];
            }else {
                btnView.title.textColor = mainColor;
                btnView.title.backgroundColor = [UIColor whiteColor];
                btnView.styleId = @"0";
                //去x
                btnView.title.text = [btnView.title.text stringByReplacingOccurrencesOfString:@" x" withString:@""];
            }
        }else {
            btn.isSelect = NO; 
            btn.title.textColor = mainColor;
            btn.title.backgroundColor = [UIColor whiteColor];
            btn.title.text = [btn.title.text stringByReplacingOccurrencesOfString:@" x" withString:@""];
        }
    }if (self.toDetailBlock) {
        self.toDetailBlock(btnView.styleId,@"");
    }
}
@end
