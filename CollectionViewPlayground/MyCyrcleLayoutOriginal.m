//
//  MyCyrcleLayoutOriginal.m
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 8/27/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import "MyCyrcleLayoutOriginal.h"

@implementation MyCyrcleLayoutOriginal

- (void)prepareLayout
{
    // Handle wrapping the collection view at the boundaries
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (self.collectionView.contentOffset.y <= 0.0f) {
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, [super collectionViewContentSize].height + self.minimumLineSpacing)];
        }
        else if (self.collectionView.contentOffset.y >= [super collectionViewContentSize].height + self.minimumLineSpacing) {
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, 0.0f)];
        }
    }
    else {
        if (self.collectionView.contentOffset.x <= 0.0f) {
            [self.collectionView setContentOffset:CGPointMake([super collectionViewContentSize].width + self.minimumLineSpacing, self.collectionView.contentOffset.y)];
        }
        else if (self.collectionView.contentOffset.x >= [super collectionViewContentSize].width + self.minimumLineSpacing) {
            [self.collectionView setContentOffset:CGPointMake(0.0f, self.collectionView.contentOffset.y)];
        }
    }
    
    [super prepareLayout];
}

- (CGSize)collectionViewContentSize
{
    CGSize contentSize = [super collectionViewContentSize];
    
    // We add the height (or width) of the collection view to the content size to allow us to seemlessly wrap without any screen artifacts
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        contentSize = CGSizeMake(contentSize.width, contentSize.height + self.collectionView.bounds.size.height + self.minimumLineSpacing);
    }
    else {
        contentSize = CGSizeMake(contentSize.width + self.collectionView.bounds.size.width + self.minimumLineSpacing, contentSize.height);
    }
    
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (newBounds.origin.y <= self.collectionView.bounds.size.height) {
            return YES;
        }
        
        if (newBounds.origin.y >= [super collectionViewContentSize].height - self.collectionView.bounds.size.height) {
            return YES;
        }
    }
    else {
        if (newBounds.origin.x <= self.collectionView.bounds.size.width) {
            return YES;
        }
        
        if (newBounds.origin.x >= [super collectionViewContentSize].width - self.collectionView.bounds.size.width) {
            return YES;
        }
    }
    
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        NSArray* wrappingAttributes = [super layoutAttributesForElementsInRect:CGRectMake(rect.origin.x,
                                                                                          rect.origin.y - [super collectionViewContentSize].height,
                                                                                          rect.size.width,
                                                                                          rect.size.height)];
        
        for (UICollectionViewLayoutAttributes* attributes in wrappingAttributes) {
            attributes.center = CGPointMake(attributes.center.x, attributes.center.y + [super collectionViewContentSize].height + self.minimumLineSpacing);
        }
        
        layoutAttributes = [layoutAttributes arrayByAddingObjectsFromArray:wrappingAttributes];
    }
    else {
        NSArray* wrappingAttributes = [super layoutAttributesForElementsInRect:CGRectMake(rect.origin.x - [super collectionViewContentSize].width,
                                                                                          rect.origin.y,
                                                                                          rect.size.width,
                                                                                          rect.size.height)];
        
        for (UICollectionViewLayoutAttributes* attributes in wrappingAttributes) {
            attributes.center = CGPointMake(attributes.center.x + [super collectionViewContentSize].width + self.minimumLineSpacing, attributes.center.y);
        }
        
        layoutAttributes = [layoutAttributes arrayByAddingObjectsFromArray:wrappingAttributes];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes* layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    layoutAttributes.center = CGPointMake(layoutAttributes.center.x + self.collectionView.bounds.size.width, layoutAttributes.center.y);
    return layoutAttributes;
}

@end
