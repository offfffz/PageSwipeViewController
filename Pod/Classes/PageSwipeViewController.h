//
//  PageSwipeViewController.h
//  Orakuru
//
//  Created by Developer on 06/03/2015.
//  Copyright (c) 2015 Codemy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageSwipeViewController;

@protocol PageSwipeViewControllerDataSource <NSObject>

- (UIViewController *)pageSwipe:(PageSwipeViewController *)controller
                   pageForIndex:(NSInteger)index;

- (NSString *)pageSwipe:(PageSwipeViewController *)controller titleForPageAtIndex:(NSInteger)index;

- (NSInteger)numberOfPages;

@optional
- (UIView *)backgroundViewForSelectedTitle;
- (UIColor *)textColorForTitleTab;
- (CGFloat)heightForTitleTab;

@end

@interface PageSwipeViewController : UIViewController

@property (strong, nonatomic, readonly) UIScrollView *contentView;
@property (strong, nonatomic, readonly) UICollectionView *titleTabView;

@property (weak, nonatomic) id<PageSwipeViewControllerDataSource> dataSource;

- (void)reloadData;

@end
