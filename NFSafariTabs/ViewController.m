//
//  ViewController.m
//  NFSafariTabs
//
//  Created by Ricardo Santos on 21/04/2015.
//  Copyright (c) 2015 NextFaze. All rights reserved.
//

#import "ViewController.h"
#import "NFTabCollectionViewCell.h"
#import "NFCollectionViewTabsLayout.h"

NSString *const CellReuseIdentifier = @"CellReuseIdentifier";

@interface ViewController () <UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NFCollectionViewTabsLayout *tabsLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *tabs;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self commonInit];
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self commonInit];

    return self;
}

- (void)commonInit
{
    self.tabs = [NSMutableArray array];
    for (NSUInteger i = 0; i < 33; i++) {
        [self.tabs addObject:@(i)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NFCollectionViewTabsLayout *tabsLayout = [[NFCollectionViewTabsLayout alloc] init];
    self.tabsLayout = tabsLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:tabsLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[NFTabCollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    collectionView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    panGestureRecognizer.delegate = self;
    [collectionView addGestureRecognizer:panGestureRecognizer];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0, self.bottomLayoutGuide.length + 50.0, 0.0);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - 

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.collectionView];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        self.tabsLayout.pannedItemIndexPath = indexPath;
        self.tabsLayout.panStartPoint = point;
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        self.tabsLayout.panUpdatePoint = point;
        
    } else {
        self.tabsLayout.pannedItemIndexPath = nil;
    }
    
    [self.tabsLayout invalidateLayout];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.collectionView];
    if (fabs(velocity.x) > fabs(velocity.y)) {
        return YES;
    }
    
    return NO;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tabs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NFTabCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    
    NSNumber *tabNumber = self.tabs[indexPath.item];
    
    CGFloat alpha = 1.0 - 0.03*[tabNumber floatValue];
    
    cell.contentView.backgroundColor = [UIColor colorWithWhite:alpha alpha:1.0];
    cell.titleLabel.text = [NSString stringWithFormat:@"Tab %@, index %ld", tabNumber, (long)indexPath.item];
    cell.titleLabel.textColor = [UIColor blueColor];
    
    cell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.contentView.layer.shadowOffset = CGSizeMake(0.0, -40.0);
    cell.contentView.layer.shadowOpacity = 0.2;
    cell.contentView.layer.shadowRadius = 40.0;
    cell.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.contentView.bounds].CGPath;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"TAPPED CELL %@ (INDEX %ld)", self.tabs[indexPath.item], (long)indexPath.item);
}

@end
