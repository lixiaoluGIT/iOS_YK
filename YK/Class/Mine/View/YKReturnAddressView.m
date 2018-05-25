//
//  YKReturnAddressView.m
//  YK
//
//  Created by LXL on 2017/11/29.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKReturnAddressView.h"

@interface YKReturnAddressView()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *zone;
@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UILabel *normalLabel;

@end
@implementation YKReturnAddressView

- (void)awakeFromNib {
    [super awakeFromNib];

}


- (void)setAddress:(YKAddress *)address{
    _address = address;
    
    _name.text = _address.name;
    _phone.text = _address.phone;
    _zone.text = _address.zone;
    _des.text = _address.detail;
}

@end
