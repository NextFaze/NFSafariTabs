//
//  NFTabSelectLayout.m
//  NFSafariTabs
//
//  Created by fanzhang on 15/9/23.
//  Copyright © 2015年 NextFaze. All rights reserved.
//

#import "NFTabSelectLayout.h"

@interface NFTabSelectLayout()

@property (nonatomic, strong) NSMutableArray *attributes;
@property (nonatomic) CGSize contentSize;

@end

@implementation NFTabSelectLayout

#pragma mark - UICollectionViewLayout (UISubclassingHooks)

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (self.collectionView.numberOfSections != 1) {
        [NSException raise:@"Invalid number of sections" format:@"NFCollectionViewTabsLayout only supports data sources with 1 section"];
    }
    
    CGFloat top = 0.0;
    CGFloat left = 0.0;
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat height = self.collectionView.frame.size.height;
    
    self.attributes = [NSMutableArray array];
    
    for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:0]; item++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGRect frame = CGRectMake(left, top, width, height);
        attributes.frame = frame;
        attributes.zIndex = item;
        
        // todo: move seleted item to top
        /*
        // standard angle
        CGFloat angleOfRotation = -61.0;
        
        CGFloat frameOffset = self.collectionView.contentOffset.y - frame.origin.y - floorf(self.collectionView.frame.size.height/10.0);
        if (frameOffset > 0) {
            // make the cell at the top fall away
            frameOffset = frameOffset/5.0;
            frameOffset = MIN(frameOffset, 30.0);
            angleOfRotation += frameOffset;
        }
        
        // rotation
        CATransform3D rotation = CATransform3DMakeRotation((M_PI*angleOfRotation/180.0f), 1.0, 0.0, 0.0);
        
        // perspective
        CGFloat depth = 300.0;
        CATransform3D translateDown = CATransform3DMakeTranslation(0.0, 0.0, -depth);
        CATransform3D translateUp = CATransform3DMakeTranslation(0.0, 0.0, depth);
        CATransform3D scale = CATransform3DIdentity;
        scale.m34 = -1.0f/1500.0;
        CATransform3D perspective =  CATransform3DConcat(CATransform3DConcat(translateDown, scale), translateUp);
        
        // final transform
        CATransform3D transform = CATransform3DConcat(rotation, perspective);
        
        attributes.transform3D = transform;
         */
        
        [self.attributes addObject:attributes];
        
        top += height;
    }
    
    if (self.attributes.count)
    {
        UICollectionViewLayoutAttributes *lastItemAttributes = [self.attributes lastObject];
        self.contentSize = CGSizeMake(width, lastItemAttributes.frame.origin.y + lastItemAttributes.frame.size.height);
    }
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesInRect = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attributes in self.attributes) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [attributesInRect addObject:attributes];
        }
    }
    
    return attributesInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.attributes[indexPath.item];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark - UICollectionViewLayout (UIUpdateSupportHooks)

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return self.attributes[itemIndexPath.item];
}

@end
