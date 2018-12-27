//
//  dractLineTwoCell.h
//  ExcelViewDemol
//
//  Created by QZDelog on 16/11/24.
//  Copyright © 2016年 chedaye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dractLineTwoCell : UITableViewCell
@property (nonatomic, strong) NSArray * titleArr;
@property (nonatomic, strong) NSString *recSize;//推荐的尺码号

- (void)setTitleRow:(NSInteger)row;
@end
