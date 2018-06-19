//
//  YKActivity.h
//  YK
//
//  Created by edz on 2018/6/14.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKActivity : NSObject
//"communityActivity":{"activityId":1,"activityTitle":"标题","activityLabel":"标签","activityExplain":"活动说明","activityStatus":1,"mainDiagram":"http://img1.imgtn.bdimg.com/it/u=4054100184,7315927&fm=27&gp=0.jpg","exampleDiagram":"http://img1.imgtn.bdimg.com/it/u=4054100184,7315927&fm=27&gp=0.jpg","createDate":1528968323000,"updateDate":1528968327000,"operator":1},"totalElements":0},"success":true}

@property (nonatomic,strong)NSString *activityId;//活动ID
@property (nonatomic,strong)NSString *activityTitle;//活动标题
@property (nonatomic,strong)NSString *activityExplain;//标签
@property (nonatomic,strong)NSString *activityStatus;//活动说明
@property (nonatomic,strong)NSString *mainDiagram;//主图
@property (nonatomic,strong)NSString *exampleDiagram;//示例图
@property (nonatomic,strong)NSString *createDate;//创建时间
@property (nonatomic,strong)NSString *updateDate;//更新时间

- (void)initWithDic:(NSDictionary *)dic;
//@property (nonatomic,strong)NSString *operator;



@end
