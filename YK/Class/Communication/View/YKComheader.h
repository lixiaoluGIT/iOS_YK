//
//  YKComheader.h
//  YK
//
//  Created by edz on 2018/6/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKComheader : UITableViewCell

typedef enum : NSInteger {
    SELECTED = 1,//精选
    NEWARRIVAL = 0,//最新
    CONCERNED = 2,//关注
}CommunicationType;//晒图列表类型

@property (nonatomic,assign)CGFloat totalH;
@property (nonatomic,assign)CommunicationType CommunicationType;
@property (nonatomic,copy)void (^changeCommunicationTypeBlock)(CommunicationType CommunicationType);
@property (nonatomic,copy)void (^clickIndexToWebViewBlock)(NSString *webUrl);
@property (nonatomic,strong)NSArray *imageArray;
@property (nonatomic,strong)NSArray *clickUrlArray;

@end
