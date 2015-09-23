//
//  ViewController.m
//  NFSafariTabs
//
//  Created by Ricardo Santos on 21/04/2015.
//  Copyright (c) 2015 NextFaze. All rights reserved.
//

#import "ViewController.h"
#import "NFTabCollectionViewCell.h"
#import "NFTabsBrowsingLayout.h"
#import "NFTabSelectLayout.h"
#import "TTAutoLayoutTool.h"

NSString *const CellReuseIdentifier = @"CellReuseIdentifier";

@interface ViewController () <UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    BOOL _isSelected;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NFTabsBrowsingLayout *browseringLayout;
@property (nonatomic, strong) NFTabSelectLayout *selectLayout;

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
    for (NSUInteger i = 0; i < 10; i++) {
        [self.tabs addObject:@(i)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NFTabsBrowsingLayout *browsingLayout = [NFTabsBrowsingLayout new];
    self.browseringLayout = browsingLayout;
    
    NFTabSelectLayout *selectLayout = [NFTabSelectLayout new];
    self.selectLayout = selectLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:browsingLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[NFTabCollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    collectionView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:collectionView];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [TTAutoLayoutTool letView:collectionView FillInView:self.view];
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - 

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.collectionView];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        self.browseringLayout.pannedItemIndexPath = indexPath;
        self.browseringLayout.panStartPoint = point;
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        self.browseringLayout.panUpdatePoint = point;
        
    } else {
        self.browseringLayout.pannedItemIndexPath = nil;
    }
    
    [self.browseringLayout invalidateLayout];
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
    cell.contentView.layer.shadowOffset = CGSizeMake(0.0, -20.0);
    cell.contentView.layer.shadowOpacity = 0.6;
    cell.contentView.layer.shadowRadius = 20.0;
    cell.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.contentView.bounds].CGPath;
    cell.contentView.layer.shouldRasterize = YES;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"TAPPED CELL %@ (INDEX %ld)", self.tabs[indexPath.item], (long)indexPath.item);
    
    if (!_isSelected)
        [self.collectionView setCollectionViewLayout:self.selectLayout animated:YES];
    else
        [self.collectionView setCollectionViewLayout:self.browseringLayout animated:YES];
    
    _isSelected = !_isSelected;
}

@end
