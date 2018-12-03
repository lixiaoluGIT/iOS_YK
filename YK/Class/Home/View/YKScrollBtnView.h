//
//  YKScrollBtnView.h
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKScrollBtnView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic,strong)NSString *styleId;
@property (nonatomic,copy)void(^clickDetailBlock)(NSString *brandId,NSString *brandName);
@property (nonatomic,assign)BOOL isSelect;
@end
