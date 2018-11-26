//
//  NavViewController.h
//  bbkm
//
//  Created by liwenzhi on 15/10/12.
//  Copyright (c) 2015年 lwz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavViewController : UINavigationController<UINavigationControllerDelegate>

- (id)initWithRootViewController:(UIViewController *)rootViewController setBarBack:(id)barBack;

@end
