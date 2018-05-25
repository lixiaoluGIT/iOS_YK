//
//  AppDelegate.h
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
@private
    UINavigationController *_naviController;
}
@property (strong, nonatomic) ViewController *viewController;
@property (assign, nonatomic) int lastPayloadIndex;
@property (strong, nonatomic) UIWindow *window;


@end

