//
//  YKAddCCouponView.m
//  YK
//
//  Created by edz on 2018/8/30.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKAddCCouponView.h"

@interface YKAddCCouponView()
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *addlabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
@implementation YKAddCCouponView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)reloadData{
   
    if ([YKSuitManager sharedManager].isHadCC) {//有劵
        if ([YKSuitManager sharedManager].isUseCC== NO) {
            _addBtn.selected = NO;
            _statusImage.image = [UIImage imageNamed:@"weixuanzhong"];
            [YKSuitManager sharedManager].isUseCC = NO;
            
        }
        _statusImage.hidden = NO;
        _addlabel.hidden = NO;
        [_addBtn setTitle:@"" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn setBackgroundColor:[UIColor whiteColor]];
    }else {  //没劵
        _statusImage.hidden = YES;
        _addlabel.hidden = YES;
        [_addBtn setTitle:@"购买加衣劵" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn setBackgroundColor:YKRedColor];
    }
}

- (void)setDic:(NSDictionary *)dic{
   
  
}

//点击加衣卷
- (IBAction)addClothClick:(id)sender {
    
   

    if ([YKSuitManager sharedManager].isHadCC) {//有劵
        
        if ([YKSuitManager sharedManager].suitArray.count==4) {
            return;
        }
        //有劵
        _addBtn.selected = !_addBtn.selected;
        if (_addBtn.selected) {
            _statusImage.image = [UIImage imageNamed:@"xuanzhong"];
            [YKSuitManager sharedManager].isUseCC = YES;
        }else {
            _statusImage.image = [UIImage imageNamed:@"weixuanzhong"];
            [YKSuitManager sharedManager].isUseCC = NO;
        }
    }else {//没劵，去购买页
        if (self.buyBlock) {
            self.buyBlock();
        }
    }
    
    
}

//确认订单
- (IBAction)ensureBtn:(id)sender {
    if ([YKSuitManager sharedManager].suitArray.count==0) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请选择商品" delay:1.5];
    }else {
        //到确认订单页
        if (self.ensureBlock) {
            self.ensureBlock();
        }
    }

}

@end
