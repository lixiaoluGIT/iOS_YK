//
//  YKEditAddressView.m
//  YK
//
//  Created by LXL on 2017/11/16.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKEditAddressView.h"
#import "MOFSPickerManager.h"

@interface YKEditAddressView()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

@end
@implementation YKEditAddressView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toSelect)];
    self.toselect.userInteractionEnabled = YES;
    self.right.userInteractionEnabled = YES;
    [self.toselect addGestureRecognizer:tap];
    [self.right addGestureRecognizer:tap];
    
    self.nameText.delegate = self;
    self.phoneText.delegate = self;
    self.textView.delegate = self;
    self.textView.text = @"请填写详细地址,不少于五个字";
    self.textView.returnKeyType = UIReturnKeyDone;
    self.nameText.returnKeyType = UIReturnKeyDone;
    self.phoneText.returnKeyType = UIReturnKeyDone;
    
    
    [_btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setAddressModel:(YKAddress *)addressModel{
    if (!addressModel) {
        self.defaultBtn.selected = NO;
        return;
    }
    _addressModel = addressModel;
    
    self.nameText.text = addressModel.name;
    self.phoneText.text = addressModel.phone;
    self.address.text = addressModel.zone;
    self.textView.text = addressModel.detail;
    self.defaultBtn.selected = [addressModel.isDefaultAddress intValue];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请填写详细地址,不少于五个字";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请填写详细地址,不少于五个字"]){
        textView.text=@"";
        textView.textColor=[UIColor colorWithHexString:@"676869"];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.textView resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)toSelect{
    WeakSelf(weakSelf)
        [weakSelf.phoneText resignFirstResponder];
        [weakSelf.nameText resignFirstResponder];
        [weakSelf.textView resignFirstResponder];
        [[MOFSPickerManager shareManger] showMOFSAddressPickerWithDefaultAddress:weakSelf.address.text.length>0 ?weakSelf.address.text : @"北京市" title:@"" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *address, NSString *zipcode) {
            weakSelf.address.text = address;
        } cancelBlock:^{
            
        }];
}
- (IBAction)click:(id)sender {
    [self toSelect];
}
//设为默认地址
- (void)clicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.defaultBtn.selected = btn.selected;
}
- (void)creatAddressModel{
    _addressModel = [[YKAddress alloc]init];
    _addressModel.name = self.nameText.text;
    _addressModel.phone = self.phoneText.text;
    _addressModel.zone = self.address.text;
    _addressModel.detail = self.textView.text;
     _addressModel.isDefaultAddress = [NSString stringWithFormat:@"%d",self.defaultBtn.selected];
    
}

@end
