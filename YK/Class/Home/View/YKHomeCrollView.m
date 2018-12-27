//
//  YKHomeCrollView.m
//  YK
//
//  Created by edz on 2018/8/20.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKHomeCrollView.h"
#import "CGQCollectionViewCell.h"
@interface YKHomeCrollView()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *eng;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hh;

@property (nonatomic,strong)UIPageControl *pageControl;

@property (nonatomic,strong)NSArray *productList;

@end

@implementation YKHomeCrollView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView.contentSize=CGSizeMake((WIDHT)*5,0);
    self.scrollView.scrollEnabled = YES;
    [self.scrollView setUserInteractionEnabled:YES];
    [_rightImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(block)];
    [_rightImage addGestureRecognizer:tap];
    
    _eng.numberOfLines = 0;
    _title.font = [UIFont systemFontOfSize:kSuitLength_H(18)];
    _eng.font = [UIFont systemFontOfSize:kSuitLength_H(12)];
    _hh.constant = kSuitLength_V(50);
    
    //    _eng.backgroundColor = [UIColor greenColor];
    
    //    _eng.font = FONT(15);
//
//    _eng.lineBreakMode = NSLineBreakByCharWrapping;
//
//    //设置字间距
//
//    NSDictionary *dic = @{NSKernAttributeName:@4.f
//
//                          };
//
//    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:_eng.text attributes:dic];
//
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//
//    //    [paragraphStyle setLineSpacing:30];//行间距
//
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_eng.text length])];
//
//    [_eng setAttributedText:attributedString];
//
//    [_eng sizeToFit];
}

- (void)initWithType:(NSInteger)type productList:(NSArray *)productList OnResponse:(void (^)(void))onResponse{
    
    self.scrollView.pagingEnabled = YES;
    
    _productList = [NSArray arrayWithArray:productList];
    self.toAllBlock = onResponse;
    if (type==1) {//服装
        _logo.image = [UIImage imageNamed:@"rqmy"];
        _title.text = @"人气美衣";
        _eng.text = @"Beautiful clothes";
     
    }
    if (type==2) {//配饰
        //布局
        _logo.image = [UIImage imageNamed:@"rqps"];
        _title.text = @"人气配饰";
        _eng.text = @"Personal accessories";
        
        
    }
    
    //布局
    CGFloat w = (WIDHT-30)/2;
    for (int i=0; i<productList.count; i++) {
        YKProduct *product = [[YKProduct alloc]init];
        [product initWithDictionary:productList[i]];
        CGQCollectionViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CGQCollectionViewCell" owner:nil options:nil][0];
        cell.frame = CGRectMake(10+(w+10)*i, 0, w, w*240/140);
        //非1奇数
        if ((i)%2==0&&i!=0) {
            cell.frame = CGRectMake(10+(w+10)*i+10, 0, w, w*240/140);
        }
        if (i==3) {
            cell.frame = CGRectMake(10+(w+10)*i+10, 0, w, w*240/140);
        }
        if (i==4) {
            cell.frame = CGRectMake(10+(w+10)*i+20, 0, w, w*240/140);
        }
        if (i==5) {
            cell.frame = CGRectMake(10+(w+10)*i+20, 0, w, w*240/140);
        }
        cell.product = product;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if (self.toDetailBlock) {
                self.toDetailBlock(cell.goodsId);
            }
        }];
        [cell addGestureRecognizer:tap];
        [self.scrollView addSubview:cell];
        //            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:@"http://img-cdn.xykoo.cn/clothing/蕾丝印花猫上衣/clothingImg0"]] placeholderImage:[UIImage imageNamed:@"商品图"]];
        //            cell.tag = i;
        //            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDetail:)];
        //            [cell addGestureRecognizer:tap];
    }
    self.scrollView.contentSize= CGSizeMake(WIDHT*3,0);
    
    self.scrollView.scrollEnabled = YES;
  
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    _pageControl.frame = CGRectMake(0, self.frame.size.height-20, WIDHT, 20);
//    _pageControl.backgroundColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"f4f4f4"];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"333333"];
    self.scrollView.delegate = self;
    if (productList.count!=0) {
        [self addSubview:_pageControl];
        
        [self bringSubviewToFront:_pageControl];
    }
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = x/WIDHT;
    NSLog(@"%ld %lf",index,x);
    
    if (index!=0&&index!=1) {
        index = index+1;
    }
    self.pageControl.currentPage = index;
//    if (point.x == 0) {///< 偏移量为0，展示最后一张图片
//
//        self.pageControl.currentPage = 0;
//    } else if (point.x == scrollView.contentSize.width-SCREEN_WIDTH) {///< 偏移量到最后一张图时，展示第一张图片
//        scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
//        self.pageControl.currentPage = 0;
//    } else {
//        self.pageControl.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH-1;
//    }
//    _currentPoint = self.SV.contentOffset;///< 记录滚动之后的偏移量
}
- (IBAction)click:(id)sender {
    [self block];
}

- (void)block{
    if (self.toAllBlock) {
        self.toAllBlock();
    }
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

//- (void)toDetail:(CGQCollectionViewCell *)cell{
//    NSString *productId = self.productList[cell.tag][@"goodId"];
//
//    if (self.toDetailBlock) {
//        self.toDetailBlock(productId);
//    }
//}
@end
