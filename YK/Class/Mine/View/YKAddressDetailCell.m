//
//  YKAddressDetailCell.m
//  YK
//
//  Created by LXL on 2017/11/16.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKAddressDetailCell.h"
@interface YKAddressDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;
@property (weak, nonatomic) IBOutlet UIButton *defaultImage;
@property (weak, nonatomic) IBOutlet UILabel *edit;
@property (weak, nonatomic) IBOutlet UILabel *delete;

@property (weak, nonatomic) IBOutlet UILabel *defaultName;
@property (weak, nonatomic) IBOutlet UILabel *defaultPhone;
@property (weak, nonatomic) IBOutlet UILabel *defaultAddress;
@property (nonatomic,strong)UIButton *Button1;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;

@end
@implementation YKAddressDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.edit setUserInteractionEnabled:YES];
    [self.delete setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toEdit)];
    [self.edit addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDelete)];
    [self.delete addGestureRecognizer:tap1];
}

- (IBAction)selectBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (!btn.selected) {
        [[YKAddressManager sharedManager]setDetaultAddressWithAddress:self.address OnResponse:^(NSDictionary *dic) {
            btn.selected = !btn.selected;
            _btnImage.selected = btn.selected;
            if (self.selectDefaultBlock) {
                self.selectDefaultBlock();
            }
        }];
    }else {
        return;
    }
}

- (void)setAddress:(YKAddress *)address{
    
    _address = address;
    
    self.name.text = address.name;
    self.phone.text = address.phone;
    self.detailAddress.text = [NSString stringWithFormat:@"%@%@",address.zone,address.detail];
    self.defaultImage.selected = [address.isDefaultAddress intValue];
    
    self.defaultName.text = address.name;
    self.defaultPhone.text = address.phone;
    self.defaultAddress.text = [NSString stringWithFormat:@"%@%@",address.zone,address.detail];
    self.defaultImage.selected = [address.isDefaultAddress intValue];
}

- (void)toEdit{
    if (self.editBlock) {
        self.editBlock(self.address);
    }
}

- (void)toDelete{
    
    [[YKAddressManager sharedManager]deleteAddressWithAddress:self.address OnResponse:^(NSDictionary *dic) {
        if (self.deleteBlock) {
            self.deleteBlock();
        }
    }];
    
}

- (IBAction)delete:(id)sender {
    
    [self toEdit];
}

@end
