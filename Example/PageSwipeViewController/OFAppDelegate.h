//
//  OFAppDelegate.h
//  PageSwipeViewController
//
//  Created by CocoaPods on 03/10/2015.
//  Copyright (c) 2014 offz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PageSwipeViewController.h>

@interface OFAppDelegate : UIResponder
<
    UIApplicationDelegate,
    PageSwipeViewControllerDataSource
>

@property (strong, nonatomic) UIWindow *window;

@end
