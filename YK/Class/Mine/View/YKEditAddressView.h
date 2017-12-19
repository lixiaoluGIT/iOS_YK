//
//  YKEditAddressView.h
//  YK
//
//  Created by LXL on 2017/11/16.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YKEditAddressView : UITableViewCell

@property (nonatomic,strong)YKAddress *addressModel;

@property (weak, nonatomic) IBOutlet UILabel *toselect;
@property (weak, nonatomic) IBOutlet UIImageView *right;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *address;

- (void)creatAddressModel;
@end
