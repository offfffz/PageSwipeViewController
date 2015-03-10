//
//  PageSwipeViewController.m
//  Orakuru
//
//  Created by Developer on 06/03/2015.
//  Copyright (c) 2015 Codemy. All rights reserved.
//

#import "PageSwipeViewController.h"
#import <Masonry.h>

static CGFloat DefaultTitleTabHeight = 44;
static NSString *const TitleTabCellReuseId = @"TitleTabCellReuseId";

@interface TitleTabCell : UICollectionViewCell
@property (weak, nonatomic) UILabel *titleLabel;
- (void)configureCellWithTitle:(NSString *)title
                    titleColor:(UIColor *)color;
@end

@implementation TitleTabCell
- (void)configureCellWithTitle:(NSString *)title
                    titleColor:(UIColor *)color {
    
    if (!self.titleLabel) {
        UILabel *titleLabel = [UILabel new];
        [titleLabel setTag:10110];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        self.titleLabel = titleLabel;
    }
    [self.titleLabel setTextColor:color];
    [self.titleLabel setText:title];
    [self.titleLabel sizeToFit];
}
@end

@interface PageSwipeViewController ()
<
    UIScrollViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
>

@property (strong, nonatomic) UIScrollView *contentView;
@property (strong, nonatomic) UICollectionView *titleTabView;

@end

@implementation PageSwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.contentView.contentSize = CGSizeMake([self pages] * self.contentView.bounds.size.width,
                                              self.contentView.bounds.size.height);
}

- (void)reloadData {
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *child, NSUInteger idx, BOOL *stop) {
        [child.view removeFromSuperview];
        [child removeFromParentViewController];
    }];
    
    [self setupPages];
}


#pragma mark - CollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self pages];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TitleTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TitleTabCellReuseId
                                                                   forIndexPath:indexPath];
    NSString *title = [self.dataSource pageSwipe:self
                             titleForPageAtIndex:indexPath.item];
    
    [cell configureCellWithTitle:title
                      titleColor:[self titleTabTextColor]];
    
    if (!cell.selectedBackgroundView) {
        if ([self.dataSource respondsToSelector:@selector(backgroundViewForSelectedTitle)]) {
            cell.selectedBackgroundView = [self.dataSource backgroundViewForSelectedTitle];
        }
    }
    
    return cell;
}


#pragma mark - CollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectTabIndex:indexPath.item];
    
    CGFloat scrollOffset = indexPath.item * collectionView.bounds.size.width;
    
    [self.contentView setContentOffset:CGPointMake(scrollOffset, 0)
                              animated:YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = [self.dataSource pageSwipe:self titleForPageAtIndex:indexPath.item];
    
    TitleTabCell *cell = [TitleTabCell new];
    [cell configureCellWithTitle:title
                      titleColor:[self titleTabTextColor]];
    
    return CGRectInset(cell.titleLabel.frame, -10, -8).size;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.titleTabView) {
        return;
    }
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self selectTabIndex:page];
}


#pragma mark - getters & setters
- (void)setDataSource:(id<PageSwipeViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [UIScrollView new];
        [_contentView setDelegate:self];
        [_contentView setShowsHorizontalScrollIndicator:NO];
        [_contentView setShowsVerticalScrollIndicator:NO];
        [_contentView setBounces:NO];
        [_contentView setPagingEnabled:YES];
    }
    
    return _contentView;
}

- (UICollectionView *)titleTabView {
    if (!_titleTabView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setSectionInset:UIEdgeInsetsMake(0, 4, 0, 4)];
        
        _titleTabView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                      collectionViewLayout:layout];
        [_titleTabView setDataSource:self];
        [_titleTabView setDelegate:self];
        [_titleTabView setShowsHorizontalScrollIndicator:NO];
        [_titleTabView setShowsVerticalScrollIndicator:NO];
        [_titleTabView registerClass:[TitleTabCell class]
     forCellWithReuseIdentifier:TitleTabCellReuseId];
    }
    
    return _titleTabView;
}


#pragma mark - private methods
- (void)setupSubviews {
    [self.view addSubview:self.titleTabView];
    [self.titleTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *topLayoutGuide = (UIView *)self.topLayoutGuide;
        make.top.equalTo(topLayoutGuide.mas_bottom);
        make.leading.trailing.equalTo(self.titleTabView.superview);
        if ([self titleTabHeight] > 0) {
            make.height.equalTo(@([self titleTabHeight]));
        } else {
            make.height.equalTo(@(DefaultTitleTabHeight));
        }
    }];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleTabView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.titleTabView.superview);
        
        UIView *topLayoutGuide = (UIView *)self.topLayoutGuide;
        make.top.equalTo(topLayoutGuide.mas_bottom).priorityLow();
    }];
}

- (void)setupPages {
    NSInteger numberOfPages = [self pages];
    for (int i = 0; i < numberOfPages; i++) {
        UIViewController *page = [self.dataSource pageSwipe:self
                                               pageForIndex:i];
        
        [self addChildViewController:page];
        [self.contentView addSubview:page.view];
        
        [page.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.contentView);
            if (i == 0) {
                make.leading.top.equalTo(self.contentView);
            } else {
                UIView *pre = self.contentView.subviews[i - 1];
                make.leading.equalTo(pre.mas_trailing);
                make.top.equalTo(self.contentView);
            }
        }];
    }
    
    if (numberOfPages > 0) [self selectTabIndex:0];
    if (numberOfPages <= 1) [self.titleTabView removeFromSuperview];
}

- (void)selectTabIndex:(NSInteger)index {
    [self.titleTabView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                               animated:YES
                         scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (NSInteger)pages{
    
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfPages)],
             @"DataSource must response to %@",
             NSStringFromSelector(@selector(numberOfPages)));
    
    return MAX(0, [self.dataSource numberOfPages]);
}

- (CGFloat)titleTabHeight {
    if ([self.dataSource respondsToSelector:@selector(heightForTitleTab)]) {
        return MAX(0, [self.dataSource heightForTitleTab]);
    } else {
        return 0.0;
    }
}

- (UIColor *)titleTabTextColor {
    if ([self.dataSource respondsToSelector:@selector(textColorForTitleTab)]) {
        return [self.dataSource textColorForTitleTab];
    } else {
        return [UIColor darkGrayColor];
    }
}

@end
