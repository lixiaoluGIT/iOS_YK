//
//  YKMineCell.h
//  YK
//
//  Created by LXL on 2017/11/15.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKMineCell : UITableViewCell
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,strong)NSArray *tiles;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (nonatomic,strong)YKUser *user;
@property (nonatomic,assign)BOOL imaHidden;
@end
