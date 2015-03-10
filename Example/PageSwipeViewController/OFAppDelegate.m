//
//  OFAppDelegate.m
//  PageSwipeViewController
//
//  Created by CocoaPods on 03/10/2015.
//  Copyright (c) 2014 offz. All rights reserved.
//

#import "OFAppDelegate.h"

@implementation OFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    
    PageSwipeViewController *pageSwipe = [PageSwipeViewController new];
    [pageSwipe setDataSource:self];
    [pageSwipe.titleTabView setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.window setRootViewController:pageSwipe];
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - PageSwipeViewControllerDataSource

- (UIViewController *)pageSwipe:(PageSwipeViewController *)controller
                   pageForIndex:(NSInteger)index {
    
    UIViewController *viewController = [UIViewController new];
    UIColor *backgroundColor = index%2 ? [UIColor redColor]:[UIColor yellowColor];
    [viewController.view setBackgroundColor:backgroundColor];
    
    return viewController;
}

- (NSString *)pageSwipe:(PageSwipeViewController *)controller
    titleForPageAtIndex:(NSInteger)index {
    
    return index%2 ? @"Red":@"Yellow";
}

- (NSInteger)numberOfPages {
    return 5;
}


#pragma mark - PageSwipeViewControllerDataSource optional

- (UIColor *)textColorForTitleTab {
    return [UIColor blackColor];
}

- (UIView *)backgroundViewForSelectedTitle {
    UIView *backgroundView = [UIView new];
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    [backgroundView.layer setCornerRadius:5.0];
    
    return backgroundView;
}

- (CGFloat)heightForTitleTab {
    return 50;
}

@end
