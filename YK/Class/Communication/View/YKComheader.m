//
//  YKComheader.m
//  YK
//
//  Created by edz on 2018/6/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKComheader.h"
#import "YKBaseScrollView.h"

@interface YKComheader()<YKBaseScrollViewDelete>
@property (weak, nonatomic) IBOutlet UIImageView *headIma;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnH;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (nonatomic,strong)UIButton *Button0;
@property (nonatomic,strong)YKBaseScrollView *scrolView;

@end
@implementation YKComheader

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
    [self layOut];
    
    self.btn1.titleLabel.font = PingFangSC_Medium(kSuitLength_H(14));
     self.btn2.titleLabel.font = PingFangSC_Medium(kSuitLength_H(14));
     self.btn3.titleLabel.font = PingFangSC_Medium(kSuitLength_H(14));
}

- (void)initUI{
    _btn1.selected = YES;
    self.Button0 = _btn1;
}

- (void)layOut{
    _headH.constant = 60*WIDHT/375;
    _btnH.constant = 42*WIDHT/375;
    _totalH = _headH.constant+_btnH.constant+10;
}

- (void)setUpScrolView{
    _scrolView = [[YKBaseScrollView alloc]initWithFrame:CGRectMake(0, 10, WIDHT, kSuitLength_H(60))];
    _scrolView.delegate = self;
    [self addSubview:_scrolView];
}

- (void)setClickUrlArray:(NSArray *)clickUrlArray{
//    if (WIDHT!=320) {
        _clickUrlArray = [NSArray arrayWithArray:clickUrlArray];
//    }
}

- (void)setImageArray:(NSMutableArray *)imageArray{
    [self setUpScrolView];
    _scrolView.imagesArr = imageArray;
    _scrolView.isSmall = YES;
}

- (void)setTotalH:(CGFloat)totalH{
    _totalH = _headH.constant+_btnH.constant+10;
}

- (IBAction)btnClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    switch (button.tag) {
        case 101:
            _CommunicationType = SELECTED;
            break;
        case 102:
            _CommunicationType = NEWARRIVAL;
            break;
        case 103:
            _CommunicationType = CONCERNED;
            break;
            
        default:
            break;
    }
    
    if (_CommunicationType == CONCERNED&&[Token length]==0) {
//        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请先登录" delay:1.8];
        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
            
        }];
        return ;
    }
    if (self.Button0 != button) {
        self.Button0.selected = NO;
        button.selected = YES;
        [button setUserInteractionEnabled:NO];
        [self.Button0 setUserInteractionEnabled:YES];
        button.titleLabel.font = PingFangSC_Medium(kSuitLength_H(14))
        self.Button0.titleLabel.font = PingFangSC_Medium(kSuitLength_H(14));
    }
    self.Button0 = button;
    if (self.changeCommunicationTypeBlock) {
        self.changeCommunicationTypeBlock(self.CommunicationType);
    }
}

- (void)YKBaseScrollViewImageClick:(NSInteger)index{
    if (self.clickIndexToWebViewBlock) {
        self.clickIndexToWebViewBlock(self.clickUrlArray[index-1]);
    }
}

@end
